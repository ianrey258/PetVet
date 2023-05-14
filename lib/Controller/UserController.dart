
import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vetfindapp/Controller/FileController.dart';
import 'package:vetfindapp/Model/userModel.dart';
import 'package:vetfindapp/Services/firebase_messaging.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserController{
  static final FirebaseAuth firabaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static verifyUser(List<TextEditingController> data) async {
    try{
      UserCredential fb_auth = await firabaseAuth.signInWithEmailAndPassword(email: data[0].value.text.toString().toLowerCase(), password: data[1].value.text.toString());
      if(!await isInEmail(data[0].value.text.toString().toLowerCase())){
        return false;
      }
      return true;
    }catch(e){
      debugPrint("on Error: ${e.toString()}");
      return false;
    }
  }
  
  static loginUser(List<TextEditingController> data) async {
    try{
      UserCredential fb_auth = await firabaseAuth.signInWithEmailAndPassword(email: data[0].value.text.toString().toLowerCase(), password: data[1].value.text.toString());
      await DataStorage.setData('email', data[0].value.text.toString().toLowerCase());
      DocumentSnapshot user_doc = await firestore.collection('users').doc(fb_auth.user?.uid??"").get();
      UserModel user = UserModel.fromMap(jsonDecode(jsonEncode(user_doc.data())));
      
      await checkUserFCMToken(user);
      await DataStorage.setData('id', user.id);
      await DataStorage.setData('username',user.username);
      await DataStorage.setData('fullname',user.fullname);
      await DataStorage.setData('email',user.email);
      return true;
    }catch(e){
      debugPrint("on Error: ${e.toString()}");
      return false;
    }
  }
  
  static registerUser(List<TextEditingController> data) async {
    try{
      UserCredential fb_auth = await firabaseAuth.createUserWithEmailAndPassword(email: data[2].value.text.toString(), password: data[3].value.text.toString());
      DocumentReference users = firestore.collection('users').doc(fb_auth.user?.uid??"");
      List fcm_tokens = [await FirebaseMessagingService.getFCMToken()];
      UserModel user = UserModel(
                          fb_auth.user?.uid??"", 
                          data[0].value.text.toString(), 
                          data[1].value.text.toString(), 
                          "",
                          data[2].value.text.toString(),
                          data[3].value.text.toString(),
                          "",
                          "",
                          fb_auth.user?.uid??"",
                          fcm_tokens
                        );
      await updateUser(user);
      await DataStorage.setData('id', user.id);
      await DataStorage.setData('username',user.username);
      await DataStorage.setData('fullname',user.fullname);
      await DataStorage.setData('email',user.email);
      return true;
    }catch(e){
      debugPrint(e.toString());
      return false;
    }
  }
  
  static updateUserProfile(List<TextEditingController> data) async {
    try{
      final user_id = await DataStorage.getData('id');
      DocumentSnapshot users = await firestore.collection('users').doc(user_id).get();
      UserModel user = UserModel.fromMap(jsonDecode(jsonEncode(users.data())));
      user.username = data[0].value.text.toString();
      user.fullname = data[1].value.text.toString();
      user.birthdate = data[2].value.text.toString();
      user.address = data[3].value.text.toString();
      user.email = data[4].value.text.toString();
      updateUser(user);
      await DataStorage.setData('id', user.id);
      await DataStorage.setData('username',user.username);
      await DataStorage.setData('fullname',user.fullname);
      await DataStorage.setData('email',user.email);
      return true;
    }catch(e){
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<UserModel> getUser(String id) async {
    DocumentSnapshot user_doc = await firestore.collection('users').doc(id).get();
    UserModel user = UserModel.fromMap(jsonDecode(jsonEncode(user_doc.data())));
    return user;
  }
  
  static Future<void> sendResetPassword(String email) async {
    var fb_auth = await firabaseAuth.sendPasswordResetEmail(email: email);
  }

  static Future<bool> sendChangeEmail(String email) async {
    try{
      // var fb_auth = await EmailAuthProvider.credential(email);
      // var fb_auth = await firabaseAuth.currentUser?.reauthenticateWithCredential(email);
      await firabaseAuth.currentUser?.updateEmail(email);
      await firabaseAuth.currentUser!.sendEmailVerification();
      return true;
    }catch(e){
      return false;
    }
  }

  static Future<bool> isInEmail(String email) async {
    try{
      CollectionReference user_list = await firestore.collection('users');
      QuerySnapshot user = await user_list.where('email',isEqualTo: email).get();
      if(user.docs.isEmpty){
        return false;
      }
      return true;

    }catch(e){
      return false;
    }
  }
  
  static Future<UserModel> updateUser(UserModel new_data) async {
    try{
      DocumentReference user_doc = await firestore.collection('users').doc(new_data?.id);
      UserModel user = new_data;
      user_doc.set(user.toMap());
      return user;
    }catch(e){
      debugPrint(e.toString());
      return new_data;
    }
  }
  
  static Future<String> setUserPicture(String file_path) async {
    final user_id = await DataStorage.getData('id');
    String filename = file_path.split('/').last;
    String final_path = "/${user_id??''}/profile/${filename}";
    await FileController.setFile(final_path, file_path);
    UserModel user = await getUser(user_id);
    if(user.profile_img != ""){
      FileController.removeFile(user.profile_img??"");
    }
    user.profile_img = final_path;
    await updateUser(user);
    return final_path;
  }
  
  static logoutUser() async {
    try{
      await FirebaseAuth.instance.signOut();
      await DataStorage.clearStorage();
      return true;
    }catch(e){
      debugPrint(e.toString());
      return false;
    }
  }

  static Future checkUserFCMToken(UserModel user) async {
    //check fcm tokens
      List fcm_tokens = user.fcm_tokens??[];
      String device_fcm_token = await FirebaseMessagingService.getFCMToken();
      if(!fcm_tokens.contains(device_fcm_token)){
        user.fcm_tokens = fcm_tokens + [device_fcm_token];
        await updateUser(user);
      }
  }

  static updateDeviceFirestore(data) async {
    String id = await DataStorage.getData('id');
    await firestore.collection('users').doc(id).collection('devices').doc(data['id']).update(data);

  }

  

}