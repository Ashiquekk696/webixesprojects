import 'dart:convert';

import 'package:share_plus/share_plus.dart';
import 'package:webixes/helpers/dynamic_link_class.dart';
import 'package:webixes/helpers/dynamic_link_class.dart';
import 'package:webixes/repositories/brand_repository.dart';
import 'package:webixes/repositories/category_repository.dart';
import 'package:webixes/screens/seller_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webixes/my_theme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:webixes/ui_elements/product_card.dart';
import 'package:webixes/ui_elements/list_product_card.dart';
import 'package:webixes/ui_elements/mini_product_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:webixes/repositories/shop_repository.dart';
import 'package:webixes/app_config.dart';
import 'package:webixes/helpers/shimmer_helper.dart';
import 'package:webixes/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerDetails extends StatefulWidget {
  int id;

  SellerDetails({Key key, this.id}) : super(key: key);

  @override
  _SellerDetailsState createState() => _SellerDetailsState();
}

class _SellerDetailsState extends State<SellerDetails> {
  ScrollController _mainScrollController = ScrollController();
  ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //init
  int _current_slider = 0;
  List<dynamic> _carouselImageList = [];
  bool _carouselInit = false;
  var _shopDetails = null;
  List<dynamic> _searchNewArrival = [];
  List<dynamic> _newArrivalProducts = [];
  bool _newArrivalProductInit = false;
  List<dynamic> _topProducts = [];
  List<dynamic> _searchTop = [];
  bool _topProductInit = false;
  List<dynamic> _featuredProducts = [];
  List _getShoLike =[];
  List shopLink =[];
  int likeCount;
  List<dynamic> _searchFeatured = [];
  bool _featuredProductInit = false;
  List<dynamic> _filterBrandList = [];
  bool _filteredBrandsCalled = false;
  List<dynamic> _selectedBrands = [];
  dynamic facebookLink,instagram,whatsapp;
  bool likeShop =true;
  List<dynamic> _filterCategoryList =[];
  bool _filteredCategoriesCalled = false;
  List<dynamic> _selectedCategories = [];
  int _selectedCatID=0;
  int _selectedBrandID=0;
  String type="product";

