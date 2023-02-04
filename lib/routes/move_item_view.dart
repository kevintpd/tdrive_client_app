import 'package:flutter/material.dart';
import '../models/models.dart';
import '../common/network.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../widgets/move_tile.dart';

class MoveItem extends StatefulWidget {
  final Folder viewOfFolder;

  const MoveItem({Key? key, required this.viewOfFolder}) : super(key: key);

  @override
  State<MoveItem> createState() => _MoveItemState();
}

class _MoveItemState extends State<MoveItem> {
  late Folder? folderDetailed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 700,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Text(
                "移动项目到",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        "上一级",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                      child: GestureDetector(
                    child: Text(
                      "取  消",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                    onTap: () {},
                  )),
                ],
              ),
              Divider(),
              SizedBox(
                height: 540,
                child: ListView.builder(
                  itemCount: folderDetailed?.subFolders.length,
                    itemBuilder: (context, index) {
                    print(folderDetailed?.subFolders[index].toString());
                      Folder subFolder = Folder.fromJson(folderDetailed?.subFolders[index]);
                      return Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                                bottomLeft: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0))),
                        child: InkWell(
                          onTap: (){},
                          child: ListTile(
                            leading: const Icon(Icons.folder_rounded),
                            title: Text(subFolder.name),
                            subtitle: Text(
                                subFolder.dateCreated.replaceFirst('T', ' ').split('.')[0]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: subFolder.files.isNotEmpty
                                  ? [
                                const Icon(Icons.file_present_rounded),
                                Text(subFolder.files.length.toString())
                              ]
                                  : [],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
              Align(
                child: SizedBox(
                  height: 80,
                  width: 370,
                  child: Card(
                    shadowColor: Colors.cyan,
                    color: Colors.grey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.create_new_folder),
                              iconSize: 30,
                            ),
                              Text("新建文件夹"),
                          ],),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_circle_right_rounded),
                                iconSize: 30,
                              ),
                              Text("移动到此处"),
                            ],),
                        )

                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,)
            ],
          ),
        ));
  }

  @override
  void initState() {
    if(widget.viewOfFolder.parentFolder!=null){
    fetchMoveFolder(widget.viewOfFolder.parentFolder).then((value) => folderDetailed = value);
    }
    else{
      EasyLoading.showToast("这里是根目录");
      fetchMoveFolder(widget.viewOfFolder.id).then((value) => folderDetailed = value);
    }
    super.initState();
  }
}
