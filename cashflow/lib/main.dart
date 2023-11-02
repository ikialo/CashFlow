import 'package:cashflow/Cost/cost_main.dart';
import 'package:cashflow/LoginScreen/login_screen.dart';
import 'package:cashflow/LoginScreen/signup.dart';
import 'package:cashflow/Revenue/revenue_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashFLow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  User? user = FirebaseAuth.instance.currentUser;
  final List<Widget> _tabs = [
    CostMain(),
    RevenueMain(),
    ProfileScreen(),
  ];

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                _signOut();
              },
            )
          ],
          title: Text('Welcome: ${user!.displayName}'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.house_outlined), text: 'RentR'),
              Tab(icon: Icon(Icons.house_rounded), text: 'LandLord'),
              Tab(icon: Icon(Icons.stacked_line_chart), text: 'CashFlow'),
            ],
          ),
        ),
        body: TabBarView(
          children: _tabs,
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Screen'),
    );
  }
}
