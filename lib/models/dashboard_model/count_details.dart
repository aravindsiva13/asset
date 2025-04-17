/// <!-- Data Class for Count Details --!> ///
class CountDetails {
  int? userCounts;
  int? assetCounts;
  int? procurementCounts;
  int? serviceCounts;

  CountDetails(
      {this.userCounts,
      this.assetCounts,
      this.procurementCounts,
      this.serviceCounts});

  CountDetails.fromJson(Map<String, dynamic> json) {
    userCounts = json['userCounts'];
    assetCounts = json['assetCounts'];
    procurementCounts = json['procurementCounts'];
    serviceCounts = json['serviceCounts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['userCounts'] = userCounts;
    data['assetCounts'] = assetCounts;
    data['procurementCounts'] = procurementCounts;
    data['serviceCounts'] = serviceCounts;

    return data;
  }
}
/// <!-- Data Class for Asset Count Details --!> ///
