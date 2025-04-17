exports.responsePacket = function (
  apiStatus,

  msg,

  data
) {
  var response = [apiStatus];

  let format = { msg: msg };

  if (data !== undefined && data !== null) {
    format.data = data;
  }

  response.push(format);

  return response;
};
