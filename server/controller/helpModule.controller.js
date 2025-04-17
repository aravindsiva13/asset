const responsePacket = require("../helpers/response");
const fs = require("fs").promises;
const mailTemplate = require("../helpers/mailTemplate");
const mail = require("../helpers/mail");

exports.bot = async (req, res) => {
  let { name, emailId, issue, description } = req.body;

  try {
    let userData = {
      heading: "ITAM Admin",
      type: `${name}, You have raised a ${issue}. Our asset manager will contact you soon to address it.`,
      descriptions: description,
    };

    let userTemplate = await mailTemplate.generateTemplate("support", userData);

    let sendEmailToUser = mail.sendEmail(
      emailId,
      `${issue}: Ticket Created`,
      null,
      userTemplate
    );
    res.status(200).send(
      responsePacket.responsePacket(true, "User Mail Sent Successfully", {
        null: null,
      })
    );

    let adminData = {
      heading: "ITAM",
      type: `${name} has raised a ${issue}. Please resolve it as soon as possible.`,
      descriptions: description,
    };

    let adminTemplate = await mailTemplate.generateTemplate(
      "support",
      adminData
    );

    let sendEmailToAdmin = mail.sendEmail(
      process.env.from,
      `${issue}: New Ticket Raised`,
      null,
      adminTemplate
    );
    res.status(200).send(
      responsePacket.responsePacket(true, "Admin Mail Sent Successfully", {
        null: null,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Unable to send mail", {
        null: null,
      })
    );
  }
};
