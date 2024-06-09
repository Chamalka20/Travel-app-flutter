import 'package:flutter/material.dart';

class TopButtonIndicator extends StatelessWidget {
  const TopButtonIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return
    Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  child: Center(
                      child: Wrap(children: <Widget>[
                        Container(
                            width: 60,
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            )),
                      ]))),
            ]));
          
  }
}