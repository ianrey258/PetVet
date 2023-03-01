
import 'package:shared_preferences/shared_preferences.dart';

class DataStorage{

  static Future<dynamic> setData(key,value) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    return true;
  }

  static Future<dynamic> getData(key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }
  
  static Future<dynamic> clearStorage() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
  
  static Future<bool> isInStorage(key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

}