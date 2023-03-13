
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vetfindapp/Model/apointmentModel.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ApointmentController{
  static final FirebaseAuth firabaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List> getApointments() async {
    try{
      List<ClinicApointmentModel> apointments = [];
      QuerySnapshot apointment_list = await firestore.collection('appointments').get();
      apointment_list.docs.forEach((doc) { 
        apointments.add(ClinicApointmentModel.fromMap(jsonDecode(jsonEncode(doc.data()))));
      });
      return apointments;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return [];
    }
  }
  
  static Future<ClinicApointmentModel> getApointment(String id) async {
    try{
      ClinicApointmentModel? apointment;
      QuerySnapshot apointment_list = await firestore.collection('appointments').get();
      apointment_list.docs.forEach((doc) { 
        if(doc.id == id){
          apointment = ClinicApointmentModel.fromMap(jsonDecode(jsonEncode(doc.data())));
        } 
      });
      return apointment!;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return {} as ClinicApointmentModel;
    }
  }

  static Future<bool> setApointment(ClinicApointmentModel apointment) async {
    try{
      await firestore.collection('appointments').add(apointment.toMap());
      return true;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return false;
    }
  }
  
}