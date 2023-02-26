import 'package:flutter/material.dart';
import 'package:tdrive_client_app/common/global.dart' as Global;
import 'package:tdrive_client_app/common/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:tdrive_client_app/routes/home/registerRoute.dart';
import 'package:tdrive_client_app/routes/upload_download_page.dart';
import 'routes/home/loginRoute.dart';
import 'routes/home/home_page.dart';
import './routes/bottom_navigation_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'routes/myshare/myshare_root.dart';
import 'routes/joinedshare/joinedshare_root.dart';
import 'routes/joinedshare/join_share_route.dart';
import 'routes/home/home_search.dart';

Future<void> main() async{
  await Global.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider())
        ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, ThemeProvider, child){
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: BottomNavigationWidget(),
            builder: EasyLoading.init(),
            routes: <String, WidgetBuilder>{
              "login": (context) => LoginRoute(),
              "register": (context) => RegisterRoute(),
              "updown": (context) => UpDownRoute(),
              "myshare": (context) => MyShareRootRoute(),
              "joinedshare": (context) => JoinedShareRootRoute(),
              "joinshare": (context) => JoinShareRoute(),
              "homesearch": (context) => homeSearchRoute(),
            },
          );
        },
      ),
    );
  }
}
class ThemeProvider extends ChangeNotifier{
  int _themeMode = 0;

  ThemeProvider(){
    _themeMode = prefs.getInt('themeMode')??0;
  }
  ThemeMode get thememode => {0:ThemeMode.system, 1:ThemeMode.light, 2:ThemeMode.dark}[_themeMode]!;

  set themeMode(ThemeMode value){
    _themeMode = {ThemeMode.system:0, ThemeMode.light:1, ThemeMode.dark:2}[value]!;
    prefs.setInt('ThemeMode', _themeMode);
  }

}