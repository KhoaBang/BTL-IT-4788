const cors = require("cors");
const dotenv = require("dotenv");
const express = require("express");
const morgan = require("morgan");
const { errorHandler } = require("./middleware/errorHandler");

const admin = require("firebase-admin");
const serviceAccount = require("./firebase.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

/*
Import routes here:
*/
const authRoutes = require("./routes/auth.routes");
const groupRoutes = require("./routes/group.routes.js");
const userRoutes = require("./routes/user.routes.js");
const fridgeRoutes = require("./routes/fridge.routes.js");
const shoppingRoutes = require("./routes/shopping.routes.js");
const mealRoutes = require("./routes/meal.routes.js");
const recipeRoutes = require("./routes/recipe.routes.js");
dotenv.config();

const app = express();
app.set("trust proxy", true);

const FRONTEND_URL = process.env.FRONTEND_URL ?? false;

const corsURLs = [FRONTEND_URL].filter((v) => v);

app.use(
  cors({
    origin:  "*",
    methods: ["POST", "GET", "PUT", "DELETE", "PATCH"],
    optionsSuccessStatus: 200,
    preflightContinue: true,
  })
);

app.use(morgan("tiny"));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.get("/", (req, res) => res.send("Hello from MealPrep!"));
app.get("/api", (req, res) => res.send("Hello from MealPrep API!"));
app.use("/api", authRoutes);
app.use("/api", groupRoutes);
app.use("/api", userRoutes);
app.use("/api", fridgeRoutes);
app.use("/api", shoppingRoutes);
app.use("/api", mealRoutes);
app.use("/api", recipeRoutes);
// Error Handling Middleware
app.use(errorHandler);

// Catch-all 404 for undefined routes
app.use((req, res, next) => {
  res.status(404).json({
    status: 0,
    message: "Not Found - The requested resource does not exist.",
  });
});

module.exports = app;
