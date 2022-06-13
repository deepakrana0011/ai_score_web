class CategoryListModel{
  List<CategoryList> categoryList = [];

  CategoryListModel.fromJson(Map<String, dynamic> parsedJson){
    List<CategoryList> list = [];
    for(int i =0 ; i < parsedJson['categoryList'].length; i++){
      list.add(CategoryList.fromJson(parsedJson['categoryList'][i]));
    }
    categoryList = list;
  }

}

class CategoryList{
  String? categoryName;
  String? categoryNumber;

  CategoryList({this.categoryName,this.categoryNumber});

  CategoryList.fromJson(Map<String ,dynamic> parsedJson){
    categoryName = parsedJson['category'];
    categoryNumber = parsedJson['categoryNo'];
  }
}