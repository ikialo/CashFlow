import 'package:cashflow/LoginScreen/signup.dart';
import 'package:cashflow/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import '../appcolor.dart';

class LoginScreen extends StatelessWidget {
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    return Future.delayed(loginTime).then((value) async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: data.name, password: data.password);

        return null;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'user-not-found';
        } else if (e.code == 'wrong-password') {
          return 'wrong-password';
        }
      }
      return 'Wrong UserName Or Password';
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    return Future.delayed(loginTime).then((_) async {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: data.name.toString(), password: data.password.toString());

      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      // if (!users.containsKey(name)) {
      //   return 'User not exists';
      // }
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
      theme: LoginTheme(primaryColor: AppColors.melon),
      title: 'RenterPG',
      logo: const AssetImage('assets/images/RenterPG_logo.png'),
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
