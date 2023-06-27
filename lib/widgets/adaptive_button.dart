

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton(this.text, this.handler, {super.key});

  final String text;
  final Function handler;


  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
                        ? CupertinoButton(
                          child: Text(text), 
                          onPressed: () {handler();}
                          )
                        : IconButton(
                            onPressed: () {handler();},
                            icon: Icon(Icons.calendar_today),
                            style: ButtonStyle(
                                iconColor: MaterialStatePropertyAll(
                                    Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .color),
                                foregroundColor: MaterialStatePropertyAll(
                                    Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .color)),
                          );
  }
}