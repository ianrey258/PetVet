import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetfindapp/Controller/ApointmentController.dart';
import 'package:vetfindapp/Controller/ClinicController.dart';
import 'package:vetfindapp/Controller/PetController.dart';
import 'package:vetfindapp/Model/apointmentModel.dart';
import 'package:vetfindapp/Model/clinicModel.dart';
import 'package:vetfindapp/Model/petModel.dart';
import 'package:vetfindapp/Pages/_helper/image_loader.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';


class ShowAppointment extends StatefulWidget {
  final ClinicApointmentModel? apointment;
  const ShowAppointment({Key? key,this.apointment}) : super(key: key);

  @override
  _ShowAppointmentState createState() => _ShowAppointmentState();
}

class _ShowAppointmentState extends State<ShowAppointment> {
  final ScrollController _sc = ScrollController();
  DateTime today = DateTime.now();
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  String payment = ''; 
  String schedule = ''; 
  ClinicModel? clinic;
  ClinicApointmentModel? apointment;
  List<String> status = ['Pending','Approved','Declined'];
  List<PetModel> pets = [];

  @override
  initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
      }
      apointment = widget.apointment;
    });
    initLoadData();
  }

  initLoadData() async {
    print(apointment?.clinic_id??"");
    ClinicModel _clinic = await ClinicController.getClinic(apointment?.clinic_id??"");
    apointment?.pet_list_ids?.forEach((id) async {
      PetModel pet = await PetController.getPet(id);
      setState(() {
        pets.add(pet);
      });  
    });
    if(apointment != null){
      setState(() {
        clinic = _clinic;
        text[0].text = apointment?.reason??"";
        DateTime sched = DateTime.parse(apointment?.schedule_datetime??"");
        text[1].text = "${DateFormat.yMMMEd().add_jm().format(sched)}";
      });
    }
  }

  Widget _textFormField(String name, int controller, TextInputType type) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: TextFormField(
              keyboardType: type,
              maxLines: TextInputType.multiline == type ? 4 : null,
              minLines: TextInputType.multiline == type ? 4 : null,
              expands: false,
              readOnly: true,
              controller: text[controller],
              style: TextStyle(fontSize: 18, color: secondaryColor),
              cursorColor: secondaryColor,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                fillColor: text3Color,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
              ),
              validator: (val) => val!.isNotEmpty ? null : "Invalid " + name,
            ),
          )
        ],
      ),
    );
  }

  Widget getDateAppointment(int controller){
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        fillColor: text3Color,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none
        ),
        hintText: 'DateTime'
      ),
      readOnly: true,
      controller: text[controller],
    );
  }

  Widget pet(PetModel pet){
    return Container(
      margin: EdgeInsets.only(top: 5,bottom: 5),
      height: 60,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        color: text1Color,
        margin: EdgeInsets.all(1),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)
            ),
            // child: Image.asset(image,height: double.infinity,width: 50)
            child: pet?.pet_img != null && pet?.pet_img != "" ? ImageLoader.loadImageNetwork(pet?.pet_img??"",50.0,50.0) : FaIcon(Icons.pets,size: 50,)
          ),
          title: Text(pet.pet_name??"",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: text2Color),),
          trailing: Container(
            width: 50,
            height: double.infinity,
          ),
          onTap: (){
          },
        ),
      ),
    );
  }

  Widget petList(){
    return Container(
      height: 200,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: pets.map((PetModel _pet) => pet(_pet)).toList(),
        ),
      )
    );
  }

  Color statusColor(status){
    if(status == "Approved"){
      return text9Color;
    }
    if(status == "Declined"){
      return text4Color;
    }
    return text6Color;
  }

  Widget formAppointment(){
    return Form(
      key: _key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(apointment?.status??"",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold, color: statusColor(apointment?.status??"")),),
          _textFormField("Reason", 0, TextInputType.multiline),
          getDateAppointment(1),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('Pets',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: petList(),
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
            style: buttonStyleA(250,50,1,primaryColor),
            onPressed: () => Navigator.popAndPushNamed(context, '/message',arguments: clinic), 
            child: Center(
              child: Text('Send Message'),
            )
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
            style: buttonStyleA(250,50,1,primaryColor),
            onPressed: () => Navigator.popAndPushNamed(context, '/vet_clinic',arguments: clinic), 
            child: Center(
              child: Text('Visit Clinic'),
            )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AlertDialog(
      content: Container(
        height: size.height*.55,
        child: SizedBox(
          height: size.height*.30,
          width: double.infinity,
          child: SingleChildScrollView(
            child: formAppointment()
          ),
        ),
      ),
    );
  }
}
