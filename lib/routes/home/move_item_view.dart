import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../common/network.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MoveItem extends StatefulWidget {
  final Folder viewOfFolder;

  const MoveItem({Key? key, required this.viewOfFolder}) : super(key: key);

  @override
  State<MoveItem> createState() => _MoveItemState();
}

class _MoveItemState extends State<MoveItem> {
  Folder? folderDetailed;
  bool isRoot = false;
  List<Folder>? rootList;

  @override
  void initState() {
    super.initState();

    if (widget.viewOfFolder.parentFolder != null) {
      fetchMoveFolder(widget.viewOfFolder.parentFolder).then((value) {
        setState(() {
          folderDetailed = value;
          isRoot = false;
        });
      });
    } else {
      EasyLoading.showToast("这里是根目录");
      fetchRoot().then((value){
        setState((){
          rootList = value;
          isRoot = true;
        });
      });
    }

  }


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
                      onTap: () {
                        setState(() {
                          if (folderDetailed?.parentFolder != null) {
                            fetchMoveFolder(folderDetailed!.parentFolder).then((value) {
                              setState(() {
                                folderDetailed = value;
                              });
                            });
                          } else {
                            fetchRoot().then((value){
                              setState((){
                                rootList = value;
                                isRoot = true;
                              });
                            });

                          }
                        });
                      },
                    ),
                  ),
                  Expanded(
                      child: GestureDetector(
                    child: Text(
                      "取  消",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )),
                ],
              ),
              Divider(),
              SizedBox(
                height: 540,
                child:
                isRoot == false?MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                      itemCount: folderDetailed?.subFolders.length,
                      itemBuilder: (context, index) {
                        // print(folderDetailed!.subFolders[index]);
                        Folder subFolder =
                            Folder.fromJson(folderDetailed!.subFolders[index]);
                        return Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0))),
                          child: InkWell(
                            onTap: () {
                              fetchMoveFolder(subFolder.id).then((value) {
                                setState(() {
                                  folderDetailed = value;
                                  isRoot = false;
                                });
                              });
                            },
                            child: ListTile(
                              leading: const Icon(Icons.folder_rounded),
                              title: Text(subFolder.name),
                              subtitle: Text(subFolder.dateCreated
                                  .replaceFirst('T', ' ')
                                  .split('.')[0]),
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
                      }),
                ):MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                      itemCount: rootList?.length,
                      itemBuilder: (context, index) {
                        Folder folder =rootList![index];
                        return Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0))),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                fetchMoveFolder(folder.id).then((value) {
                                  setState(() {
                                    folderDetailed = value;
                                    isRoot = false;
                                  });
                                });
                              });
                            },
                            child: ListTile(
                              leading: const Icon(Icons.folder_rounded),
                              title: Text(folder.name),
                              subtitle: Text(folder.dateCreated
                                  .replaceFirst('T', ' ')
                                  .split('.')[0]),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: folder.files.isNotEmpty
                                    ? [
                                  const Icon(Icons.file_present_rounded),
                                  Text(folder.files.length.toString())
                                ]
                                    : [],
                              ),
                            ),
                          ),
                        );
                      }),
                )
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
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Folder newfolder = Folder.clone(widget.viewOfFolder);
                                  if(isRoot == true){newfolder.parentFolder = null;}else{newfolder.parentFolder = folderDetailed!.id;};
                                  updateFolder(widget.viewOfFolder,newfolder);
                                  if(widget.viewOfFolder.parentFolder == null){}else{
                                    Folder? parentFolder;
                                    fetchFolder(widget.viewOfFolder.parentFolder).then((value)=>parentFolder=value);
                                    Folder newparentFolder = Folder.clone(parentFolder!);
                                    newparentFolder.subFolders.remove(widget.viewOfFolder);
                                    updateFolder(parentFolder!,newparentFolder);
                                  }
                                  EasyLoading.showToast("移动成功");
                                  Navigator.pop(context);
                                  Navigator.pop(context);

                                },
                                icon: Icon(Icons.arrow_circle_right_rounded),
                                iconSize: 30,
                              ),
                              Text("移动到此处"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ));
  }
}
