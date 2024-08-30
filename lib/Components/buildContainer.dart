import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Controller/quotes_controller.dart';
import '../utiils/image_list.dart';

class SharedContainer extends StatelessWidget {
  const SharedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(QuotesController());
    List<GlobalKey> bgImage =
    List.generate(controller.dataList.length, (index) => GlobalKey());
    return Scaffold(
      body: RepaintBoundary(
        key: bgImage[controller.selectedIndex.value],
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(image: AssetImage(bg[controller.bgIndex.value]),fit: BoxFit.cover),
          ),
          alignment: Alignment.center,
          child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
            Center(child: Text(controller.dataList[controller.selectedIndex.value]['quote'],style: TextStyle(color: Colors.white,fontSize: 20),textAlign: TextAlign.center,)),
            Text(controller.dataList[controller.selectedIndex.value]['author'],style: TextStyle(color: Colors.white,fontSize: 20),textAlign: TextAlign.end,),
          ],),
        ),
      ),
    );
  }
}
