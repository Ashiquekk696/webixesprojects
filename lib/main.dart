import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:webixes/helpers/addons_helper.dart';
import 'package:webixes/helpers/auth_helper.dart';
import 'package:webixes/helpers/business_setting_helper.dart';
import 'package:webixes/other_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webixes/my_theme.dart';
import 'package:webixes/screens/splash.dart';
import 'package:shared_value/shared_value.dart';
import 'package:webixes/helpers/shared_value_helper.dart';
import 'dart:async';
import 'app_config.dart';
import 'package:webixes/services/push_notification_service.dart';
import 'package:one_context/one_context.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:webixes/providers/locale_provider.dart';
import 'lang_config.dart';
import 'package:firebase_core/firebase_core.dart';

main() async {
//  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AddonsHelper().setAddonsData();
  BusinessSettingHelper().setBusinessSettingData();
  app_language.load();
  app_mobile_language.load();
  app_language_rtl.load();

  access_token.load().whenComplete(() {
    AuthHelper().fetch_and_set();
  });

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  is_logged_in.load();
  runApp(
    SharedValue.wrapApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //List<FocusNode> focusNodes = <FocusNode>[];

  @override
  void initState() {
    super.initState();

    if (OtherConfig.USE_PUSH_NOTIFICATION) {
      Future.delayed(Duration(milliseconds: 100), () async {
        PushNotificationService().initialise();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
          return MaterialApp(
            builder: OneContext().builder,
            navigatorKey: OneContext().navigator.key,
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
            locale: provider.locale,
            supportedLocales: LangConfig().supportedLocales(),
            home: Splash(),
            //home: Main(),
          );
        }));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  Future<HttpClient> createh(SecurityContext context) async {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
