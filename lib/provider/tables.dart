import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/models/authors.dart';
import 'package:admin_dashboard/models/brands.dart';
import 'package:admin_dashboard/models/categories.dart';
import 'package:admin_dashboard/models/genres.dart';
import 'package:admin_dashboard/models/novels.dart';
import 'package:admin_dashboard/models/orders.dart';
import 'package:admin_dashboard/models/products.dart';
import 'package:admin_dashboard/models/slideshows.dart';
import 'package:admin_dashboard/models/users.dart';
import 'package:admin_dashboard/models/users_roles.dart';
import 'package:admin_dashboard/services/authors.dart';
import 'package:admin_dashboard/services/brands.dart';
import 'package:admin_dashboard/services/categories.dart';
import 'package:admin_dashboard/services/genre.dart';
import 'package:admin_dashboard/services/novels.dart';
import 'package:admin_dashboard/services/orders.dart';
import 'package:admin_dashboard/services/product.dart';
import 'package:admin_dashboard/services/slideshows.dart';
import 'package:admin_dashboard/services/user.dart';
import 'package:admin_dashboard/services/users_roles.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe

class TablesProvider with ChangeNotifier {
  // ANCHOR table headers
  List<String> fieldsUser = ['id', 'email', 'name', 'gender', 'userRole'];
  String fieldUserCurrent = 'name';
  List<String> fieldsUserRole = ['id', 'role', 'description'];
  String fieldUserRoleCurrent = 'role';
  List<String> fieldsCategory = ['id', 'name', 'image', 'description'];
  String fieldCategoryCurrent = 'name';
  List<String> fieldsBrand = ['id', 'name', 'image', 'description'];
  String fieldBrandCurrent = 'name';
  List<String> fieldsProduct = [
    'id',
    'title',
    'images',
    'colors',
    'description',
    'price',
    'view',
    'favourite'
  ];
  String fieldProductCurrent = 'title';
  List<String> fieldsOrder = [
    'id',
    'order_date',
    'address',
    'email',
    'phone_number',
    'user_id'
  ];
  String fieldOrderCurrent = 'order_date';
  List<String> fieldsNovel = [
    'id',
    'name',
    'reader',
    'follower',
    'chapter',
    'status',
    'year_release'
  ];
  String fieldNovelCurrent = 'name';
  List<String> fieldsGenre = ['id', 'name', 'description'];
  String fieldGenreCurrent = 'name';
  List<String> fieldsAuthor = ['id', 'name', 'description'];
  String fieldAuthorCurrent = 'name';
  List<String> fieldsSlideshow = ['id', 'title', 'index'];
  String fieldSlideshowCurrent = 'title';

  List<int> perPages = [5, 10, 15, 100];
  int total = 100;
  int? currentPerPage;
  late int currentPage = 1;
  bool isSearch = false;
  List<Map<String, dynamic>> usersTableSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> usersRolesTableSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> categoriesTableSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> brandsTableSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> productsTableSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> ordersTableSource = <Map<String, dynamic>>[];

  List<Map<String, dynamic>> genresTableSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> novelsTableSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> authorsTableSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> slideshowTableSource = <Map<String, dynamic>>[];

  List<Map<String, dynamic>> selecteds = <Map<String, dynamic>>[];
  String selectableKey = "id";

  String? sortColumn;
  bool sortAscending = true;
  bool isLoading = true;
  bool showSelect = true;

  final UserServices _userServices = UserServices();
  List<UserModel> _users = <UserModel>[];
  List<UserModel> get users => _users;

  final UserRoleService _userRoleService = UserRoleService();
  List<UserRoleModel> _usersRoles = <UserRoleModel>[];
  List<UserRoleModel> get usersRoles => _usersRoles;

  final CategoryService _categoryService = CategoryService();
  List<CategoryModel> _categories = <CategoryModel>[];
  List<CategoryModel> get categories => _categories;

  final BrandService _brandService = BrandService();
  List<BrandModel> _brands = <BrandModel>[];
  List<BrandModel> get brands => _brands;

  final ProductService _productService = ProductService();
  List<ProductModel> _products = <ProductModel>[];
  List<ProductModel> get products => _products;

