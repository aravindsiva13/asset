const express = require("express");
const router = express.Router();
const { catchErrors } = require("./../helpers/errorHandlers");
const userControllers = require("./../controller/userModule.controller");
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

// Add User
router.post(
  "/addUser",
  auth,
  upload.single("image"),
  catchErrors(userControllers.addUser)
);
// Add Bulk User
router.post(
  "/addBulkUser",
  auth,
  upload.single("image"),
  catchErrors(userControllers.addBulkUsers)
);
// Update or Edit User
router.post(
  "/updateUser",
  auth,
  upload.single("image"),
  catchErrors(userControllers.updateUser)
);
//  Delete User
router.post("/deleteUser", auth, catchErrors(userControllers.deleteUser));
// Get User Details
router.post("/userDetails", auth, catchErrors(userControllers.getUserDetails));
// Get Particular Usert Details
router.post(
  "/particularUser",
  auth,
  catchErrors(userControllers.getParticularUserDetails)
);

// Login User
router.post("/login", catchErrors(userControllers.loginUser));
// Reset Password from User Side
router.post("/resetUser", auth, catchErrors(userControllers.resetPassworUser));
// Reset Password from Admin Side
router.post(
  "/resetAdmin",
  auth,
  catchErrors(userControllers.resetPasswordAdmin)
);

// Get User Configuration Details
router.post(
  "/userConfigurationDetails",
  auth,
  catchErrors(userControllers.getUserConfiguration)
);
// Update User Configuration Details
router.post(
  "/updateuserConfiguration",
  auth,
  catchErrors(userControllers.updateUserConfiguration)
);

// Assign Role
router.post("/role", auth, catchErrors(userControllers.assignRole));

// Update Assign Role
router.post("/updateRole", auth, catchErrors(userControllers.updateAssignRole));

//  Assign Role Details
router.post(
  "/roleDetails",
  auth,
  catchErrors(userControllers.getAssignRoleDetails)
);

router.post(
  "/deleteRole",
  auth,
  catchErrors(userControllers.deleteRoleDetails)
);

module.exports = router;
