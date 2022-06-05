import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderModel {
  static const String ID = "uid";
  static const String ORDERDATE = "order_date";
  static const String ADDRESS = "address";
  static const String EMAIL = "email";
  static const String PHONENUMBER = "phone_number";
  static const String USERID = "user_id";

  late String _id;
  late DateTime _orderDate;
  late String _address;
  late String _email;
  late String _phoneNumber;
  late String _userId;

  //  getters
  String get id => _id;
  DateTime get orderDate => _orderDate;
  String get address => _address;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get userId => _userId;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    _userId = snapshot[USERID];
    _phoneNumber = snapshot[PHONENUMBER];
    _email = snapshot[EMAIL];
    _address = snapshot[ADDRESS];
    _orderDate = snapshot[ORDERDATE].toDate();
    _id = snapshot.id;
  }
}