  final OrderService _orderService = OrderService();
  List<OrderModel> _orders = <OrderModel>[];
  List<OrderModel> get orders => _orders;

  final GenreService _genreService = GenreService();
  List<GenreModel> _genres = <GenreModel>[];
  List<GenreModel> get genres => _genres;

  final NovelService _novelService = NovelService();
  List<NovelModel> _novels = <NovelModel>[];
  List<NovelModel> get novels => _novels;

  final AuthorService _authorService = AuthorService();
  List<AuthorModel> _authors = <AuthorModel>[];
  List<AuthorModel> get authors => _authors;

  final SlideshowService _slideshowService = SlideshowService();
  List<SlideshowModel> _slideshows = <SlideshowModel>[];
  List<SlideshowModel> get slideshows => _slideshows;

  Future _loadFromFirebase() async {
    _users = await _userServices.getAllUsers();
    _usersRoles = await _userRoleService.getAllUsersRoles();
    _categories = await _categoryService.getAllCategories();
    _brands = await _brandService.getAllBrands();
    _products = await _productService.getAllProducts();
    _orders = await _orderService.getAllOrders();

    _genres = await _genreService.getAllGenres();
    _novels = await _novelService.getAllNovels();
    _authors = await _authorService.getAllAuthors();
    _slideshows = await _slideshowService.getAllSlideshows();
  }

  removeFromTable(Tables tables, String id) {
    switch (tables) {
      case Tables.users:
        usersTableSource.removeWhere((element) => element['id'] == id);
        _users.removeWhere((element) => element.id == id);
        notifyListeners();
        break;
      case Tables.usersRoles:
        usersRolesTableSource.removeWhere((element) => element['id'] == id);
        _users.removeWhere((element) => element.id == id);
        notifyListeners();
        break;
      case Tables.categories:
        categoriesTableSource.removeWhere((element) => element['id'] == id);
        _categories.removeWhere((element) => element.id == id);
        notifyListeners();
        break;
      case Tables.brands:
        brandsTableSource.removeWhere((element) => element['id'] == id);
        _brands.removeWhere((element) => element.id == id);
        notifyListeners();
        break;
      case Tables.products:
        productsTableSource.removeWhere((element) => element['id'] == id);
        _products.removeWhere((element) => element.id == id);
        notifyListeners();
        break;
      case Tables.orders:
        ordersTableSource.removeWhere((element) => element['id'] == id);
        _orders.removeWhere((element) => element.id == id);
        notifyListeners();
        break;
      case Tables.novels:
        novelsTableSource.removeWhere((element) => element['id'] == id);
        _users.removeWhere((element) => element.id == id);
        notifyListeners();
        break;
      case Tables.genres:
        genresTableSource.removeWhere((element) => element['id'] == id);
        _users.removeWhere((element) => element.id == id);
        notifyListeners();
        break;
      case Tables.authors:
        authorsTableSource.removeWhere((element) => element['id'] == id);
        _users.removeWhere((element) => element.id == id);
        notifyListeners();
        break;
      case Tables.slideshows:
        slideshowTableSource.removeWhere((element) => element['id'] == id);
        _slideshows.removeWhere((element) => element.id == id);
        notifyListeners();
        break;
      default:
    }
  }

