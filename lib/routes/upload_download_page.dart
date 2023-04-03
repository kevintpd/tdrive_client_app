import 'package:flutter/material.dart';
import 'package:tdrive_client_app/common/global.dart';
import 'dart:convert';

class UpDownRoute extends StatefulWidget {
  const UpDownRoute({Key? key}) : super(key: key);

  @override
  State<UpDownRoute> createState() => _UpDownRouteState();
}

class _UpDownRouteState extends State<UpDownRoute> {
  final download_record_json = jsonDecode(prefs.getString("download_record")!);

  @override
  void initState() {
    super.initState();
    print(download_record_json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("下载列表"),
      ),
      body: download_record_json.isNotEmpty
          ? ListView.builder(
              itemCount: download_record_json.length,
              itemBuilder: (context, index) {
                return Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0))),
                    child: ListTile(
                      leading: const Icon(Icons.file_present_rounded),
                      title: Text(download_record_json[index]["filename"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(download_record_json[index]["downloadtime"].substring(0,19)),
                          //Text(widget.file.fileTags)
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(download_record_json[index]["size"] + "kb"),

                        ],
                      ),
                    ));
              })
          : Center(
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
            ),
    );
  }
}
