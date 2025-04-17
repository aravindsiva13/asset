const express = require("express");
const router = express.Router();
const { catchErrors } = require("./../helpers/errorHandlers");
const companyControllers = require("./../controller/companyModule.controller");
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

// Create Company
router.post(
  "/addCompany",
  auth,
  upload.fields([{ name: "image", maxCount: 1 }]),
  catchErrors(companyControllers.createCompanyDetails)
);
// Update Company
router.post(
  "/updateCompany",
  auth,
  upload.fields([{ name: "image", maxCount: 1 }]),
  catchErrors(companyControllers.updateCompanyDetails)
);
// Delete Company
router.post(
  "/deleteCompany",
  auth,
  catchErrors(companyControllers.deleteCompanyDetails)
);

// Get Company Details
router.post(
  "/companyDetails",
  auth,
  catchErrors(companyControllers.getCompanyDetails)
);
module.exports = router;
