-- Create 'User' table
CREATE TABLE IF NOT EXISTS `User` (
    `UUID` int AUTO_INCREMENT NOT NULL UNIQUE,
    `Username` varchar(255) NOT NULL,
    `DOB` date,
    `Email` varchar(255) NOT NULL UNIQUE,
    `Password` varchar(255) NOT NULL UNIQUE,
    `Tag_list` JSON NOT NULL,
    `Personal_ingredient_list` JSON NOT NULL,
    PRIMARY KEY (`UUID`),
    CHECK (JSON_VALID(`Tag_list`)), -- Ensures 'Tag_list' contains valid JSON
    CHECK (JSON_VALID(`Personal_ingredient_list`)) -- Ensures 'Personal_ingredient_list' contains valid JSON
);

-- Create 'Recipe' table
CREATE TABLE IF NOT EXISTS `Recipe` (
    `recipe_id` int AUTO_INCREMENT NOT NULL UNIQUE,
    `user_id` int NOT NULL,
    `text_guide` text NOT NULL,
    `Ingredient_list` JSON NOT NULL,
    PRIMARY KEY (`recipe_id`),
    FOREIGN KEY (`user_id`) REFERENCES `User`(`UUID`),
    CHECK (JSON_VALID(`Ingredient_list`)) -- Ensures 'Ingredient_list' contains valid JSON
);

-- Create 'INGREDIENTS' table
CREATE TABLE IF NOT EXISTS `INGREDIENTS` (
    `ingredient_id` int AUTO_INCREMENT NOT NULL UNIQUE,
    `ingredient_name` varchar(255) NOT NULL,
    `Unit` varchar(255) NOT NULL,
    PRIMARY KEY (`ingredient_id`)
);

-- Create 'UserGroup' (previously `GROUP`) table to avoid reserved keyword conflict
CREATE TABLE IF NOT EXISTS `UserGroup` (
    `Group_id` int AUTO_INCREMENT NOT NULL UNIQUE,
    `Manager_id` int NOT NULL,
    `Group_name` varchar(255) NOT NULL,
    PRIMARY KEY (`Group_id`),
    FOREIGN KEY (`Manager_id`) REFERENCES `User`(`UUID`)
);

-- Create 'GROUP_MEMBER' table
CREATE TABLE IF NOT EXISTS `GROUP_MEMBER` (
    `User_id` int NOT NULL,
    `Group_id` int NOT NULL,
    `Time_join` datetime NOT NULL,
    PRIMARY KEY (`User_id`, `Group_id`),
    FOREIGN KEY (`User_id`) REFERENCES `User`(`UUID`),
    FOREIGN KEY (`Group_id`) REFERENCES `UserGroup`(`Group_id`)
);

-- Create 'MEALS' table
CREATE TABLE IF NOT EXISTS `MEALS` (
    `Meal_id` int AUTO_INCREMENT NOT NULL UNIQUE,
    `Meal_name` varchar(255) NOT NULL,
    `Consume_date` JSON NOT NULL,
    `Group_id` int NOT NULL,
    `Ingredient_list` JSON NOT NULL,
    PRIMARY KEY (`Meal_id`),
    FOREIGN KEY (`Group_id`) REFERENCES `UserGroup`(`Group_id`),
    CHECK (JSON_VALID(`Consume_date`)), -- Ensures 'Consume_date' contains valid JSON
    CHECK (JSON_VALID(`Ingredient_list`)) -- Ensures 'Ingredient_list' contains valid JSON
);

-- Create 'FRIDGE' table
CREATE TABLE IF NOT EXISTS `FRIDGE` (
    `Group_id` int NOT NULL UNIQUE,
    `Ingredient_list` JSON NOT NULL,
    PRIMARY KEY (`Group_id`),
    FOREIGN KEY (`Group_id`) REFERENCES `UserGroup`(`Group_id`),
    CHECK (JSON_VALID(`Ingredient_list`)) -- Ensures 'Ingredient_list' contains valid JSON
);

-- Create 'SHOPPING_LISTS' table
CREATE TABLE IF NOT EXISTS `SHOPPING_LISTS` (
    `List_id` int AUTO_INCREMENT NOT NULL UNIQUE,
    `Group_id` int NOT NULL,
    `Issued_at` datetime NOT NULL,
    PRIMARY KEY (`List_id`),
    FOREIGN KEY (`Group_id`) REFERENCES `UserGroup`(`Group_id`)
);

-- Create 'TASKS_OF_LIST' table
CREATE TABLE IF NOT EXISTS `TASKS_OF_LIST` (
    `List_id` int NOT NULL,
    `Ingredient` JSON NOT NULL,
    `From` int NOT NULL,
    `To` int NOT NULL,
    `Status` boolean NOT NULL,
    `Note` JSON NOT NULL,
    FOREIGN KEY (`List_id`) REFERENCES `SHOPPING_LISTS`(`List_id`),
    FOREIGN KEY (`From`) REFERENCES `User`(`UUID`),
    FOREIGN KEY (`To`) REFERENCES `User`(`UUID`),
    CHECK (JSON_VALID(`Ingredient`)), -- Ensures 'Ingredient' contains valid JSON
    CHECK (JSON_VALID(`Note`)) -- Ensures 'Note' contains valid JSON
);
