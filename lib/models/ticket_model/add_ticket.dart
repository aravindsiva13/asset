/// <!-- Data Class for Ticket --!> ///
class AddTicket {
  String? type;
  String? priority;
  String? vendorRefId;
  String? modelRefId;
  String? expectedTime;
  String? description;
  String? userRefId;
  String? assignedRefId;
  String? stockRefId;
  String? status;
  String? locationRefId;
  String? estimatedTime;
  String? remarks;
  String? attachment;
  String? createdBy;
  String? updatedBy;
  String? displayId;
  String? sId;

  AddTicket({
    this.type,
    this.priority,
    this.vendorRefId,
    this.modelRefId,
    this.expectedTime,
    this.description,
    this.assignedRefId,
    this.userRefId,
    this.stockRefId,
    this.status,
    this.locationRefId,
    this.estimatedTime,
    this.remarks,
    this.attachment,
    this.createdBy,
    this.updatedBy,
    this.displayId='',
    this.sId,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['type'] = type;
    map['priority'] = priority;
    map['vendorRefId'] = vendorRefId;
    map['modelRefId'] = modelRefId;
    map['expectedTime'] = expectedTime;
    map['description'] = description;
    map['assignedRefId'] = assignedRefId;
    map['userRefId'] = userRefId;
    map['stockRefId'] = stockRefId;
    map['status'] = status;
    map['locationRefId'] = locationRefId;
    map['estimatedTime'] = estimatedTime;
    map['remarks'] = remarks;
    map['attachment'] = attachment;
    map['createdBy'] = createdBy;
    map['updatedBy'] = updatedBy;
    map['displayId'] = displayId;
    map['sId'] = sId;

    return map;
  }

  AddTicket.fromMapObject(Map<String, dynamic> map) {
    type = map['type'];
    priority = map['priority'];
    vendorRefId = map['vendorRefId'];
    modelRefId = map['modelRefId'];
    expectedTime = map['expectedTime'];
    description = map['description'];
    assignedRefId = map['assignedRefId'];
    userRefId = map['userRefId'];
    stockRefId = map['stockRefId'];
    status = map['status'];
    locationRefId = map['locationRefId'];
    estimatedTime = map['estimatedTime'];
    remarks = map['remarks'];
    attachment = map['attachment'];
    createdBy = map['createdBy'];
    updatedBy = map['updatedBy'];
    displayId = map['displayId'];
    sId = map['sId'];
  }
}
/// <!-- Data Class for Ticket --!> ///