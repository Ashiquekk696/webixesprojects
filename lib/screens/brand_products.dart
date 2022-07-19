import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:webixes/custom/toast_component.dart';
import 'package:webixes/helpers/shared_value_helper.dart';
import 'package:webixes/my_theme.dart';
import 'package:webixes/screens/filter.dart';
import 'package:webixes/ui_elements/product_card.dart';
import 'package:webixes/repositories/product_repository.dart';
import 'package:webixes/helpers/shimmer_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BrandProducts extends StatefulWidget {
  BrandProducts({Key? key, this.id, this.brand_name}) : super(key: key);
  final int? id;
  final String? brand_name;

  @override
  _BrandProductsState createState() => _BrandProductsState();
}

class _BrandProductsState extends State<BrandProducts> {
  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  List<dynamic> _productList = [];
  bool _isInitial = true;
  int _page = 1;
  String _searchKey = "";
  int _totalData = 0;
  bool _showLoadingContainer = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchData();

    _xcrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  fetchData() async {
    var productResponse = await ProductRepository().getBrandProducts(
        id: widget.id ?? 0,
        page: _page,
        name: _searchKey,
        sort_key: _selectedSort);
    _productList.addAll(productResponse.products ?? []);
    _isInitial = false;
    _totalData = productResponse.meta?.total ?? 0;
    _showLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _productList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            buildProductList(),
            Align(
                alignment: Alignment.bottomCenter,
                child: buildLoadingContainer())
          ],
        ));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _productList.length
            ? AppLocalizations.of(context)!.common_no_more_products
            : AppLocalizations.of(context)!.common_loading_more_products),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        elevation: 3.0,
        titleSpacing: 0,
        backgroundColor: Colors.white.withOpacity(0.95),
        automaticallyImplyLeading: false,
        actions: [
          new Container(),
        ],
        centerTitle: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
          child: Column(
            children: [buildTopAppbar(context), buildBottomAppBar(context)],
          ),
        ));
  }

  WhichFilter? _selectedFilter;
  String? _givenSelectedFilterOptionKey;
  List<DropdownMenuItem<WhichFilter>>?
      _dropdownWhichFilterItems; // may be it can come from another page
  var _selectedSort = "";
  Row buildTopAppbar(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Container(
              width: 250,
              child: TextField(
                controller: _searchController,
                onTap: () {},
                onChanged: (txt) {
                  /*_searchKey = txt;
              reset();
              fetchData();*/
                },
                onSubmitted: (txt) {
                  _searchKey = txt;
                  reset();
                  fetchData();
                },
                autofocus: true,
                decoration: InputDecoration(
                    hintText:
                        "${AppLocalizations.of(context)!.brand_products_screen_search_product_of_brand} : " +
                            widget!.brand_name!,
                    hintStyle: TextStyle(
                        fontSize: 14.0, color: MyTheme.textfield_grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                    ),
                    contentPadding: EdgeInsets.all(0.0)),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            child: IconButton(
              icon: Icon(Icons.search, color: MyTheme.dark_grey),
              onPressed: () {
                _searchKey = _searchController.text.toString();
                setState(() {});
                reset();
                fetchData();
              },
            ),
          ),
        ]);
  }

  Row buildBottomAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => Directionality(
                      textDirection: app_language_rtl.$
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: AlertDialog(
                        contentPadding: EdgeInsets.only(
                            top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .filter_screen_sort_products_by,
                                    )),
                                RadioListTile(
                                  dense: true,
                                  value: "",
                                  groupValue: _selectedSort,
                                  activeColor: MyTheme.font_grey,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(AppLocalizations.of(context)!
                                      .filter_screen_default),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSort = "";
                                    });
                                    _onSortChange();
                                    Navigator.pop(context);
                                  },
                                ),
                                RadioListTile(
                                  dense: true,
                                  value: "price_high_to_low",
                                  groupValue: _selectedSort,
                                  activeColor: MyTheme.font_grey,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(AppLocalizations.of(context)!
                                      .filter_screen_price_high_to_low),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSort = "";
                                    });
                                    _onSortChange();
                                    Navigator.pop(context);
                                  },
                                ),
                                RadioListTile(
                                  dense: true,
                                  value: "price_low_to_high",
                                  groupValue: _selectedSort,
                                  activeColor: MyTheme.font_grey,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(AppLocalizations.of(context)!
                                      .filter_screen_price_low_to_high),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSort = "";
                                    });
                                    _onSortChange();
                                    Navigator.pop(context);
                                  },
                                ),
                                RadioListTile(
                                  dense: true,
                                  value: "new_arrival",
                                  groupValue: _selectedSort,
                                  activeColor: MyTheme.font_grey,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(AppLocalizations.of(context)!
                                      .filter_screen_price_new_arrival),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSort = "";
                                    });
                                    _onSortChange();
                                    Navigator.pop(context);
                                  },
                                ),
                                RadioListTile(
                                  dense: true,
                                  value: "popularity",
                                  groupValue: _selectedSort,
                                  activeColor: MyTheme.font_grey,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(AppLocalizations.of(context)!
                                      .filter_screen_popularity),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSort = "";
                                    });
                                    _onSortChange();
                                    Navigator.pop(context);
                                  },
                                ),
                                RadioListTile(
                                  dense: true,
                                  value: "top_rated",
                                  groupValue: _selectedSort,
                                  activeColor: MyTheme.font_grey,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(AppLocalizations.of(context)!
                                      .filter_screen_top_rated),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSort = "";
                                    });
                                    _onSortChange();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                        actions: [
                          FlatButton(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .common_close_in_all_capital,
                              style: TextStyle(color: MyTheme.medium_grey),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    ));
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))),
            height: 16,
            width: MediaQuery.of(context).size.width * .33,
            child: Center(
                child: Container(
              width: 50,
              child: Row(
                children: [
                  Icon(
                    Icons.swap_vert,
                    size: 13,
                  ),
                  SizedBox(width: 2),
                  Text(
                    "Sort",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )),
          ),
        )
      ],
    );
  }

  _onSortChange() {
    reset();
    //resetpList();
    // fetchProductData();
    fetchData();
  }

  buildProductList() {
    if (_isInitial && _productList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _scrollController));
    } else if (_productList.length > 0) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _xcrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: GridView.builder(
            // 2
            //addAutomaticKeepAlives: true,
            itemCount: _productList.length,
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.618),
            padding: EdgeInsets.all(16),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // 3
              return ProductCard(
                id: _productList[index].id,
                image: _productList[index].thumbnail_image,
                name: _productList[index].name,
                main_price: _productList[index].main_price,
                stroked_price: _productList[index].stroked_price,
                has_discount: _productList[index].has_discount,
                wishListButton: false,
              );
            },
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.common_no_data_available));
    } else {
      return Container(); // should never be happening
    }
  }
}
