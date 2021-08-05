
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:demo_news_app/infrastructure/common/utills/route_constant.dart';
import 'package:demo_news_app/ui/screen/detail_screen/detail_screen.dart';
import 'package:demo_news_app/ui/screen/home_screen/home_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  mainSetup();
}
mainSetup()async{
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: Colors.white,
        brightness: Brightness.light,
        backgroundColor: const Color(0xFFE5E5E5),
        accentColor: Colors.black,
        accentIconTheme: IconThemeData(color: Colors.white),
        dividerColor: Colors.grey,
      ),
      dark: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        backgroundColor: const Color(0xFF212121),
        accentColor: Colors.white,
        accentIconTheme: IconThemeData(color: Colors.black),
        dividerColor: Colors.grey,
      ),
      initial: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'News App',
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: RouteConstant.homeScreenRoute,
        routes: _buildNavigationRoutes(),
      ),
    );
  }

  Map<String, WidgetBuilder> _buildNavigationRoutes() {
    return <String, WidgetBuilder>{
      RouteConstant.homeScreenRoute: (context) => HomePageScreen(),
      RouteConstant.detailScreenRoute: (context) => DetailScreen(data: ModalRoute.of(context)!.settings.arguments as DetailScreenArgument),
    };
  }
}


