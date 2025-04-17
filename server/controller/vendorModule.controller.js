const {
  createVendorValidator,
  updateVendorValidator,
  deleteValidator,
} = require("../helpers/validator");
const Vendor = require("../model/vendor");
const responsePacket = require("../helpers/response");
const { addDisplayId, modifyDisplayId } = require("../helpers/displayId");

exports.getVendorDetails = async (req, res) => {
  const { vendorId } = req.body;
  try {
    const allVendor = await Vendor.find();
    //const vendor = await Vendor.findById({ _id: vendorId });

    if (allVendor && allVendor.length > 0) {
      res.status(200).send(
        responsePacket.responsePacket(true, "Vendor Found", {
          allVendor: allVendor,
        })
      );
    } else {
      res.status(500).send(
        responsePacket.responsePacket(false, "Vendor not Found", {
          allVendor: [],
        })
      );
    }
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Vendor Not Found", {
        null: null,
      })
    );
  }
};

// Create Vendor
exports.createVendorDetails = async (req, res) => {
  let { vendorName, address, phoneNumber, email, name, gstIn, tag } =
    JSON.parse(req.body.jsonData);

  let contractDocument = null;
  let image = null;

  if (
    req.files &&
    req.files["contractDocument"] &&
    req.files["contractDocument"][0]
  ) {
    contractDocument = req.files["contractDocument"][0].filename;
  }

  if (req.files && req.files["image"] && req.files["image"][0]) {
    image = req.files["image"][0].filename;
  }

  let error = [];

  error.push(
    ...createVendorValidator(
      vendorName,
      address,
      phoneNumber,
      email,
      name,
      gstIn
    )
  );

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let idPrefix = "VEND";

  let displayId;
  try {
    displayId = await addDisplayId(idPrefix, Vendor);
  } catch (error) {
    console.error("Error while generating displayId:", error);
    res.status(500).send({
      ErrorMsg: "Error while generating displayId",
    });
    return;
  }

  try {
    var vendorJson = {
      vendorName: vendorName,
      address: address,
      phoneNumber: phoneNumber,
      email: email,
      name: name,
      gstIn: gstIn,
      tag: tag,
      displayId: displayId,
    };

    if (contractDocument != undefined && contractDocument != null) {
      vendorJson.contractDocument = contractDocument;
    }

    if (image != undefined && image != null) {
      vendorJson.image = image;
    }

    let result = new Vendor(vendorJson).save();

    res.status(200).send(
      responsePacket.responsePacket(true, "Vendor Created Successfully", {
        data: result,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Vendor Not Created", {
        null: null,
      })
    );
  }
};

// Update Vendor
exports.updateVendorDetails = async (req, res) => {
  let { vendorName, address, phoneNumber, email, name, gstIn, tag, sId } =
    JSON.parse(req.body.jsonData);

  const vendorId = sId;

  let contractDocument = null;
  let image = null;

  if (
    req.files &&
    req.files["contractDocument"] &&
    req.files["contractDocument"][0]
  ) {
    contractDocument = req.files["contractDocument"][0].filename;
  }

  if (req.files && req.files["image"] && req.files["image"][0]) {
    image = req.files["image"][0].filename;
  }

  let error = [];

  error.push(
    ...updateVendorValidator(
      vendorName,
      address,
      phoneNumber,
      email,
      name,
      gstIn
    )
  );

  if (error.length !== 0) {
    return res.status(400).send({
      ErrorMsg: error,
    });
  }

  try {
    var vendorJson = {
      vendorName: vendorName,
      address: address,
      phoneNumber: phoneNumber,
      email: email,
      name: name,
      gstIn: gstIn,
      tag: tag,
    };

    if (contractDocument != undefined && contractDocument != null) {
      vendorJson.contractDocument = contractDocument;
    }

    if (image != undefined && image != null) {
      vendorJson.image = image;
    }

    const foundVendor = await Vendor.findOneAndUpdate(
      { _id: vendorId },
      vendorJson
    );

    if (!foundVendor) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "Vendor not found", {
          null: null,
        })
      );
    }

    const updatedVendor = await Vendor.findById(vendorId);

    res.status(200).send(
      responsePacket.responsePacket(true, "Vendor Updated Successfully", {
        oldVendorData: foundVendor,
        newVendorData: updatedVendor,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Vendor Not Updated", {
        null: null,
      })
    );
  }
};

// Delete Vendor
exports.deleteVendorDetails = async (req, res) => {
  const { id } = req.body;

  let error = [];

  error.push(...deleteValidator(id));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let result = null;
  try {
    let vendor = await Vendor.findById({ _id: id });

    if (!vendor) {
      res.status(404).send({
        ErrorMsg: "Vendor not found",
      });
      return;
    }

    let displayId = vendor.displayId;

    let idPrefix = "VEND";

    result = await Vendor.deleteOne({
      _id: id,
    });

    try {
      await modifyDisplayId(displayId, idPrefix);
    } catch (error) {
      console.error("Error while removing displayId:", error);
      res.status(500).send({
        ErrorMsg: "Error while removing displayId",
      });
      return;
    }

    res.status(200).send(
      responsePacket.responsePacket(true, "Vendor is deleted successfully", {
        data: result,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Vendor is not deleted", {
        data: result,
      })
    );
  }
};
