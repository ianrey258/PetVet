
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vetfindapp/Model/clinicModel.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ClinicController{
  static final FirebaseAuth firabaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  static Future<List> getClinics() async {
    try{
      List<ClinicModel> clinics = [];
      QuerySnapshot list_clinics = await firestore.collection('clinics').get();
      list_clinics.docs.forEach((clinic) { 
        clinics!.add(ClinicModel.fromMap(jsonDecode(jsonEncode(clinic.data()))));
      });
      return clinics;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return [];
    }
  }
  
  static Future<ClinicModel> getClinic(String id) async {
    try{
      DocumentSnapshot clinic_data = await firestore.collection('clinics').doc(id).get();
      ClinicModel _clinic = ClinicModel.fromMap(jsonDecode(jsonEncode(clinic_data.data())));
      return _clinic;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return {} as ClinicModel;
    }
  }

}