  HelperClass helperClass= new HelperClass();
  @override
  void initState() {
    fetchAll();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchAll() {
    fetchProductDetails();
    fetchNewArrivalProducts();
    fetchTopProducts();
    fetchFeaturedProducts();
    fetchFilteredBrands();
    fetchFilteredCategories();
  }
  fetchFilteredBrands() async {
    var filteredBrandResponse = await BrandRepository().getFilterSellerBrands(id: widget.id);
    _filterBrandList.addAll(filteredBrandResponse.brands);
    _filteredBrandsCalled = true;
    setState(() {});
  }
  fetchFilteredCategories() async {
    var filteredCategoriesResponse =
    await CategoryRepository().getFilterSellerCategories(id: widget.id);
    _filterCategoryList.addAll(filteredCategoriesResponse.categories);
    _filteredCategoriesCalled = true;
    print(_filterCategoryList);
    setState(() {});
  }
  fetchProductDetails() async {
    var shopDetailsResponse = await ShopRepository().getShopInfo(id: widget.id);

    //print('ss:' + shopDetailsResponse.toString());
    if (shopDetailsResponse.shops.length > 0) {
      _shopDetails = shopDetailsResponse.shops[0];
      var getShopLike = await ShopRepository().getShopLike(id: widget.id);
      var shopLink1= await ShopRepository().getSocialLinks(id: widget.id);

      var decodShopLink=json.decode(shopLink1);
      shopLink.add(decodShopLink);
      print("shopLink00->$shopLink");
       facebookLink=shopLink[0]["shop_links"]["facebook"];
       instagram=shopLink[0]["shop_links"]["instagram"];
       whatsapp=shopLink[0]["shop_links"]["whatsapp"];

      var decodRes=json.decode(getShopLike);
      _getShoLike.add(decodRes);
      likeCount= _getShoLike[0]["shop_likes"];
      print("likeCount-->$likeCount");
      if(likeCount!=null||likeCount!=0){
        likeShop=true;
      }else{
        likeShop=false;
      }

     // print("_getShoLike-->${_getShoLike[0]["shop_likes"]}");

    }

    if (_shopDetails != null) {
      _shopDetails.sliders.forEach((slider) {
        _carouselImageList.add(slider);
      });
    }
    _carouselInit = true;

    setState(() {});
  }

  fetchNewArrivalProducts() async {
    var newArrivalProductResponse =
        await ShopRepository().getNewFromThisSellerProducts(id: widget.id);
    _newArrivalProducts.addAll(newArrivalProductResponse.products);
    _searchNewArrival.addAll(newArrivalProductResponse.products);
    _newArrivalProductInit = true;

    setState(() {});
  }

  fetchTopProducts() async {
    var topProductResponse =
        await ShopRepository().getTopFromThisSellerProducts(id: widget.id);
    _topProducts.addAll(topProductResponse.products);
    _searchTop.addAll(topProductResponse.products);
    _topProductInit = true;
  }

  fetchFeaturedProducts() async {
    var featuredProductResponse =
        await ShopRepository().getfeaturedFromThisSellerProducts(id: widget.id);
    _featuredProducts.addAll(featuredProductResponse.products);
    _searchFeatured.addAll(featuredProductResponse.products);
    _featuredProductInit = true;
  }

  reset() {
    _shopDetails = null;
    _carouselImageList.clear();
    _carouselInit = false;
    _newArrivalProducts.clear();
    _topProducts.clear();
    _featuredProducts.clear();
    _topProductInit = false;
    _newArrivalProductInit = false;
    _featuredProductInit = false;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }
  _applyProductFilter() {
    reset();
   fetchFeaturedProducts();
   fetchNewArrivalProducts();
   fetchNewArrivalProducts();
  }
  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: buildFilterDrawer(),
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          bottomNavigationBar: buildBottomAppBar(context),
          body: RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onPageRefresh,
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        16.0,
                        0.0,
                      ),
                      child: buildCarouselSlider(context),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16.0,
                            16.0,
                            16.0,
                            0.0,
                          ),
                          child: Text(
                            AppLocalizations.of(context)
                                .seller_details_screen_new_arrivals,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            _scaffoldKey.currentState.openEndDrawer();
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16.0,
                              16.0,
                              16.0,
                              0.0,
                            ),
                            child: Text(
                              "filter",
                              style: TextStyle(
                                  color: MyTheme.font_grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        8.0,
                        16.0,
                        0.0,
                        0.0,
                      ),
                      child: buildNewArrivalList(),
                    )
                  ]),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        16.0,
                        0.0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                            .seller_details_screen_no_top_selling_products,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        16.0,
                        0.0,
                      ),
                      child: buildTopSellingProductList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        16.0,
                        0.0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                            .seller_details_screen_featured_products,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          16.0,
                          16.0,
                          0.0,
                        ),
                        child: buildfeaturedProductList())
                  ]),
                )
              ],
            ),
          )),
    );
  }

  buildfeaturedProductList() {
    if (_featuredProductInit == false && _featuredProducts.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _scrollController));
    } else if (_featuredProducts.length > 0) {
      return _searchFeatured.isNotEmpty?GridView.builder(
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: _searchFeatured.length,
        //controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.618),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // 3
          return ProductCard(
            id: _searchFeatured[index].id,
            image: _searchFeatured[index].thumbnail_image.replaceAll(",",""),
            name: _searchFeatured[index].name,
            main_price: _searchFeatured[index].main_price,
            stroked_price: _searchFeatured[index].stroked_price,
            has_discount: _searchFeatured[index].has_discount,
            wishListButton: false,
          );
        },
      ):
        GridView.builder(
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: _featuredProducts.length,
        //controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.618),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // 3
          return ProductCard(
              id: _featuredProducts[index].id,
              image: _featuredProducts[index].thumbnail_image.replaceAll(",",""),
              name: _featuredProducts[index].name,
              main_price: _featuredProducts[index].main_price,
              stroked_price: _featuredProducts[index].stroked_price,
              has_discount: _featuredProducts[index].has_discount,
              wishListButton: false,
          );
        },
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                  AppLocalizations.of(context)
                      .seller_details_screen_no_featured_porducts,
                  style: TextStyle(color: MyTheme.font_grey))));
    }
  }

  buildCarouselSlider(context) {
    if (_shopDetails == null) {
      return ShimmerHelper().buildBasicShimmer(
        height: 190.0,
      );
    } else if (_carouselImageList.length > 0) {
      return CarouselSlider(
        options: CarouselOptions(
            aspectRatio: 2.1,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInCubic,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _current_slider = index;
              });
            }),
        items: _carouselImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Stack(
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder_rectangle.png',
                            image: AppConfig.BASE_PATH + i,
                            fit: BoxFit.fill,
                          ))),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _carouselImageList.map((url) {
                        int index = _carouselImageList.indexOf(url);
                        return Container(
                          width: 7.0,
                          height: 7.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current_slider == index
                                ? MyTheme.white
                                : Color.fromRGBO(112, 112, 112, .3),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          );
        }).toList(),
      );
    } else {
      return Container();
    }
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _shopDetails != null
                ? buildShowProductsButton(context)
                : Container()
          ],
        ),
      ),
    );
  }

  buildShowProductsButton(BuildContext context) {
    return FlatButton(
      minWidth: MediaQuery.of(context).size.width,
      height: 50,
      color: MyTheme.accent_color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Text(
        AppLocalizations.of(context)
            .seller_details_screen_btn_view_all_products,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SellerProducts(
            id: _shopDetails.id,
            shop_name: _shopDetails.name,
          );
        }));
      },
    );
  }

  buildTopSellingProductList() {
    if (_topProductInit == false && _topProducts.length == 0) {
      return Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 75.0,
              )),
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 75.0,
              )),
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 75.0,
              )),
        ],
      );
    } else if (_topProducts.length > 0) {
      return _searchTop.isNotEmpty?SingleChildScrollView(
        child: ListView.builder(
          itemCount: _searchTop.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: ListProductCard(
                  id: _searchTop[index].id,
                  image:_searchTop[index].thumbnail_image!=null? _searchTop[index].thumbnail_image.replaceAll(",",""):null,
                  name: _searchTop[index].name,
                  main_price: _searchTop[index].main_price,
                  stroked_price: _searchTop[index].stroked_price,
                  has_discount: _searchTop[index].has_discount),
            );
          },
        ),
      ):
       SingleChildScrollView(
        child: ListView.builder(
          itemCount: _topProducts.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: ListProductCard(
                  id: _topProducts[index].id,
                  image:_topProducts[index].thumbnail_image!=null? _topProducts[index].thumbnail_image.replaceAll(",",""):null,
                  name: _topProducts[index].name,
                  main_price: _topProducts[index].main_price,
                  stroked_price: _topProducts[index].stroked_price,
                  has_discount: _topProducts[index].has_discount),
            );
          },
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                  AppLocalizations.of(context)
                      .seller_details_screen_no_top_selling_products,
                  style: TextStyle(color: MyTheme.font_grey))));
    }
  }

  buildNewArrivalList() {
    if (_newArrivalProductInit == false && _newArrivalProducts.length == 0) {
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
        ],
      );
    } else if (_newArrivalProducts.length > 0) {
      return _searchNewArrival.isNotEmpty?SingleChildScrollView(
        child: SizedBox(
          height: 175,
          child: ListView.builder(
            itemCount: _searchNewArrival.length,
            scrollDirection: Axis.horizontal,
            itemExtent: 120,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: MiniProductCard(
                  id: _searchNewArrival[index].id,
                  image: _searchNewArrival[index].thumbnail_image!=null?_searchNewArrival[index].thumbnail_image.replaceAll(",",""):null,
                  name: _searchNewArrival[index].name,
                  main_price: _searchNewArrival[index].main_price,
                  stroked_price: _searchNewArrival[index].stroked_price,
                  has_discount: _searchNewArrival[index].has_discount,
                ),
              );
            },
          ),
        ),
      ):
       SingleChildScrollView(
        child: SizedBox(
          height: 175,
          child: ListView.builder(
            itemCount: _newArrivalProducts.length,
            scrollDirection: Axis.horizontal,
            itemExtent: 120,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: MiniProductCard(
                  id: _newArrivalProducts[index].id,
                  image: _newArrivalProducts[index].thumbnail_image!=null?_newArrivalProducts[index].thumbnail_image.replaceAll(",",""):null,
                  name: _newArrivalProducts[index].name,
                  main_price: _newArrivalProducts[index].main_price,
                  stroked_price: _newArrivalProducts[index].stroked_price,
                  has_discount: _newArrivalProducts[index].has_discount,
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).seller_details_screen_no_new_arrival,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return PreferredSize(
        child:Column(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 140,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              title: Container(
                color: Colors.white,
               // height: 100,
                child: Container(
                    width: 370,
                    //color: Colors.blue,
                    child: _shopDetails != null
                        ? buildAppbarShopDetails()
                        : Row(
                      children: [
                        ShimmerHelper()
                            .buildBasicShimmer(height: 60.0, width: 60.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerHelper()
                                  .buildBasicShimmer(height: 25.0, width: 150.0),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ShimmerHelper().buildBasicShimmer(
                                    height: 20.0, width: 100.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
              elevation: 0.0,
              titleSpacing: 0,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                  child: IconButton(
                    icon: Icon(Icons.location_on, color: MyTheme.dark_grey),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => Directionality(
                            textDirection: app_language_rtl.$
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: AlertDialog(
                              contentPadding: EdgeInsets.only(
                                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
                              content: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  _shopDetails.address,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: MyTheme.font_grey, fontSize: 14),
                                ),
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .common_close_in_all_capital,
                                    style: TextStyle(color: MyTheme.medium_grey),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                ),
                                TextButton(
                                    onPressed: () async{
                                      Navigator.of(context, rootNavigator: true).pop();
                                      final url = 'https://www.google.com/maps/search/${Uri.encodeFull( _shopDetails.address)}';
                                      if (await canLaunch(url) != null) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Text("Open Map")),
                              ],
                            ),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),

        preferredSize: Size.fromHeight(140));
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 75,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      title: Container(
        child: Container(
            width: 350,
            child: _shopDetails != null
                ? buildAppbarShopDetails()
                : Row(
                    children: [
                      ShimmerHelper()
                          .buildBasicShimmer(height: 60.0, width: 60.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerHelper()
                                .buildBasicShimmer(height: 25.0, width: 150.0),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ShimmerHelper().buildBasicShimmer(
                                  height: 20.0, width: 100.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: IconButton(
            icon: Icon(Icons.location_on, color: MyTheme.dark_grey),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => Directionality(
                        textDirection: app_language_rtl.$
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: AlertDialog(
                          contentPadding: EdgeInsets.only(
                              top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
                          content: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Text(
                              _shopDetails.address,
                              maxLines: 3,
                              style: TextStyle(
                                  color: MyTheme.font_grey, fontSize: 14),
                            ),
                          ),
                          actions: [
                            FlatButton(
                              child: Text(
                                AppLocalizations.of(context)
                                    .common_close_in_all_capital,
                                style: TextStyle(color: MyTheme.medium_grey),
                              ),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                            TextButton(
                                onPressed: () async{
                                  Navigator.of(context, rootNavigator: true).pop();
                              final url = 'https://www.google.com/maps/search/${Uri.encodeFull( _shopDetails.address)}';
                              if (await canLaunch(url) != null) {
                              await launch(url);
                              } else {
                              throw 'Could not launch $url';
                              }
                            },
                                child: Text("Open Map")),
                          ],
                        ),
                      ));
            },
          ),
        ),
      ],
    );
  }
  buildFilterDrawer() {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Drawer(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          AppLocalizations.of(context).filter_screen_categories,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterCategoryList.length == 0
                          ? Container(
                        height: 100,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).common_no_category_is_available,
                            style: TextStyle(color: MyTheme.font_grey),
                          ),
                        ),
                      )
                          : SingleChildScrollView(
                        child: buildFilterCategoryList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          AppLocalizations.of(context).filter_screen_brands,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),


                      _filterBrandList.length == 0
                          ? Container(
                        height: 100,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).common_no_brand_is_available,
                            style: TextStyle(color: MyTheme.font_grey),
                          ),
                        ),
                      )
                          : SingleChildScrollView(
                        child: buildFilterBrandsList(),
                      ),
                    ]),
                  )
                ]),
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      color: Color.fromRGBO(234, 67, 53, 1),
                      shape: RoundedRectangleBorder(
                        side:
                        new BorderSide(color: MyTheme.light_grey, width: 2.0),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        AppLocalizations.of(context).common_clear_in_all_capital,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedBrands.clear();
                          _selectedCategories.clear();
                          _selectedBrandID=0;
                          _selectedCatID=0;
                          Navigator.of(context);
                        });
                      },
                    ),
                    FlatButton(
                      color: Color.fromRGBO(52, 168, 83, 1),
                      child: Text(
                        "APPLY",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                         // _applyProductFilter();
                          type="filter";
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return SellerProducts(
                            id: _shopDetails.id,
                            shop_name: _shopDetails.name,
                            catID:  _selectedCatID,
                            brandID: _selectedBrandID,
                            type:type
                          );
                        }));
                          },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  ListView buildFilterCategoryList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterCategoryList
            .map(
              (category) => CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            title: Text(category.name),
            value: _selectedCategories.contains(category.id),
            onChanged: (bool value) {
              if (value) {
                setState(() {
                  _selectedCategories.clear();
                  _selectedCategories.add(category.id);
                  print("_selectedCategories-->$_selectedCategories");
                  _selectedCatID=category.id;
                  print("_selectedCatID-->$_selectedCatID");


                });
              } else {
                setState(() {
                  _selectedCategories.remove(category.id);
                  _selectedCatID=0;
                });
              }
            },
          ),
        )
            .toList()
      ],
    );
  }
  ListView buildFilterBrandsList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterBrandList
            .map(
              (brand) => CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            title: Text(brand.name),
            value: _selectedBrands.contains(brand.id),
            onChanged: (bool value) {
              if (value) {
                setState(() {
                  _selectedBrands.add(brand.id);
                  _selectedBrandID=brand.id;
                });
              } else {
                setState(() {
                  _selectedBrands.remove(brand.id);
                  _selectedBrandID=0;
                });
              }
            },
          ),
        )
            .toList()
      ],
    );
  }
  buildAppbarShopDetails() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
        child: Container(
         // width: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shopDetails.logo!=null ?Container(
                width: 150,
                height: 70,
                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color.fromRGBO(112, 112, 112, .3), width: .5),
                  //shape: BoxShape.rectangle,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: AppConfig.BASE_PATH + _shopDetails.logo.replaceAll(",",""),
                      fit: BoxFit.cover,
                    )),
              ):Container(
                width: 150,
                height: 70,
                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color.fromRGBO(112, 112, 112, .3), width: .5),
                  //shape: BoxShape.rectangle,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child:Image.asset(
                     'assets/placeholder.png',
                      //image: AppConfig.BASE_PATH + _shopDetails.logo.replaceAll(",",""),
                      fit: BoxFit.contain,
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Text(
                  _shopDetails.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 4, 0, 0),
                child:SingleChildScrollView(
                  child: Row(
                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildRatingWithCountRow(),

                      if( whatsapp!=null)
                        Wrap(
                          children: [
                            InkWell(
                              onTap: ()async{
                               // final url = 'https://wa.me/$whatsapp/?text=${Uri.parse("message")}';
                                final url = 'https://wa.me/$whatsapp/';
                                if (await canLaunch(whatsapp) != null) {
                                  await launch(whatsapp);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Container(
                                  height: 20,width: 20,
                                  child: Image.asset("assets/whatsapp.png")),
                            ),
                          ],
                        ),
                     SizedBox(width: 5,),
                     if( whatsapp!=null)
                       Wrap(
                         children: [
                           InkWell(
                             onTap: (){
                               launch("tel://$whatsapp");
                             },
                             child: Container(
                                 height: 25,width: 20,
                                 child: Image.asset("assets/call.png")),
                           ),
                         ],
                       ),
                      SizedBox(width: 5,),
                      if (facebookLink!=null)
                      Wrap(
                        children: [
                          InkWell(
                            onTap: () async{
                              //final url = 'https://wa.me/9604609321/?text=${Uri.parse("message")}';
                              if (await canLaunch(facebookLink) != null) {
                              await launch(facebookLink);
                              } else {
                              throw 'Could not launch $facebookLink';
                              }
                            },
                            child: Container(
                              color: Colors.white,
                              height: 20,width: 20,
                              child: Image.asset(
                                  "assets/facebook_logo.png"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 5,),
                     if( instagram!=null)
                       Wrap(
                         children: [
                        InkWell(
                            onTap: ()async {
                              if (await canLaunch(instagram) != null) {
                              await launch(instagram);
                              } else {
                              throw 'Could not launch $instagram';
                              }
                            },
                            child: Container(
                              height: 20,width: 20,
                              child:
                              Image.asset("assets/instagram.png"),
                            ),
                        ),
                      ],
                       ),
                      SizedBox(width: 5,),
                      Wrap(
                        children: [
                          InkWell(
                            onTap: ()async{
                              likeShop=!likeShop;
                              print(likeShop);
                              if(likeShop==true){
                                var postLike =await ShopRepository().postLikes(id: widget.id, userId: user_id.$);
                                print("postlike-->$postLike");
                                var decodRes=json.decode(postLike);
                                _getShoLike.add(decodRes);
                                likeCount= _getShoLike[0]["shop_likes"];
                              }

                            },
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                likeShop==true? Container(
                                    height: 20,width: 20,
                                    child: Image.asset("assets/thumb_like.png")):Container(
                                    height: 20,width: 10,
                                    child: Icon(CupertinoIcons.hand_thumbsup,color: Colors.blue,)),
                                SizedBox(width: 5,),
                                likeCount!=null?Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text("("+likeCount.toString()+")",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                                ):Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text("",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                                ),
                                SizedBox(width: 5,),
                                InkWell(
                                    onTap: (){
                                      helperClass.createDynamicLink(widget.id).then((value){
                                        //Sharing the content on other applications
                                        helperClass.shareData(context,
                                            'open seller details $value',
                                            '');
                                      });
                                      },
                                    child:Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Icon(Icons.share,color: Colors.blue,size: 20,),
                                    )
                                ),
                              ],
                            )
                          ),
                        ],
                      ),

                    ],
                  ),
                )
              ),


            ],
          ),
        ),
      ),

    ]
    );
  }

  Row buildRatingWithCountRow() {
    print("rating -->${_shopDetails.rating}");
    return Row(
      children: [
        RatingBar(
          itemSize: 10.0,
          ignoreGestures: true,
          initialRating: double.parse(_shopDetails.rating.toString()),
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: Icon(FontAwesome.star, color: Colors.amber),
            empty:
                Icon(FontAwesome.star, color: Color.fromRGBO(224, 224, 225, 1)),
          ),
          itemPadding: EdgeInsets.only(right: 2.0),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
      ],
    );
  }
}
