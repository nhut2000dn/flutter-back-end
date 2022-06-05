import 'package:admin_dashboard/models/novels.dart';
import 'package:admin_dashboard/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/helpers/costants.dart';
import 'package:flutter/cupertino.dart';

class UsersProductsService {
  String usersCollection = "profiles";
  String usersProductsCollection = "users_products";

  Future<List<UserModel>> getAllUsersFollowed(String idProduct) async {
    List<String> usersId = [];
    List<UserModel> users = [];
    bool check = false;
    await firebaseFiretore
        .collection(usersProductsCollection)
        .where('product_id', isEqualTo: idProduct)
        .get()
        .then((result) async {
      for (DocumentSnapshot userNovel in result.docs) {
        usersId.add(userNovel['user_id']);
        check = true;
      }
    });
    if (check) {
      await firebaseFiretore
          .collection(usersCollection)
          .where(
            'user_id',
            whereIn: usersId,
          )
          .get()
          .then((result) {
        for (DocumentSnapshot novel in result.docs) {
          users.add(UserModel.fromSnapshot(novel));
        }
      });
    }
    return users;
  }

  Future<bool> addUserNovel(Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(usersProductsCollection)
          .add(values)
          .then((result) {
        return true;
      });

  Future<bool> deleteUserNovel(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection(usersProductsCollection)
        .where('user_id', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }
}
