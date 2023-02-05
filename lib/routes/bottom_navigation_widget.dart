import 'package:flutter/material.dart';
import 'myshare/share_page.dart';
import 'home/home_page.dart';
import 'home/personal_page.dart';

class BottomNavigationWidget extends StatefulWidget {
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {

  int _currentIndex = 0;
  List<Widget> list = [];

  @override
  void initState() {
    list
      ..add(HomeRoute())
      ..add(SharePageRoute())
      ..add(PersonalPageRoute());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: '主页',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.share,
            ),
            label: '共享',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: '个人',
          ),
        ],
        currentIndex: _currentIndex,
        // type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}