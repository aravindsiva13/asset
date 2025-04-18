/*
  Catch Errors Handler
*/

const multer = require("multer");

exports.catchErrors = (fn) => {
  return function (req, res, next) {
    fn(req, res, next).catch((err) => {
      console.log(err);
      if (typeof err === "string") {
        res.status(400).json({
          message: err,
        });
      } else {
        next(err);
      }
    });
  };
};

exports.catchMulterErrors = (fn) => {
  return function (req, res, next) {
    try {
      console.log("GOT IT");
      fn(req, res, next);
    } catch (err) {
      console.log(err);
      if (err instanceof multer.MulterError) {
        res.status(400).json({
          message: err + "Upload failed due to multer error",
        });
      } else if (err) {
        res.status(400).json({
          message: err + "Upload failed due to unknown error",
        });
      } else {
        next(err);
      }
    }
  };
};

/*
        Development Error Handler
      
        In development we show good error messages so if we hit a syntax error or any other previously un-handled error, we can show good info on what happened
      */

exports.developmentErrors = (err, req, res, next) => {
  err.stack = err.stack || "";
  const errorDetails = {
    message: err.message,
    status: err.status,
    stack: err.stack,
  };

  res.status(err.status || 500).json(errorDetails); // send JSON back
};

/*
        Production Error Handler
      
        No stacktraces and error details are leaked to user
      */
exports.productionErrors = (err, req, res, next) => {
  res.status(err.status || 500).json({
    error: "Internal Server Error",
  }); // send JSON back
};

/*
      404 Page Error
      */

exports.notFound = (req, res, next) => {
  res.status(404).json({
    message: "Route not found",
  });
};
