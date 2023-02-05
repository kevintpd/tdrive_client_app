
import '../models/models.dart';
import 'package:flutter/material.dart';

import '../routes/home/move_item_view.dart';

class MoveItemTile extends StatefulWidget {
  Folder folder;
  MoveItemTile({Key? key, required this.folder}) : super(key: key);

  @override
  State<MoveItemTile> createState() => _MoveItemTileState();
}

class _MoveItemTileState extends State<MoveItemTile> {
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
              return MoveItem(viewOfFolder: widget.folder);
            }));
          },
          child: ListTile(
            leading: const Icon(Icons.folder_rounded),
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
