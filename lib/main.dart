import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'util/applocale.dart';
import 'util/database.dart';
import 'screens/home_wrapper.dart';
import 'screens/landing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: FB().userState,
      child: MaterialApp(
        title: 'Harvest',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'TajawalRegular',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: const Color(0xfff2b705),
            textTheme: const TextTheme(
              headline6: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              bodyText1: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff252e40))),
        supportedLocales: const [
          Locale('ar', ''),
          Locale('en', ''),
        ],
        localizationsDelegates: const [GlobalMaterialLocalizations.delegate, AppLocale.delegate],
        localeResolutionCallback: (currentLocale, supportedLocales) {
          if (currentLocale != null) {
            for (Locale locale in supportedLocales) {
              if (locale.languageCode == currentLocale.languageCode) {
                return currentLocale;
              }
            }
          }
          if (supportedLocales.contains(currentLocale)) {
            return currentLocale;
          } else {
            return supportedLocales.first;
          }
        },
        home: const AppWrapper(),
      ),
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<User?>(context);

    if (userState == null) return const Landing();
    return const HomeWrapper();
  }
}
