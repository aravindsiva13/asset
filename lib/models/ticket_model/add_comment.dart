/// <!-- Data Class for Comments --!> ///
class AddComment {
  String? comment;
  String? userName;
  String? dateTime;
  String? ticketRefId;
  String? userRefId;
  String? assignUserRefId;
  String? ticketDisplayId;
  String? sId;

  AddComment({
    this.comment,
    this.userName,
    this.dateTime,
    this.ticketRefId,
    this.userRefId,
    this.assignUserRefId,
    this.ticketDisplayId,
    this.sId,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['comment'] = comment;
    map['userName'] = userName;
    map['dateTime'] = dateTime;
    map['ticketRefId'] = ticketRefId;
    map['userRefId'] = userRefId;
    map['assignUserRefId'] = assignUserRefId;
    map['ticketDisplayId'] = ticketDisplayId;
    map['sId'] = sId;

    return map;
  }

  AddComment.fromMapObject(Map<String, dynamic> map) {
    comment = map['comment'];
    userName = map['userName'];
    dateTime = map['dateTime'];
    ticketRefId = map['ticketRefId'];
    userRefId = map['userRefId'];
    assignUserRefId = map['assignUserRefId'];
    ticketDisplayId = map['ticketDisplayId'];
    sId = map['sId'];
  }
}
/// <!-- Data Class for Comments --!> ///