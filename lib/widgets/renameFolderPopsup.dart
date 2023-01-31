import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../common/network.dart';
class RenameDialog extends AlertDialog {
  RenameDialog({Widget? contentWidget})
      : super(
    content: contentWidget,
    contentPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey, width: 3)),
  );
}

double btnHeight = 60;
double borderWidth = 2;

class RenameDialogContent extends StatefulWidget {
  String ParentId;
  String title;
  String cancelBtnTitle;
  String okBtnTitle;
  VoidCallback? cancelBtnTap;
  Function? okBtnTap;
  TextEditingController? vc;
  RenameDialogContent(
      {required this.ParentId,
        required this.title,
        this.cancelBtnTitle = "取消",
        this.okBtnTitle = "确定",
        this.cancelBtnTap,
        this.okBtnTap,
        this.vc});

  @override
  _RenameDialogContentState createState() =>
      _RenameDialogContentState();
}

class _RenameDialogContentState extends State<RenameDialogContent> {
  TextEditingController _foldername = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        height: 180,
        width: 10000,
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                )),
            Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextField(
                style: TextStyle(fontSize:18, color: Colors.black87),
                controller: _foldername,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(),
                    )),
              ),
            ),
            Container(
              // color: Colors.red,
              height: btnHeight,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Column(
                children: [
                  Container(
                    // 按钮上面的横线
                    width: double.infinity,
                    color: Colors.grey,
                    height: borderWidth,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          // widget.vc?.text = "";
                          // widget.cancelBtnTap();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.cancelBtnTitle,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      Container(
                        // 按钮中间的竖线
                        width: borderWidth,
                        color: Colors.grey,
                        height: btnHeight - borderWidth - borderWidth,
                      ),
                      TextButton(
                          onPressed: (){
                            setState(() {
                              final response = renameFolder(widget.ParentId,_foldername.text);
                              if(response != null){
                                EasyLoading.showToast("修改成功");
                                Navigator.of(context).pop();
                              }
                              else{
                                EasyLoading.showToast("请重新输入文件名");
                              }
                            });
                          },
                          child: Text(
                            widget.okBtnTitle,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
