import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../common/network.dart';
import '../../models/models.dart';
import '../../widgets/folder_tile.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'share_folder_root_tile.dart';

class MyShareRootRoute extends StatefulWidget {
  @override
  _MyShareRootRouteState createState() => _MyShareRootRouteState();
}

class _MyShareRootRouteState extends State<MyShareRootRoute> {
  TextEditingController _foldername = TextEditingController();
  late Future<List<ShareItem>> root;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的共享"),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search_rounded)),
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed("updown"),
              icon: const Icon(Icons.swap_vert)),
        ],
      ),
      body: FutureBuilder<List<ShareItem>>(
        future: root,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  ShareItem item = snapshot.data![index];
                  return ShareFolderRootTile(sharefolder: item);
                });
          } else if (snapshot.hasError) {
            return Center(
              child: ElevatedButton(
                child: Text("登录"),
                onPressed: () => Navigator.of(context).pushNamed("login"),
              ),
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: () {
              setState(() {
                root = fetchMyShareRoot();
              });
            },
            child: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    root = fetchMyShareRoot();
    super.initState();
  }
}
