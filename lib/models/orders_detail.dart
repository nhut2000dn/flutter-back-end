import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailModel {
  static const String ID = "uid";
  static const String PRICE = "price";
  static const String QUANTIILY = "quantily";
  static const String COLOR = 'color';
  static const String PRODUCTID = 'product_id';
  static const String ORDERID = 'order_id';

  late String _id;
  late double _price;
  late int _quantily;
  late String _color;
  late String _productId;
  late String _orderId;

//  getters
  String get id => _id;
  double get price => _price;
  int get quantily => _quantily;
  String get color => _color;
  String get productId => _productId;
  String get orderId => _orderId;

  OrderDetailModel.fromSnapshot(DocumentSnapshot snapshot) {
    _orderId = snapshot[ORDERID];
    _productId = snapshot[PRODUCTID];
    _color = snapshot[COLOR];
    _quantily = snapshot[QUANTIILY];
    _price = snapshot[PRICE];
    _id = snapshot.id;
  }
}
