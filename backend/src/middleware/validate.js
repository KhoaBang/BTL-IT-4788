const Ajv = require('ajv');
const addFormats = require('ajv-formats');
const ajv = new Ajv();
addFormats(ajv);

 const loginSchema = {
  type: "object",
  required: ["email", "password"],
  properties: {
    email: { type: "string", format: "email" },
    password: { type: "string", minLength: 6 },
  },
};

 const refreshSchema = {
  type: "object",
  required: ["refresh_token"],
  properties: {
    refresh_token: { type: "string" },
  },
};
 const registerSchema = {
  type: "object",
  required: ['username',"email", "password"],
  properties: {
    username:{type: "string"},
    email: { type: "string", format: "email" },
    password: { type: "string", minLength: 6 },
  },
}
 const validateReq = (schema) => {
  const validate = ajv.compile(schema);

  return (req, res, next) => {
    const isValid = validate(req.body);

    if (!isValid) {
      const errors = validate.errors
        .map((err) => `${err.instancePath} ${err.message}`)
        .join(", ");
      return res.status(400).json({ error: `Validation failed: ${errors}` });
    }

    next(); // Pass control to the next middleware or route handler
  };
};
module.exports = {
  loginSchema,
  refreshSchema,
  registerSchema,
  validateReq,
};
