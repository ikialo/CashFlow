import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RevenueMain extends StatefulWidget {
  const RevenueMain({super.key});

  @override
  State<RevenueMain> createState() => _RevenueMainState();
}

class _RevenueMainState extends State<RevenueMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Revenue"),
    );
  }
}
