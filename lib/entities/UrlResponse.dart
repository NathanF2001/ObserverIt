class UrlResponse {
  int? timeMS;
  String? contentType;
  int? statusCode;
  DateTime? runDate;

  UrlResponse({this.timeMS, this.contentType, this.statusCode, this.runDate});

  UrlResponse.fromJson(Map<String, dynamic> json) {
    timeMS = json['timeMS'];
    contentType = json['contentType'];
    statusCode = json['statusCode'];
    runDate = json['runDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timeMS'] = this.timeMS;
    data['contentType'] = this.contentType;
    data['statusCode'] = this.statusCode;
    data['runDate'] = this.runDate;
    return data;
  }
}