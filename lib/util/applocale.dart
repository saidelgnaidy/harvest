import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';



String? lang  ( BuildContext context , String? key  ) {
  return AppLocale.of(context)!.getTranslation(key);
}

String langCode(BuildContext context ){
  return AppLocale.of(context)!.locale!.languageCode ;
}

class AppLocale{
  Locale? locale ;
  AppLocale({this.locale}) ;

  late Map<String , String > _translation ;

  static AppLocale? of (BuildContext context ){
    return Localizations.of(context, AppLocale) ;
  }

  Future loadTranslation() async {
    String langFile = await rootBundle.loadString('langs/${locale!.languageCode}.json') ;
    Map<String,dynamic > loadedValues  = await jsonDecode(langFile) ;
    _translation =  loadedValues.map((key, value) => MapEntry(key, value.toString()));
  }

  String? getTranslation(String? key){
    return _translation[key!] ;
  }

  static const LocalizationsDelegate<AppLocale> delegate = _AppLocaleDelegate();

}


class _AppLocaleDelegate extends LocalizationsDelegate<AppLocale> {
  const _AppLocaleDelegate() ;

  @override
  bool isSupported(Locale locale) {
    return ['en' , 'ar'].contains(locale.languageCode) ;
  }

  @override
  Future<AppLocale> load(Locale locale) async  {
    AppLocale appLocale = AppLocale(locale: locale);
    await appLocale.loadTranslation();
    return appLocale ;

  }

  @override
  bool shouldReload(LocalizationsDelegate old) => false ;

}

class GetSharedLang extends ChangeNotifier {

  String? langCodeFromShared = 'ar' ;

  Future<String?> loadLang() async {
    SharedPreferences getLangCode = await SharedPreferences.getInstance() ;
    langCodeFromShared = getLangCode.getString('lCode') ;
    notifyListeners() ;
    return getLangCode.getString('lCode') ;
  }

  Future<bool> saveLang(String code) async {
    SharedPreferences saveLangCode = await SharedPreferences.getInstance() ;
    langCodeFromShared = code ;
    notifyListeners() ;
    return await saveLangCode.setString('lCode', code);
  }

}