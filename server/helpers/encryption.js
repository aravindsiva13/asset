var bcrypt = require("bcrypt");
const saltRounds = 10;
exports.encryptPassword = function (password) {
  return bcrypt.hashSync(password, saltRounds);
};

exports.comparePassword = function (password, hashedPassword) {
  return bcrypt.compareSync(password, hashedPassword);
};
