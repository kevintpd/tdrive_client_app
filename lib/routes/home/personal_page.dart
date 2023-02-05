import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../common/network.dart';
import '../../common/global.dart';

class PersonalPageRoute extends StatefulWidget {
  const PersonalPageRoute({Key? key}) : super(key: key);

  @override
  State<PersonalPageRoute> createState() => _PersonalPageRouteState();
}

class _PersonalPageRouteState extends State<PersonalPageRoute> {
  late Future<User?> userinfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("个人信息"),
        ),
        body: FutureBuilder<User?>(
          future: userinfo,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              return ListView(
                children: [
                  Container(
                    color: Colors.blue,
                    constraints: BoxConstraints(minHeight: 50, maxHeight: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          child: CircleAvatar(
                            radius: 40,
                            child: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data!.username,
                              style: TextStyle(fontSize: 25),
                            ),
                            Text(
                              snapshot.data!.email,
                              style: TextStyle(fontSize: 25),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.cloud_queue_rounded,
                            size: 35,
                          ),
                          title: Text(
                            "容量统计",
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            "12G/66G",
                            style: TextStyle(fontSize: 17),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_rounded),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.logout_rounded,
                            size: 35,
                          ),
                          title: Text(
                            "退出登录",
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            "点击退出",
                            style: TextStyle(fontSize: 17),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_rounded),
                          onTap: (){
                            prefs.setString('token','');
                            Navigator.of(context).pushNamed("login");
                          },
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.lock_outline_rounded,
                            size: 35,
                          ),
                          title: Text(
                            "修改密码",
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            "点击修改",
                            style: TextStyle(fontSize: 17),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_rounded),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.contact_support_rounded,
                            size: 35,
                          ),
                          title: Text(
                            "帮助与反馈",
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            "点击发送邮件",
                            style: TextStyle(fontSize: 17),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_rounded),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ));
  }

  @override
  void initState() {
    userinfo = fetchInfo();
    super.initState();
  }
}
