/// <!-- Data Class for Asset Checklist Details --!> ///
class AssetCheckList {
  List? entryName;
  List? functionalFlag;
  List? remarks;
  String? stockRefId;


  AssetCheckList(
      {this.entryName, this.functionalFlag,this.remarks, this.stockRefId});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['entryName'] = entryName;
    map['functionalFlag'] = functionalFlag;
    map['remarks'] = remarks;
    map['stockRefId'] = stockRefId;

    return map;
  }

  AssetCheckList.fromMapObject(Map<String, dynamic> map) {
    entryName = map['entryName'];
    functionalFlag = map['functionalFlag'];
    remarks = map['remarks'];
    stockRefId = map['stockRefId'];
  }
}
/// <!-- Data Class for Asset Checklist Details --!> ///
