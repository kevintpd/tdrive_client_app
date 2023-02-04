import 'package:flutter/material.dart';
import '../models/models.dart';
import '../common/network.dart';

class SharePageRoute extends StatefulWidget {
  const SharePageRoute({Key? key}) : super(key: key);

  @override
  State<SharePageRoute> createState() => _SharePageRouteState();
}

class _SharePageRouteState extends State<SharePageRoute> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("共享"),
      ),
      body: Center(child: Text("共享页面"),),
    );
  }
}
