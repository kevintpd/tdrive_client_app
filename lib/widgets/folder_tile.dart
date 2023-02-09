import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tdrive_client_app/common/network.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'renameFolderPopsup.dart';
import '../models/models.dart';
import '../routes/home/folder_view.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import '../routes/home/move_item_view.dart';
import '../routes/home/make_share.dart';
import 'move_tile.dart';

class FolderTile extends StatefulWidget {
  Folder folder;

  FolderTile({Key? key, required this.folder}) : super(key: key);

  @override
  State<FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<FolderTile> {

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0))),
        child: InkWell(
          onLongPress: () {
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => SingleChildScrollView(
                controller: ModalScrollController.of(context),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: const ListTile(
                        leading: Icon(Icons.download_rounded),
                        title: Text("下载"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showMaterialModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => SingleChildScrollView(
                            controller: ModalScrollController.of(context),
                            child: MakeShare(folder: widget.folder),
                          ),
                        );
                      },
                      child: const ListTile(
                        leading: Icon(Icons.share_rounded),
                        title: Text("共享"),
                      ),
                    ),
                    //修改文件夹名称
                    InkWell(
                      onTap: () {
                        showTextInputDialog(
                                okLabel: "确定",
                                cancelLabel: "取消",
                                context: context,
                                textFields: [
                                  DialogTextField(
                                      initialText: widget.folder.name)
                                ],
                                title: "文件夹重命名")
                            .then((value) async {
                          if (value != null) {
                            var foldername = value[0].replaceAll(" ", "");
                            if (foldername != "") {
                              Folder newFolder = Folder.clone(widget.folder);
                              newFolder.name = foldername;
                              var response =
                                  updateFolder(widget.folder, newFolder);
                              if (response != null) {
                                EasyLoading.showToast("修改成功");
                                setState(() {
                                  widget.folder = newFolder;
                                });
                                EasyLoading.dismiss();
                                Navigator.pop(context);
                              } else {
                                EasyLoading.showToast("请重新输入文件名");
                              }
                              if (!mounted) return;
                            }
                          }
                        });
                        // showDialog(
                        //     barrierDismissible: false,
                        //     context: context,
                        //     builder: (context) {
                        //       return RenameDialog(
                        //         contentWidget: RenameDialogContent(
                        //           ParentId: widget.folder.id,
                        //           title: "修改文件夹名称",
                        //         ),
                        //       );
                        //     });
                      },
                      child: const ListTile(
                        leading: Icon(Icons.drive_file_rename_outline_rounded),
                        title: Text("重命名"),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     showMaterialModalBottomSheet(
                    //       context: context,
                    //       builder: (context) => SingleChildScrollView(
                    //         controller: ModalScrollController.of(context),
                    //         child: Column(
                    //           children: [
                    //             SizedBox(height: 20,),
                    //             Text("修改文件夹名称",
                    //               textAlign: TextAlign.left,
                    //               style: new TextStyle(
                    //                 fontSize: 18.0,
                    //                 fontWeight: FontWeight.bold,
                    //               ),),
                    //             SizedBox(height: 20,),
                    //             TextField(
                    //               decoration: InputDecoration(
                    //                   hintText: "请输入新文件夹名称"
                    //               ),
                    //               controller: _foldername,
                    //             ),
                    //             SizedBox(height: 20,),
                    //             ElevatedButton(
                    //               child: Text("确定"),
                    //               onPressed: (){
                    //                 setState(() {
                    //                   final response = renameFolder(widget.folder.id,_foldername.text);
                    //                   if(response != null){
                    //                     EasyLoading.showToast("修改成功");
                    //                     Navigator.pop(context);
                    //                   }
                    //                   else{
                    //                     EasyLoading.showToast("请重新输入文件名");
                    //                   }
                    //                 });
                    //               },
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   child: const ListTile(
                    //     leading: Icon(Icons.drive_file_rename_outline_rounded),
                    //     title: Text("Rename"),
                    //   ),
                    // ),
                    InkWell(
                      onTap: () {
                        //TODO
                        showMaterialModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => SingleChildScrollView(
                            controller: ModalScrollController.of(context),
                            child: MoveItem(viewOfFolder:widget.folder),
                          ),
                        );
                      },
                      child: const ListTile(
                        leading: Icon(Icons.drive_file_move_rounded),
                        title: Text("移动"),
                      ),
                    ),
                    //删除按钮
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    color: Colors.deepOrange[800],
                                  ),
                                  content: const Text("确认删除吗？"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          deleteFolder(widget.folder.id);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text("确认")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("取消"))
                                  ],
                                ));
                      },
                      child: const ListTile(
                        leading: Icon(Icons.delete_rounded),
                        title: Text("删除"),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return FolderView(viewOfFolder: widget.folder);
            }));
          },
          child: ListTile(
            leading: widget.folder.IsShared
                ? const Icon(
              Icons.folder_shared,
              color: Colors.blue,
            )
                : const Icon(Icons.folder_rounded),
            title: Text(widget.folder.name),
            subtitle: Text(
                widget.folder.dateCreated.replaceFirst('T', ' ').split('.')[0]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.folder.files.isNotEmpty
                  ? [
                      const Icon(Icons.file_present_rounded),
                      Text(widget.folder.files.length.toString())
                    ]
                  : [],
            ),
          ),
        ));
  }
}
