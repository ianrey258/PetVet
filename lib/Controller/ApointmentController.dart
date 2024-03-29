
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
      String user_id = await DataStorage.getData('id');
      QuerySnapshot apointment_list = await firestore.collection('appointments').where('pet_owner_id',isEqualTo: user_id).get();
      apointment_list.docs.forEach((doc) { 
        apointments.add(ClinicApointmentModel.fromMap(jsonDecode(jsonEncode(doc.data()))));
      });
      return apointments;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return [];
    }
  }
  
  static Future<List> getUnreadApointments() async {
    try{
      List<ClinicApointmentModel> apointments = [];
      String user_id = await DataStorage.getData('id');
      QuerySnapshot apointment_list = await firestore.collection('appointments').where('pet_owner_id',isEqualTo: user_id).get();
      apointment_list.docs.forEach((doc) {
        try{
          if(doc.get('pet_owner_read_status') == 'false'){
            apointments.add(ClinicApointmentModel.fromMap(jsonDecode(jsonEncode(doc.data()))));
          }
        }catch(e){}
      });
      return apointments;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return [];
    }
  }
  
  static Future<ClinicApointmentModel> getApointment(String id) async {
    try{
      DocumentSnapshot apointment_data = await firestore.collection('appointments').doc(id).get();
      ClinicApointmentModel apointment = ClinicApointmentModel.fromMap(jsonDecode(jsonEncode(apointment_data.data())));
      return apointment;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return {} as ClinicApointmentModel;
    }
  }
  
  static Future<bool> removeApointment(String id) async {
    try{
      await firestore.collection('appointments').doc(id).delete();
      return true;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return false;
    }
  }

  static Future<bool> updateApointment(ClinicApointmentModel apointment) async {
    try{
      await firestore.collection('appointments').doc(apointment.id).set(apointment.toMap());
      return true;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return false;
    }
  }

  static Future<bool> setApointment(ClinicApointmentModel apointment) async {
    try{
      String user_id = await DataStorage.getData('id');
      apointment.pet_owner_id = user_id;
      var _apointment = await firestore.collection('appointments').add(apointment.toMap());
      apointment.id = _apointment.id; 
      await updateApointment(apointment);
      return true;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return false;
    }
  }

  static Future<List<DateTime>> getClinicAppointmentSchedule(clinic_id) async {
    List<DateTime> schedules = [];
    try{
      QuerySnapshot appointments = await firestore.collection('appointments')
                                                  .where('clinic_id',isEqualTo: clinic_id)
                                                  .where('status', isEqualTo: 'Approved')
                                                  .get();
      appointments.docs.forEach((doc) { 
        String schedule_datetime = doc.get('schedule_datetime');
        schedules.add(DateTime.parse(schedule_datetime));
      });
      return schedules;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return schedules;
    }
  }
  
}