  Future refreshFromFirebase(Tables tables) async {
    switch (tables) {
      case Tables.users:
        _users = await _userServices.getAllUsers();
        usersTableSource.clear();
        usersTableSource.addAll(_getUsersData());
        notifyListeners();
        break;
      case Tables.usersRoles:
        _usersRoles = await _userRoleService.getAllUsersRoles();
        usersRolesTableSource.clear();
        usersRolesTableSource.addAll(_getUsersRolesData());
        notifyListeners();
        break;
      case Tables.categories:
        _categories = await _categoryService.getAllCategories();
        categoriesTableSource.clear();
        categoriesTableSource.addAll(_getCategoriesData());
        notifyListeners();
        break;
      case Tables.brands:
        _brands = await _brandService.getAllBrands();
        brandsTableSource.clear();
        brandsTableSource.addAll(_getBrandsData());
        notifyListeners();
        break;
      case Tables.products:
        _products = await _productService.getAllProducts();
        productsTableSource.clear();
        productsTableSource.addAll(_getProductsData());
        notifyListeners();
        break;
      case Tables.orders:
        _orders = await _orderService.getAllOrders();
        ordersTableSource.clear();
        ordersTableSource.addAll(_getOrdersData());
        notifyListeners();
        break;
      case Tables.novels:
        _novels = await _novelService.getAllNovels();
        novelsTableSource.clear();
        novelsTableSource.addAll(_getNovelsData());
        notifyListeners();
        break;
      case Tables.genres:
        _genres = await _genreService.getAllGenres();
        genresTableSource.clear();
        genresTableSource.addAll(_getGenresData());
        notifyListeners();
        break;
      case Tables.authors:
        _authors = await _authorService.getAllAuthors();
        authorsTableSource.clear();
        authorsTableSource.addAll(_getAuthorsData());
        notifyListeners();
        break;
      case Tables.slideshows:
        _slideshows = await _slideshowService.getAllSlideshows();
        slideshowTableSource.clear();
        slideshowTableSource.addAll(_getSlideshowData());
        notifyListeners();
        break;
      default:
    }
  }

  List<Map<String, dynamic>> _getUsersData() {
    isLoading = true;
    notifyListeners();
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _users.length;
    debugPrint(i.toString());
    for (UserModel userData in _users) {
      temps.add({
        "id": userData.id,
        "email": userData.email,
        "name": (userData.fullName != '') ? userData.fullName : 'Null',
        "gender": (userData.gender != '') ? userData.gender : 'Null',
        "userRole": userData.userRoleId,
        "avatar": userData.avatar,
        "user_id": userData.userId,
      });
      i++;
    }
    isLoading = false;
    notifyListeners();
    return temps;
  }

  List<Map<String, dynamic>> _getUsersRolesData() {
    isLoading = true;
    notifyListeners();
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _usersRoles.length;
    debugPrint(i.toString());
    for (UserRoleModel data in _usersRoles) {
      temps.add({
        "id": data.id,
        "role": data.role,
        "description": (data.description != '') ? data.description : 'Null',
      });
      i++;
    }
    isLoading = false;
    notifyListeners();
    return temps;
  }

  List<Map<String, dynamic>> _getCategoriesData() {
    isLoading = true;
    notifyListeners();
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _categories.length;
    debugPrint(i.toString());
    for (CategoryModel data in _categories) {
      temps.add({
        "id": data.id,
        "name": data.name,
        "image": data.image,
        "description": (data.description != '') ? data.description : 'Null',
      });
      i++;
    }
    isLoading = false;
    notifyListeners();
    return temps;
  }

  List<Map<String, dynamic>> _getBrandsData() {
    isLoading = true;
    notifyListeners();
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _brands.length;
    debugPrint(i.toString());
    for (BrandModel data in _brands) {
      temps.add({
        "id": data.id,
        "name": data.name,
        "image": data.image,
        "description": (data.description != '') ? data.description : 'Null',
      });
      i++;
    }
    isLoading = false;
    notifyListeners();
    return temps;
  }

  List<Map<String, dynamic>> _getProductsData() {
    isLoading = true;
    notifyListeners();
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _products.length;
    debugPrint(i.toString());
    for (ProductModel data in _products) {
      temps.add({
        "id": data.id,
        "title": data.title,
        "images": data.images,
        "colors": data.colors,
        "description": (data.description != '') ? data.description : 'Null',
        "price": data.price,
        "view": data.view,
        "favourite": data.favourite,
        "quantity": data.quantity,
        'brand_id': data.brandId,
        'category_id': data.categoryId,
      });
      i++;
    }
    isLoading = false;
    notifyListeners();
    return temps;
  }

  List<Map<String, dynamic>> _getOrdersData() {
    isLoading = true;
    notifyListeners();
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _orders.length;
    debugPrint(i.toString());
    for (OrderModel data in _orders) {
      temps.add({
        "id": data.id,
        "order_date": data.orderDate,
        "address": data.address,
        "email": data.email,
        "phone_number": data.phoneNumber,
        "user_id": data.userId,
      });
      i++;
    }
    isLoading = false;
    notifyListeners();
    return temps;
  }

