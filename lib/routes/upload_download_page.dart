import 'package:flutter/material.dart';

class UpDownRoute extends StatefulWidget {
  const UpDownRoute({Key? key}) : super(key: key);

  @override
  State<UpDownRoute> createState() => _UpDownRouteState();
}

class _UpDownRouteState extends State<UpDownRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("传输管理"),
      ),
    );
  }
}
