import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webixes/screens/change_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webixes/screens/common_webview_screen.dart';

import 'package:webixes/screens/main.dart';
import 'package:webixes/screens/profile.dart';
import 'package:webixes/screens/order_list.dart';
import 'package:webixes/screens/wishlist.dart';

import 'package:webixes/screens/login.dart';
import 'package:webixes/screens/messenger_list.dart';
import 'package:webixes/screens/wallet.dart';
import 'package:webixes/helpers/shared_value_helper.dart';
import 'package:webixes/app_config.dart';
import 'package:webixes/helpers/auth_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  onTapLogout(context) async {
    AuthHelper().clearUserData();

    // var logoutResponse = await AuthRepository().getLogoutResponse();
    //
    // if (logoutResponse.result == true) {
    //   ToastComponent.showDialog(logoutResponse.message, context,
    //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //
    //   Navigator.push(context, MaterialPageRoute(builder: (context) {
    //     return Login();
    //   }));
    // }
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection:
            app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                is_logged_in.$ == true
                    ? ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            AppConfig.BASE_PATH + "${avatar_original.$}",
                          ),
                        ),
                        title: Text("${user_name.$}"),
                        subtitle:                 Text(
                          //if user email is not available then check user phone if user phone is not available use empty string
                          "${user_email.$ != "" && user_email.$ != null?
                          user_email.$:user_phone.$ != "" && user_phone.$ != null?user_phone.$:''}",
                        )

                )
                    : Text(
                        AppLocalizations.of(context).main_drawer_not_logged_in,
                        style: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 14)),
                Divider(),
                /*ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/language.png",
                        height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                    title: Text(
                        AppLocalizations.of(context)
                            .main_drawer_change_language,
                        style: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ChangeLanguage();
                      }));
                    }),*/
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/home.png",
                        height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                    title: Text(AppLocalizations.of(context).main_drawer_home,
                        style: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Main();
                      }));
                    }),
                is_logged_in.$ == true
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset("assets/profile.png",
                            height: 16,
                            color: Color.fromRGBO(153, 153, 153, 1)),
                        title: Text(
                            AppLocalizations.of(context).main_drawer_profile,
                            style: TextStyle(
                                color: Color.fromRGBO(153, 153, 153, 1),
                                fontSize: 14)),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Profile(show_back_button: true);
                          }));
                        })
                    : Container(),
                is_logged_in.$ == true
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset("assets/order.png",
                            height: 16,
                            color: Color.fromRGBO(153, 153, 153, 1)),
                        title: Text(
                            AppLocalizations.of(context).main_drawer_orders,
                            style: TextStyle(
                                color: Color.fromRGBO(153, 153, 153, 1),
                                fontSize: 14)),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return OrderList(from_checkout: true);
                          }));
                        })
                    : Container(),
                is_logged_in.$ == true
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset("assets/heart.png",
                            height: 16,
                            color: Color.fromRGBO(153, 153, 153, 1)),
                        title: Text(
                            AppLocalizations.of(context)
                                .main_drawer_my_wishlist,
                            style: TextStyle(
                                color: Color.fromRGBO(153, 153, 153, 1),
                                fontSize: 14)),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Wishlist();
                          }));
                        })
                    : Container(),
                (is_logged_in.$ == true)
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset("assets/chat.png",
                            height: 16,
                            color: Color.fromRGBO(153, 153, 153, 1)),
                        title: Text(
                            AppLocalizations.of(context).main_drawer_messages,
                            style: TextStyle(
                                color: Color.fromRGBO(153, 153, 153, 1),
                                fontSize: 14)),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MessengerList();
                          }));
                        })
                    : Container(),
                is_logged_in.$ == true
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset("assets/wallet.png",
                            height: 16,
                            color: Color.fromRGBO(153, 153, 153, 1)),
                        title: Text(
                            AppLocalizations.of(context).main_drawer_wallet,
                            style: TextStyle(
                                color: Color.fromRGBO(153, 153, 153, 1),
                                fontSize: 14)),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Wallet();
                          }));
                        })
                    : Container(),
                ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(Icons.person_outline,
                        size: 16,
                        color: Color.fromRGBO(153, 153, 153, 1)),
                    title: Text(
                        "Vendor Registration",
                        style: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 14)),
                    onTap: ()async {
                      final url = "https://play.google.com/store/apps/details?id=com.city.deal";

                      if ( await canLaunch(url) != null) {
                      await launch(url);
                      } else {
                      throw 'Could not launch $url';
                      }
                    }),
                ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(Icons.lock_open_outlined,
                        size: 16,
                        color: Color.fromRGBO(153, 153, 153, 1)),
                    title: Text(
                        "Privacy Policy",
                        style: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return CommonWebviewScreen(
                              url: "https://citydeal.co.in/privacypolicy",
                              page_name: AppLocalizations.of(context).main_drawer_home,
                            );
                          }));
                    }),
                ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(Icons.share_outlined,
                        size: 16,
                        color: Color.fromRGBO(153, 153, 153, 1)),
                    title: Text(
                        "Share App",
                        style: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 14)),
                    onTap: () {
                      Share.share("https://play.google.com/store/apps/details?id=com.city.deals");
                    }),
                ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(Icons.rate_review_outlined,
                        size: 16,
                        color: Color.fromRGBO(153, 153, 153, 1)),
                    title: Text(
                        "Review App",
                        style: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 14)),
                    onTap: () async{
                      final url = 'https://play.google.com/store/apps/details?id=com.city.deals';
                      if ( await canLaunch(url) != null) {
                      await launch(url);
                      } else {
                      throw 'Could not launch $url';
                      }
                    }),
                ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(Icons.star_border_outlined,
                        size: 16,
                        color: Color.fromRGBO(153, 153, 153, 1)),
                    title: Text(
                        "Rate App",
                        style: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 14)),
                    onTap: () async{

                      final url = 'https://play.google.com/store/apps/details?id=com.city.deals';
                      if ( await canLaunch(url) != null) {
                      await launch(url);
                      } else {
                      throw 'Could not launch $url';
                      }
                    }),
                //Divider(height: 0),
                is_logged_in.$ == false
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset("assets/login.png",
                            height: 16,
                            color: Color.fromRGBO(153, 153, 153, 1)),
                        title: Text(
                            AppLocalizations.of(context).main_drawer_login,
                            style: TextStyle(
                                color: Color.fromRGBO(153, 153, 153, 1),
                                fontSize: 14)),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Login();
                          }));
                        })
                    : Container(),
                is_logged_in.$ == true
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset("assets/logout.png",
                            height: 16,
                            color: Color.fromRGBO(153, 153, 153, 1)),
                        title: Text(
                            AppLocalizations.of(context).main_drawer_logout,
                            style: TextStyle(
                                color: Color.fromRGBO(153, 153, 153, 1),
                                fontSize: 14)),
                        onTap: () {
                          onTapLogout(context);
                        })
                    : Container(),
                Container(height: 60,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

