import 'package:db_miner/Helper/favourite_helper.dart';
import 'package:get/get.dart';

class FavouriteController extends GetxController
{
  RxList favouriteList = [].obs;
  RxList categoryList = [].obs;

  @override
  void onInit() {
    super.onInit();
    getData();
    initDb();
  }

  Future<void> initDb() async {
    await FavouriteHelper.favouriteHelper.database;
  }

  Future<RxList> getData()
  async {
    favouriteList.value=await FavouriteHelper.favouriteHelper.readData();
    return favouriteList;
  }

  Future<RxList> showCategoryData(String category)
  async {
    favouriteList.value=await FavouriteHelper.favouriteHelper.showCategoryWiseData(category);
    return favouriteList;
  }
Future<void> insertData(String category,String quote,String author,String description,int like,int no)
async {
  FavouriteHelper.favouriteHelper.insertData(category, quote, author, description, like,no);
  await getData();
}

  void showFolder()
  {
    bool isvalue = false;
    for (int i = 0; i < favouriteList.length; i++) {
      for (int j = 0; j <categoryList.length; j++) {
        if (favouriteList[i]['category'] ==
            categoryList[j]) {
          isvalue = true;
        }
      }
      if (isvalue == false) {
        categoryList.add(favouriteList[i]['category']);
      }
      isvalue=false;
    }
  }

  void removeData(int id)
  {
    FavouriteHelper.favouriteHelper.deleteData(id);
    getData();
    showFolder();
  }

  void favourite(int like,int id)
  {
    FavouriteHelper.favouriteHelper.updateData(like, id);
    getData();
  }

}