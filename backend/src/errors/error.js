// errors/NotAuthenticateError.js
 class NotAuthenticateError extends Error {
    constructor(message) {
      super(message);
      this.name = 'NotAuthenticateError';
      this.statusCode = 401; // HTTP 401 Unauthorized
    }
  }
  
  // errors/BadRequestError.js
   class BadRequestError extends Error {
    constructor(message) {
      super(message);
      this.name = 'BadRequestError';
      this.statusCode = 400; // HTTP 400 Bad Request
    }
  }
  
  // errors/NotFoundError.js
   class NotFoundError extends Error {
    constructor(message) {
      super(message);
      this.name = 'NotFoundError';
      this.statusCode = 404; // HTTP 404 Not Found
    }
  }
  
  // errors/InternalServerError.js
   class InternalServerError extends Error {
    constructor(message) {
      super(message);
      this.name = 'InternalServerError';
      this.statusCode = 500; // HTTP 500 Internal Server Error
    }
  }
  
  // errors/ForbiddenError.js
   class ForbiddenError extends Error {
    constructor(message) {
      super(message);
      this.name = 'ForbiddenError';
      this.statusCode = 403; // HTTP 403 Forbidden
    }
  }
  
  module.exports = {
    NotAuthenticateError,
    BadRequestError,
    NotFoundError,
    InternalServerError,
    ForbiddenError,
  };