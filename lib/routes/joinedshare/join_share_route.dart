import '../../models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/network.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class JoinShareRoute extends StatefulWidget {
  const JoinShareRoute({Key? key}) : super(key: key);

  @override
  State<JoinShareRoute> createState() => _JoinShareRouteState();
}

class _JoinShareRouteState extends State<JoinShareRoute> {
  TextEditingController _searchText = TextEditingController();
  late Future<List<ShareItem>>  shareItem;


  @override
  void initState() {
    shareItem = fetchAllShareItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("加入共享"),
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
                  hintText: "请输入项目码",
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
                    shareItem=fetchOneShareItem(value);
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
            child: FutureBuilder<List<ShareItem>>(
              future: shareItem,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index){
                        ShareItem item = snapshot.data![index];
                        return Card(
                            clipBehavior: Clip.antiAlias,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                    bottomLeft: Radius.circular(16.0),
                                    bottomRight: Radius.circular(16.0))),
                            child: InkWell(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.folder_shared,
                                  color: Colors.blue,
                                ),
                                title: Text("${item.name}【${item.owner.username}】"),
                                subtitle: Text(item.description),
                                trailing: GestureDetector(
                                  child: Text("加入",style: TextStyle(color: Colors.blue),),
                                  onTap: (){
                                    final response = joinShare(item.id);
                                    if(response != null){
                                      EasyLoading.showToast("加入成功");
                                    }
                                    else{
                                      EasyLoading.showToast("加入失败");
                                    }
                                  },
                                ),
                              ),
                            ));
                      });
                }
                else if (snapshot.hasError) {
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
                shareItem = fetchAllShareItem();
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
