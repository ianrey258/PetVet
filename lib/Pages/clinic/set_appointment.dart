import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';


class SetAppointment extends StatefulWidget {
  const SetAppointment({Key? key}) : super(key: key);

  @override
  _SetAppointmentState createState() => _SetAppointmentState();
}

class _SetAppointmentState extends State<SetAppointment> {
  final ScrollController _sc = ScrollController();
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  List<bool> _values = [false,false,false];
  String payment = ''; 
  final datetime_format = DateFormat("yyyy-MM-dd HH:mm");

  @override
  initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
      }
    });
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
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    );
  }

  Widget pet({image='assets/images/cat.jpg',required title,required checkedIndex}){
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
            child: Image.asset(image,height: double.infinity,width: 50)
          ),
          title: Text(title,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: text2Color),),
          trailing: Container(
            width: 50,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50)
            ),
            child: Checkbox(
              value: _values[checkedIndex],
              onChanged: (bool? value){
                setState(() {
                  _values[checkedIndex] = value!;
                });
              },
            )
          ),
          onTap: (){
            setState(() {
              _values[checkedIndex] = !_values[checkedIndex];
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
          children: [
            pet(title: 'Bruno',image: 'assets/images/cat.jpg',checkedIndex: 0),
            pet(title: 'Chella',image: 'assets/images/cat.jpg',checkedIndex: 1),
            pet(title: 'Mika',image: 'assets/images/cat.jpg',checkedIndex: 2),
          ],
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
          RadioListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text('Gcash',style: TextStyle(color: text2Color),),
            value: 'Gcash', 
            groupValue: payment, 
            onChanged: (value){
              setState(() {
                payment = value!;
              });
            }
          ),
          RadioListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text('Payment on Clinic',style: TextStyle(color: text2Color),),
            value: 'Payment on Clinic', 
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
          onPressed: (){
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
