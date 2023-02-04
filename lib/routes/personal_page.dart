import 'package:flutter/material.dart';
import '../models/models.dart';
import '../common/network.dart';


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
          builder: (context, snapshot){
            if(snapshot.hasError){
              return Text('${snapshot.error}');
            }
            else if (snapshot.hasData){
              return Column(
                children: [
                  Text(snapshot.data!.username)
                ],
              );
            }
            else{
              return Center(child: const CircularProgressIndicator());
            }
          },
        )
        );
  }

  @override
  void initState() {
    userinfo = fetchInfo();
    super.initState();
  }
}