import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetfindapp/Controller/ClinicController.dart';
import 'package:vetfindapp/Controller/MessageController.dart';
import 'package:vetfindapp/Controller/UserController.dart';
import 'package:vetfindapp/Model/clinicModel.dart';
import 'package:vetfindapp/Model/messageModel.dart';
import 'package:vetfindapp/Model/userModel.dart';
import 'package:vetfindapp/Pages/_helper/image_loader.dart';
import 'package:vetfindapp/Services/firebase_messaging.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';

class Message extends StatefulWidget {
  final ClinicModel? data;
  const Message({Key? key,this.data}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final ScrollController _sc = ScrollController();
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  UserModel? user;
  ClinicModel? clinic;
  MessageIdModel? message_id;
  @override
  initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
      }
    });
    initLoadData();
  }

  initLoadData() async {
    String userid = await DataStorage.getData('id');
    UserModel _user = await UserController.getUser(userid);
    MessageIdModel _message_id = await MessageController.getGroupId([clinic?.id??"",_user.id??""]);
    if(_message_id.id == null){
      _message_id.id = null;
      _message_id.users_id = [clinic?.id??"",_user.id??""];
      _message_id = await MessageController.setGroupId(_message_id);
    }
    setState(() {
      user = _user;
      message_id = _message_id;
    });
  }

  sendMessage() async {
    if(text[0].text != ''){
      MessageModel message = MessageModel('', user?.id, text[0].text, 'text', DateTime.now().millisecondsSinceEpoch.toString());
      await MessageController.sendMessage(message_id?.id??"", message);
      FirebaseMessagingService.sendMessageNotification('Appointment', "${await DataStorage.getData('username')}", 'Message', text[0].text, clinic!.fcm_tokens!);
      _sc.animateTo(0,duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
    text[0].clear();
  }


  Widget messageInput() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: (){},
              icon: const Icon(
                Icons.camera_alt,
                size: 25,
              ),
              color: text1Color,
            ),
          ),
          Flexible(
            child: TextField(
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              controller: text[0],
              textAlignVertical: TextAlignVertical.bottom,
              expands: true,
              maxLines: null,
              autofocus: true,
              focusNode: FocusNode(),
              style: TextStyle(color: text1Color),
              decoration: InputDecoration(
                hintText: 'write here...',
              ),
              onSubmitted: (value) {
                sendMessage();
              },
            )
          ),
          Container(
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: () {
                sendMessage();
              },
              icon: const Icon(Icons.send_rounded),
              color: text1Color,
            ),
          ),
        ],
      ),
    );
  }

  Widget messageContainer(snapshot) {
    MessageModel data = MessageModel.fromMap(jsonDecode(jsonEncode(snapshot)));
    if(data.user != clinic?.id){
      return ListTile(
        contentPadding: EdgeInsets.all(1),
        // trailing: Container(
        //   // clipBehavior: Clip.hardEdge,
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(50),
        //     child: user?.profile_img != "" ? ImageLoader.loadImageNetwork(user?.profile_img??"",45.0,45.0) : FaIcon(FontAwesomeIcons.circleUser,size: 45,color: text1Color,)
        //   ),
        // ),
        title: Container(
          margin: EdgeInsets.only(left: 50),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(20),
                    color: text5Color 
                  ),
                  child: Text(data.message??"",softWrap: true,style: TextStyle(color: text2Color),overflow: TextOverflow.clip,)
                )
              )
            ],
          ),
        ),
      );
    }else{
      return ListTile(
        contentPadding: EdgeInsets.all(1),
        // leading: Container(
        //   // clipBehavior: Clip.hardEdge,
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(50),
        //     child: clinic?.clinic_img != "" ? ImageLoader.loadImageNetwork(clinic?.clinic_img??"",45.0,45.0) : FaIcon(FontAwesomeIcons.circleUser,size: 45,color: text1Color,)
        //   ),
        // ),
        title: Container(
          margin: EdgeInsets.only(right: 50),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(20),
                    color: alternativeColor 
                  ),
                  child: Text(data.message??"",softWrap: true,style: TextStyle(color: text3Color),overflow: TextOverflow.clip,)
                )
              )
            ],
          ),
        ),
      );
    }
  }

  Widget listMessage() {
    if(message_id == null){
      return const Center(child: CircularProgressIndicator());
    }
    return Flexible(
      child: StreamBuilder(
        stream: MessageController.getMessagesSnapshots(message_id?.id??"", 10),
        builder: (BuildContext context,AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
            List listMessages = snapshot.data.docs;
            if (listMessages.isNotEmpty) {
              return ListView(
                  padding: const EdgeInsets.all(10),
                  reverse: true,
                  controller: _sc,
                  children: listMessages.map((snapshot) => messageContainer(snapshot.data())).toList()
                  // children: []
                );
            } else {
              return const Center(
                child: Text('No messages...'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
       }
      )
   );
 }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setState(() {
      final data = ModalRoute.of(context)!.settings.arguments as ClinicModel;
      clinic = data;
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: text1Color,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(clinic?.clinic_name??"",textAlign: TextAlign.center),
          actions: [
            Center(
              child: IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/video_call');
                }, 
                icon: FaIcon(FontAwesomeIcons.video)
              ),
            )
          ],
        ),
        // body: Container(
        //   height: double.infinity,
        //   width: double.infinity,
        //   child: ListView(
        //     reverse: true,
        //   ),
        // ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              listMessage(),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
        bottomSheet: Container(
          height:50,
          width: double.infinity,
          child: messageInput(),
        ),
      ),
    );
  }
}
