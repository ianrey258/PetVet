
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vetfindapp/Model/apointmentModel.dart';
import 'package:vetfindapp/Model/messageModel.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MessageController{
  static final FirebaseAuth firabaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;



  static Future<MessageIdModel> getGroupId(List<String> ids) async {
    try{
      MessageIdModel message_model = MessageIdModel(null,[]);
      // QuerySnapshot _chat = await firestore.collection('chat').where('users_id',arrayContainsAny: [ids[0],ids[1]]).get();
      QuerySnapshot _chat = await firestore.collection('chat').get();
      _chat.docs.forEach((QueryDocumentSnapshot doc) { 
        MessageIdModel _message_model = MessageIdModel.fromMap(jsonDecode(jsonEncode(doc.data()))); 
        if(_message_model.users_id!.contains(ids[0]) && _message_model.users_id!.contains(ids[1])){
          message_model = _message_model;
        }
      });
      return message_model;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return MessageIdModel(null,[]);
    }
  }
  
  static Future<MessageIdModel> setGroupId(MessageIdModel groupMessage) async {
    try{
      MessageIdModel group_message = groupMessage;
      if(groupMessage.id == null){
        DocumentReference _chat = await firestore.collection('chat').add(group_message.toMap());
        group_message.id = _chat.id;
        await setGroupId(group_message);
      } else {
        await firestore.collection('chat').doc(groupMessage.id).set(group_message.toMap());
      }
      return group_message;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return MessageIdModel(null,[]);
    }
  }

  static Stream<List> getStreamMessages(String group_id,int limit) async* {
    for(int i = 0;i<10;i++ ){
      final messages = await getMessages(group_id,limit); 
      yield  messages;
      await Future.delayed(Duration(seconds: 2));

    }
    // while(true){
    //   yield await getMessages(group_id,limit);
    //   await Future.delayed(Duration(seconds: 20));
    // }
  }


  static Future<List> getMessages(String group_id,int limit) async {
    try{
      List _messages = [];
      QuerySnapshot snapshots = await firestore
          .collection("chat")
          .doc(group_id)
          .collection('messages')
          .orderBy('datetime', descending: true)
          // .limit(limit)
          .get();
        snapshots.docs.forEach((QueryDocumentSnapshot doc) { 
          _messages.add(MessageModel.fromMap(jsonDecode(jsonEncode(doc.data()))));
        });
        return _messages;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return [];
    }
    
    // return firestore
    //        .collection("chat")
    //        .doc(group_id)
    //        .collection('messages')
    //        .orderBy('datetime', descending: true)
    //        // .limit(limit)
    //        .snapshots();
  }
  
  static Stream getMessagesSnapshots(String group_id,int limit) {
    return firestore
           .collection("chat")
           .doc(group_id)
           .collection('messages')
           .orderBy('datetime', descending: true)
           // .limit(limit)
           .snapshots();
  }
  
  static Future<bool> sendMessage(String group_id,MessageModel message) async {
    try{
      MessageModel _message = message;
      DocumentReference _message_ref = await firestore.collection('chat').doc(group_id).collection('messages').add(_message.toMap());
      _message.id = _message_ref.id;
      await updateMessage(group_id, message);
      return true;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return false;
    }
  }
  
  static Future<bool> updateMessage(String group_id,MessageModel message) async {
    try{
      MessageModel _message = message;
      DocumentReference _message_ref = await firestore.collection('chat').doc(group_id).collection('messages').doc(_message.id);
      await firestore.runTransaction((transaction) async {
        transaction.set(_message_ref, _message.toMap());
      });
      return true;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return false;
    }
  }
  
  static Future<bool> removeMessage(String group_id,MessageModel message) async {
    try{
      await firestore.collection('chat').doc(group_id).collection('messages').doc(message.id).delete();
      return true;
    }catch (e){
      debugPrint("Error on: ${e.toString()}");
      return false;
    }
  }
  
}