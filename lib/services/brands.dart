import 'package:admin_dashboard/models/brands.dart';
import 'package:admin_dashboard/models/novels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/helpers/costants.dart';

class BrandService {
  String BrandsCollection = "brands";

  Future<List<BrandModel>> getAllBrands() async =>
      firebaseFiretore.collection(BrandsCollection).get().then((result) {
        List<BrandModel> brands = [];
        for (DocumentSnapshot brand in result.docs) {
          brands.add(BrandModel.fromSnapshot(brand));
        }
        return brands;
      });

  Future<bool> addBrand(Map<String, dynamic> values) async =>
      firebaseFiretore.collection(BrandsCollection).add(values).then((result) {
        return true;
      });

  Future<bool> updateBrand(String id, Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(BrandsCollection)
          .doc(id)
          .update(values)
          .then((result) {
        return true;
      });

  Future<bool> deleteBrand(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection(BrandsCollection)
        .where('__name__', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }
}
