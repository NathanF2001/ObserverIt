class UserObserverIt {
  String? username;
  String? imageUrl;
  String? id;
  String? email;
  bool? isFromGoogleAuth;

  UserObserverIt({this.username, this.imageUrl, this.id, this.email, this.isFromGoogleAuth});

  UserObserverIt.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    imageUrl = json['imageUrl'];
    id = json['id'];
    email = json['email'];
    isFromGoogleAuth = json['isFromGoogleAuth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['imageUrl'] = this.imageUrl;
    data['id'] = this.id;
    data['email'] = this.email;
    data['isFromGoogleAuth'] = this.isFromGoogleAuth;
    return data;
  }
}