  List<Map<String, dynamic>> _getGenresData() {
    isLoading = true;
    notifyListeners();
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _genres.length;
    debugPrint(i.toString());
    for (GenreModel data in _genres) {
      temps.add({
        "id": data.id,
        "name": data.name,
        "description": (data.description != '') ? data.description : 'Null',
        "image": (data.image != '') ? data.image : '',
      });
      i++;
    }
    isLoading = false;
    notifyListeners();
    return temps;
  }

  List<Map<String, dynamic>> _getNovelsData() {
    isLoading = true;
    notifyListeners();
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _novels.length;
    debugPrint(i.toString());
    for (NovelModel data in _novels) {
      temps.add({
        "id": data.id,
        "name": data.name,
        "reader": data.reader,
        "follower": data.follower,
        "chapter": data.chapter,
        "status": data.status,
        "year_release": data.yearRelease,
        "description": (data.description != '') ? data.description : 'Null',
        "image": (data.image != '') ? data.image : '',
        "author_id": data.authorId,
      });
      i++;
    }
    isLoading = false;
    notifyListeners();
    return temps;
  }

  List<Map<String, dynamic>> _getAuthorsData() {
    isLoading = true;
    notifyListeners();
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _authors.length;
    debugPrint(i.toString());
    for (AuthorModel data in _authors) {
      temps.add({
        "id": data.id,
        "name": data.name,
        "description": (data.description != '') ? data.description : 'Null',
        "avatar": (data.avatar != '') ? data.avatar : '',
      });
      i++;
    }
    isLoading = false;
    notifyListeners();
    return temps;
  }

  List<Map<String, dynamic>> _getSlideshowData() {
    isLoading = true;
    notifyListeners();
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _slideshows.length;
    debugPrint(i.toString());
    for (SlideshowModel data in _slideshows) {
      temps.add({
        "id": data.id,
        "title": data.title,
        "image": data.image,
        "index": data.index,
        "novel_id": data.novelId,
      });
      i++;
    }
    isLoading = false;
    notifyListeners();
    return temps;
  }

  _initData() async {
    isLoading = true;
    notifyListeners();
    await _loadFromFirebase();
    usersTableSource.addAll(_getUsersData());
    usersRolesTableSource.addAll(_getUsersRolesData());
    categoriesTableSource.addAll(_getCategoriesData());
    brandsTableSource.addAll(_getBrandsData());
    productsTableSource.addAll(_getProductsData());
    ordersTableSource.addAll(_getOrdersData());

    genresTableSource.addAll(_getGenresData());
    novelsTableSource.addAll(_getNovelsData());
    authorsTableSource.addAll(_getAuthorsData());
    slideshowTableSource.addAll(_getSlideshowData());

    isLoading = false;
    notifyListeners();
  }

