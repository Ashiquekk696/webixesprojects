import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';
import 'package:webixes/app_config.dart';
import 'package:webixes/lang_config.dart';
import 'package:webixes/my_theme.dart';
import 'package:webixes/repositories/category_repository.dart';
import 'package:webixes/repositories/profile_repository.dart';
import 'package:webixes/screens/cart.dart';
import 'package:webixes/screens/category_list.dart';
import 'package:webixes/screens/home.dart';
import 'package:webixes/screens/profile.dart';
import 'package:webixes/screens/filter.dart';
import 'package:webixes/screens/qrcode_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:webixes/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'notification.dart';

class Main extends StatefulWidget {
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();
  Main({Key key, go_back = true})
      : super(key: key);

  bool go_back;


  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  List<FocusNode> focusNodes = <FocusNode>[];
  int _currentIndex = 0;
  int _cartCounter = 0;
  String _cartCounterString = "...";
  var _children = [
    Home(focusNodes: AppConfig.focusNodes,),

    Cart(has_bottomnav: true),
    Container(),
    NotificationPage(),
    Profile()
  ];
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();
  void onTapped(int i) {
    setState(() {
      _currentIndex = i;
      fetchCounters();
    });
  }

  void initState() {
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
    AppConfig.focusNodes = List<FocusNode>.generate(
      7,
          (int i) => FocusNode(debugLabel: i.toString()),
      growable: false,
    );

    fetchCounters();
   // fetchFeaturedCategories();


  }
  fetchCounters() async {
    var profileCountersResponse =
    await ProfileRepository().getProfileCountersResponse();

    _cartCounter = profileCountersResponse.cart_item_count;
    print("_cartCounter-->$_cartCounter");


    //_cartCounterString = counterText(_cartCounter.toString(), default_length: 2);


    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    //fetchCounters();
    return MaterialApp(
      title: AppConfig.app_name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyTheme.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: MyTheme.accent_color,
        /*textTheme: TextTheme(
              bodyText1: TextStyle(),
              bodyText2: TextStyle(fontSize: 12.0),
            )*/
        //
        // the below code is getting fonts from http
        textTheme: GoogleFonts.sourceSansProTextTheme(textTheme).copyWith(
          bodyText1:
          GoogleFonts.sourceSansPro(textStyle: textTheme.bodyText1),
          bodyText2: GoogleFonts.sourceSansPro(
              textStyle: textTheme.bodyText2, fontSize: 12),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      //locale: provider.locale,
      supportedLocales: LangConfig().supportedLocales(),
      home: Onboarding(
        key: widget.onboardingKey,
        steps: <OnboardingStep>[

          OnboardingStep(
            focusNode: AppConfig.focusNodes[0],
            titleText: 'Welcome!!',
            bodyText: 'Tap to continue',
            shape: const CircleBorder(),
            fullscreen: true,
            overlayColor: Colors.blue.withOpacity(0.5),
            overlayShape: const CircleBorder(),
            hasLabelBox: false,

          ),
          OnboardingStep(
            fullscreen: false,
            focusNode: AppConfig.focusNodes[1],
            titleText: 'All Category',
            bodyText: 'You can view all category  from here',
            overlayColor: Colors.blue.withOpacity(0.8),
            shape: const CircleBorder(),
            overlayBehavior: HitTestBehavior.translucent,
            onTapCallback:
                (TapArea area, VoidCallback next, VoidCallback close) {
              if (area == TapArea.hole) {
                next();
              }
            },
          ),
          OnboardingStep(
            fullscreen: false,
            focusNode: AppConfig.focusNodes[2],
            titleText: 'Search by shop',
            bodyText: 'You can view all shops  from here',
            overlayColor: Colors.blue.withOpacity(0.8),
            shape: const CircleBorder(),
            overlayBehavior: HitTestBehavior.translucent,
            onTapCallback:
                (TapArea area, VoidCallback next, VoidCallback close) {
              if (area == TapArea.hole) {
                next();
              }
            },
          ),
          OnboardingStep(
            fullscreen: false,
            focusNode: AppConfig.focusNodes[3],
            titleText: 'Menu',
            bodyText: 'You can view all menus  from here',
            overlayColor: Colors.blue.withOpacity(0.8),
            shape: const CircleBorder(),
            overlayBehavior: HitTestBehavior.translucent,
            onTapCallback:
                (TapArea area, VoidCallback next, VoidCallback close) {
              if (area == TapArea.hole) {
                next();
              }
            },
          ),
        ],
        onChanged: (int index) {
           if (index == 3) {
            // close the drawer
            // if (s.currentState?.isDrawerOpen ?? false) {
            //   scaffoldKey.currentState?.openEndDrawer();
            // }
            // interrupt onboarding on specific step
            widget.onboardingKey.currentState.hide();
          }
          final int currentIndex =
              widget.onboardingKey.currentState?.controller.currentIndex;

          print('currentIndex $currentIndex');
        },
        child: WillPopScope(
          onWillPop: () async {
            return widget.go_back;
          },
          child: Directionality(
            textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
                  extendBody: true,
                  body: _children[_currentIndex],
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  //specify the location of the FAB
                  floatingActionButton: Visibility(
                    visible: MediaQuery.of(context).viewInsets.bottom ==
                        0.0, // if the kyeboard is open then hide, else show
                    child: FloatingActionButton(
                      backgroundColor: MyTheme.yellow,
                      onPressed: () {},
                      tooltip: "start FAB",
                      child: Container(
                          margin: EdgeInsets.all(0.0),
                          child: IconButton(
                              icon: new Icon(Icons.qr_code_outlined),
                              tooltip: 'Action',
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return QRViewExample();
                                }));
                              })),
                      elevation: 0.0,
                    ),
                  ),
                  bottomNavigationBar: BottomAppBar(
                    color: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                      child: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        onTap: onTapped,
                        currentIndex: _currentIndex,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        fixedColor: Theme.of(context).accentColor,
                        unselectedItemColor: Color.fromRGBO(153, 153, 153, 1),
                        items: [
                          BottomNavigationBarItem(
                              icon: Image.asset(
                                "assets/home.png",
                                color: _currentIndex == 0
                                    ? Theme.of(context).accentColor
                                    : Color.fromRGBO(153, 153, 153, 1),
                                height: 20,
                              ),
                              label: AppLocalizations.of(context).main_screen_bottom_navigation_home),
                          /*new BottomNavigationBarItem(
                            label: 'CART',
                            icon: new Stack(

                                children: <Widget>[
                                  Image.asset(
                                    "assets/cart.png",
                                    color: _currentIndex == 2
                                        ? Theme.of(context).accentColor
                                        : Color.fromRGBO(153, 153, 153, 1),
                                    height: 20,
                                  ),
                                  Container(

                                    width: 25,height: 25,// This is your Badge
                                    child: Center(child: Text('41', style: TextStyle(fontSize:12,color: Colors.white))),
                                    //padding: EdgeInsets.all(8),
                                    constraints: BoxConstraints(minHeight: 27, minWidth: 15),
                                    decoration: BoxDecoration( // This controls the shadow
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            color: Colors.black.withAlpha(50))
                                      ],
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.blue,  // This would be color of the Badge
                                    ),
                                  )
                                ]
                            ),
                          ),*/
                          BottomNavigationBarItem(
                            icon: new Stack(
                              children: <Widget>[
                                new Icon(Icons.shopping_cart_outlined,color: _currentIndex == 2
                                    ? Theme.of(context).accentColor
                                    : Color.fromRGBO(153, 153, 153, 1),),
                                new Positioned(
                                  right: 0,
                                  child: new Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: new BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: new Text(
                                      _cartCounter.toString(),
                                      style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            label: 'CART',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(
                              Icons.circle,
                              color: Colors.transparent,
                            ),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                              icon: Icon(
                                Icons.notifications_none,
                                color: _currentIndex == 3
                                    ? Theme.of(context).accentColor
                                    : Color.fromRGBO(153, 153, 153, 1),
                                //height: 20,
                              ),
                              label: "NOTIFICATION"),
                          BottomNavigationBarItem(
                              icon: Image.asset(
                                "assets/profile.png",
                                color: _currentIndex == 4
                                    ? Theme.of(context).accentColor
                                    : Color.fromRGBO(153, 153, 153, 1),
                                height: 20,
                              ),
                              label: AppLocalizations.of(context).main_screen_bottom_navigation_profile),
                        ],
                      ),
                    ),
                  ),
                ),

          ),
        ),
      ),
    );
  }
}
/*Onboarding(
key: onboardingKey,
autoSizeTexts: true,
debugBoundaries: true,
steps: <OnboardingStep>[
OnboardingStep(
focusNode: AppConfig.focusNodes[1],
titleText: 'left fab',
bodyText: 'Tap to continue',
shape: const CircleBorder(),
fullscreen: false,
overlayColor: Colors.blue.withOpacity(0.9),
overlayShape: const CircleBorder(),
hasLabelBox: true,
labelBoxDecoration: BoxDecoration(
shape: BoxShape.rectangle,
borderRadius: const BorderRadius.all(Radius.circular(8.0)),
color: const Color(0xFF1100FF),
border: Border.all(
color: const Color(0xFFE2FB05),
width: 1.0,
style: BorderStyle.solid,
),
),
),
OnboardingStep(
focusNode: AppConfig.focusNodes[2],
titleText: 'left fab',
bodyText: 'Tap to continue',
shape: const CircleBorder(),
fullscreen: false,
overlayColor: Colors.blue.withOpacity(0.9),
overlayShape: const CircleBorder(),
hasLabelBox: true,
labelBoxDecoration: BoxDecoration(
shape: BoxShape.rectangle,
borderRadius: const BorderRadius.all(Radius.circular(8.0)),
color: const Color(0xFF1100FF),
border: Border.all(
color: const Color(0xFFE2FB05),
width: 1.0,
style: BorderStyle.solid,
),
),
),
],*/
