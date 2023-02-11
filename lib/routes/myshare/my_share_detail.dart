import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdrive_client_app/common/network.dart';
import '../../models/models.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyShareDetail extends StatefulWidget {
  late ShareItem shareItem;


  MyShareDetail({Key? key, required this.shareItem}) : super(key: key);

  @override
  State<MyShareDetail> createState() => _MyShareDetailState();
}

class _MyShareDetailState extends State<MyShareDetail> {
  TextEditingController _DescriptionController = TextEditingController();
  TextEditingController _joinCodeController = TextEditingController();
  List<int> dateTime = [];
  int shareType = 1;
  List<String> RemovedPeople = [];
  // late ShareItemSample shareItemSample;

  @override
  void initState() {
    _DescriptionController.text = widget.shareItem.description;
    _joinCodeController.text = widget.shareItem.code;
    if (widget.shareItem.outdatedTime != null) {
      widget.shareItem.outdatedTime
          .replaceFirst('T', ' ')
          .split(' ')[0]
          .split('-')
          .forEach((num) => dateTime.add(int.parse(num)));
    }
    shareType = widget.shareItem.sharetype;
    RemovedPeople = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                height: 600,
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                      itemCount: widget.shareItem.members.length + 8,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return ListTile(
                            leading: Icon(Icons.folder),
                            title: Text("名称"),
                            subtitle: Text(widget.shareItem.name),
                          );
                        }
                        if (index == 1) {
                          return ListTile(
                            leading: Icon(Icons.person),
                            title: Text("创建者"),
                            subtitle: Text(widget.shareItem.owner.username),
                          );
                        }
                        if (index == 2) {
                          return ListTile(
                            leading: Icon(Icons.access_time_rounded),
                            title: Text("有效期"),
                            trailing: TextButton(
                              onPressed: () {
                                Pickers.showDatePicker(
                                  context,
                                  mode: DateMode.YMD,
                                  // 后缀 默认Suffix.normal()，为空的话Suffix()
                                  suffix: Suffix(
                                      years: ' 年', month: ' 月', days: ' 日'),
                                  // 样式  详见下方样式
                                  // 默认选中
                                  selectDate: dateTime.isNotEmpty
                                      ? PDuration(
                                      year: dateTime[0],
                                      month: dateTime[1],
                                      day: dateTime[2])
                                      : PDuration(),
                                  maxDate: PDuration(),
                                  onConfirm: (p) {
                                    setState(() {
                                      if (dateTime.isNotEmpty) {
                                        dateTime[0] = p.year ?? 2100;
                                        dateTime[1] = p.month ?? 1;
                                        dateTime[2] = p.day ?? 1;
                                      } else {
                                        dateTime.add(p.year ?? 2100);
                                        dateTime.add(p.month ?? 1);
                                        dateTime.add(p.day ?? 1);
                                      }
                                    });
                                  },
                                );
                              },
                              child: Text("修改"),
                            ),
                            subtitle: dateTime.isNotEmpty
                                ? Text(
                                "${dateTime[0]}-${dateTime[1]}-${dateTime[2]}")
                                : Text("无限期"),
                          );
                        }
                        if (index == 3) {
                          return ListTile(
                            leading: Icon(Icons.close_fullscreen_rounded),
                            title: Text("项目码"),
                            subtitle: Text(widget.shareItem.id),
                            trailing: TextButton(
                              onPressed: (){
                                Clipboard.setData(ClipboardData(text: widget.shareItem.id));
                                EasyLoading.showToast("复制成功");
                              },
                              child: Text("复制"),
                            ),
                          );
                        }
                        if (index == 4) {
                          return ListTile(
                            leading: Icon(Icons.code_rounded),
                            title: Text("加入码"),
                            subtitle: TextFormField(
                              controller: _joinCodeController,
                              maxLength: 4,
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                              },
                            ),
                          );
                        }
                        if (index == 5) {
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
                                      groupValue: shareType,
                                      onChanged: (v) {
                                        setState(() {
                                          shareType = 1;
                                        });
                                      },
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
                                      groupValue: shareType,
                                      onChanged: (v) {
                                        setState(() {
                                          shareType = 2;
                                        });
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
                        if (index == 6) {
                          return ListTile(
                            leading: Icon(Icons.description_rounded),
                            title: Text("描述"),
                            subtitle: TextFormField(
                              controller: _DescriptionController,
                              // initialValue: widget.shareItem.description,
                              maxLength: 100,
                              maxLines: 6,
                              minLines: 1,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                              },
                            ),
                          );
                        }
                        if (index == 7) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("成员列表"),
                            ],
                          );
                        } else {
                          if (RemovedPeople.contains(
                              widget.shareItem.members[index - 8].id)) {
                            return ListTile(
                              leading: Icon(Icons.people_outline),
                              title: Text(
                                widget.shareItem.members[index - 8].username,
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.red),
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    RemovedPeople.remove(
                                        widget.shareItem.members[index - 8].id);
                                  });
                                },
                                child: Text(
                                  "取消",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            );
                          } else {
                            return ListTile(
                              leading: Icon(Icons.people_outline),
                              title: Text(
                                  widget.shareItem.members[index - 8].username),
                              trailing: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    RemovedPeople.add(
                                        widget.shareItem.members[index - 8].id);
                                  });
                                },
                                child: Text(
                                  "移除",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            );
                          }
                        }
                      }),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    icon: Icon(
                                      Icons.delete_rounded,
                                      color: Colors.deepOrange[800],
                                    ),
                                    content: const Text("确认删除吗?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            deleteShareItem(widget.shareItem.id);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("确认")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("取消"))
                                    ],
                                  ));
                            },
                            child: Text(
                              "删除共享",
                              style: TextStyle(fontSize: 20),
                            ))),
                    Expanded(
                        child: TextButton(
                            onPressed: () async {
                              List<String> stayPeople = [];
                              widget.shareItem.members.forEach((element) {
                                stayPeople.add(element.id);
                              });
                              RemovedPeople.forEach((element) {
                                if (stayPeople.contains(element)) {
                                  stayPeople.remove(element);
                                }
                              });
                              dynamic newTime;
                              if (widget.shareItem.outdatedTime != null &&
                                  dateTime.isNotEmpty) {
                                newTime = dateTime[0].toString();
                                if (dateTime[1] < 10) {
                                  newTime += "-0${dateTime[1].toString()}";
                                } else {
                                  newTime += "-${dateTime[1].toString()}";
                                };

                                if (dateTime[2] < 10) {
                                  newTime += "-0${dateTime[2].toString()}";
                                } else {
                                  newTime += "-${dateTime[2].toString()}";
                                };
                                newTime +=
                                    "T" + widget.shareItem.outdatedTime
                                        .split("T")[1].substring(0,5);
                              }
                              else if (widget.shareItem.outdatedTime == null &&
                                  dateTime.isEmpty) {}
                              else if (widget.shareItem.outdatedTime == null &&
                                  dateTime.isNotEmpty) {
                                newTime = dateTime[0].toString();
                                if (dateTime[1] < 10) {
                                  newTime += "-0${dateTime[1].toString()}";
                                } else {
                                  newTime += "-${dateTime[1].toString()}";
                                };

                                if (dateTime[2] < 10) {
                                  newTime += "-0${dateTime[2].toString()}";
                                } else {
                                  newTime += "-${dateTime[2].toString()}";
                                };

                                newTime += "T00:00";
                              }
                             ShareItemSample a = new ShareItemSample(
                                  widget.shareItem.id,
                                  widget.shareItem.name,
                                  widget.shareItem.owner.id,
                                  widget.shareItem.items,
                                  widget.shareItem.root.id,
                                  widget.shareItem.createdTime,
                                  newTime,
                                  stayPeople,
                                  _joinCodeController.text,
                                  shareType,
                                  _DescriptionController.text);
                              // print(newTime);
                              // print(widget.shareItem.outdatedTime);

                              var response =await updateShareitem(
                                  widget.shareItem, a);
                              if (response == 200) {
                                EasyLoading.showToast("修改成功");
                                Future.delayed(Duration(seconds: 1), () {
                                  Navigator.pop(context);
                                  EasyLoading.dismiss();
                                });
                              }
                              else {
                                EasyLoading.showToast("修改失败");
                              }
                            },
                            child: Text(
                              "确认修改",
                              style: TextStyle(fontSize: 20),
                            ))),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
