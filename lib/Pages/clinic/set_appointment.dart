import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetfindapp/Controller/ApointmentController.dart';
import 'package:vetfindapp/Controller/PetController.dart';
import 'package:vetfindapp/Model/apointmentModel.dart';
import 'package:vetfindapp/Model/clinicModel.dart';
import 'package:vetfindapp/Model/petModel.dart';
import 'package:vetfindapp/Pages/_helper/image_loader.dart';
import 'package:vetfindapp/Services/firebase_messaging.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';


class SetAppointment extends StatefulWidget {
  final ClinicModel? clinic;
  const SetAppointment({Key? key,this.clinic}) : super(key: key);

  @override
  _SetAppointmentState createState() => _SetAppointmentState();
}

class _SetAppointmentState extends State<SetAppointment> {
  final ScrollController _sc = ScrollController();
  DateTime today = DateTime.now();
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  String payment = ''; 
  String schedule = ''; 
  ClinicModel? clinic;
  ClinicApointmentModel? apointment;
  List<String> status = ['Pending','Approved','Declined'];
  List<String> selected_pets = [];
  List<PetModel> pets = [];
  List<DateTime> clinic_schedule = [];
  final datetime_format = DateFormat("yyyy-MM-dd HH:mm");

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
    List<PetModel> pet_list = await PetController.getPetList();
    List<DateTime> _clinic_schedule = await ApointmentController.getClinicAppointmentSchedule(clinic?.id??"");
    setState(() {
      clinic_schedule = _clinic_schedule;
      pets = pet_list;
      apointment = ClinicApointmentModel("","","","","","","","",[],"","");
    });
  }

  validation() async {
    if(schedule.isEmpty || selected_pets.isEmpty){
      return false;
    }
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      setState(() {
        apointment?.clinic_id = clinic?.id;
        apointment?.datetime_created = today.toString();
        apointment?.reason = text[0].text;
        apointment?.schedule_datetime = schedule;
        apointment?.status = status[0];
        apointment?.pet_list_ids = selected_pets;
        apointment?.payment = payment;
        apointment?.pet_owner_read_status = "true";
        apointment?.clinic_read_status = "false";
      });
      return true;
    }
    return false;
  }

  Future sendNotification() async {
    
  }

  bool checkConflictSchedule(DateTime datetime_appoint){
    bool is_conflict = false;
    clinic_schedule.forEach((DateTime datetime) { 
      DateTime datetime_appoint_start = datetime_appoint;
      DateTime datetime_appoint_end = datetime_appoint_start.add(Duration(minutes: 30));
      DateTime datetime_start = datetime;
      DateTime datetime_end = datetime_start.add(Duration(minutes: 30));
      if(!is_conflict && datetime_start.microsecondsSinceEpoch <= datetime_appoint.microsecondsSinceEpoch && datetime_appoint.microsecondsSinceEpoch <= datetime_end.microsecondsSinceEpoch){
        is_conflict = !is_conflict;
      }
      if(!is_conflict && datetime_appoint_start.microsecondsSinceEpoch <= datetime_start.microsecondsSinceEpoch && datetime_start.microsecondsSinceEpoch <= datetime_appoint_end.microsecondsSinceEpoch){
        is_conflict = !is_conflict;
      }
    });
    
    return is_conflict;
  }

  Future<bool> afterValidation() async {
    return await ApointmentController.setApointment(apointment!);
  }

  Widget _textFormField(String name, int controller, TextInputType type) {

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: TextStyle(color: text2Color),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: TextFormField(
              keyboardType: type,
              maxLines: TextInputType.multiline == type ? 4 : null,
              minLines: TextInputType.multiline == type ? 4 : null,
              expands: false,
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

  Widget getDateAppointment(){
    return DateTimeField(
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
      format: datetime_format,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(context: context,initialTime:TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          setState(() {
            schedule = DateTimeField.combine(date, time).toString(); 
          });
          return DateTimeField.combine(date, time);
        } else {
          setState(() {
            schedule = currentValue.toString(); 
          });
          return currentValue;
        }
      },
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50)
            ),
            child: Checkbox(
              value: selected_pets.contains(pet.id??''),
              onChanged: (bool? value){
                setState(() {
                  !selected_pets.contains(pet.id??'') ? selected_pets.add(pet.id??'') : selected_pets.remove(pet.id??'');
                });
              },
            )
          ),
          onTap: (){
            setState(() {
              !selected_pets.contains(pet.id??'') ? selected_pets.add(pet.id??'') : selected_pets.remove(pet.id??'');
            });
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

  Widget paymentList(){
    return Container(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // RadioListTile(
          //   contentPadding: EdgeInsets.all(0),
          //   title: Text('Gcash',style: TextStyle(color: text2Color),),
          //   value: 'Gcash', 
          //   groupValue: payment, 
          //   onChanged: (value){
          //     setState(() {
          //       payment = value!;
          //     });
          //   }
          // ),
          RadioListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text('Over The Counter',style: TextStyle(color: text2Color),),
            value: 'Over The Counter', 
            groupValue: payment, 
            onChanged: (value){
              setState(() {
                payment = value!;
              });
            }
          ),
        ],
      ),
    );
  }

  Widget formAppointment(){
    return Form(
      key: _key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textFormField("Reason", 0, TextInputType.multiline),
          getDateAppointment(),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('My Pet List',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: petList(),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('Payment:',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          ),
          paymentList()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setState(() {
      clinic = widget.clinic;
    });

    return AlertDialog(
      title: Text('Set Appointment',style: TextStyle(fontSize: 20,color: text2Color),),
      content: Container(
        height: size.height*.45,
        child: SizedBox(
          height: size.height*.30,
          width: double.infinity,
          child: SingleChildScrollView(
            child: formAppointment()
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          child: Text('Cancel',style: TextStyle(color: text1Color),),
          style:  buttonStyleA(80,30,25,text4Color)
        ),
        TextButton(
          onPressed: () async {
            if(!await validation()){
              return CherryToast.error(
                title: Text('Error Input!'),
                toastPosition: Position.bottom,
                displayCloseButton: false,
                animationType: AnimationType.fromRight,
              ).show(context); 
            }
            if(checkConflictSchedule(DateTime.parse(schedule))){
              return CherryToast.error(
                title: Text('Schedule not available!'),
                toastPosition: Position.bottom,
                displayCloseButton: false,
                animationType: AnimationType.fromRight,
              ).show(context); 
            }
            if(!await afterValidation()){
              return CherryToast.error(
                title: Text('Set Appointment on Error!'),
                toastPosition: Position.bottom,
                displayCloseButton: false,
                animationType: AnimationType.fromRight,
              ).show(context); 
            }
            FirebaseMessagingService.sendMessageNotification('Appointment', await DataStorage.getData('username'), 'Pet Apointment', apointment?.reason??'', clinic!.fcm_tokens);
            Navigator.pop(context);
            CherryToast.success(
              title: Text('Set Appointment Successfuly!'),
              toastPosition: Position.bottom,
              displayCloseButton: false,
              animationType: AnimationType.fromRight,
            ).show(context);
          }, 
          child: Text('Set',style: TextStyle(color: text1Color),),
          style: buttonStyleA(80, 30, 25, primaryColor)
        )
      ],
    );
  }
}
