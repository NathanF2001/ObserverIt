import 'package:observerit/entities/Request.dart';
import 'package:observerit/entities/StatisticsView.dart';

class ViewObserverIt {
  String? alias;
  String? url;
  int? verificationPeriod;
  List<Request>? requests;
  StatisticsView? statistics;

  ViewObserverIt({this.alias, this.url, this.verificationPeriod, this.requests, this.statistics});

  ViewObserverIt.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    url = json['url'];
    verificationPeriod = json['verificationPeriod'];
    requests = json['requests'];
    statistics = json['statistics'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alias'] = this.alias;
    data['url'] = this.url;
    data['verificationPeriod'] = this.verificationPeriod;
    data['requests'] = this.requests;
    data['statistics'] = this.statistics;
    return data;
  }
}