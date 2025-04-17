const express = require("express");
const router = express.Router();
const { catchErrors } = require("./../helpers/errorHandlers");
const helpControllers = require("./../controller/helpModule.controller");
const auth = require("./../helpers/auth");
const responsePacket = require("../helpers/response");
const mailTemplate = require("../helpers/mailTemplate");
const mail = require("../helpers/mail");

var multer = require("multer"),
  upload = multer({ storage: multer.memoryStorage({}) });

router.post("/bot", auth, catchErrors(helpControllers.bot));

router.post(
  "/helpSection",
  upload.single("image"),
  async function (req, res, next) {
    let fileInfo = req.file;
    let { queries, emailId } = JSON.parse(req.body.jsonData);

    let userData = {
      heading: "ITAM Admin",
      descriptions: queries,
    };

    let adminData = {
      heading: "ITAM",
      descriptions: queries,
    };

    let attachments = [];
    if (fileInfo) {
      attachments.push({
        content: fileInfo.buffer,
        filename: fileInfo.originalname,
        type: fileInfo.mimetype,
        disposition: "attachment",
      });
    }

    try {
      let adminTemplate = await mailTemplate.generateTemplate(
        "help",
        adminData
      );
      let userTemplate = await mailTemplate.generateTemplate("help", userData);
      let sendEmailToUser = await mail.sendEmail(
        emailId,
        `Ticket Created`,
        null,
        userTemplate,
        attachments
      );
      let sendEmailToAdmin = await mail.sendEmail(
        process.env.from,
        `New Ticket Raised`,
        null,
        adminTemplate,
        attachments
      );
      res.status(200).send(
        responsePacket.responsePacket(true, "Querie Sent Successfully", {
          null: null,
        })
      );
    } catch (error) {
      console.log(error);
      res.status(500).send(
        responsePacket.responsePacket(false, "Querie Not Sent", {
          null: null,
        })
      );
    }
  }
);

module.exports = router;
