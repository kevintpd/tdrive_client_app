import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as mymodel;
import '../../models/models.dart';
import '../myshare/share_folder_view.dart';

class JoinedShareFolderRootTile extends StatefulWidget {
  ShareItem sharefolder;

  JoinedShareFolderRootTile({Key? key, required this.sharefolder}) : super(key: key);

  @override
  State<JoinedShareFolderRootTile> createState() => _JoinedShareFolderRootTileState();
}

class _JoinedShareFolderRootTileState extends State<JoinedShareFolderRootTile> {

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
            mymodel.showMaterialModalBottomSheet(
              context: context,
              builder: (context) => SingleChildScrollView(
                controller: mymodel.ModalScrollController.of(context),
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
                      onTap: () {},
                      child: const ListTile(
                        leading: Icon(Icons.share_rounded),
                        title: Text("共享"),
                      ),
                    ),
                    //修改文件夹名称
                    InkWell(
                      onTap: () {
                      },
                      child: const ListTile(
                        leading: Icon(Icons.drive_file_rename_outline_rounded),
                        title: Text("重命名"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                      },
                      child: const ListTile(
                        leading: Icon(Icons.drive_file_move_rounded),
                        title: Text("移动"),
                      ),
                    ),
                    //删除按钮
                    InkWell(
                      onTap: () {
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
              return ShareFolderView(viewOfFolderId: widget.sharefolder.root, Name: widget.sharefolder.name);
            }));
          },
          child: ListTile(
            leading: const Icon(
              Icons.folder_shared,
              color: Colors.blue,
            ),
            title: Text(widget.sharefolder.name),
            subtitle: Text(
                widget.sharefolder.description),
          ),
        ));
  }
}