  onSort(dynamic value, Tables tables) {
    sortColumn = value;
    sortAscending = !sortAscending;
    switch (tables) {
      case Tables.users:
        if (sortAscending) {
          usersTableSource
              .sort((a, b) => b["$sortColumn"].compareTo(a["$sortColumn"]));
        } else {
          usersTableSource
              .sort((a, b) => a["$sortColumn"].compareTo(b["$sortColumn"]));
        }
        notifyListeners();
        break;
      case Tables.usersRoles:
        if (sortAscending) {
          usersRolesTableSource
              .sort((a, b) => b["$sortColumn"].compareTo(a["$sortColumn"]));
        } else {
          usersRolesTableSource
              .sort((a, b) => a["$sortColumn"].compareTo(b["$sortColumn"]));
        }
        notifyListeners();
        break;
      case Tables.categories:
        if (sortAscending) {
          categoriesTableSource
              .sort((a, b) => b["$sortColumn"].compareTo(a["$sortColumn"]));
        } else {
          categoriesTableSource
              .sort((a, b) => a["$sortColumn"].compareTo(b["$sortColumn"]));
        }
        notifyListeners();
        break;
      case Tables.brands:
        if (sortAscending) {
          brandsTableSource
              .sort((a, b) => b["$sortColumn"].compareTo(a["$sortColumn"]));
        } else {
          brandsTableSource
              .sort((a, b) => a["$sortColumn"].compareTo(b["$sortColumn"]));
        }
        notifyListeners();
        break;
      case Tables.products:
        if (sortAscending) {
          productsTableSource
              .sort((a, b) => b["$sortColumn"].compareTo(a["$sortColumn"]));
        } else {
          productsTableSource
              .sort((a, b) => a["$sortColumn"].compareTo(b["$sortColumn"]));
        }
        notifyListeners();
        break;
      case Tables.orders:
        if (sortAscending) {
          ordersTableSource
              .sort((a, b) => b["$sortColumn"].compareTo(a["$sortColumn"]));
        } else {
          ordersTableSource
              .sort((a, b) => a["$sortColumn"].compareTo(b["$sortColumn"]));
        }
        notifyListeners();
        break;
      case Tables.novels:
        if (sortAscending) {
          novelsTableSource
              .sort((a, b) => b["$sortColumn"].compareTo(a["$sortColumn"]));
        } else {
          novelsTableSource
              .sort((a, b) => a["$sortColumn"].compareTo(b["$sortColumn"]));
        }
        notifyListeners();
        break;
      case Tables.genres:
        if (sortAscending) {
          genresTableSource
              .sort((a, b) => b["$sortColumn"].compareTo(a["$sortColumn"]));
        } else {
          genresTableSource
              .sort((a, b) => a["$sortColumn"].compareTo(b["$sortColumn"]));
        }
        notifyListeners();
        break;
      case Tables.authors:
        if (sortAscending) {
          authorsTableSource
              .sort((a, b) => b["$sortColumn"].compareTo(a["$sortColumn"]));
        } else {
          authorsTableSource
              .sort((a, b) => a["$sortColumn"].compareTo(b["$sortColumn"]));
        }
        notifyListeners();
        break;
      case Tables.slideshows:
        if (sortAscending) {
          slideshowTableSource
              .sort((a, b) => b["$sortColumn"].compareTo(a["$sortColumn"]));
        } else {
          slideshowTableSource
              .sort((a, b) => a["$sortColumn"].compareTo(b["$sortColumn"]));
        }
        notifyListeners();
        break;
      default:
    }
  }

  onChangeFieldCurrent(Tables tables, String fieldValueCurrent) {
    switch (tables) {
      case Tables.users:
        fieldUserCurrent = fieldValueCurrent;
        notifyListeners();
        break;
      case Tables.usersRoles:
        fieldUserRoleCurrent = fieldValueCurrent;
        notifyListeners();
        break;
      case Tables.categories:
        fieldCategoryCurrent = fieldValueCurrent;
        notifyListeners();
        break;
      case Tables.brands:
        fieldBrandCurrent = fieldValueCurrent;
        notifyListeners();
        break;
      case Tables.products:
        fieldProductCurrent = fieldValueCurrent;
        notifyListeners();
        break;
      case Tables.orders:
        fieldOrderCurrent = fieldValueCurrent;
        notifyListeners();
        break;
      case Tables.novels:
        fieldNovelCurrent = fieldValueCurrent;
        notifyListeners();
        break;
      case Tables.genres:
        fieldGenreCurrent = fieldValueCurrent;
        notifyListeners();
        break;
      case Tables.authors:
        fieldAuthorCurrent = fieldValueCurrent;
        notifyListeners();
        break;
      case Tables.slideshows:
        fieldSlideshowCurrent = fieldValueCurrent;
        notifyListeners();
        break;
      default:
    }
  }

