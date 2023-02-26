import '../../models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/network.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../widgets/file_tile.dart';

class homeSearchRoute extends StatefulWidget {
  const homeSearchRoute({Key? key}) : super(key: key);

  @override
  State<homeSearchRoute> createState() => _homeSearchRouteState();
}

class _homeSearchRouteState extends State<homeSearchRoute> {
  TextEditingController _searchText = TextEditingController();
  late Future<List<File>>  files;


  @override
  void initState() {
    files = SearchMyFile("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("搜索"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 40,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: _searchText,
                decoration: InputDecoration(
                    hintText: "请输入搜索内容",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    contentPadding: EdgeInsets.only(bottom: 10),
                    border: InputBorder.none,
                    icon: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Icon(
                          Icons.search,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        )),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 17,
                      ),
                      onPressed: (){
                        _searchText.text = "";
                      },
                      splashColor: Theme.of(context).primaryColor,
                    )),
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (value) {
                  setState(() {
                    files = SearchMyFile(value);
                  });
                  SystemChannels.textInput
                      .invokeMethod('TextInput.hide');
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<File>>(
              future: files,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          File file = snapshot.data![index];
                          return FileTile(file: file);
                        });
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
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: () {
              setState(() {
                files = SearchMyFile("");
              });
            },
            child: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
