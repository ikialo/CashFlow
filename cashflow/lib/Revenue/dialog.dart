import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ServiceDialog extends StatefulWidget {
  const ServiceDialog({super.key});

  @override
  State<ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<ServiceDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: buyDialog(context),
    );
  }

  buyDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 10.0,
          child: Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 4.3,
              // height: 23.5.h,
              // height: 210,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.yellowAccent.shade100,
                          Colors.yellow,
                          Colors.yellow.shade600,
                          Colors.yellow.shade800,
                        ],
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12.0),
                        topLeft: Radius.circular(12.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        //-------------------------------------- Pack Title
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'NSFW 18+ Pack',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NewYork',
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        Divider(color: Colors.yellow.shade800),
                        //----------------------------------------------- Features
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 0.5),
                            child: Text(
                              'SFX set powerful enough to embarrass any individual on planet Earth.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'NewYork',
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //------------------------------------    Buy Now
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 1),
                        child: Text(
                          'Unlock',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
