const { Id } = require("../model/id");

exports.addDisplayId = async function (tableName, moduleName) {
  try {
    let idTable = await Id.findOne({ tableName: tableName });

    let displayIndex = idTable ? idTable.displayIndex + 1 : 1;

    if (!idTable) {
      idTable = new Id({
        tableName: tableName,
        displayIndex: displayIndex,
      });
      await idTable.save();
    } else {
      idTable.displayIndex = displayIndex;
      await idTable.save();
    }

    let paddedDisplayIndex = displayIndex.toString().padStart(4, "0");

    let displayId = tableName + paddedDisplayIndex;

    while (await moduleName.findOne({ displayId: displayId })) {
      displayIndex++;
      idTable.displayIndex = displayIndex;
      await idTable.save();
      paddedDisplayIndex = displayIndex.toString().padStart(4, "0");
      displayId = tableName + paddedDisplayIndex;
    }

    await Id.updateOne(
      { tableName: tableName },
      { displayIndex: displayIndex }
    );

    return displayId;
  } catch (error) {
    console.error("Error in displayId function:", error);
    throw error;
  }
};

exports.modifyDisplayId = async function (displayId, idprefix) {
  try {
    let numericPart = parseInt(displayId.match(/\d+$/)[0]);

    let editedDisplayId = displayId.replace(/\d+$/, numericPart - 1);

    let removedIdPrefix = editedDisplayId.replace(idprefix, "");

    let existingIdTable = await Id.findOne({ tableName: idprefix });

    if (
      !existingIdTable ||
      parseInt(existingIdTable.displayIndex) > parseInt(removedIdPrefix)
    ) {
      let idTable = await Id.updateOne(
        { tableName: idprefix },
        { displayIndex: removedIdPrefix }
      );
      return idTable;
    } else {
      return null;
    }
  } catch (error) {
    console.error("Error in displayId function:", error);
    throw error;
  }
};

/// Creating ID for Stock means Asset
exports.addDisplayIdForStock = async function (
  idPrefix,
  tableName,
  moduleName
) {
  try {
    let idTable = await Id.findOne({ tableName: tableName });

    let displayIndex = idTable ? idTable.displayIndex + 1 : 1;

    if (!idTable) {
      idTable = new Id({
        tableName: tableName,
        displayIndex: displayIndex,
      });
      await idTable.save();
    } else {
      idTable.displayIndex = displayIndex;
      await idTable.save();
    }

    let paddedDisplayIndex = displayIndex.toString().padStart(4, "0");

    let displayId = idPrefix + paddedDisplayIndex;

    while (await moduleName.findOne({ displayId: displayId })) {
      displayIndex++;
      idTable.displayIndex = displayIndex;
      await idTable.save();
      paddedDisplayIndex = displayIndex.toString().padStart(4, "0");
      displayId = idPrefix + paddedDisplayIndex;
    }

    await Id.updateOne(
      { tableName: tableName },
      { displayIndex: displayIndex }
    );

    return displayId;
  } catch (error) {
    console.error("Error in displayId function:", error);
    throw error;
  }
};
