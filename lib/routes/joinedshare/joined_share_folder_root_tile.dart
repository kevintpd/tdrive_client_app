import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../models/models.dart';
import '../myshare/share_folder_view.dart';
import 'joined_share_folder_view.dart';
import 'joined_share_detail.dart';

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
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return JoinedShareFolderView(viewOfFolderId: widget.sharefolder.root.id, Name: widget.sharefolder.name, sharetiemId: widget.sharefolder.id,);
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
                    child: JoinedShareDetail(shareItem:widget.sharefolder),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
