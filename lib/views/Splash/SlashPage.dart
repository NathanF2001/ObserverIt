import 'package:flutter/material.dart';
import 'package:observerit/core/services/AuthService.dart';
import 'package:observerit/core/services/LocalStorage.dart';
import 'package:observerit/entities/User.dart';
import 'package:observerit/views/HomePage/HomePage.dart';
import 'package:observerit/views/LoginScreen/login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  AuthService authService = AuthService();
  LocalStorage localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), _redirect);
  }

  _redirect(){
    final isAuthenticated = _checkAuthentication();

    if (isAuthenticated) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  _checkAuthentication() {
    UserObserverIt? userFromAuth = authService.isSinging();
    UserObserverIt? userFromLocalStorage = null;

    Map<String, dynamic> localStorageUser = localStorage.getValueJSON('user');
    if (localStorageUser.isNotEmpty) {
      userFromLocalStorage = UserObserverIt.fromJson(localStorageUser);
    }

    if (userFromAuth != null && userFromLocalStorage != null && userFromAuth.id == userFromLocalStorage.id){
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Container(
          color: Color(0xff6c31cc),
            child: Image.asset("assets/app-images/LogoPequenoGeral.jpg")
        ),
      ),
    );
  }
}
