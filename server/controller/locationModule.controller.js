const {
  createlocationValidator,
  deleteValidator,
} = require("../helpers/validator");
const Location = require("../model/location");
const responsePacket = require("../helpers/response");
const { addDisplayId, modifyDisplayId } = require("../helpers/displayId");

// Get Location Details
exports.getLocationDetails = async (req, res) => {
  const { locationId } = req.body;
  try {
    const allLocation = await Location.find();

    res.status(200).send(
      responsePacket.responsePacket(true, "Location Found", {
        allLocation: allLocation,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Location Not Found", {
        null: null,
      })
    );
  }
};

// Create Location Page
exports.createLocationDetails = async (req, res) => {
  const { name, plusCode, address, latitude, longitude, tag } = req.body;

  let error = [];

  error.push(
    ...createlocationValidator(plusCode, address, latitude, longitude)
  );

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let idPrefix = "LOC";

  let displayId;
  try {
    displayId = await addDisplayId(idPrefix, Location);
  } catch (error) {
    console.error("Error while generating displayId:", error);
    res.status(500).send({
      ErrorMsg: "Error while generating displayId",
    });
    return;
  }

  try {
    let result = new Location({
      name: name,
      plusCode: plusCode,
      latitude: latitude,
      longitude: longitude,
      address: address,
      tag: tag,
      displayId: displayId,
    });
    await result.save();
    res.status(200).send(
      responsePacket.responsePacket(true, "Location Created Successfully", {
        null: null,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Location Not Created", {
        null: null,
      })
    );
  }
};

// Update Location Page
exports.updateLocationDetails = async (req, res) => {
  const { name, plusCode, address, latitude, longitude, tag, sId } = req.body;

  const locationId = sId;

  let error = [];

  error.push(
    ...createlocationValidator(plusCode, address, latitude, longitude)
  );

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    const foundLocation = await Location.findOneAndUpdate(
      { _id: locationId },
      {
        name: name,
        plusCode: plusCode,
        latitude: latitude,
        longitude: longitude,
        address: address,
        tag: tag,
      }
    );

    if (!foundLocation) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "Location not found", {
          null: null,
        })
      );
    }

    const updatedLocation = await Location.findById(locationId);

    res.status(200).send(
      responsePacket.responsePacket(true, "Location updated successfully", {
        oldLocationData: foundLocation,
        newLocationData: updatedLocation,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Location Not Updated", {
        null: null,
      })
    );
  }
};

exports.deleteLocation = async (req, res) => {
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
    let location = await Location.findById({ _id: id });

    if (!location) {
      res.status(404).send({
        ErrorMsg: "Location not found",
      });
      return;
    }

    let displayId = location.displayId;

    let idPrefix = "LOC";

    result = await Location.deleteOne({
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
      responsePacket.responsePacket(true, "Location is deleted successfully", {
        data: result,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Location is not deleted", {
        data: result,
      })
    );
  }
};
