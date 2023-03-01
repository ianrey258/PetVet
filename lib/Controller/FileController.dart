
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FileController{
  static FirebaseStorage firebaseStorage= FirebaseStorage.instance;
  
  static Future<String> setFile(String server_path,String local_path) async {
    try{
      firebaseStorage.ref(server_path).putFile(File(local_path)).whenComplete(()async{});
      return server_path;
    } catch (e){
      debugPrint(e.toString());
      return "";
    }
  }
  
  static Future<void> removeFile(String server_path) async {
    try{
      firebaseStorage.ref(server_path).delete();
    } catch (e){
      debugPrint(e.toString());
    }
  }
  
  static Future<String> getFileURL(String server_file_path) async {
    try{
      return await firebaseStorage.ref(server_file_path).getDownloadURL();
    }catch (e){
      return getFileURL(server_file_path);
    }
  }

}