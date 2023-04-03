import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as mymodel;
import 'package:another_flushbar/flushbar.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/models.dart';
import '../common/network.dart';
import '../common/utils.dart';
import '../routes/home/move_file_view.dart';
import 'package:tdrive_client_app/common/global.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class FileTile extends StatefulWidget {
  File file;

  FileTile({Key? key, required this.file}) : super(key: key);

  @override
  State<FileTile> createState() => _FileTileState();
}

class _FileTileState extends State<FileTile> {
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
          onTap: () {

            mymodel.showMaterialModalBottomSheet(
              context: context,
              builder: (context) => SingleChildScrollView(
                controller: mymodel.ModalScrollController.of(context),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        final download_record_string = prefs.getString("download_record");
                        // final download_record_string = "[]";
                        // print(download_record_string);
                        final download_record_list = jsonDecode(download_record_string!);
                        downloadFile(context, widget.file);
                        Navigator.of(context).pop();
                        Flushbar(
                          margin: const EdgeInsets.all(8),
                          borderRadius: BorderRadius.circular(8),
                          title:
                              '${widget.file.name} [${widget.file.fileSize}]',
                          message: 'Downloading Started...',
                          icon: Icon(
                            Icons.download_rounded,
                            size: 28,
                            color: Colors.blue[300],
                          ),
                          duration: const Duration(seconds: 3),
                          flushbarPosition: FlushbarPosition.TOP,
                        ).show(context);
                        var now = DateTime.now();
                        download_record_list.add(
                            {"filename":"${widget.file.name}", "downloadtime":"${now.toString()}", "size":"${widget.file.fileSize.toString()}"});
                        prefs.setString("download_record", jsonEncode(download_record_list));
                      },
                      child: const ListTile(
                        leading: Icon(Icons.download_rounded),
                        title: Text("下载"),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {},
                    //   child: const ListTile(
                    //     leading: Icon(Icons.share_rounded),
                    //     title: Text("分享"),
                    //   ),
                    // ),
                    InkWell(
                      onTap: () {
                        showTextInputDialog(
                                okLabel: "确定",
                                cancelLabel: "取消",
                                context: context,
                                textFields: [
                                  DialogTextField(initialText: widget.file.name)
                                ],
                                title: '新文件名')
                            .then((value) async {
                          if (value != null) {
                            var newName = value[0].replaceAll(' ', '');
                            if (newName != '') {
                              print(newName);
                              File newFile = File.clone(widget.file);
                              newFile.name = newName;
                              print(widget.file.id);
                              var response =
                                  await updateFile(widget.file, newFile);
                              print(response?.data);
                              setState(() {
                                widget.file = newFile;
                              });

                              if (!mounted) return;
                              Navigator.of(context).pop();
                            }
                          }
                        });
                      },
                      child: const ListTile(
                        leading: Icon(Icons.drive_file_rename_outline_rounded),
                        title: Text("重命名"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showMaterialModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => SingleChildScrollView(
                            controller: ModalScrollController.of(context),
                            child: MoveFile(moveFile: widget.file),
                          ),
                        );
                      },
                      child: const ListTile(
                        leading: Icon(Icons.drive_file_move_rounded),
                        title: Text("移动"),
                      ),
                    ),
                    //删除，做好了
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    color: Colors.deepOrange[800],
                                  ),
                                  content: const Text("确认删除吗?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          deleteFile(widget.file.id);
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
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.file_present_rounded),
                title: Text(widget.file.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.file.dateUpload
                        .replaceFirst('T', ' ')
                        .split('.')[0]),
                    //Text(widget.file.fileTags)
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.file.fileSize),
                    const Icon(Icons.file_download)
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
