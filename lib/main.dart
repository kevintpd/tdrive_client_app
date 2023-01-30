import 'package:flutter/material.dart';
import 'package:tdrive_client_app/common/global.dart' as Global;
import 'package:tdrive_client_app/common/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:tdrive_client_app/routes/registerRoute.dart';
import './routes/loginRoute.dart';
import './routes/home_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
            home: HomeRoute(),
            builder: EasyLoading.init(),
            routes: <String, WidgetBuilder>{
              "login": (context) => LoginRoute(),
              "register": (context) => RegisterRoute(),
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