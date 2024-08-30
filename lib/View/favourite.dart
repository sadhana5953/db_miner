import 'package:db_miner/View/quotes_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Controller/favourite_controller.dart';

class Favourite extends StatelessWidget {
  const Favourite({super.key});

  @override
  Widget build(BuildContext context) {
    var likeController = Get.put(FavouriteController());

    return Scaffold(
      backgroundColor: likeController.categoryList.length==0?Colors.white:Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        },icon: Icon(Icons.arrow_back_ios,color: likeController.categoryList.length==0?Colors.black:Colors.white,),),
        backgroundColor: likeController.categoryList.length==0?Colors.white:Colors.black,
        title: Text('Favourite Quotes',style: TextStyle(color: likeController.categoryList.length==0?Colors.black:Colors.white,),),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(5),
        child: Obx(
              () => likeController.categoryList.length==0?Center(child:Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkN4Mws1Ru4G9vnXi4HN663GqlPn3IoV47dg&s'),fit: BoxFit.cover,),
                    ),
                  ),
                  Text("No Favourite Yet",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                ],
              )): GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 4/4),
                  itemCount: likeController.categoryList.length,
                  itemBuilder: (context, index) =>
                      GestureDetector(onTap:(){
                        likeController.showCategoryData(likeController.categoryList[index]);
                        Get.to(QuotesPage());
                      },child:Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: Offset(5, 5),
                                spreadRadius: 3.5,
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.purple],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          borderRadius: BorderRadius.circular(15),
                         // borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomLeft: Radius.circular(25),)
                        ),
                        alignment: Alignment.center,
                        child: Text(likeController.categoryList[index],style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                      ),
                      ),
                ),
            ),
      ),
    );
  }
}
