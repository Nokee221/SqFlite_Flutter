import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqlflutter_app/screen/home_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

    return const MaterialApp(
          title: 'BoostMe',
          home: HomeScreen(),
        );
  }
}