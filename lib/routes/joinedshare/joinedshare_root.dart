import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/network.dart';
import '../../models/models.dart';
import 'joined_share_folder_root_tile.dart';

class JoinedShareRootRoute extends StatefulWidget {
  @override
  _JoinedShareRootRouteState createState() => _JoinedShareRootRouteState();
}

class _JoinedShareRootRouteState extends State<JoinedShareRootRoute> {
  TextEditingController _foldername = TextEditingController();
  late Future<List<ShareItem>> root;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("加入的共享"),
        actions: [
          IconButton(onPressed: () => Navigator.of(context).pushNamed("joinshare"), icon: const Icon(Icons.add)),
          IconButton(onPressed: () => Navigator.of(context).pushNamed("joinsharesearch"), icon: const Icon(Icons.search_rounded)),
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
                  return JoinedShareFolderRootTile(sharefolder: item);
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
                RefreshShare();
                root = fetchJoinedShareRoot();
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
    root = fetchJoinedShareRoot();
    super.initState();
  }
}
