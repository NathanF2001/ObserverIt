import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsView {
  DocumentReference? id;
  double? average;
  int? total;
  int? peak;
  int? uptime;
  DateTime? createTime;
  DateTime? lastUpdate;

  StatisticsView({this.average, this.total, this.peak, this.uptime, this.lastUpdate});

  StatisticsView.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    average = json['average'];
    peak = json['peak'];
    uptime = json['uptime'];
    createTime = json['createTime'];
    lastUpdate = json['lastUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['id'] = this.id;
    data['average'] = this.average;
    data['peak'] = this.peak;
    data['uptime'] = this.uptime;
    data['createTime'] = this.createTime;
    data['lastUpdate'] = this.lastUpdate;
    return data;
  }
}