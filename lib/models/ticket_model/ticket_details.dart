/// <!-- Data Class for Ticket Details --!> ///
class TicketDetails {
  String? sId;
  String? type;
  String? priority;
  String? vendorRefId;
  String? vendorName;
  String? modelRefId;
  String? modelName;
  String? expectedTime;
  String? description;
  String? userRefId;
  String? userName;
  String? userDesignation;
  String? userEmpId;
  String? userImage;
  String? assignedRefId;
  String? assignedName;
  String? stockRefId;
  String? stockName;
  String? status;
  String? locationRefId;
  String? locationName;
  String? estimatedTime;
  String? remarks;
  String? attachment;
  String? createdBy;
  String? updatedBy;
  String? displayId;
  List<TicketTracker>? trackers;
  List<CommentDetails>? comments;

  TicketDetails({
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
    this.userName,
    this.vendorName,
    this.stockName,
    this.modelName,
    this.locationName,
    this.assignedName,
    this.displayId = '',
    this.userDesignation,
    this.userEmpId,
    this.userImage,
    this.trackers,
    this.comments,
  });

  TicketDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    priority = json['priority'];
    vendorRefId = json['vendorRefId'];
    modelRefId = json['modelRefId'];
    expectedTime = json['expectedTime'];
    description = json['description'];
    assignedRefId = json['assignedRefId'];
    userRefId = json['userRefId'];
    stockRefId = json['stockRefId'];
    status = json['status'];
    locationRefId = json['locationRefId'];
    estimatedTime = json['estimatedTime'];
    remarks = json['remarks'];
    attachment = json['attachment'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    displayId = json['displayId'];
    userName = json['userName'];
    assignedName = json['assignedName'];
    locationName = json['locationName'];
    vendorName = json['vendorName'];
    stockName = json['stockName'];
    modelName = json['modelName'];
    userDesignation = json['userDesignation'];
    userEmpId = json['userEmpId'];
    userImage = json['userImage'];

    List<TicketTracker>? tracker = [];
    for (int i = 0; i < json["trackers"].length; i++) {
      TicketTracker trackers = TicketTracker.fromJson(json["trackers"][i]);

      tracker.add(trackers);
    }

    if (tracker.isNotEmpty) {
      trackers = tracker;
    }

    List<CommentDetails>? comment = [];

    for (int i = 0; i < json["comments"].length; i++) {
      CommentDetails comments = CommentDetails.fromJson(json["comments"][i]);

      comment.add(comments);
    }

    comments = comment;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = sId;
    data['type'] = type;
    data['priority'] = priority;
    data['vendorRefId'] = vendorRefId;
    data['modelRefId'] = modelRefId;
    data['expectedTime'] = expectedTime;
    data['description'] = description;
    data['assignedRefId'] = assignedRefId;
    data['userRefId'] = userRefId;
    data['stockRefId'] = stockRefId;
    data['status'] = status;
    data['locationRefId'] = locationRefId;
    data['estimatedTime'] = estimatedTime;
    data['remarks'] = remarks;
    data['attachment'] = attachment;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['displayId'] = displayId;
    data['userName'] = userName;
    data['assignedName'] = assignedName;
    data['locationName'] = locationName;
    data['vendorName'] = vendorName;
    data['stockName'] = stockName;
    data['modelName'] = modelName;
    data['userImage'] = userImage;
    data['userEmpId'] = userEmpId;
    data['userDesignation'] = userDesignation;
    data['trackers'] = trackers;
    data['comments'] = comments;

    return data;
  }
}

/// <!-- Ticket Tracker Details --!> ///
class TicketTracker {
  String? sId;
  String? createdBy;
  String? status;
  String? estimatedTime;
  String? priority;
  String? assignedRefId;
  String? remarks;
  String? createdAt;

  TicketTracker({
    this.sId,
    this.createdBy,
    this.status,
    this.estimatedTime,
    this.priority,
    this.assignedRefId,
    this.remarks,
    this.createdAt,
  });

  TicketTracker.fromJson(Map<String, dynamic> json) {
    sId = json['trackerId'];
    createdBy = json['trackerCreatedBy'];
    status = json['trackerStatus'];
    estimatedTime = json['trackerEstimatedTime'];
    priority = json['trackerPriority'];
    assignedRefId = json['trackerAssignedRefId'];
    remarks = json['trackerRemarks'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['trackerId'] = sId;
    data['trackerCreatedBy'] = createdBy;
    data['trackerStatus'] = status;
    data['trackerEstimatedTime'] = estimatedTime;
    data['trackerPriority'] = priority;
    data['trackerAssignedRefId'] = assignedRefId;
    data['trackerRemarks'] = remarks;
    data['createdAt'] = createdAt;

    return data;
  }
}
/// <!-- Ticket Tracker Details --!> ///

/// <!-- Comment Details --!> ///
class CommentDetails {
  String? comment;
  String? userName;
  String? dateTime;
  String? ticketRefId;
  String? sId;

  CommentDetails({
    this.comment,
    this.userName,
    this.dateTime,
    this.ticketRefId,
    this.sId,
  });

  CommentDetails.fromJson(Map<String, dynamic> json) {
    comment = json['comments'];
    userName = json['commentUserName'];
    dateTime = json['commentDateTime'];
    ticketRefId = json['commentTicketId'];
    sId = json['commentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['comments'] = comment;
    data['commentUserName'] = userName;
    data['commentDateTime'] = dateTime;
    data['commentTicketId'] = ticketRefId;
    data['commentId'] = sId;

    return data;
  }
}
/// <!-- Comment Details --!> ///
/// <!-- Data Class for Ticket Details --!> ///