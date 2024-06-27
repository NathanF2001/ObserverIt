import 'package:cloud_firestore/cloud_firestore.dart';

class Agent {
  DocumentReference? id;
  DateTime? lastUpdate;
  bool? hasNewContent;
  String? expression;
  String? payload;

  Agent({this.lastUpdate, this.hasNewContent, this.expression, this.payload});

  Agent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastUpdate = json['lastUpdate'];
    hasNewContent = json['hasNewContent'];
    expression = json['expression'];
    payload = json['payload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lastUpdate'] = this.lastUpdate;
    data['hasNewContent'] = this.hasNewContent;
    data['expression'] = this.expression;
    data['payload'] = this.payload;
    return data;
  }
}