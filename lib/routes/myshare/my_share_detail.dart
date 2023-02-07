
import 'package:flutter/material.dart';
import '../../models/models.dart';

class MyShareDetail extends StatefulWidget {
  late ShareItem shareItem;
  MyShareDetail({Key? key, required this.shareItem}) : super(key: key);

  @override
  State<MyShareDetail> createState() => _MyShareDetailState();
}

class _MyShareDetailState extends State<MyShareDetail> {

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
              SizedBox(height: 10,),

              Text(
                "名称:${widget.shareItem.name}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19),
              ),
              Text("创建者:${widget.shareItem.owner.username}",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 19),),
              Text("有效期:${"${widget.shareItem.outdatedTime??"无限期"}".replaceFirst('T', ' ').split('+')[0]}",
              style: TextStyle(fontSize: 19),),
              Text("项目码:${widget.shareItem.id}",style: TextStyle(fontSize: 19),softWrap: true,),
              Text("加入码:${widget.shareItem.code}",style: TextStyle(fontSize: 19),),
              Row(children: [
                Text("类型:",style: TextStyle(fontSize: 19),),
                Row(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(value: 1,
                  groupValue: widget.shareItem.sharetype,
                  onChanged: (v){},),
                  Text("仅查看",style: TextStyle(fontSize: 19),)
                ],),
                Row(mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(value: 2,
                      groupValue: widget.shareItem.sharetype,
                      onChanged: (v){
                      setState(() {

                      });
                      },),
                    Text("上传下载",style: TextStyle(fontSize: 19),)
                  ],)
              ],),
              Text("描述:${widget.shareItem.description}",style: TextStyle(fontSize: 19),softWrap: true,),
              SizedBox(
                height: 350,
                child: ListView.builder(
                    itemCount: widget.shareItem.members.length,
                    itemBuilder: (BuildContext context, int index)=>ListTile(
                      title: Text(widget.shareItem.members[index].username),
                      trailing: GestureDetector(
                        onTap: (){},
                        child: Text("移除",style: TextStyle(color: Colors.blue),),
                      ),
                    )),
              ),
              Expanded(
                child: Row(children: [
                  Expanded(child: TextButton(onPressed: (){}, child: Text("删除共享",style: TextStyle(fontSize: 20),))),
                  Expanded(child: TextButton(onPressed: (){}, child: Text("确认修改",style: TextStyle(fontSize: 20),))),
                ],),
              )
            ],
          ),
        ));
  }
}
