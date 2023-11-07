import 'dart:developer';

import 'package:cashflow/Cost/cost_main.dart';
import 'package:cashflow/LoginScreen/login_screen.dart';
import 'package:cashflow/LoginScreen/signup.dart';
import 'package:cashflow/Revenue/revenue_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'state_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _currentIndex = 2;
  late TabController tabcon;

  User? user = FirebaseAuth.instance.currentUser;
  final List<Widget> _tabs = [
    CostMain(),
    RevenueMain(),
  ];

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    // TODO: implement initState
    tabcon = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
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
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(
              "assets/images/RenterPG_logo.png",
              height: 30,
              width: 30,
            ),
          ),
          title:
              Center(child: new Text("Renter PG", textAlign: TextAlign.center)),
          bottom: TabBar(
            controller: tabcon,
            tabs: [
              Tab(icon: Icon(Icons.house_outlined), text: 'Renter'),
              Tab(icon: Icon(Icons.house_rounded), text: 'LandLord'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabcon,
          children: _tabs,
        ),
      ),
    );
  }
}
