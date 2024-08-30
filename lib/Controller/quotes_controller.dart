import 'package:db_miner/Helper/quotes_helper.dart';
import 'package:db_miner/Model/quotes_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';

class QuotesController extends GetxController {
  late QuotesModal quotesModal;
  RxList dataList = [].obs;
  RxInt bgIndex=0.obs;
  RxInt selectedIndex=0.obs;
  RxInt changeValue=0.obs;

  RxBool line=false.obs;
  Rx<CrossAxisAlignment> align=CrossAxisAlignment.center.obs;
  Rx<TextAlign> alignText=TextAlign.center.obs;
  RxBool fontStyle=false.obs;
  RxInt no = 0.obs;
  RxInt size = 20.obs;
  RxString textFont = 'chocolate'.obs;
  Rx<Color> chooseColor = Colors.white.obs;
  RxList<Color> color = [
    Colors.pink,
    Colors.red,
    Colors.pinkAccent,
    Colors.yellow,
    Colors.black,
    Colors.white,
    Colors.cyan,
    Colors.green,
    Colors.deepPurpleAccent,
    Colors.indigoAccent
  ].obs;
  RxList fonts = [
    'bold','chocolate','crackWord','dance','diff','italic','normal','playWrite','shadow',
  ].obs;

  String? Quote;
  int selected=0;
  String appTheme = 'Dark';

  @override
  void onInit() {
    super.onInit();
    fromAllData();
    getData();
    initDb();
  }

  Future<void> initDb() async {
    await QuotesHelper.quotesHelper.database;
  }

  Future<RxList> getData()
  async {
    dataList.value=await QuotesHelper.quotesHelper.readData();
    print('get data***************************************');
    return dataList;
  }
  // void insertData()
  // {
  //   QuotesHelper.quotesHelper.insertData("sadhana","sadhana","sadhana","sadhana");
  // }
  void fromAllData() async {
    final Map<String, dynamic>? data = await QuotesHelper.quotesHelper.fetchData();
    quotesModal = QuotesModal.fromMap(data!);
    for (int i = 0; i < quotesModal.quotes.length; i++) {
      QuotesHelper.quotesHelper.insertData(
          quotesModal.quotes[i].category,
          quotesModal.quotes[i].quote,
          quotesModal.quotes[i].author,
          quotesModal.quotes[i].description,
        0
      );
      print('fromall data loppp==========================');
    }
  }

  void favourite(int like,int id)
  {
    QuotesHelper.quotesHelper.updateData(like, id);
    getData();
  }
}
