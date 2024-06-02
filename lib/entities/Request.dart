class Request {
  DateTime? date;
  String? status;
  int? time;

  Request({this.date, this.status, this.time});

  Request.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    status = json['status'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['status'] = this.status;
    data['time'] = this.time;
    return data;
  }
}