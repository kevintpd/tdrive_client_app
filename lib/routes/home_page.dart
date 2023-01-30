import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../common/global.dart';
import '../common/network.dart';
import '../models/models.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  late Future<List<Folder>> root;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TDrive"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.swap_vert)),
        ],
      ),

      body: _buildBody(), // 构建主页面
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    prefs.setString('token', "123");
    root = fetchRoot();
    return FutureBuilder<List<Folder>>(
      future: root,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                Folder folder = snapshot.data![index];
                // return FolderTile(folder: folder);
                return Center(child: Text("登录成功，有内容"));
              });
        } else
        {
          return Center(
                    child: ElevatedButton(
                      child: Text("登录"),
                      onPressed: () => Navigator.of(context).pushNamed("login"),
                    ),
                  );;
        }
      },
    );

    }




  //   if (prefs.getString('token') == "") {
  //     //用户未登录，显示登录按钮
  //     return Center(
  //       child: ElevatedButton(
  //         child: Text("登录"),
  //         onPressed: () => Navigator.of(context).pushNamed("login"),
  //       ),
  //     );
  //   } else {
  //     return Center(
  //       child: ElevatedButton(
  //         child: Text("退出登录"),
  //         onPressed: () {
  //           setState(() {
  //             prefs.setString('token', '');
  //           });
  //         },
  //       ),
  //     );
  //   }


  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '我的文件',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.share),
          label: '共享文件',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '个人信息',
        ),
      ],
    );
  }
}
