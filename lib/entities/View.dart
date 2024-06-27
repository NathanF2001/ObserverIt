import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observerit/entities/Agent.dart';
import 'package:observerit/entities/Request.dart';
import 'package:observerit/entities/StatisticsView.dart';

class ViewObserverIt {
  DocumentReference? id;
  String? alias;
  String? url;
  int? verificationPeriod;
  DateTime? creationTime;
  DateTime? nextExecution;
  List<Request>? requests;
  StatisticsView? statistics;
  Agent? agent;

  ViewObserverIt({this.alias, this.id, this.url, this.verificationPeriod, this.requests, this.statistics});

  ViewObserverIt.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alias = json['alias'];
    url = json['url'];
    verificationPeriod = json['verificationPeriod'];
    requests = json['requests'];
    statistics = json['statistics'];
    agent = json['agent'];
    creationTime = json['creationTime'] != null ? json['creationTime'] : DateTime.timestamp();
    nextExecution = json['nextExecution'] != null ? json['nextExecution'] : DateTime.timestamp();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alias'] = this.alias;
    data['url'] = this.url;
    data['verificationPeriod'] = this.verificationPeriod;
    data['requests'] = this.requests;
    data['statistics'] = this.statistics;
    data['creationTime'] = this.creationTime;
    data['nextExecution'] = this.nextExecution;
    data['agent'] = this.agent;
    return data;
  }
}