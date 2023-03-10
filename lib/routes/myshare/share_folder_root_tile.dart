import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../models/models.dart';
import 'share_folder_view.dart';
import 'my_share_detail.dart';

class ShareFolderRootTile extends StatefulWidget {
  ShareItem sharefolder;

  ShareFolderRootTile({Key? key, required this.sharefolder}) : super(key: key);

  @override
  State<ShareFolderRootTile> createState() => _ShareFolderRootTileState();
}

class _ShareFolderRootTileState extends State<ShareFolderRootTile> {

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
              return ShareFolderView(viewOfFolderId: widget.sharefolder.root.id, Name: widget.sharefolder.name);
            }));
          },
          child: ListTile(
            leading: const Icon(
              Icons.folder_shared,
              color: Colors.blue,
            ),
            title: Text(widget.sharefolder.name),
            subtitle: Text("有效期:${"${widget.sharefolder.outdatedTime??"无限期"}".replaceFirst('T', ' ').split(' ')[0]}"),
            trailing: GestureDetector(
              child: Icon(Icons.more_vert_rounded),
              onTap: (){
                showMaterialModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => SingleChildScrollView(
                    controller: ModalScrollController.of(context),
                    child: MyShareDetail(shareItem:widget.sharefolder),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
