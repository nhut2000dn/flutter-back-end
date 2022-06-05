// ignore_for_file: deprecated_member_use
import 'package:admin_dashboard/models/chapters.dart';
import 'package:admin_dashboard/models/orders_detail.dart';
import 'package:admin_dashboard/services/chapters.dart';
import 'package:admin_dashboard/services/orders_detail.dart';
import 'package:admin_dashboard/widgets/add_modals/add_chapter.dart';
import 'package:admin_dashboard/widgets/edit_modals/edit_chapter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/services/user.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/ResponsiveDatatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/responsive_table.dart';

// ignore: must_be_immutable
class OrderDetailTable extends StatefulWidget {
  String id;
  OrderDetailTable({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _OrderDetailTableState createState() => _OrderDetailTableState();
}

class _OrderDetailTableState extends State<OrderDetailTable>
    with AutomaticKeepAliveClientMixin<OrderDetailTable> {
  late TextEditingController inputSearchController;
  late bool isSearch = false;
  List<Map<String, dynamic>> ordersDetailsTableSource =
      <Map<String, dynamic>>[];
  List<OrderDetailModel> _ordersDetails = <OrderDetailModel>[];
  List<OrderDetailModel> get chapters => _ordersDetails;
  bool isLoading = true;
  bool sortAscending = true;
  String? sortColumn;

  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> _getOrderDetailData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _ordersDetails.length;
    debugPrint(i.toString());
    for (OrderDetailModel orderDetailData in _ordersDetails) {
      temps.add({
        "id": orderDetailData.id,
        "price": orderDetailData.price,
        "quantily": orderDetailData.quantily,
        "color": orderDetailData.color,
        "product_id": orderDetailData.productId,
      });
      i++;
    }
    return temps;
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {
    debugPrint(widget.id);
    var placeholder =
        await OrderDetailService().getordersDetailOfOrder(widget.id);
    setState(() {
      _ordersDetails = placeholder;
      ordersDetailsTableSource.addAll(_getOrderDetailData());
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    inputSearchController = TextEditingController();
    ordersDetailsTableSource.clear();
    initData();
  }

  updateAddTable(bool check) {
    if (check) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Add Chapter Succesful!")));
      ordersDetailsTableSource.clear();
      initData();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed!")));
    }
  }

  updateEditTable(bool check) {
    if (check) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Update Chapter Succesful!")));
      ordersDetailsTableSource.clear();
      initData();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed!")));
    }
  }

  updateDeleteTable(bool check) {
    if (check) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Delete Chapter Succesful!")));
      ordersDetailsTableSource.clear();
      initData();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed!")));
    }
  }

  onSort(String value) {
    if (sortAscending) {
      setState(() {
        ordersDetailsTableSource
            .sort((a, b) => b["$value"].compareTo(a["$value"]));
      });
    } else {
      setState(() {
        ordersDetailsTableSource
            .sort((a, b) => a["$value"].compareTo(b["$value"]));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TablesProvider tablesProvider = Provider.of<TablesProvider>(context);
    List<DatatableHeader> ordersDetailsTableHeader = [
      DatatableHeader(
          text: "ID",
          value: "id",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "PRICE",
          value: "price",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "QUANTILY",
          value: "quantily",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "COLOR",
          value: "color",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "PRODUCT",
          value: "product_id",
          show: true,
          sortable: true,
          sourceBuilder: (value, row) {
            return Text(tablesProvider.productsTableSource
                .where((element) => element['id'] == value)
                .first['title']);
          },
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Action",
          value: "id",
          show: true,
          sortable: true,
          sourceBuilder: (value, row) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red[700],
                  ),
                  onTap: () async {
                    bool check =
                        await ChapterService().deleteChapter(row['id']);
                    updateDeleteTable(check);
                  },
                ),
                InkWell(
                  child: Icon(
                    Icons.edit,
                    color: Colors.green[700],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: EditChapterPage(
                              idChapter: value,
                              chapter: row,
                              notifyAndRefresh: updateEditTable,
                            ));
                      },
                    );
                  },
                ),
              ],
            );
          },
          textAlign: TextAlign.center),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              constraints: const BoxConstraints(
                maxHeight: 625,
              ),
              child: Card(
                elevation: 1,
                shadowColor: Colors.black,
                clipBehavior: Clip.none,
                child: ResponsiveDatatable(
                  title: !isSearch
                      ? RaisedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: AddChapterPage(
                                      idNovel: widget.id,
                                      notifyAndRefresh: updateAddTable,
                                    ));
                              },
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("ADD ORDER DETAIL"))
                      : null,
                  actions: [
                    if (isSearch)
                      Expanded(
                        child: TextField(
                          controller: inputSearchController,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                setState(
                                  () {
                                    isSearch = false;
                                  },
                                );
                              },
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    if (!isSearch)
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(
                            () {
                              isSearch = true;
                            },
                          );
                        },
                      )
                  ],
                  onSort: (value) => onSort(value),
                  sortAscending: sortAscending,
                  sortColumn: sortColumn,
                  headers: ordersDetailsTableHeader,
                  source: ordersDetailsTableSource,
                  autoHeight: false,
                  onTabRow: (data) {
                    debugPrint(data);
                  },
                  isLoading: isLoading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
