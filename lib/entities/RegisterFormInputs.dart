class RegisterFormInputs {
  String? username;
  String? email;
  String? password;
  String? confirmPassword;

  RegisterFormInputs(
      {this.username, this.email, this.password, this.confirmPassword});

  RegisterFormInputs.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    return data;
  }
}