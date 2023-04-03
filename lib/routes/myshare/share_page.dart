import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../common/network.dart';

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
        // actions: [
        //   // IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        //   IconButton(
        //       onPressed: () => Navigator.of(context).pushNamed("updown"),
        //       icon: const Icon(Icons.swap_vert)),
        // ],
      ),
      body: Center(
          child: SizedBox(
            height: 200,
            child: Card(
        margin: EdgeInsets.all(10),
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        iconSize:80.0,
                      constraints: BoxConstraints(minHeight: 80),
                        onPressed: () => Navigator.of(context).pushNamed("myshare"),
                        icon: const Icon(Icons.person_add_alt_1_rounded,color: Colors.grey,)),
                    Text("我的共享   ",style: TextStyle(fontSize: 20,color: Colors.grey),)
                  ],
                ),
              ),
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                    iconSize:80.0,
                        constraints: BoxConstraints(minHeight: 80),
                        onPressed: () => Navigator.of(context).pushNamed("joinedshare"),
                        icon: const Icon(Icons.cloud_download_outlined,color: Colors.grey,)),
                    Text("我加入的共享",style: TextStyle(fontSize: 20,color: Colors.grey),)
                  ],),
              )
            ],
        ),
      ),
          )),
    );
  }
}
