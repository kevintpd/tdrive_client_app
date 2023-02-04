import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/folder_tile.dart';
import '../models/models.dart';
import '../common/network.dart';
import '../widgets/file_tile.dart';
import '../widgets/createFolderPopsup.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'dart:io' as io;

class FolderView extends StatefulWidget {
  final Folder viewOfFolder;

  const FolderView({Key? key, required this.viewOfFolder}) : super(key: key);

  @override
  State<FolderView> createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  TextEditingController _foldername = TextEditingController();
  late Future<Folder?> folderDetailed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.viewOfFolder.name)),
      body: FutureBuilder<Folder?>(
        future: folderDetailed,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else if (snapshot.hasData) {
            if (snapshot.data!.subFolders.isNotEmpty ||
                snapshot.data!.files.isNotEmpty) {
              ListView folderList = ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.subFolders.length,
                  itemBuilder: (context, index) {
                    Folder subFolder =
                        Folder.fromJson(snapshot.data?.subFolders[index]);
                    return FolderTile(folder: subFolder);
                  });

              ListView fileList = ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.files.length,
                  itemBuilder: (context, index) {
                    File file = File.fromJson(snapshot.data!.files[index]);
                    return FileTile(file: file);
                  });

              return Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: folderList,
                  ),
                  Flexible(
                    flex: 2,
                    child: fileList,
                  )
                ],
              );
            }
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.emoji_emotions_rounded,
                    color: Colors.blue,
                  ),
                  Text('Nothing Seems To Be There'),
                ],
              ),
            );
          }
          return Center(child: const CircularProgressIndicator());
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'upload',
            onPressed: () async {
              // print("1111"*100);
              // ProfileScreen(PId:widget.viewOfFolder.id);
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                // io.File file = io.File(result.files.single.path??"");
                PlatformFile file = result.files.single;
                final response = await uploadFile(
                    widget.viewOfFolder.id, file.path, file.name);
                if (response == 201) {
                  EasyLoading.showToast("上传成功");
                }
              } else {
                // User canceled the picker
              }
              ;
            },
            child: const Icon(Icons.file_upload_rounded),
          ),
          const SizedBox(
            height: 8,
          ),
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: () {
              setState(() {
                folderDetailed = fetchFolder(widget.viewOfFolder.id);
              });
            },
            child: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(
            height: 8,
          ),
          FloatingActionButton(
            heroTag: 'newFolder',
            onPressed: () {
              showTextInputDialog(
                      okLabel: "确定",
                      cancelLabel: "取消",
                      context: context,
                      textFields: [DialogTextField(initialText: "新建文件夹")],
                      title: "创建新文件夹")
                  .then((value) async {
                if (value != null) {
                  var foldername = value[0].replaceAll(" ", "");
                  if (_foldername != "") {
                    var response =
                        newFolder(widget.viewOfFolder.id, foldername);
                    if (response != null) {
                      EasyLoading.showToast("创建成功");
                    } else {
                      EasyLoading.showToast("请重新输入文件名");
                    }
                    if (!mounted) return;
                  }
                }
              });
              // setState(() {
              //   showDialog(
              //     barrierDismissible: false,
              //     context: context,
              //     builder: (context) {
              //       return CreateDialog(
              //         contentWidget: CreateDialogContent(
              //           ParentId: widget.viewOfFolder.id,
              //           title: "创建新文件夹",
              //         ),
              //       );
              //     });
              // });
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    folderDetailed = fetchFolder(widget.viewOfFolder.id);
    super.initState();
  }
}
