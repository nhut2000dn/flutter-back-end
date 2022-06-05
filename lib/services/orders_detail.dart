import 'package:admin_dashboard/models/orders_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/helpers/costants.dart';
import 'package:flutter/cupertino.dart';

class OrderDetailService {
  String ordersDetailCollection = "orders_details";

  Future<List<OrderDetailModel>> getordersDetailOfOrder(String id) async =>
      firebaseFiretore
          .collection(ordersDetailCollection)
          .where('order_id', isEqualTo: id)
          .get()
          .then((result) {
        List<OrderDetailModel> ordersDetail = [];
        for (DocumentSnapshot orderDetail in result.docs) {
          ordersDetail.add(OrderDetailModel.fromSnapshot(orderDetail));
        }
        return ordersDetail;
      });

  Future<bool> addOrderDetail(Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(ordersDetailCollection)
          .add(values)
          .then((result) {
        return true;
      });

  Future<bool> updateOrderDetail(
          String id, Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(ordersDetailCollection)
          .doc(id)
          .update(values)
          .then((result) {
        return true;
      });

  Future<bool> deleteOrderDetail(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection(ordersDetailCollection)
        .where('__name__', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }
}
