const express = require("express");
const router = express.Router();
const { catchErrors } = require("./../helpers/errorHandlers");
const ticketControllers = require("./../controller/ticketModule.controller");
const otherModule = require("./../controller/otherModule.controller");
const auth = require("./../helpers/auth");
const multer = require("multer");
const { GridFsStorage } = require("multer-gridfs-storage");
const crypto = require("crypto");
const path = require("path");

// Used for Storage in Mongo DB
const storage = new GridFsStorage({
  url: process.env.MONGO_URL,
  file: (req, file) => {
    return new Promise((resolve, reject) => {
      crypto.randomBytes(16, (err, buf) => {
        if (err) {
          return reject(err);
        }
        const filename = buf.toString("hex") + path.extname(file.originalname);
        const fileInfo = {
          filename: filename,
          bucketName: "uploads",
        };
        resolve(fileInfo);
      });
    });
  },
});
const upload = multer({
  storage: storage,
  limits: { fieldSize: 10 * 1024 * 1024 },
});

router.post(
  "/addTicket",
  auth,
  upload.fields([{ name: "attachment", maxCount: 1 }]),
  catchErrors(ticketControllers.addTicket)
);
router.post(
  "/updateTicket",
  auth,
  upload.fields([{ name: "attachment", maxCount: 1 }]),
  catchErrors(ticketControllers.updateTicket)
);
// Get Ticket Details
router.post(
  "/ticketDetails",
  auth,
  catchErrors(ticketControllers.getTicketDetails)
);
// Delete Ticket
router.post(
  "/deleteTicket",
  auth,
  catchErrors(ticketControllers.deleteTicketDetails)
);

router.post(
  "/addComment",
  auth,
  upload.fields([{ name: "attachment", maxCount: 1 }]),
  catchErrors(ticketControllers.addComments)
);
router.post(
  "/updateComment",
  auth,
  upload.fields([{ name: "attachment", maxCount: 1 }]),
  catchErrors(ticketControllers.updateComments)
);

// Get Ticket Tracker Details
router.post(
  "/ticketTrackerDetails",
  auth,
  catchErrors(ticketControllers.ticketTracker)
);
// Assign a Ticket
router.post("/assignTicket", auth, catchErrors(ticketControllers.assignTicket));

// Ticket View User
router.post("/ticketView", auth, catchErrors(ticketControllers.ticketView));

/// Other Module Router
router.post(
  "/notification",
  auth,
  catchErrors(otherModule.getNotificationDetails)
);
router.post(
  "/countDetails",
  auth,
  catchErrors(otherModule.getCountOfAllDetails)
);
router.post("/checkList", auth, catchErrors(otherModule.addCheckList));

module.exports = router;
