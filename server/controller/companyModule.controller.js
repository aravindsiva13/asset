const {
  createCompanyValidator,
  deleteValidator,
} = require("../helpers/validator");
const Company = require("../model/company");
const responsePacket = require("../helpers/response");
const { addDisplayId, modifyDisplayId } = require("../helpers/displayId");

// Get Company Details
exports.getCompanyDetails = async (req, res) => {
  const { companyIds } = req.body;

  var companies = [];

  if (!companyIds || companyIds.length === 0) {
    companies = await Company.find();
  } else {
    const companyIdsFetcher = companyIds.map(async (companyId) => {
      var companyDetails;
      try {
        const companyDetailsList = await Company.find({
          _id: companyId,
        });
        companyDetails = companyDetailsList[0];

        if (!companyDetails) {
          companyDetails = {
            _id: companyId,
            error: "Null or Undefined",
          };
        } else {
          const matchingCompanyList = await Company.find()
            .where("_id")
            .in(companyDetails._id)
            .select("departments")
            .lean();
          const matchingCompany = matchingCompanyList[0];
          companyDetails = {
            ...companyDetails.toObject(),
            departments: matchingCompany.departments,
          }; // Merging the properties
        }
      } catch (e) {
        companyDetails = {
          _id: companyId,
          error: String(e),
        };
      }

      companies.push(companyDetails);
    });

    await Promise.allSettled(companyIdsFetcher);
  }

  res.status(200).send(
    responsePacket.responsePacket(true, "Companies Query Succeeded", {
      companies: companies,
    })
  );
};

// Create Company
exports.createCompanyDetails = async (req, res) => {
  let {
    name,
    address,
    phoneNumber,
    email,
    website,
    contactPersonName,
    contactPersonPhoneNumber,
    contactPersonEmail,
    departments,
    tag,
  } = JSON.parse(req.body.jsonData);

  let image = null;

  if (req.files != undefined && req.files != null) {
    try {
      image = req.files["image"][0].filename;
    } catch (e) {
      console.log(e);
    }
  }

  let error = [];

  error.push(
    ...createCompanyValidator(
      name,
      address,
      phoneNumber,
      email,
      website,
      contactPersonName,
      contactPersonPhoneNumber,
      contactPersonEmail,
      departments
    )
  );

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let idPrefix = "COMP";

  let displayId;
  try {
    displayId = await addDisplayId(idPrefix, Company);
  } catch (error) {
    console.error("Error while generating displayId:", error);
    res.status(500).send({
      ErrorMsg: "Error while generating displayId",
    });
    return;
  }

  try {
    let result = new Company({
      name: name,
      address: address,
      phoneNumber: phoneNumber,
      email: email,
      website: website,
      contactPersonName: contactPersonName,
      contactPersonPhoneNumber: contactPersonPhoneNumber,
      contactPersonEmail: contactPersonEmail,
      departments: departments,
      image: image,
      tag: tag,
      displayId: displayId,
    });
    await result.save();
    res.status(200).send(
      responsePacket.responsePacket(true, "Company Created Successfully", {
        null: null,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Company Not Created", {
        null: null,
      })
    );
  }
};

// Update Company
exports.updateCompanyDetails = async (req, res) => {
  let {
    name,
    address,
    phoneNumber,
    email,
    website,
    contactPersonName,
    contactPersonPhoneNumber,
    contactPersonEmail,
    departments,
    tag,
    sId,
  } = JSON.parse(req.body.jsonData);

  const companyId = sId;

  let image = null;

  if (req.files && req.files["image"] && req.files["image"][0]) {
    image = req.files["image"][0].filename;
  }

  let error = [];

  error.push(
    ...createCompanyValidator(
      name,
      address,
      phoneNumber,
      email,
      website,
      contactPersonName,
      contactPersonPhoneNumber,
      contactPersonEmail,
      departments
    )
  );

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    var companyJson = {
      name: name,
      address: address,
      phoneNumber: phoneNumber,
      email: email,
      website: website,
      contactPersonName: contactPersonName,
      contactPersonPhoneNumber: contactPersonPhoneNumber,
      contactPersonEmail: contactPersonEmail,
      departments: departments,
      tag: tag,
    };

    if (image != undefined && image != null) {
      companyJson.image = image;
    }

    const foundComapny = await Company.findOneAndUpdate(
      { _id: companyId },
      companyJson
    );

    if (!foundComapny) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "Company not found", {
          null: null,
        })
      );
    }

    const updatedCompany = await Company.findById(companyId);

    res.status(200).send(
      responsePacket.responsePacket(true, "Company Updated Successfully", {
        oldCompanyData: foundComapny,
        newCompanyData: updatedCompany,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Company Not Updated", {
        null: null,
      })
    );
  }
};

// Delete Company
exports.deleteCompanyDetails = async (req, res) => {
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
    let company = await Company.findById({ _id: id });

    if (!company) {
      res.status(404).send({
        ErrorMsg: "Company not found",
      });
      return;
    }

    let displayId = company.displayId;

    let idPrefix = "COMP";

    result = await Company.deleteOne({
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
      responsePacket.responsePacket(true, "Company is deleted successfully", {
        data: result,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Company is not deleted", {
        data: result,
      })
    );
  }
};
