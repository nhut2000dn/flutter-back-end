import 'package:admin_dashboard/models/products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/helpers/costants.dart';

class ProductService {
  String productsCollection = "products";

  Future<List<ProductModel>> getAllProducts() async =>
      firebaseFiretore.collection(productsCollection).get().then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });

  Future<bool> addProduct(Map<String, dynamic> values) async => firebaseFiretore
          .collection(productsCollection)
          .add(values)
          .then((result) {
        return true;
      });

  Future<bool> updateProduct(String id, Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(productsCollection)
          .doc(id)
          .update(values)
          .then((result) {
        return true;
      });

  Future<bool> deleteProduct(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection(productsCollection)
        .where('__name__', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }
}
