class User {
  String? username;
  String? imageUrl;
  int? id;
  String? email;

  User({this.username, this.imageUrl, this.id, this.email});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    imageUrl = json['imageUrl'];
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['imageUrl'] = this.imageUrl;
    data['id'] = this.id;
    data['email'] = this.email;
    return data;
  }
}