
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vetfindapp/Controller/FileController.dart';
import 'package:vetfindapp/Model/petModel.dart';
import 'package:vetfindapp/Model/userModel.dart';
import 'package:vetfindapp/Pages/pets/pet.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class PetController{
  static final FirebaseAuth firabaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  static Future<PetModel> getPet(String pet_id) async {
    String user_id = await DataStorage.getData('id');
    DocumentSnapshot user_pet = await firestore.collection('users').doc(user_id).collection('pets').doc(pet_id).get();
    PetModel pet = PetModel.fromMap(jsonDecode(jsonEncode(user_pet.data())));
    return pet;
  }

  static Future<List<PetModel>> getPetList() async {
    List<PetModel> pets = [];
    String user_id = await DataStorage.getData('id');
    QuerySnapshot user_pets = await firestore.collection('users').doc(user_id).collection('pets').get();
    user_pets.docs.forEach((pet) {
      PetModel _pet = PetModel.fromMap(jsonDecode(jsonEncode(pet.data())));  
      pets.add(_pet);
    });
    return pets;
  }
  
  // static Stream<List<PetModel>> getStreamPetList(String id) async* {
  //   List<PetModel> pets = [];
  //   String user_id = await DataStorage.getData('id');
  //   QuerySnapshot user_pets = await firestore.collection('users').doc(user_id).collection('pets').get();
  //   user_pets.docs.forEach((pet) {
  //     PetModel _pet = PetModel.fromMap(jsonDecode(jsonEncode(pet.data())));  
  //     pets.add(_pet);
  //   });
  //   return pets;
  // }
  
  static Future<PetModel> insertPet(List<TextEditingController> data) async {
    String user_id = await DataStorage.getData('id');
    CollectionReference pet_list = await firestore.collection('users').doc(user_id).collection('pets');
    PetModel pet = PetModel(
                      "", 
                      data[0].value.text.toString(),
                      data[1].value.text.toString(),
                      data[2].value.text.toString(),
                      ""
                      );
    DocumentReference _pet = await pet_list.add(pet.toMap());
    pet.id = _pet.id;
    await updatePet(pet);
    return pet;
  }

  static Future<String> setPetPicture(String pet_id,String file_path) async {
    final user_id = await DataStorage.getData('id');
    String filename = file_path.split('/').last;
    String final_path = "/${user_id??''}/pets/${filename}";
    await FileController.setFile(final_path, file_path);
    PetModel pet = await getPet(pet_id);
    if(pet.pet_img != ""){
      await FileController.removeFile(pet.pet_img??"");
    }
    pet.pet_img = final_path;
    await updatePet(pet);
    return final_path;
  }

  static Future<PetModel> updatePet(PetModel pet) async {
    String user_id = await DataStorage.getData('id');
    DocumentReference pet_doc = await firestore.collection('users').doc(user_id).collection('pets').doc(pet.id);
    pet_doc.set(pet.toMap());
    return pet;
  }
  
  static Future<PetModel> removePet(PetModel pet) async {
    String user_id = await DataStorage.getData('id');
    DocumentReference pet_doc = await firestore.collection('users').doc(user_id).collection('pets').doc(pet.id);
    pet_doc.delete();
    return pet;
  }

}