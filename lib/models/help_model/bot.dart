/// <!-- Data Class for Bot --!> ///
class Bot {
  String? name;
  String? emailId;
  String? issue;
  String? description;

  Bot({this.name, this.emailId, this.issue,this.description});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['name'] = name;
    map['emailId'] = emailId;
    map['issue'] = issue;
    map['description'] = description;

    return map;
  }

  Bot.fromMapObject(Map<String, dynamic> map) {
    name = map['name'];
    emailId = map['emailId'];
    issue = map['issue'];
    description = map['description'];
  }
}
/// <!-- Data Class for Bot --!> ///
