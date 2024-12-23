const { BadRequestError } = require("../errors/error");
const sequelize = require("../config/database");
const { _User } = sequelize.models;
const bcrypt = require("bcrypt");

const getUserProfile = async (req, res, next) => {
  try {
    const { UUID } = req.Userdata;
    const user = await sequelize.models._User.findOne({ where: { UUID } });
    if (!user) {
      throw new NotFoundError("User not found");
    }
    const { username, email, phone, status } = user;
    res.status(200).json({ username, email, phone, status });
  } catch (error) {
    next(error);
  }
};

// cập nhật profile
const updateUserProfile = async (req, res, next) => {
  try {
    const { UUID } = req.Userdata;
    const { username, phone } = req.body;
    const user = await sequelize.models._User.findOne({ where: { UUID } });
    if (!user) {
      throw new NotFoundError("User not found");
    }
    if (username) user.username = username;
    if (phone) user.phone = phone;
    new_user = await user.save();
    res.status(200).json({ message: "Profile updated successfully",new_user });
  } catch (error) {
    next(error);
  }
};

// Update user password
const updateUserPassword = async (req, res, next) => {
  try {
    const { UUID } = req.Userdata;
    const { oldPassword, newPassword } = req.body;

    // Validate input
    if (!oldPassword || !newPassword) {
      throw new BadRequestError("Old and new passwords are required.");
    }
    if (newPassword.length < 8) {
      throw new BadRequestError("Password must be at least 8 characters long.");
    }

    // Find the user
    const user = await sequelize.models._User.findOne({ where: { UUID } });
    if (!user) {
      throw new NotFoundError("User not found.");
    }

    // Compare old password with the hashed password in the database
    const isPasswordMatch = await bcrypt.compare(oldPassword, user.password);
    if (!isPasswordMatch) {
      throw new BadRequestError("Invalid old password.");
    }

    // Hash and save the new password
    user.password = await bcrypt.hash(newPassword, 10);
    user.changed("password", true);
    await user.save();

    res.status(200).json({ message: "Password updated successfully." });
  } catch (error) {
    next(error);
  }
};

