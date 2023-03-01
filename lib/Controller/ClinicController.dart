
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vetfindapp/Model/userModel.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ClinicController{
  static final FirebaseAuth firabaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  

}