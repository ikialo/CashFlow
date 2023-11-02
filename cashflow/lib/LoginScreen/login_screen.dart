import 'package:cashflow/LoginScreen/signup.dart';
import 'package:cashflow/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Names: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((value) async {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: data.name, password: data.password);

        debugPrint('Name: ${data.name}, Password: ${data.password}');
        return null;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');

          return 'user-not-found';
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          return 'wrong-password';
        }
      }
      return 'Wrong UserName Or Password';
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: data.name.toString(), password: data.password.toString());

      debugPrint('Name: ${data.name}, Password: ${data.password}');
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return 'user exists';
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.displayName == null) {
            return const SignUp();
          } else {
            return MyHomePage();
          }
        }
        return login(context);
      },
    );
  }

  Widget login(context) {
    return FlutterLogin(
      title: 'HomeFix',
      logo: AssetImage('assets/images/homefixlogowithname.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignUp()),
        );
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
