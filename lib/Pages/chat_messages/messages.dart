import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetfindapp/Controller/ClinicController.dart';
import 'package:vetfindapp/Controller/MessageController.dart';
import 'package:vetfindapp/Model/clinicModel.dart';
import 'package:vetfindapp/Pages/_helper/image_loader.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final ScrollController _sc = ScrollController();
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  List<ClinicModel>? clinic_chat_list = [];
  bool refresh = false;

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
    clinic_chat_list = [];
    List _clinic_chat_list = await MessageController.getListMessages();
    _clinic_chat_list.forEach((clinic_id) async { 
      ClinicModel clinic = await ClinicController.getClinic(clinic_id);
      setState(() {  
        clinic_chat_list!.add(clinic);
      });
    });
  }

  refreshPage(){
    refresh = !refresh;
  }

  Color statusColor(status){
    if(status == "Approved"){
      return text10Color;
    }
    if(status == "Declined"){
      return text4Color;
    }
    return text6Color;
  }

  Widget chat_card(ClinicModel clinic) {
    return Card(
      elevation: 5,
      child: ListTile(
        // tileColor: apointment?.pet_owner_read_status == 'true' ? text1Color : text7Color,
        style: ListTileStyle.list,
        leading: clinic.clinic_img != "" ? ImageLoader.loadImageNetwork(clinic.clinic_img??"",50.0,50.0) : FaIcon(Icons.store,size: 50),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(clinic.clinic_doctor??"")
          ],
        ),
        subtitle: Text(clinic.clinic_name??''),
        trailing: Container(
          // width: 90,
          child: IconButton(
            icon: FaIcon(Icons.message,size: 35,color: text9Color,),
            onPressed: () => Navigator.pushNamed(context, '/message',arguments: clinic),
          ),
        ),
        onTap: ()=> Navigator.pushNamed(context, '/message',arguments: clinic),
      ),
    );   
  }

  List<Widget> chatList(){
    if(clinic_chat_list!.isEmpty){
      return [Center(child: Text("No Messages"),)];
    }
    return clinic_chat_list!.map((ClinicModel data) => chat_card(data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: text1Color,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Image.asset(logoImg,fit: BoxFit.contain),
          // leading: Container(),
          actions: [
            IconButton(
              onPressed: (){
                // Navigator.pushNamed(context, "/user_profile");
              }, 
              icon: FaIcon(FontAwesomeIcons.filter)
            )
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: RefreshIndicator(
            onRefresh: ()=>initLoadData(),
            child: ListView(
              children: chatList(),
            ),
          ),
        ),
      ),
    );
  }
}
