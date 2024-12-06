const dotenv = require('dotenv');
const sequelize= require('../config/database');
const { BadRequestError } = require('../errors/error');

//lấy nguyên liệu từ tủ lạnh
// 
const ingredientList = async (req, res,next) => {
    const {GID} = req.params;
    try{
        const group = await sequelize.models._Group.findOne({where:{GID:GID}});
        const {fridge} = group;
        res.status(200).json(fridge);
    }catch(error){
        next(error)
    }
}

//thêm nguyên liệu vào tủ lạnh
/**
 có 2 trương hợp: 
    1. nguyên liệu đã có trong tủ lạnh 
        1.1. nguyên liệu này cùng ngày với nguyên liệu đã có -> cộng thêm số lượng
        1.2. nguyên liệu này khác ngày với nguyên liệu đã có -> push vào trường detail object có dạng {
            "quantity": 3,
            "createdAt": "2024-12-03"
      }
    2. nguyên liệu chưa có trong tủ lạnh -> thêm mới
 */
const addIngred = async (req,res,next)=>{
    const {GID}= req.params;
    const {ingredient}= req.body;
    const {ingredient_name,detail}= ingredient
    const {quantity,createdAt}= detail[0];
    try{
        const group = await sequelize.models._Group.findOne({where:{GID:GID}});
        const {fridge} = group;
        let index = fridge.findIndex((item)=>item.ingredient_name === ingredient_name);
        if(index === -1){
            fridge.push(ingredient);}
        else{
            let detailIndex = fridge[index].detail.findIndex((item)=>item.createdAt===createdAt);
            if(detailIndex===-1){
                fridge[index].detail.push({quantity,createdAt});
            }else{
                fridge[index].detail[detailIndex].quantity+=quantity;
            }
        }
        group.fridge=fridge;
        group.changed('fridge',true);
        await group.save();
        return res.status(200).json(fridge)
    }catch(error){
        next(error)
    }
}
// chỉnh sửa nguyên liệu trong tủ lạnh
const updateIngred = async (req,res,next)=>{
    const {GID}= req.params;
    const{old_ingredient_name,ingredient}= req.body;
    try{
        const group = await sequelize.models._Group.findOne({where:{GID:GID}});
        const {fridge} = group;
        let index = fridge.findIndex((item)=>item.ingredient_name === old_ingredient_name);
        if(index === -1){
            throw new BadRequestError('Ingredient not found');
        }
        fridge[index]=ingredient;
        group.fridge=fridge;
        group.changed('fridge',true);
        await group.save();
        return res.status(200).json(fridge)
    }catch(error){
        next(error)
    }
}

//xóa nguyên liệu trong tủ lạnh
const deleteIngred = async (req,res,next)=>{
    const {GID}= req.params;
    const{ingredient_name}= req.body;
    try{
        const group = await sequelize.models._Group.findOne({where:{GID:GID}});
        const {fridge} = group;
        const newFridge = fridge.filter((item)=>item.ingredient_name!==ingredient_name);
        group.fridge=newFridge;
        group.changed('fridge',true);
        await group.save();
        return res.status(200).json(newFridge)
    }catch(error){
        next(error)
    }   
}

// tiêu thụ nguyên liệu trong tủ lạnh
/**
 có 3 trường hợp tiêu thụ:
    số lượng tiêu thụ >= tổng => xóa nguyên liệu
    số lượng tiêu thụ < tổng
        xét mảng detail, xếp mảng detail từ ngày gần nhất đến ngày xa nhất (max->min)
        nếu số lượng tiêu thụ > số lượng của detail đó thì xóa detail này và xét đến detail kế, cho tới khi hết lượng tiêu thụ
 */
const consumeIngred = async (req,res,next)=>{
    const {GID}= req.params;
    const {ingredient_name,quantity}=req.body
    try{
        const group = await sequelize.models._Group.findOne({where:{GID:GID}})
        const {fridge}= group
        const ingreIndex = fridge.findIndex((item)=>item.ingredient_name===ingredient_name)
        if(ingreIndex===-1) throw new BadRequestError("no ingredient match")
        let sum_quantity = fridge[ingreIndex].detail.reduce((acc, item) => acc + item.quantity, 0);
        if(quantity>=sum_quantity){
            const newFridge = fridge.filter((item)=>item.ingredient_name!==ingredient_name);
            group.fridge=newFridge;
            group.changed('fridge',true);
            await group.save();
            return res.status(200).json(newFridge)
        }
        // nếu quantity>=sum_quantity thì trừ quantity từ detail có createdAt nhỏ nhất tới lớn nhất
        //sort theo trường createdAt
        fridge[ingreIndex].detail.sort((a,b)=> new Date(a.createdAt)-new Date(b.createdAt))
        while(quantity!=0){

        }
    }catch(error){
        next(error)
    }

}

module.exports = {
    ingredientList, addIngred, updateIngred, deleteIngred
}