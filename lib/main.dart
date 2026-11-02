import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isSupportedPlatform() {
  if (kIsWeb) {
    return false;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return true;
  }
  return false;
}

void main() {
  if (isSupportedPlatform()) {
    runApp(const App());
  } else {
    runApp(const UnsupportedPlatformApp());
  }
}

class UnsupportedPlatformApp extends StatelessWidget {
  const UnsupportedPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'This app saves orders with SQLite and is set up to run on '
              'Android only. Stop the app and run it on an Android emulator '
              'or device instead.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  bool _largeText = false;

  @override
  void initState() {
    super.initState();
    _loadTextSize();
  }

  Future<void> _loadTextSize() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final bool? savedLargeText = await prefs.getBool(prefLargeText);
    if (!mounted) {
      return;
    }
    setState(() {
      _largeText = savedLargeText ?? false;
    });
  }

  void _updateTextSize(bool largeText) {
    setState(() {
      _largeText = largeText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData mediaQuery = MediaQuery.of(context);
        TextScaler textScaler = mediaQuery.textScaler;
        if (_largeText) {
          textScaler = _BiggerTextScaler(textScaler);
        }
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: textScaler),
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: shopBrand,
          primary: shopBrand,
        ),
        scaffoldBackgroundColor: shopBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: shopBrand,
          foregroundColor: shopWhite,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return const MenuScreen();
        },
        '/basket': (BuildContext context) {
          return const BasketScreen();
        },
        '/settings': (BuildContext context) {
          return SettingsScreen(
            largeText: _largeText,
            onLargeTextChanged: _updateTextSize,
          );
        },
        '/orders': (BuildContext context) {
          return const OrdersScreen();
        },
      },
    );
  }
}

class _BiggerTextScaler extends TextScaler {
  const _BiggerTextScaler(this.systemTextScaler);

  final TextScaler systemTextScaler;

  @override
  double scale(double fontSize) {
    return systemTextScaler.scale(fontSize) * 1.2;
  }

  @override
  double get textScaleFactor {
    return scale(14) / 14;
  }
}
