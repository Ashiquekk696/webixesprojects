import 'package:webixes/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:webixes/screens/product_details.dart';
import 'package:webixes/app_config.dart';

class MiniProductCard extends StatefulWidget {
  int? id;
  String? image;
  String? name;
  String? main_price;
  String? stroked_price;
  bool? has_discount;

  MiniProductCard(
      {Key? key,
      this.id,
      this.image,
      this.name,
      this.main_price,
      this.stroked_price,
      this.has_discount})
      : super(key: key);

  @override
  _MiniProductCardState createState() => _MiniProductCardState();
}

class _MiniProductCardState extends State<MiniProductCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(id: widget.id);
        }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.image != null
                  ? Container(
                      width: double.infinity,
                      height: (MediaQuery.of(context).size.width - 36) / 3.5,
                      child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16), bottom: Radius.zero),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: AppConfig.BASE_PATH + (widget.image ?? ""),
                            fit: BoxFit.cover,
                          )))
                  : Container(
                      width: double.infinity,
                      height: (MediaQuery.of(context).size.width - 36) / 3.5,
                      child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16), bottom: Radius.zero),
                          child: Image.asset("assets/placeholder.png"))),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Text(
                  widget.name ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 11,
                      height: 1.2,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  widget.main_price ?? "",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
              (widget.has_discount ?? false)
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Text(
                        widget.stroked_price ?? "",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: MyTheme.accent_color,
                            fontSize: 9,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  : Container(),
            ]),
      ),
    );
  }
}
