import 'package:db_miner/View/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'View/homepage.dart';

void main()
{
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => SplashScreen(),),
      ],
    );
  }
}
