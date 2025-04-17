const moment = require("moment-timezone");

/**
 *
 * @param {string} date  string date ex. 31/07/23
 * @param {string} format format of the date string ex. DD/MM/YY
 * @param {string} timezone timezone the string date is in ex. Asia/Kolkata
 * @returns Javascript Date Object
 */
exports.parseDateWithTimezone = (date, format, timezone) => {
  const parsedDate = moment.tz(date, format, timezone);
  return parsedDate.toDate();
};

/**
 *
 * @param {string} date  string date ex. 31/07/23
 * @param {string} format format of the date string ex. DD/MM/YY
 * @param {string} timezone timezone the string date is in ex. Asia/Kolkata
 * @returns boolean true if date is valid or false if invalid date
 */
exports.validateDateWithTimezone = (date, format, timezone) => {
  const parsedDate = moment.tz(date, format, timezone);
  return parsedDate.isValid();
};
