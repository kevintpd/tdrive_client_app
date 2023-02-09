import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdrive_client_app/common/network.dart';
import '../../models/models.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MakeShare extends StatefulWidget {
  late Folder folder;


  MakeShare({Key? key, required this.folder}) : super(key: key);

  @override
  State<MakeShare> createState() => _MakeShareState();
}

class _MakeShareState extends State<MakeShare> {
  TextEditingController _DescriptionController = TextEditingController();
  TextEditingController _joinCodeController = TextEditingController();
  List<int> dateTime = [];
  int shareType = 1;

  @override
  void initState() {
    shareType = 1;
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
                "创建共享",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 600,
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView(
                    children: [
                  ListTile(
                  leading: Icon(Icons.folder),
                  title: Text("名称"),
                  subtitle: Text(widget.folder.name),
                ),
                ListTile(
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
                        selectDate: PDuration(),
                        maxDate: PDuration(),
                        onConfirm: (p) {
                          setState(() {
                              dateTime.add(p.year ?? 2100);
                              dateTime.add(p.month ?? 1);
                              dateTime.add(p.day ?? 1);
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
                ),
                ListTile(
                  leading: Icon(Icons.code_rounded),
                  title: Text("加入码"),
                  subtitle: TextFormField(
                    decoration: InputDecoration(
                        hintText: "最多4位字母，不填写则自动生成"
                    ),
                    controller: _joinCodeController,
                    maxLength: 4,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      SystemChannels.textInput
                          .invokeMethod('TextInput.hide');
                    },
                  ),
                ),
                ListTile(
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
                ),
                ListTile(
                  leading: Icon(Icons.description_rounded),
                  title: Text("描述"),
                  subtitle: TextFormField(
                    decoration: InputDecoration(
                      hintText: "描述一下你的共享文件夹吧~"
                    ),
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
                ),
                    ],
                  )
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () async {
                              dynamic newTime;

                              if (dateTime.isEmpty) {}
                              else if (dateTime.isNotEmpty) {
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

                                newTime += "T12:00";
                              }


                              var response =await newShareItem(
                              widget.folder.id,
                                newTime,
                                _joinCodeController.text,
                                shareType,
                                _DescriptionController.text,
                              );
                              if (response == 201) {
                                EasyLoading.showToast("创建成功");
                                Future.delayed(Duration(seconds: 1), () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  EasyLoading.dismiss();
                                });
                              }
                              else {
                                EasyLoading.showToast("创建失败");
                              }
                            },
                            child: Text(
                              "创建",
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
