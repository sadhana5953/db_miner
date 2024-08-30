import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:db_miner/Components/buildContainer.dart';
import 'package:db_miner/Controller/favourite_controller.dart';
import 'package:db_miner/Controller/quotes_controller.dart';
import 'package:db_miner/View/favourite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

import '../utiils/image_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(QuotesController());
    var likeController = Get.put(FavouriteController());
    List<GlobalKey> bgImage =
    List.generate(controller.dataList.length, (index) => GlobalKey());

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    String? _selectedItem;
    final List<String> _dropdownItems = ['HOMESCREEN','LOCKSCREEN','HOMESCREEN AND LOCKSCREEN'];
    final List<IconData> _iconList = [Icons.add_to_home_screen,Icons.lock_outline,Icons.control_point_duplicate];

    Future<void> _selectMenuItem(String value) async {
      _selectedItem = value;
      if(_selectedItem=='HOMESCREEN')
      {
        String result;
        bool goToHome=true;
        // Platform messages may fail, so we use a try/catch PlatformException.
        try {
          result = await AsyncWallpaper.setWallpaper(
            url: bg[controller.bgIndex.value],
            wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
            goToHome: goToHome,
            toastDetails: ToastDetails.success(),
            errorToastDetails: ToastDetails.error(),
          )
              ? 'Wallpaper set'
              : 'Failed to get wallpaper.';
        } on PlatformException {
          result = 'Failed to get wallpaper.';
        }
      }
      else if(_selectedItem=='LOCKSCREEN')
      {
        String result;
        bool goToHome=true;
// Platform messages may fail, so we use a try/catch PlatformException.
        try {
          result = await AsyncWallpaper.setWallpaper(
            url: bg[controller.bgIndex.value],
            wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
            goToHome: goToHome,
            toastDetails: ToastDetails.success(),
            errorToastDetails: ToastDetails.error(),
          )
              ? 'Wallpaper set'
              : 'Failed to get wallpaper.';
        } on PlatformException {
          result = 'Failed to get wallpaper.';
        }
      }
      else if(_selectedItem=='HOMESCREEN AND LOCKSCREEN')
      {
        String result;
        bool goToHome=true;
// Platform messages may fail, so we use a try/catch PlatformException.
        try {
          result = await AsyncWallpaper.setWallpaper(
            url: bg[controller.bgIndex.value],
            wallpaperLocation: AsyncWallpaper.BOTH_SCREENS,
            goToHome: goToHome,
            toastDetails: ToastDetails.success(),
            errorToastDetails: ToastDetails.error(),
          )
              ? 'Wallpaper set'
              : 'Failed to get wallpaper.';
        } on PlatformException {
          result = 'Failed to get wallpaper.';
        }
      }

    }

    return SafeArea(
      child: Scaffold(
          body:Obx(
            () =>  RepaintBoundary(
              key: bgImage[controller.selectedIndex.value],
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(image: AssetImage(bg[controller.bgIndex.value]),fit: BoxFit.cover,opacity: 0.8),
                ),
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: controller.dataList.length,
                  itemBuilder: (context, index) =>  Stack(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                                height: 50,
                                width: 150,
                                margin: EdgeInsets.only(top:8,left: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text('${controller.dataList[index]['category']}',style: TextStyle(color: Colors.white,fontSize: 20),)),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top:8,left: 15),
                              child: IconButton(onPressed: (){
                                likeController.categoryList=[].obs;
                                likeController.showFolder();
                                Get.to(Favourite());
                              }, icon: Icon(Icons.navigate_next,color: Colors.white,size: 35,)),
                            ),
                          ],
                        ),
                        Spacer(),
                        Obx(() =>  Center(child: Text(controller.dataList[index]['quote'],style: TextStyle(color: controller.chooseColor.value,fontSize: controller.size.value.toDouble()),textAlign: controller.alignText.value,))),
                        Text(controller.dataList[index]['author'],style: TextStyle(color: controller.chooseColor.value,fontSize: controller.size.value.toDouble()),textAlign: controller.alignText.value),
                        Obx(
                              () =>  IconButton(onPressed: (){
                            if(controller.dataList[index]['like']==0)
                            {
                              controller.favourite(1, controller.dataList[index]['id']);
                              likeController.insertData(controller.dataList[index]['category'], controller.dataList[index]['quote'], controller.dataList[index]['author'], controller.dataList[index]['description'], controller.dataList[index]['like'], controller.dataList[index]['id']);
                            }else{
                              controller.favourite(0, controller.dataList[index]['id']);
                              likeController.removeData(controller.dataList[index]['id']);
                            }
                          }, icon: controller.dataList[index]['like']==0?Icon(Icons.favorite_border,color: Colors.white,):Icon(Icons.favorite,color: Colors.red,)),
                        ),
                        Spacer(),
                        Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [
                          IconButton(onPressed: (){
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 500,
                                  color: Colors.black,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Divider(thickness: 2,color: Colors.grey,indent: 190,endIndent: 190,),
                                      SizedBox(height: 10,),
                                      Text("Choose a  background",style: TextStyle(color: Colors.green,fontSize: 22,letterSpacing: 1),),
                                      Expanded(
                                        child: GridView.builder(itemBuilder: (context, index) =>
                                            GestureDetector(
                                              onTap: (){
                                                controller.bgIndex.value=index;
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius: BorderRadius.circular(15),
                                                    image: DecorationImage(image: AssetImage(bg[index]),fit: BoxFit.cover)
                                                ),
                                              ),
                                            ),itemCount: bg.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 6/8.5),),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }, icon: Icon(Icons.image,color: Colors.white,)),
                          IconButton(onPressed: (){
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Obx(
                                  () =>  Container(
                                    height: 380,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        //borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                                    ),
                                    child: Column(children: [
                                      Obx(
                                        ()=> Container(
                                          height: 250,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(image: AssetImage(bg[controller.bgIndex.value]),fit: BoxFit.cover),
                                          ),
                                          child: Center(child: Text(controller.dataList[index]['quote'],style: TextStyle(fontSize: controller.size.value.toDouble(),color:controller.chooseColor.value,fontFamily: controller.textFont.value),textAlign: controller.alignText.value,)),
                                        ),
                                      ),
                                      Obx(
                                        () =>  Row(children: [
                                          IconButton(onPressed: (){
                                            controller.changeValue.value=1;
                                          }, icon: controller.changeValue.value!=1?Icon(Icons.font_download_outlined,color: Colors.white,):Icon(Icons.font_download_outlined,color: Colors.blue,size: 25,)),
                                          IconButton(onPressed: (){
                                            controller.changeValue.value=2;
                                          }, icon: controller.changeValue.value!=2?Icon(Icons.color_lens_outlined,color: Colors.white,):Icon(Icons.color_lens_outlined,color: Colors.blue,size: 25,)),
                                          IconButton(onPressed: (){
                                            controller.changeValue.value=3;
                                          }, icon: controller.changeValue.value!=3?Icon(Icons.format_align_center,color: Colors.white,):Icon(Icons.format_align_center,color: Colors.blue,size: 25,)),
                                          IconButton(onPressed: (){
                                            controller.changeValue.value=4;
                                          }, icon: controller.changeValue.value!=4?Icon(Icons.format_size,color: Colors.white,):Icon(Icons.format_size,color: Colors.blue,size: 25,)),
                                        ],),
                                      ),
                                      (controller.changeValue.value==1)?Row(children: [
                                        Text('  Alignment',style: TextStyle(color: Colors.white,fontSize: height*0.020),),
                                        IconButton(onPressed: (){
                                          controller.align.value=CrossAxisAlignment.start;
                                          controller.alignText.value=TextAlign.left;
                                        }, icon: Icon(Icons.align_horizontal_left,color: Colors.grey,)),
                                        IconButton(onPressed: (){
                                          controller.align.value=CrossAxisAlignment.center;
                                          controller.alignText.value=TextAlign.center;
                                        }, icon: Icon(Icons.align_horizontal_center,color: Colors.grey,)),
                                        IconButton(onPressed: (){
                                          controller.align.value=CrossAxisAlignment.end;
                                          controller. alignText.value=TextAlign.right;
                                        }, icon: Icon(Icons.align_horizontal_right,color: Colors.grey,)),
                                        IconButton(onPressed: (){
                                          // setState(() {
                                          //   line=!line;
                                          // });
                                        }, icon: Icon(Icons.text_format,color: Colors.grey,size: height*0.035,))
                                      ],):
                                      (controller.changeValue.value==2)?SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Text(
                                              '  Text color',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: height * 0.022),
                                            ),
                                            SizedBox(
                                              width: width * 0.010,
                                            ),
                                            ...List.generate(
                                              controller.color.length,
                                                  (index) => GestureDetector(
                                                onTap: () {
                                                  controller.chooseColor.value=controller.color[index];
                                                },
                                                child: Container(
                                                  height: height * 0.045,
                                                  width: width * 0.090,
                                                  margin: EdgeInsets.all(
                                                      height * 0.007),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: controller.color[index],
                                                    border: Border.all(color: Colors.white,width: 2),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ):
                                      (controller.changeValue.value==3)?SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Text(
                                              '  Font style',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: height * 0.020),
                                            ),
                                            ...List.generate(controller.fonts.length, (index) => TextButton(
                                                onPressed: () {
                                                  controller.textFont.value=controller.fonts[index];
                                                },
                                                child: Text(
                                                  'Sample',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: controller.fonts[index].toString(),
                                                      fontSize: height * 0.023),
                                                ),
                                            ),)
                                          ],
                                        ),
                                      ):
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Text size',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: height * 0.022),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                controller.size++;
                                              },
                                              icon: Icon(
                                                Icons.text_increase_outlined,
                                                color: Colors.grey,
                                                size: height*0.027,
                                              )),
                                          Text(
                                            '${controller.size.value}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: height * 0.022),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                controller.size--;
                                              },
                                              icon: Icon(
                                                Icons.text_decrease_outlined,
                                                color: Colors.grey,
                                                size: height*0.027,
                                              )),
                                        ],
                                      ),

                                    ],),
                                  ),
                                );
                              },
                            );
                          }, icon: Icon(Icons.text_fields,color: Colors.white,)),
                          IconButton(onPressed: (){
                            Clipboard.setData(ClipboardData(
                                text:
                                '${controller.dataList[index]['quote'].toString()}\n${controller.dataList[index]['author'].toString()}'));
                          }, icon: Icon(Icons.copy,color: Colors.white,)),
                          IconButton(onPressed: () async {
                            controller.selectedIndex.value=index;
                            RenderRepaintBoundary boundary = bgImage[index]
                                .currentContext!
                                .findRenderObject() as RenderRepaintBoundary;
                            ui.Image imageUi = await boundary.toImage();
                            ByteData? byteData = await imageUi.toByteData(
                                format: ui.ImageByteFormat.png);
                            Uint8List img = byteData!.buffer.asUint8List();
                            final path = await getApplicationCacheDirectory();
                            File file = File("${path.path}/img.png");
                            file.writeAsBytes(img);
                            ShareExtend.share(file.path, "image");
                          }, icon: Icon(Icons.share,color: Colors.white,)),
                          IconButton(onPressed: (){
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 230,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Divider(thickness: 2,color: Colors.grey,indent: 190,endIndent: 190,),
                                      SizedBox(height: 10,),
                                      Text("Set as Wallpaper\n",style: TextStyle(color: Colors.purple,fontSize: 20),),
                                      ...List.generate(_iconList.length, (index) =>  GestureDetector(
                                        onTap: (){
                                          _selectMenuItem(_dropdownItems[index]);
                                        },
                                        child: Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(_iconList[index],color: Colors.white,size: 25,),
                                          ),
                                          Text(_dropdownItems[index],style: TextStyle(color: Colors.white,fontSize: 18),)
                                        ],),
                                      ),),
                                    ],
                                  ),
                                );
                              },
                            );
                          }, icon: Icon(Icons.wallpaper,color: Colors.white,)),
                        ],),
                        SizedBox(height: 30,),
                      ],
                    ),
                  ],),
                ),
              ),
            ),
          ),
      ),
    );
  }
}
