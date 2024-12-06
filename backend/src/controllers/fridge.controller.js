const dotenv = require('dotenv');
const sequelize= require('../config/database');

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

module.exports = {
    ingredientList
}