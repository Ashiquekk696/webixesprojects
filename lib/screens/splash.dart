import 'dart:ui';

import 'package:webixes/app_config.dart';
import 'package:webixes/my_theme.dart';
import 'package:webixes/repositories/category_repository.dart';
import 'package:webixes/screens/login.dart';
import 'package:webixes/screens/main.dart';
import 'package:webixes/ui_elements/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:webixes/helpers/shared_value_helper.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  PackageInfo _packageInfo = PackageInfo(
    appName: AppConfig.app_name,
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
    _initPackageInfo();
    startTime();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<Widget> loadFromFuture() async {
    // <fetch data from server. ex. login>

    return Future.value(Main());
  }

  Future fetchCategories() async {
    print("Initial calling--splash");
    AppConfig.featuredCategoryList = [];
    var categoryResponse = await CategoryRepository().getTopCategories();
    AppConfig.featuredCategoryList.addAll(categoryResponse.categories ?? []);
    print("API CALL-->${AppConfig.featuredCategoryList.length}");
    return categoryResponse.categories;
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    if (is_logged_in.$ == true) {
      //final response = await weatherRepo.postLogin(event._mobile, event._password);
      final categoryResponse = await CategoryRepository().getTopCategories();
      AppConfig.featuredCategoryList.addAll(categoryResponse.categories ?? []);
      print("API CALL-->${AppConfig.featuredCategoryList.length}");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Main(),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Login(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("assets/splash.jpeg"),
        ),
      ),
    ));
    // return CustomSplashScreen(
    //comment this
    //seconds: 5,

    //comment this
    //navigateAfterSeconds:navigate(),

    //navigateAfterFuture: navigate(), //uncomment this

    //   useLoader: false,

    //  // image: Image.asset("citydeal/img/core-img/logo-small.png"),
    //  //// backgroundImage: Image.asset("citydeal/img/core-img/logo-small.png"),
    //   backgroundColor: MyTheme.soft_accent_color,
    // ////  photoSize: 70.0,
    //   //backgroundPhotoSize: 120.0,
    // );
  }

  navigate() {
    // is_logged_in.load();

    fetchCategories().then((value) {
      if (is_logged_in.$ == true) {
        return Main();
      } else {
        return Login();
      }
    });
  }
}

class CustomSplashScreen extends StatefulWidget {
  /// Seconds to navigate after for time based navigation
  final int? seconds;

  /// App title, shown in the middle of screen in case of no image available
  final Text? title;

  /// Page background color
  final Color? backgroundColor;

  /// Style for the laodertext
  final TextStyle? styleTextUnderTheLoader;

  /// The page where you want to navigate if you have chosen time based navigation
  final dynamic? navigateAfterSeconds;

  /// Main image size
  final double? photoSize;

  final double? backgroundPhotoSize;

  /// Triggered if the user clicks the screen
  final dynamic? onClick;

  /// Loader color
  final Color? loaderColor;

  /// Main image mainly used for logos and like that
  final Image? image;

  final Image? backgroundImage;

  /// Loading text, default: "Loading"
  final Text? loadingText;

  ///  Background image for the entire screen
  final ImageProvider? imageBackground;

  /// Background gradient for the entire screen
  final Gradient? gradientBackground;

  /// Whether to display a loader or not
  final bool? useLoader;

  /// Custom page route if you have a custom transition you want to play
  final Route? pageRoute;

  /// RouteSettings name for pushing a route with custom name (if left out in MaterialApp route names) to navigator stack (Contribution by Ramis Mustafa)
  final String? routeName;

  /// expects a function that returns a future, when this future is returned it will navigate
  final Future<dynamic>? navigateAfterFuture;

  /// Use one of the provided factory constructors instead of.
  @protected
  CustomSplashScreen({
    this.loaderColor,
    this.navigateAfterFuture,
    this.seconds,
    this.photoSize,
    this.backgroundPhotoSize,
    this.pageRoute,
    this.onClick,
    this.navigateAfterSeconds,
    this.title = const Text(''),
    this.backgroundColor = Colors.white,
    this.styleTextUnderTheLoader = const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
    this.image,
    this.backgroundImage,
    this.loadingText = const Text(""),
    this.imageBackground,
    this.gradientBackground,
    this.useLoader = true,
    this.routeName,
  });

