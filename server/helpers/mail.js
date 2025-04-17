const nodemailer = require("nodemailer");

exports.sendEmail = async (
  email,
  subject,
  msg,
  html,
  attachments,
  retries = 5
) => {
  // create reusable transporter object using the default SMTP transport
  let transporter = nodemailer.createTransport({
    host: process.env.sendgrid_host,
    port: process.env.sendgrid_port,
    auth: {
      user: process.env.user,
      pass: process.env.pass,
    },
  });

  let obj = {
    from: process.env.from, // sender address
    to: email, // list of receivers
    subject: subject, // Subject line
  };

  if (msg != null) {
    obj["text"] = msg;
  }
  if (html != null) {
    obj["html"] = html;
  }
  if (attachments != null) {
    obj["attachments"] = attachments;
  }

  for (let i = 0; i < retries; i++) {
    try {
      console.log("MSG PREPARED", JSON.stringify(obj));
      let info = await transporter.sendMail(obj);

      console.log("Message sent: %s", info.messageId);
      console.log("Preview URL: %s", nodemailer.getTestMessageUrl(info));
      console.log("Mail sent successfully");
      return "Mail sent successfully";
    } catch (e) {
      console.log("Error occurred while sending mail:", e);
      if (i < retries - 1) {
        console.log(`Retrying attempt ${i + 2}...`);
      } else {
        console.error(
          "Maximum number of attempts reached. Could not send email."
        );
        return "Failed to send mail";
      }
    }
  }
};
