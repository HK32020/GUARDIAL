import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guardial/splash.dart';
import 'package:guardial/utils/route_generator.dart';
import 'utils/constants.dart';
import 'core/sqflite_database_util.dart';
import 'home/guardial_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final Color darkBlue = Color.fromARGB(256, 18, 32, 47);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Open the database and store the reference.
  //DatabaseHandler.deleteDB();
  final initializeDB = await DatabaseHandler.initializeDB();
  DatabaseHandler.printAllTables(initializeDB);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Map<String, WidgetBuilder> routes = {
    SplashScreen.id: (context) => SplashScreen(),
    HomePage.id: (context) => HomePage(),
    //ShowLockScreen.id: (context) => ShowLockScreen(ModalRoute.of(context).settings.arguments),
  };

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 630),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Flutter Demo',
          //theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
          theme: ThemeData(
            primarySwatch: blackTextMaterialColor,
            //fontFamily: 'Modular'
            /*textTheme: TextTheme(
              bodyText1: TextStyle(fontSize: 20, color: Colors.red[900]),
            ),*/
          ),

          onGenerateRoute: RouteGenerator.onGenerateRoute,
          initialRoute: splashScreenViewRoute,
          debugShowCheckedModeBanner: false,
          routes: routes,
          debugShowMaterialGrid: false,
        );
      },
    );
  }
}