  factory CustomSplashScreen.timer(
          { //int seconds,
          Color? loaderColor,
          Color? backgroundColor,
          double? photoSize,
          Text? loadingText,
          Image? image,
          Route? pageRoute,
          dynamic? onClick,
          // dynamic navigateAfterSeconds,
          Text? title,
          TextStyle? styleTextUnderTheLoader,
          ImageProvider? imageBackground,
          Gradient? gradientBackground,
          bool? useLoader,
          String? routeName}) =>
      CustomSplashScreen(
        loaderColor: loaderColor ?? Colors.black,
        // seconds: seconds,
        photoSize: photoSize ?? 0,
        loadingText: loadingText!,
        backgroundColor: backgroundColor ?? Colors.black,
        image: image ?? Image.asset("name"),
        // pageRoute: pageRoute ,
        onClick: onClick,
        // navigateAfterSeconds: navigateAfterSeconds,
        title: title ?? Text("data"),
        styleTextUnderTheLoader: styleTextUnderTheLoader ?? TextStyle(),
        //      imageBackground: imageBackground,
        //   gradientBackground: gradientBackground,
        useLoader: useLoader ?? false,
        routeName: routeName ?? "",
      );

  factory CustomSplashScreen.network(
          { //@required Future<dynamic> navigateAfterFuture,
          Color? loaderColor,
          Color? backgroundColor,
          double? photoSize,
          double? backgroundPhotoSize,
          Text? loadingText,
          Image? image,
          Route? pageRoute,
          dynamic onClick,
          // dynamic navigateAfterSeconds,
          Text? title,
          TextStyle? styleTextUnderTheLoader,
          ImageProvider? imageBackground,
          Gradient? gradientBackground,
          bool? useLoader,
          String? routeName}) =>
      CustomSplashScreen(
        loaderColor: loaderColor ?? Colors.black,
        // seconds: seconds,
        photoSize: photoSize ?? 0,
        loadingText: loadingText!,
        backgroundColor: backgroundColor ?? Colors.black,
        image: image ?? Image.asset("name"),
        // pageRoute: pageRoute ,
        onClick: onClick,
        // navigateAfterSeconds: navigateAfterSeconds,
        title: title ?? Text("data"),
        styleTextUnderTheLoader: styleTextUnderTheLoader ?? TextStyle(),
        //      imageBackground: imageBackground,
        //   gradientBackground: gradientBackground,
        useLoader: useLoader ?? false,
        routeName: routeName ?? "",
      );

  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.routeName != null &&
        widget.routeName is String &&
        "${widget.routeName?[0]}" != "/") {
      throw ArgumentError(
          "widget.routeName must be a String beginning with forward slash (/)");
    }
    /* if (widget.navigateAfterFuture == null) {
      Timer(Duration(seconds: widget.seconds), () {
        if (widget.navigateAfterSeconds is String) {
          // It's fairly safe to assume this is using the in-built material
          // named route component
          Navigator.of(context)
              .pushReplacementNamed(widget.navigateAfterSeconds);
        } else if (widget.navigateAfterSeconds is Widget) {
          Navigator.of(context).pushReplacement(widget.pageRoute != null
              ? widget.pageRoute
              : MaterialPageRoute(
                  settings: widget.routeName != null
                      ? RouteSettings(name: "${widget.routeName}")
                      : null,
                  builder: (BuildContext context) =>
                      widget.navigateAfterSeconds));
        } else {
          throw ArgumentError(
              'widget.navigateAfterSeconds must either be a String or Widget');
        }
      });
    } else {
      widget.navigateAfterFuture.then((navigateTo) {
        if (navigateTo is String) {
          // It's fairly safe to assume this is using the in-built material
          // named route component
          Navigator.of(context).pushReplacementNamed(navigateTo);
        } else if (navigateTo is Widget) {
          Navigator.of(context).pushReplacement(widget.pageRoute != null
              ? widget.pageRoute
              : MaterialPageRoute(
                  settings: widget.routeName != null
                      ? RouteSettings(name: "${widget.routeName}")
                      : null,
                  builder: (BuildContext context) => navigateTo));
        } else {
          throw ArgumentError(
              'widget.navigateAfterFuture must either be a String or Widget');
        }
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        //  backgroundColor: MyTheme.soft_accent_color,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //  alignment: Alignment.center,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/splash.jpeg"))),
          /*  child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //vertically align center
                children:<Widget>[
                  Container(
                    margin: EdgeInsets.only(top:40)),
                  Container(
                    child:SizedBox(
                        height:100,width:230,
                        child:widget.backgroundImage
                    ),
                  ),
                ]
            )*/
        ),
        /*bottomNavigationBar: Container(
          height: 100,
          child:Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                        child: CustomButton(
                          onPressed: (){
                            if (is_logged_in.$ == true) {
                              fetchFeaturedCategories().then((value) {
                                if(value!=null){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return Main();
                                      }));
                                }
                              });

                            }else{
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return Login();
                                  }));
                            }

                          },
                          title: 'Get Started',
                          bgColor:  MyTheme.yellow,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),*/
      ),
    );
  }
}
