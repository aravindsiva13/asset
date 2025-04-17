const express = require("express");
const router = express.Router();
const { catchErrors } = require("./../helpers/errorHandlers");
const locationControllers = require("./../controller/locationModule.controller");
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
const upload = multer({ storage });

// Create Location
router.post(
  "/addLocation",
  auth,
  catchErrors(locationControllers.createLocationDetails)
);
// Update Location
router.post(
  "/updateLocation",
  auth,
  catchErrors(locationControllers.updateLocationDetails)
);
// Get Location Details
router.post(
  "/locationDetails",
  auth,
  catchErrors(locationControllers.getLocationDetails)
);
// Delete Location Details
router.post(
  "/deleteLocation",
  auth,
  catchErrors(locationControllers.deleteLocation)
);

module.exports = router;
