/// <!-- Data Class for Notifications Details --!> ///
class NotificationDetails {
  String? sId;
  String? message;
  String? ticketRefId;

  NotificationDetails({this.sId, this.message, this.ticketRefId});

  NotificationDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    message = json['message'];
    ticketRefId = json['ticketRefId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = sId;
    data['message'] = message;
    data['ticketRefId'] = ticketRefId;

    return data;
  }
}
/// <!-- Data Class for Asset Notifications Details --!> ///



