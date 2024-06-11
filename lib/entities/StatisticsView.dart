class StatisticsView {
  double? average;
  int? peak;
  int? uptime;
  DateTime? lastUpdate;

  StatisticsView({this.average, this.peak, this.uptime, this.lastUpdate});

  StatisticsView.fromJson(Map<String, dynamic> json) {
    average = json['average'];
    peak = json['peak'];
    uptime = json['uptime'];
    lastUpdate = json['lastUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average'] = this.average;
    data['peak'] = this.peak;
    data['uptime'] = this.uptime;
    data['lastUpdate'] = this.lastUpdate;
    return data;
  }
}