import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CostMain extends StatefulWidget {
  const CostMain({super.key});

  @override
  State<CostMain> createState() => _CostMainState();
}

class _CostMainState extends State<CostMain> {
  final CapitalExCon = TextEditingController();
  final CogExCon = TextEditingController();

  String testString = "test";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: CapitalExCon,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Capital Expense',
                          hintText: 'Capital Expense')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: CogExCon,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Cost of Goods Sold',
                          hintText: 'Cost of Goods Sold')),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(88, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
