import 'package:observerit/core/exceptions/AuthException.dart';
import 'package:observerit/entities/RegisterFormInputs.dart';
import 'package:observerit/entities/User.dart';

class AuthService {
  Future<void> createUser(RegisterFormInputs inputForm) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      return ;
    } catch (error) {
      throw const AuthException('Error to create User');
    }
  }

  Future<User> loginByGoogle() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      return User.fromJson({
        "username": "Joe Doe",
        "imageUrl": null,
        "id": 1,
        "email": "joedoe@gmail.com"
      });
    } catch (error) {
      throw const AuthException('Error to login');
    }
  }

  Future<User> login(String login, String password) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      return User.fromJson({
        "username": "Joe Doe",
        "imageUrl": null,
        "id": 1,
        "email": "joedoe@gmail.com"
      });;
    } catch (error) {
      throw const AuthException('Error to login');
    }
  }
}