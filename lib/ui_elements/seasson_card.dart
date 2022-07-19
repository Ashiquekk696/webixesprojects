import 'package:webixes/custom/toast_component.dart';
import 'package:webixes/helpers/shared_value_helper.dart';
import 'package:webixes/my_theme.dart';
import 'package:webixes/repositories/wishlist_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webixes/screens/product_details.dart';
import 'package:webixes/app_config.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class SeassonCard extends StatefulWidget {

  int id;
  String image;
  String name;
  String main_price;
  String stroked_price;
  bool has_discount;
  bool wishListButton;

  SeassonCard({Key key,this.id, this.image, this.name, this.main_price,this.stroked_price,this.has_discount,this.wishListButton}) : super(key: key);

  @override
  _SeassonCardState createState() => _SeassonCardState();
}

class _SeassonCardState extends State<SeassonCard> {
// bool _isInWishList=true;
 @override
 void initState() {

   super.initState();
   fetchWishListCheckInfo();
 }
  fetchWishListCheckInfo() async {
    var wishListCheckResponse =
    await WishListRepository().isProductInUserWishList(
      product_id: widget.id,
    );

    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    widget.wishListButton = wishListCheckResponse.is_in_wishlist;
    //setState(() {});
  }

  addToWishList() async {
    var wishListCheckResponse =
    await WishListRepository().add(product_id: widget.id);

    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    widget.wishListButton = wishListCheckResponse.is_in_wishlist;
    setState(() {});
  }

  removeFromWishList() async {
    var wishListCheckResponse =
    await WishListRepository().remove(product_id: widget.id);

    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    widget.wishListButton = wishListCheckResponse.is_in_wishlist;
    setState(() {});
  }

  onWishTap() {
    if (is_logged_in.$ == false) {
      ToastComponent.showDialog(AppLocalizations.of(context).common_login_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (widget.wishListButton) {
      widget.wishListButton = false;
      setState(() {});
      removeFromWishList();
    } else {
      widget.wishListButton = true;
      setState(() {});
      addToWishList();
    }
  }
  @override
  Widget build(BuildContext context) {
    print((MediaQuery.of(context).size.width - 48 ) / 2);
    print("pp card-->${widget.image}");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProductDetails(id: widget.id,);
          }));

        },
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                // width: 100,
                child: Row(
                  children: [
                    Column(
                      children: [
                        widget.image!=null?  Padding(
                          padding: const EdgeInsets.only(top: 8.0,left: 10.0),
                          child: Container(
                              width: 120,
                              //color: Colors.yellow,
                              height: 63,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(0),
                                      bottom: Radius.zero),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder.png',
                                    image: AppConfig.BASE_PATH +widget.image,
                                    fit: BoxFit.cover,
                                  )

                              )),
                        ):Padding(
                          padding: const EdgeInsets.only(top: 8.0,left: 10.0),
                          child: Container(
                              width: 120,
                              //color: Colors.yellow,
                              height: 63,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(0),
                                      bottom: Radius.zero),
                                  child: Image.asset("assets/placeholder.png")

                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                widget.wishListButton
                                    ? InkWell(
                                  onTap: () {
                                    onWishTap();
                                  },
                                  child: Icon(
                                    FontAwesome.heart,
                                    color: Color.fromRGBO(230, 46, 4, 1),
                                    size: 18,
                                  ),
                                )
                                    : InkWell(
                                  onTap: () {
                                    onWishTap();
                                  },
                                  child: Icon(
                                    FontAwesome.heart_o,
                                    color: Color.fromRGBO(230, 46, 4, 1),
                                    size: 18,
                                  ),
                                ),
                                //Icon(CupertinoIcons.suit_heart,color: Colors.pink,),
                                SizedBox(width: 25,),
                               // Icon(CupertinoIcons.refresh_thin,color: Colors.pink,)
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                //width: 160,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Container(
                            width: 140,
                            child: Text(
                              widget.name,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13, color: MyTheme.font_grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: MyTheme.yellow,
                              child: Center(
                                child: Icon(
                                  Icons.add,color: Colors.white,size: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 0, 8, 1),
                              child: Container(
                                // height: 22,
                                child: Text(
                                  widget.main_price,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14, color: MyTheme.yellow),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1,),
                        /*     Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: MyTheme.yellow,
                              child: Center(
                                child: Icon(
                                  Icons.add,color: Colors.white,size: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                              child: Container(
                                // height: 22,
                                child: Text(
                                  '488(22)',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14, color: MyTheme.dark_grey),
                                ),
                              ),
                            ),
                          ],
                        ),*/
                        SizedBox(height: 2,),
                        Container(
                          color: MyTheme.yellow,
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.add_shopping_cart_sharp,color: Colors.white,size: 17,),
                                Text("BUY NOW",style: TextStyle(fontSize:12,color: Colors.white),)
                              ],
                            ),
                          ),
                        )

                      ],
                    )

                  ],
                ),
              )


            ],
          ),
        ),
      ),
    );
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(id: widget.id,);
        }));
      },
      child: Card(
         //clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(width: 89,),
                    Expanded(child:Row(
                      children: [
                        Icon(
                          CupertinoIcons.refresh_thin,
                          color: Colors.pink,size: 18,
                        ),
                        SizedBox(width: 10,),
                        widget.wishListButton
                            ? InkWell(
                          onTap: () {
                            onWishTap();
                          },
                          child: Icon(
                            FontAwesome.heart,
                            color: Color.fromRGBO(230, 46, 4, 1),
                            size: 18,
                          ),
                        )
                            : InkWell(
                          onTap: () {
                            onWishTap();
                          },
                          child: Icon(
                            FontAwesome.heart_o,
                            color: Color.fromRGBO(230, 46, 4, 1),
                            size: 18,
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              ),
              Expanded(
                child:  widget.image!=null?Container(
                    width: double.infinity,
                    //height: 158,
                    height: (( MediaQuery.of(context).size.width - 28 ) / 2) + 2,
                    child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(0), bottom: Radius.zero),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: AppConfig.BASE_PATH + widget.image,
                          fit: BoxFit.contain,
                        ))):
                Container(
                    width: double.infinity,
                    //height: 158,
                    height: (( MediaQuery.of(context).size.width - 28 ) / 2) + 2,
                    child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(0), bottom: Radius.zero),
                        child:Image.asset("assets/placeholder.png")
                    )),
              ), 
              Expanded(
                child: Container(
                  height: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Text(
                          widget.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              height: 1.2,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                        child: Text(
                          widget.main_price,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                     widget.has_discount ? Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Text(
                          widget.stroked_price,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            decoration:TextDecoration.lineThrough,
                              color: MyTheme.medium_grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ):Container(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RatingBar(
                      itemSize: 18.0,
                      ignoreGestures: true,
                      initialRating: 5,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                        full: Icon(FontAwesome.star, color: Colors.amber),
                        empty:
                        Icon(FontAwesome.star, color: Color.fromRGBO(224, 224, 225, 1)),
                      ),
                      itemPadding: EdgeInsets.only(right: 1.0),
                      onRatingUpdate: (rating) {
                        //print(rating);
                      },
                    ),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.teal,
                      child: Icon(
                        Icons.add,color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
