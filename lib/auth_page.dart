import 'package:assignment_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

const users = const {
  'hunter@gmail.com': 'hunter',
};

class LoginPage extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 250);

  void saveUser(String email, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(email, password);
  }

  Future<String> getUser(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(email) ?? "null";
  }

  Future<String?> _authUser(LoginData data) {
    String user = "";
    getUser(data.name).then((value) {
      user = value;
    });
    return Future.delayed(loginTime).then((_) {
      if (user == "null") {
        debugPrint("Myowndata ${getUser(data.name).toString()}");
        return 'User not exists';
      }
      if (user != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    saveUser(data.name.toString(), data.password.toString());
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'PHONE STAT',
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHomePage(title: ""),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
