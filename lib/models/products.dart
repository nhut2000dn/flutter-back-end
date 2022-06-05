import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const String ID = 'uid';
  static const String TITLE = 'title';
  static const String IMAGES = 'images';
  static const COLORS = 'colors';
  static const String DESCRIPTION = 'description';
  static const String PRICE = 'price';
  static const String VIEW = 'view';
  static const String FAVOURITE = 'favourite';
  static const QUANTITY = "quantity";
  static const String BRANDID = 'brand_id';
  static const String CATEGORYID = 'category_id';

  late String _id;
  late String _title;
  late String _images;
  late String _colors;
  late String _description;
  late double _price;
  late int _view;
  late int _favourite;
  late int _quantity;
  late String _brandId;
  late String _categoryId;

  //  getters
  String get id => _id;
  String get title => _title;
  String get images => _images;
  String get colors => _colors;
  String get description => _description;
  double get price => _price;
  int get view => _view;
  int get favourite => _favourite;
  int get quantity => _quantity;
  String get brandId => _brandId;
  String get categoryId => _categoryId;

  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    _categoryId = snapshot[CATEGORYID];
    _brandId = snapshot[BRANDID];
    _quantity = snapshot[QUANTITY];
    _favourite = snapshot[FAVOURITE];
    _view = snapshot[VIEW];
    _price = snapshot[PRICE];
    _description = snapshot[DESCRIPTION];
    _colors = snapshot[COLORS];
    _images = snapshot[IMAGES];
    _title = snapshot[TITLE];
    _id = snapshot.id;
  }
}
