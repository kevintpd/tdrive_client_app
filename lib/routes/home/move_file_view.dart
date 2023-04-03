import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../common/network.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class MoveFile extends StatefulWidget {
  final File moveFile;

  const MoveFile({Key? key, required this.moveFile}) : super(key: key);

  @override
  State<MoveFile> createState() => _MoveFileState();
}

class _MoveFileState extends State<MoveFile> {
  Folder? folderDetailed;
  Folder? parentFolder;
  bool isRoot = false;
  bool isLoad = false;
  List<Folder>? rootList;
  TextEditingController _foldername = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.moveFile.parentFolder != null) {
      fetchMoveFolder(widget.moveFile.parentFolder).then((value) {
        setState(() {
          folderDetailed = value;
          isRoot = false;
          isLoad = true;
        });
      });
      fetchFolder(widget.moveFile.parentFolder)
          .then((value) => parentFolder = value);
    } else {
      EasyLoading.showToast("这里是根目录");
      fetchRoot().then((value) {
        setState(() {
          rootList = value;
          isRoot = true;
          isLoad = true;
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
                            fetchMoveFolder(folderDetailed!.parentFolder)
                                .then((value) {
                              setState(() {
                                folderDetailed = value;
                                isRoot = false;
                              });
                            });
                          } else {
                            fetchRoot().then((value) {
                              setState(() {
                                EasyLoading.showToast("此处已是根目录");
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
                  child: isLoad == true
                      ? (isRoot == false
                      ? MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.builder(
                        itemCount: folderDetailed?.subFolders.length,
                        itemBuilder: (context, index) {
                          // print(folderDetailed!.subFolders[index]);
                          print(folderDetailed?.subFolders[index]);
                          Folder subFolder = Folder.fromJson(
                              folderDetailed?.subFolders[index]);
                          return Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                    bottomLeft: Radius.circular(16.0),
                                    bottomRight:
                                    Radius.circular(16.0))),
                            child: InkWell(
                              onTap: () {
                                fetchMoveFolder(subFolder.id)
                                    .then((value) {
                                  setState(() {
                                    folderDetailed = value;
                                    isRoot = false;
                                  });
                                });
                              },
                              child: ListTile(
                                leading:
                                const Icon(Icons.folder_rounded),
                                title: Text(subFolder.name),
                                subtitle: Text(subFolder.dateCreated
                                    .replaceFirst('T', ' ')
                                    .split('.')[0]),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: subFolder.files.isNotEmpty
                                      ? [
                                    const Icon(Icons
                                        .file_present_rounded),
                                    Text(subFolder.files.length
                                        .toString())
                                  ]
                                      : [],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                      : MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.builder(
                        itemCount: rootList?.length,
                        itemBuilder: (context, index) {
                          Folder folder = rootList![index];
                          return Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                    bottomLeft: Radius.circular(16.0),
                                    bottomRight:
                                    Radius.circular(16.0))),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  fetchMoveFolder(folder.id)
                                      .then((value) {
                                    setState(() {
                                      folderDetailed = value;
                                      isRoot = false;
                                    });
                                  });
                                });
                              },
                              child: ListTile(
                                leading:
                                const Icon(Icons.folder_rounded),
                                title: Text(folder.name),
                                subtitle: Text(folder.dateCreated
                                    .replaceFirst('T', ' ')
                                    .split('.')[0]),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: folder.files.isNotEmpty
                                      ? [
                                    const Icon(Icons
                                        .file_present_rounded),
                                    Text(folder.files.length
                                        .toString())
                                  ]
                                      : [],
                                ),
                              ),
                            ),
                          );
                        }),
                  ))
                      : Center(child: const CircularProgressIndicator())),
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
                                onPressed: () {
                                  showTextInputDialog(
                                      okLabel: "确定",
                                      cancelLabel: "取消",
                                      context: context,
                                      textFields: [
                                        DialogTextField(
                                            initialText: "新建文件夹")
                                      ],
                                      title: "创建新文件夹")
                                      .then((value) async {
                                    if (value != null) {
                                      var foldername =
                                      value[0].replaceAll(" ", "");

                                      if (isRoot == true) {
                                        if (_foldername != "") {
                                          var response =
                                          newFolder("", foldername);
                                          if (response != null) {
                                            EasyLoading.showToast("创建成功");
                                          } else {
                                            EasyLoading.showToast("请重新输入文件名");
                                          }
                                          if (!mounted) return;
                                        }
                                        fetchRoot().then((value) {
                                          setState(() {
                                            rootList = value;
                                            isRoot = true;
                                          });
                                        });
                                      } else {
                                        if (_foldername != "") {
                                          var response =
                                          newFolder(
                                              folderDetailed!.id, foldername);
                                          if (response != null) {
                                            EasyLoading.showToast("创建成功");
                                          } else {
                                            EasyLoading.showToast("请重新输入文件名");
                                          }
                                          if (!mounted) return;
                                        }
                                        fetchMoveFolder(folderDetailed!.id)
                                            .then((value) {
                                          setState(() {
                                            folderDetailed = value;
                                            isRoot = false;
                                          });
                                        });
                                      }
                                    }
                                  });
                                },
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
                                  File newFile =
                                  File.clone(widget.moveFile);
                                  if (isRoot == true) {
                                    EasyLoading.showToast("不能移动到根目录下");
                                  } else {
                                    newFile.parentFolder = folderDetailed!.id;
                                    updateFile(
                                        widget.moveFile, newFile);
                                    print("newFile.parentFolder");
                                    print(newFile.parentFolder);

                                    Folder newFolderdetail =
                                    Folder.clone(folderDetailed!);

                                    newFolderdetail.files
                                        .add(widget.moveFile.id);
                                    updateFolder(
                                        folderDetailed!, newFolderdetail);
                                    print("newFolderdetail.files");
                                    print(newFolderdetail.files);


                                    Folder newparentFolder =
                                    Folder.clone(parentFolder!);
                                    for (var sub
                                    in newparentFolder.files) {
                                      if (sub["Id"] == widget.moveFile.id) {
                                        var done = newparentFolder.files
                                            .remove(sub);
                                        print(done);
                                        break;
                                      }
                                    }
                                    updateFolder(
                                        parentFolder!, newparentFolder);

                                    EasyLoading.showToast("移动成功");
                                  }
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
