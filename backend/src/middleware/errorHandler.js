// middleware/errorHandler.js
 const errorHandler = (err, req, res, next) => {
    const statusCode = err.statusCode || 500; // Default to 500 for server errors
    const errorMessage = err.message || 'An unexpected error occurred.';
  
    res.status(statusCode).json({
      error: {
        name: err.name,
        message: errorMessage,
      },
    });
  };
  
  module.exports = { errorHandler };