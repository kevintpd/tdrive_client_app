import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../common/global.dart';
import '../widgets/createFolderPopsup.dart';
import '../common/network.dart';
import '../models/models.dart';
import '../widgets/folder_tile.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  TextEditingController _foldername = TextEditingController();
  late Future<List<Folder>> root;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TDrive"),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed("updown"),
              icon: const Icon(Icons.swap_vert)),
        ],
      ),
      body: FutureBuilder<List<Folder>>(
        future: root,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Folder folder = snapshot.data![index];
                  return FolderTile(folder: folder);
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
                root = fetchRoot();
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
                    var response = newFolder("", foldername);
                    if (response != null) {
                      EasyLoading.showToast("创建成功");
                      setState(() {
                        root = fetchRoot();
                      });
                    } else {
                      EasyLoading.showToast("请重新输入文件名");
                    }
                    if (!mounted) return;
                  }
                }
              });
              //版本2
              // showDialog(
              //     barrierDismissible: false,
              //     context: context,
              //     builder: (context) {
              //       return CreateDialog(
              //         contentWidget: CreateDialogContent(
              //           ParentId: "",
              //           title: "创建新文件夹",
              //         ),
              //       );
              //     });
              //版本1
              // setState(() {
              //   showMaterialModalBottomSheet(
              //     context: context,
              //     builder: (context) => SingleChildScrollView(
              //       controller: ModalScrollController.of(context),
              //       child: Column(
              //         children: [
              //           SizedBox(height: 20,),
              //           Text("创建新文件夹",
              //           textAlign: TextAlign.left,
              //           style: new TextStyle(
              //             fontSize: 18.0,
              //             fontWeight: FontWeight.bold,
              //           ),),
              //           SizedBox(height: 20,),
              //           TextField(
              //             decoration: InputDecoration(
              //               hintText: "请输入文件夹名称"
              //             ),
              //             controller: _foldername,
              //           ),
              //           SizedBox(height: 20,),
              //           ElevatedButton(
              //             child: Text("确定"),
              //             onPressed: (){
              //               setState(() {
              //                 final response = newFolder("",_foldername.text);
              //                 if(response != null){
              //                   EasyLoading.showToast("创建成功");
              //                   Navigator.pop(context);
              //                 }
              //                 else{
              //                   EasyLoading.showToast("请重新输入文件名");
              //                 }
              //               });
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              //   );
              // }
              // );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    root = fetchRoot();
    super.initState();
  }
}
