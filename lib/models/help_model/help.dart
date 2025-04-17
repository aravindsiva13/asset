/// <!-- Data Class for Help --!> ///
class Help {
  String? emailId;
  String? queries;
  String? image;

  Help({this.queries, this.emailId, this.image});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['emailId'] = emailId;
    map['queries'] = queries;
    map['image'] = image;

    return map;
  }

  Help.fromMapObject(Map<String, dynamic> map) {
    queries = map['queries'];
    emailId = map['emailId'];
    image = map['image'];
  }
}
/// <!-- Data Class for Help --!> ///
