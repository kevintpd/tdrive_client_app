import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:file_picker/file_picker.dart';
import '../../widgets/folder_tile.dart';
import '../../models/models.dart';
import '../../common/network.dart';
import '../../widgets/file_tile.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'joined_share_folder_tile.dart';

class JoinedShareFolderView extends StatefulWidget {
  final String viewOfFolderId;
  final String Name;
  final String sharetiemId;


  const JoinedShareFolderView({Key? key, required this.viewOfFolderId, required this.Name, required this.sharetiemId}) : super(key: key);

  @override
  State<JoinedShareFolderView> createState() => _JoinedShareFolderViewState();
}

class _JoinedShareFolderViewState extends State<JoinedShareFolderView> {
  TextEditingController _foldername = TextEditingController();
  late Future<Folder?> folderDetailed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.Name)),
      body: FutureBuilder<Folder?>(
        future: folderDetailed,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else if (snapshot.hasData) {
            if (snapshot.data!.subFolders.isNotEmpty ||
                snapshot.data!.files.isNotEmpty) {
              ListView folderList = ListView.builder(
                physics:const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.subFolders.length,
                  itemBuilder: (context, index) {
                    Folder subFolder =
                    Folder.fromJson(snapshot.data?.subFolders[index]);
                    return JoinedShareFolderTile(folder: subFolder);
                  });

              ListView fileList = ListView.builder(
                  physics:const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.files.length,
                  itemBuilder: (context, index) {
                    File file = File.fromJson(snapshot.data!.files[index]);
                    return FileTile(file: file);
                  });

              return SingleChildScrollView(
                child: Column(
                  children: [
                    folderList,
                    fileList
                  ],
                ),
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
                  Text('这里什么都没有~'),
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
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                // io.File file = io.File(result.files.single.path??"");
                PlatformFile file = result.files.single;
                final response = await uploadFileToShare(widget.sharetiemId,
                    widget.viewOfFolderId, file.path, file.name);
                if (response == 201) {
                  EasyLoading.showToast("上传成功");
                  setState(() {
                    folderDetailed = fetchShareFolder(widget.viewOfFolderId);
                  });
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
                folderDetailed = fetchShareFolder(widget.viewOfFolderId);
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
                    newShareFolder(widget.sharetiemId, widget.viewOfFolderId, foldername);
                    if (response != null) {
                      EasyLoading.showToast("创建成功");
                      setState(() {
                        folderDetailed = fetchShareFolder(widget.viewOfFolderId);
                      });
                    } else {
                      EasyLoading.showToast("请重新输入文件名");
                    }
                    if (!mounted) return;
                  }
                }
              });
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    folderDetailed = fetchShareFolder(widget.viewOfFolderId);
    super.initState();
  }
}
