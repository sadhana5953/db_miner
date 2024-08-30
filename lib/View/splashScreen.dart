import 'dart:async';

import 'package:db_miner/Controller/quotes_controller.dart';
import 'package:db_miner/View/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(QuotesController());

    Timer(const Duration(seconds: 4), () {
      controller.fromAllData();
      controller.getData();
      Get.to(HomePage());
    });
    return Scaffold(
      backgroundColor: Color(0xff474747),
      body:  Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/img/bg.jpeg'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}

//bg image,
// font family,
// copy,
// share,
// device wallpaper

