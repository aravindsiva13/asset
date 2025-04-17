const jwt = require("jwt-then");
module.exports = async (req, res, next) => {
  try {
    if (!req.headers.authorization) throw "Unauthorized!!";
    const payload = await jwt.verify(
      req.headers.authorization,
      process.env.SECRET
    );
    req.payload = payload;
    next();
  } catch (e) {
    console.log(e);
    res.status(401).json({
      message: "Unauthorized",
    });
  }
};
