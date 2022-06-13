//@dart=2.11
import 'package:ai_score/constants/color_constants.dart';
import 'package:ai_score/constants/dimensions_constants.dart';
import 'package:ai_score/constants/route_constants.dart';
import 'package:ai_score/helper/shared_pref.dart';
import 'package:ai_score/locator.dart';
import 'package:ai_score/service/api.dart';
import 'package:ai_score/widgets/camera.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ai_score/router.dart' as router;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SharedPref.prefs = await SharedPreferences.getInstance();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(EasyLocalization(
      supportedLocales: const [
        Locale('en'),
      ],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      child: MyApp(),
    ));
  });
  setupLocator();


}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(DimensionsConstants.mockupWidth.toDouble(),
          DimensionsConstants.mockupHeight.toDouble()),
      builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AiScore',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: EasyLocalization.of(context).supportedLocales,
          locale: EasyLocalization.of(context).locale,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: ColorConstants.primaryColor, // Your accent color
            ),
            primarySwatch: color,
          ),
          onGenerateRoute: router.Router.generateRoute,
          initialRoute: SharedPref.prefs.getBool(SharedPref.isUserLogin) == null ||
              SharedPref.prefs.getBool(SharedPref.isUserLogin) ==
                  false ? RoutesConstants.login : RoutesConstants.home),
    );
  }

  MaterialColor color = MaterialColor(0xFF00B9A7, <int, Color>{
    50: ColorConstants.primaryColor,
    100: ColorConstants.primaryColor,
    200: ColorConstants.primaryColor,
    300: ColorConstants.primaryColor,
    400: ColorConstants.primaryColor,
    500: ColorConstants.primaryColor,
    600: ColorConstants.primaryColor,
    700: ColorConstants.primaryColor,
    800: ColorConstants.primaryColor,
    900: ColorConstants.primaryColor,
  });
}
