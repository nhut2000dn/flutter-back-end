import 'package:admin_dashboard/models/orders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/helpers/costants.dart';

class OrderService {
  String ordersCollection = "orders";

  Future<List<OrderModel>> getAllOrders() async =>
      firebaseFiretore.collection(ordersCollection).get().then((result) {
        List<OrderModel> orders = [];
        for (DocumentSnapshot order in result.docs) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });

  Future<bool> addOrder(Map<String, dynamic> values) async =>
      firebaseFiretore.collection(ordersCollection).add(values).then((result) {
        return true;
      });

  Future<bool> updateOrder(String id, Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(ordersCollection)
          .doc(id)
          .update(values)
          .then((result) {
        return true;
      });

  Future<bool> deleteOrder(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection(ordersCollection)
        .where('__name__', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }
}
