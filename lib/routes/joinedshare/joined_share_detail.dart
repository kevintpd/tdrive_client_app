import 'package:flutter/material.dart';
import '../../models/models.dart';

class JoinedShareDetail extends StatefulWidget {
  late ShareItem shareItem;

  JoinedShareDetail({Key? key, required this.shareItem}) : super(key: key);

  @override
  State<JoinedShareDetail> createState() => _JoinedShareDetailState();
}

class _JoinedShareDetailState extends State<JoinedShareDetail> {
  // TextEditingController _newName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.shareItem.outdatedTime.runtimeType);
    return SizedBox(
        height: 700,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "共享详情",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 650,
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(

                      itemCount: widget.shareItem.members.length + 8,
                      itemBuilder: (BuildContext context, int index) {
                        if(index==0){
                          return ListTile(
                            leading: Icon(Icons.folder),
                            title: Text("名称"),
                            subtitle: Text(widget.shareItem.name),
                          );
                        }
                        if(index==1){
                          return ListTile(
                            leading: Icon(Icons.person),
                            title: Text("创建者"),
                            subtitle: Text(widget.shareItem.owner.username),
                          );
                        }
                        if(index==2){
                          return ListTile(
                            leading: Icon(Icons.access_time_rounded),
                            title: Text("有效期"),
                            subtitle: Text("${"${widget.shareItem.outdatedTime ?? "无限期"}".replaceFirst('T', ' ').split('+')[0]}"),
                          );
                        }
                        if(index==3){
                          return ListTile(
                            leading: Icon(Icons.close_fullscreen_rounded),
                            title: Text("项目码"),
                            subtitle: Text(widget.shareItem.id),
                          );
                        }
                        if(index==4){
                          return ListTile(
                            leading: Icon(Icons.code_rounded),
                            title: Text("加入码"),
                            subtitle: Text(widget.shareItem.code),
                          );
                        }
                        if(index==5){
                          return ListTile(
                            leading: Icon(Icons.merge_type_rounded),
                            title: Text("类型"),
                            subtitle: Row(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: widget.shareItem.sharetype,
                                      onChanged: (v) {},
                                    ),
                                    Text(
                                      "仅查看",
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio(
                                      value: 2,
                                      groupValue: widget.shareItem.sharetype,
                                      onChanged: (v) {
                                        setState(() {});
                                      },
                                    ),
                                    Text(
                                      "上传下载",
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                        if(index==6){
                          return ListTile(
                            leading: Icon(Icons.description_rounded),
                            title: Text("描述"),
                            subtitle: Text(widget.shareItem.description,softWrap: true,),



                          );
                        }
                        if(index==7){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("成员列表"),
                            ],
                          );
                        }



                        return ListTile(
                          leading: Icon(Icons.people_outline),
                          title: Text(widget.shareItem.members[index-8].username),
                        );
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
