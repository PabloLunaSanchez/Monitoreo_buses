import 'dart:convert';

import 'package:app_bus_tesis/Modelos/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordarUserPref{
  static Future<void> AlmacenaminetoInfoUser(User userInfo) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }  
 
  static Future<User?> LeerUserInfo() async{
    User? currentUserInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
   String? userInfo = preferences.getString("currentUser");
   if(userInfo != null){
    Map<String, dynamic> userDataMap  = jsonDecode(userInfo); 
    currentUserInfo = User.fromJson(userDataMap);
   }
   return currentUserInfo;
  }

static Future<void> removerUserInfo() async{
SharedPreferences preferences = await SharedPreferences.getInstance();
await preferences.remove("currentUser");
}
}