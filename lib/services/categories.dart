import 'package:admin_dashboard/models/categories.dart';
import 'package:admin_dashboard/models/novels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/helpers/costants.dart';

class CategoryService {
  String CategoriesCollection = "categories";

  Future<List<CategoryModel>> getAllCategories() async =>
      firebaseFiretore.collection(CategoriesCollection).get().then((result) {
        List<CategoryModel> categories = [];
        for (DocumentSnapshot author in result.docs) {
          categories.add(CategoryModel.fromSnapshot(author));
        }
        return categories;
      });

  Future<bool> addCategory(Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(CategoriesCollection)
          .add(values)
          .then((result) {
        return true;
      });

  Future<bool> updateCategory(String id, Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(CategoriesCollection)
          .doc(id)
          .update(values)
          .then((result) {
        return true;
      });

  Future<bool> deleteCategory(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection(CategoriesCollection)
        .where('__name__', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }
}
