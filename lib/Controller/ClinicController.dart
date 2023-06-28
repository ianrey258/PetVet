
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vetfindapp/Model/apointmentModel.dart';
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
      print('Clinics = ${list_clinics.docs.length}');
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
      return ClinicModel(id, '', '', '', '', '', '', '', '', '', [],[]);
    }
  }
  
  static Future<List<String>> getClinicServices() async {
    List<String> services = [];
    try{
      QuerySnapshot clinics = await firestore.collection('clinics').get();
      clinics.docs.forEach((doc) { 
        List clinic_services = doc.get('services');
        List<String> clinic_services_decode = clinic_services.map((data) => data as String).toList();
        services += clinic_services_decode;
      });
      return services.toSet().toList();
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return services;
    }
  }

  static Future checkClinicSchedule(clinic_id,ClinicApointmentModel data) async {
    bool available = false;

    final list_schedule = await firestore.collection('clinics').doc(clinic_id).collection('schedule').get();
    list_schedule.docs.forEach((_data) {
      ClinicScheduleModel scheduleModel = ClinicScheduleModel.fromMap(jsonDecode(jsonEncode(_data.data()))); 
      DateTime apointment_datatime = DateTime.parse(data.schedule_datetime??'');
      DateTime datetime_opening = DateTime.parse('${DateFormat('yyyy-MM-dd').format(apointment_datatime)} ${scheduleModel.clinic_opening??''}');
      DateTime datetime_closing = DateTime.parse('${DateFormat('yyyy-MM-dd').format(apointment_datatime)} ${scheduleModel.clinic_closing??''}').subtract(const Duration(hours: 1));

      if(!available && datetime_opening.microsecondsSinceEpoch <= apointment_datatime.microsecondsSinceEpoch && apointment_datatime.microsecondsSinceEpoch <= datetime_closing.microsecondsSinceEpoch && DateFormat('EEEE').format(apointment_datatime).contains(scheduleModel.clinic_day??'')){
        available = !available;
      }
    });
    return available;
  }

  static Future<String> fixClinicsMissingData() async {
    try{
      QuerySnapshot clinics = await firestore.collection('clinics').get();
      clinics.docs.forEach((doc)async{
        Map clinic = jsonDecode(jsonEncode(doc.data()));
        if(clinic['fcm_tokens'] == null){
          clinic['fcm_tokens'] = [];
          DocumentReference clinic_doc = await firestore.collection('clinics').doc(doc.id);
          clinic_doc.set(clinic);
        }
      });
      return 'Fix Sucess';
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return 'Fix Failed';
    }
  }

}