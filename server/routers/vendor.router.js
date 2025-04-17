const express = require("express");
const router = express.Router();
const { catchErrors } = require("./../helpers/errorHandlers");
const vendorControllers = require("./../controller/vendorModule.controller");
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

// Create Vendor
router.post(
  "/addVendor",
  auth,
  upload.fields([
    { name: "contractDocument", maxCount: 1 },
    { name: "image", maxCount: 1 },
  ]),
  catchErrors(vendorControllers.createVendorDetails)
);
// Update Vendor
router.post(
  "/updateVendor",
  auth,
  upload.fields([
    { name: "contractDocument", maxCount: 1 },
    { name: "image", maxCount: 1 },
  ]),
  // upload.single("contractDocument"),
  catchErrors(vendorControllers.updateVendorDetails)
);
// Delete Vendor
router.post(
  "/deleteVendor",
  auth,
  catchErrors(vendorControllers.deleteVendorDetails)
);
// Get Vendor Details
router.post(
  "/vendorDetails",
  auth,
  catchErrors(vendorControllers.getVendorDetails)
);

module.exports = router;
