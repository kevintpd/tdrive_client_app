import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tdrive_client_app/common/network.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'renameFolderPopsup.dart';
import '../models/models.dart';
import './/routes/folder_view.dart';

class FolderTile extends StatefulWidget {
  final Folder folder;

  const FolderTile({Key? key, required this.folder}) : super(key: key);

  @override
  State<FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<FolderTile> {
  TextEditingController _foldername = TextEditingController();
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
                        title: Text("Download All"),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const ListTile(
                        leading: Icon(Icons.share_rounded),
                        title: Text("Share"),
                      ),
                    ),
                    //修改文件夹名称
                    InkWell(
                      onTap: (){
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return RenameDialog(
                                contentWidget: RenameDialogContent(
                                  ParentId: widget.folder.id,
                                  title: "修改文件夹名称",
                                ),
                              );
                            });
                      },
                      child: const ListTile(
                            leading: Icon(Icons.drive_file_rename_outline_rounded),
                            title: Text("Rename"),
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
                      onTap: () {},
                      child: const ListTile(
                        leading: Icon(Icons.drive_file_move_rounded),
                        title: Text("Move"),
                      ),
                    ),
                    //删除按钮
                    InkWell(
                      onTap: () {
                        setState(() {
                          final response = deleteFolder(widget.folder.id);
                          if(response != null){
                            EasyLoading.showToast("删除成功");
                          }
                        });
                      },
                      child: const ListTile(
                        leading: Icon(Icons.delete_rounded),
                        title: Text("Delete"),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
              return FolderView(viewOfFolder: widget.folder);
            }));
          },
          child: ListTile(
            leading: const Icon(Icons.folder_rounded),
            title: Text(widget.folder.name),
            subtitle: Text(widget.folder.dateCreated.replaceFirst('T', ' ').split('.')[0]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.folder.files.isNotEmpty
                  ? [const Icon(Icons.file_present_rounded), Text(widget.folder.files.length.toString())]
                  : [],
            ),
          ),
        ));
  }
}