//lấy danh sách nguyên liệu
const getIngredientList = async (req, res, next) => {
  try {
    const { UUID } = req.Userdata;

    // Fetch user data
    const user = await _User.findOne({ where: { UUID: UUID } });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    const { personal_ingredient_list } = user;

    // Initialize result array
    const result = await Promise.all(
      personal_ingredient_list.map(async (element) => {
        const unitid = parseInt(element.unit_id, 10);

        // Fetch unit details
        const unit_detail = await sequelize.models._Unit.findOne({
          where: { id: unitid },
        });
        console.log("day la " + unit_detail);
        if (unit_detail) {
          const { unit_name, unit_description } = unit_detail;
          const { unit_id, ...rest } = element;
          return {
            ...rest,
            unit: {
              id: unit_id,
              unit_name,
              unit_description,
            },
          };
        }

        return element; // Return the element as-is if no unit details are found
      })
    );

    // Send response
    return res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

// tạo nguyên liệu thông tin để trong body (tag ở front- phải để droopdown)
// kiểm tra nếu tag chưa có -> add tag vào bảng tag
const addIngredient = async (req, res, next) => {
  try {
    const { UUID } = req.Userdata;
    const { ingredient } = req.body;
    let { ingredient_name, unit_id, tags = [] } = ingredient;
    // lowercase the ingredient_name
    ingredient_name = ingredient_name.toLowerCase();
    if (!ingredient_name && !unit_id) {
      throw new BadRequestError("Missing ingredient_name or unit_id");
    }
    const user = await _User.findOne({ where: { UUID: UUID } });
    const { personal_ingredient_list } = user;
    const { tag_list } = user;

    if (
      personal_ingredient_list.some(
        (ingredient) => ingredient.ingredient_name === ingredient_name
      )
    ) {
      throw new BadRequestError("Ingredient already exists");
    }
    const newIngredient = { ingredient_name, unit_id };
    if (tags.length > 0) {
      newIngredient.tags = [];
      for (let i = 0; i < tags.length; i++) {
        newIngredient.tags.push({ tag_name: tags[i].tag_name.toLowerCase() });
      }
    }
    tags.forEach(async (tag) => {
      if (!tag_list.includes(tag)) {
        tag_list.push(tag.tag_name);
      }
    });
    user.tag_list = tag_list;
    personal_ingredient_list.push(newIngredient);
    user.personal_ingredient_list = personal_ingredient_list;
    user.changed("tag_list", true);
    user.changed("personal_ingredient_list", true);
    await user.save();
    return res.status(200).json(personal_ingredient_list);
  } catch (error) {
    next(error);
  }
};

// xóa nguyên liệu
const deleteIngredient = async (req, res, next) => {
  try {
    const { ingredient_name } = req.body;
    const { UUID } = req.Userdata;
    const user = await _User.findOne({ where: { UUID: UUID } });
    const { personal_ingredient_list } = user;
    const filtered_ingredient_list = personal_ingredient_list.filter(
      (ingredient) => ingredient.ingredient_name !== ingredient_name
    );
    user.personal_ingredient_list = filtered_ingredient_list;
    user.changed("personal_ingredient_list", true);
    await user.save();
    return res.status(200).json(filtered_ingredient_list);
  } catch (error) {
    next(error);
  }
};

// cập nhật nguyên liệu
const updateIngredient = async (req, res, next) => {
  try {
    // lấy các thông tin cần thiết
    const { old_ingredient_name, new_ingredient } = req.body;
    const { ingredient_name, unit_id, tags } = new_ingredient;
    const { UUID } = req.Userdata;
    // lấy thông tin personal_ingredient_list của user
    const user = await _User.findOne({ where: { UUID: UUID } });
    const { personal_ingredient_list } = user;
    // kiểm tra xem ingredient_name mới đã tồn tại chưa
    if (
      personal_ingredient_list.some(
        (ingredient) => ingredient.ingredient_name === ingredient_name
      )
    ) {
      throw new BadRequestError("This ingredient name already exists");
    }
    // kiểm tra các tag của nguyên liệu mới
    const { tag_list } = user;
    tags.forEach(async (tag) => {
      if (!tag_list.includes(tag.tag_name)) {
        tag_list.push(tag.tag_name);
      }
    });
    // nếu chưa tồn tại ingredient_name mới thì cập nhật thông tin
    const updated_ingredient_list = personal_ingredient_list.map(
      (ingredient) => {
        if (ingredient.ingredient_name === old_ingredient_name) {
          ingredient.ingredient_name = ingredient_name;
          ingredient.unit_id = unit_id;
          ingredient.tags = tags;
        }
        return ingredient;
      }
    );
    user.personal_ingredient_list = updated_ingredient_list;
    user.tag_list = tag_list;
    user.changed("personal_ingredient_list", true);
    user.changed("tag_list", true);
    await user.save();
    return res.status(200).json(updated_ingredient_list);
  } catch (error) {
    next(error);
  }
};

//lấy danh sách tag
const getTagList = async (req, res, next) => {
  try {
    const { UUID } = req.Userdata;
    const user = await _User.findOne({ where: { UUID: UUID } });
    const { tag_list } = user;
    return res.status(200).json(tag_list);
  } catch (error) {
    next(error);
  }
};

//thêm tag vào danh sách
const addTag = async (req, res, next) => {
  try {
    const { UUID } = req.Userdata;
    let { tag_name } = req.body;
    tag_name = tag_name.toLowerCase();
    const user = await _User.findOne({ where: { UUID: UUID } });
    const { tag_list } = user;
    if (tag_list.includes(tag_name)) {
      throw new BadRequestError("Tag already exists");
    }
    tag_list.push(tag_name);
    user.tag_list = tag_list;
    user.changed("tag_list", true);
    await user.save();
    return res.status(200).json(tag_list);
  } catch (error) {
    next(error);
  }
};

// xóa tag
const deleteTag = async (req, res, next) => {
  const { UUID } = req.Userdata;
  const { tag_name } = req.body;
  try {
    const user = await _User.findOne({ where: { UUID: UUID } });
    const { tag_list, personal_ingredient_list } = user;
    personal_ingredient_list.map((ingredient) => {
      ingredient.tags = ingredient.tags.filter(
        (tag) => tag.tag_name !== tag_name
      );
    });
    user.personal_ingredient_list = personal_ingredient_list;
    user.tag_list = tag_list.filter((tag) => tag !== tag_name);
    user.changed("personal_ingredient_list", true);
    user.changed("tag_list", true);
    await user.save();
    return res.status(200).json(user.tag_list);
  } catch (error) {
    next(error);
  }
};

// cập nhật tag
const updateTag = async (req, res, next) => {
  const { UUID } = req.Userdata;
  const { old_tag_name, new_tag_name } = req.body;
  try {
    const user = await _User.findOne({ where: { UUID: UUID } });
    const { tag_list, personal_ingredient_list } = user;
    personal_ingredient_list.map((ingredient) => {
      ingredient.tags.map((tag) => {
        if (tag.tag_name === old_tag_name) {
          tag.tag_name = new_tag_name;
        }
      });
    });
    user.personal_ingredient_list = personal_ingredient_list;
    user.tag_list = tag_list.map((tag) =>
      tag === old_tag_name ? new_tag_name : tag
    );
    user.changed("personal_ingredient_list", true);
    user.changed("tag_list", true);
    await user.save();
    return res.status(200).json(user.tag_list);
  } catch (error) {
    next(error);
  }
};

//match tag và ingredient
const matchTagAndIngredient = async (req, res, next) => {
  const { UUID } = req.Userdata;
  const { tag_name, ingredient_name } = req.body;
  try {
    const user = await _User.findOne({ where: { UUID: UUID } });
    const { personal_ingredient_list, tag_list } = user;
    if (!tag_list.includes(tag_name)) {
      throw new BadRequestError("Tag not found");
    }
    // tìm nguyên liệu trong personal_ingredient_list
    let item;
    personal_ingredient_list.map((ingredient) => {
      if (ingredient.ingredient_name === ingredient_name) {
        if (ingredient.tags.some((tag) => tag.tag_name === tag_name)) {
          throw new BadRequestError("Tag already exists");
        }
        ingredient.tags.push({ tag_name: tag_name });
        item = ingredient;
      }
    });
    user.personal_ingredient_list = personal_ingredient_list;
    user.changed("personal_ingredient_list", true);
    await user.save();
    return res.status(200).json(item);
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getIngredientList,
  addIngredient,
  deleteIngredient,
  updateIngredient,
  getTagList,
  addTag,
  deleteTag,
  updateTag,
  matchTagAndIngredient,
  getUserProfile,
  updateUserProfile,
  updateUserPassword,
};
