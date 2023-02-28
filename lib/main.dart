import 'package:flutter/material.dart';
import 'package:untitled3/shared/network/local/layout_cubit.dart';

import 'layout/home_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LoyoutCubit().creatDB();
//comment
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LayoutScreen(),
    );
  }
}