  onSearch(Tables tables, String value) {
    switch (tables) {
      case Tables.users:
        usersTableSource.clear();
        usersTableSource.addAll(_getUsersData());
        usersTableSource.retainWhere((element) =>
            element[fieldUserCurrent].toString() == value.toString());
        break;
      case Tables.usersRoles:
        usersRolesTableSource.clear();
        usersRolesTableSource.addAll(_getUsersRolesData());
        usersRolesTableSource.retainWhere((element) =>
            element[fieldUserRoleCurrent].toString() == value.toString());
        break;
      case Tables.categories:
        categoriesTableSource.clear();
        categoriesTableSource.addAll(_getCategoriesData());
        categoriesTableSource.retainWhere((element) =>
            element[fieldCategoryCurrent].toString() == value.toString());
        break;
      case Tables.brands:
        brandsTableSource.clear();
        brandsTableSource.addAll(_getBrandsData());
        brandsTableSource.retainWhere((element) =>
            element[fieldBrandCurrent].toString() == value.toString());
        break;
      case Tables.products:
        productsTableSource.clear();
        productsTableSource.addAll(_getProductsData());
        productsTableSource.retainWhere((element) =>
            element[fieldProductCurrent].toString() == value.toString());
        break;
      case Tables.orders:
        ordersTableSource.clear();
        ordersTableSource.addAll(_getProductsData());
        ordersTableSource.retainWhere((element) =>
            element[fieldOrderCurrent].toString() == value.toString());
        break;
      case Tables.novels:
        novelsTableSource.clear();
        novelsTableSource.addAll(_getNovelsData());
        novelsTableSource.retainWhere((element) =>
            element[fieldNovelCurrent].toString() == value.toString());
        break;
      case Tables.genres:
        genresTableSource.clear();
        genresTableSource.addAll(_getGenresData());
        genresTableSource.retainWhere((element) =>
            element[fieldGenreCurrent].toString() == value.toString());
        break;
      case Tables.authors:
        authorsTableSource.clear();
        authorsTableSource.addAll(_getAuthorsData());
        authorsTableSource.retainWhere((element) =>
            element[fieldAuthorCurrent].toString() == value.toString());
        break;
      case Tables.slideshows:
        slideshowTableSource.clear();
        slideshowTableSource.addAll(_getSlideshowData());
        slideshowTableSource.retainWhere((element) =>
            element[fieldSlideshowCurrent].toString() == value.toString());
        break;
      default:
    }
    notifyListeners();
  }

  resestData(Tables tables) {
    switch (tables) {
      case Tables.users:
        usersTableSource.clear();
        usersTableSource.addAll(_getUsersData());
        break;
      case Tables.usersRoles:
        usersRolesTableSource.clear();
        usersRolesTableSource.addAll(_getUsersRolesData());
        break;
      case Tables.categories:
        categoriesTableSource.clear();
        categoriesTableSource.addAll(_getCategoriesData());
        break;
      case Tables.brands:
        brandsTableSource.clear();
        brandsTableSource.addAll(_getBrandsData());
        break;
      case Tables.products:
        productsTableSource.clear();
        productsTableSource.addAll(_getProductsData());
        break;
      case Tables.orders:
        ordersTableSource.clear();
        ordersTableSource.addAll(_getOrdersData());
        break;
      case Tables.novels:
        novelsTableSource.clear();
        novelsTableSource.addAll(_getNovelsData());
        break;
      case Tables.genres:
        genresTableSource.clear();
        genresTableSource.addAll(_getGenresData());
        break;
      case Tables.authors:
        authorsTableSource.clear();
        authorsTableSource.addAll(_getAuthorsData());
        break;
      default:
    }
    notifyListeners();
  }

  onSelected(bool value, Map<String, dynamic> item) {
    debugPrint("$value  $item ");
    if (value) {
      selecteds.add(item);
    } else {
      selecteds.removeAt(selecteds.indexOf(item));
    }
    notifyListeners();
  }

  onSelectAll(bool value) {
    if (value) {
      selecteds = usersTableSource.map((entry) => entry).toList().cast();
    } else {
      selecteds.clear();
    }
    notifyListeners();
  }

  onChanged(int value) {
    currentPerPage = value;
    notifyListeners();
  }

  previous() {
    currentPage = currentPage >= 2 ? currentPage - 1 : 1;
    notifyListeners();
  }

  next() {
    currentPage++;
    notifyListeners();
  }

  TablesProvider.init() {
    _initData();
  }
}
