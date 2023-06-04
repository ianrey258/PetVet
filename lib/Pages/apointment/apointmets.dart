import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetfindapp/Controller/ApointmentController.dart';
import 'package:vetfindapp/Controller/ClinicController.dart';
import 'package:vetfindapp/Model/apointmentModel.dart';
import 'package:vetfindapp/Model/clinicModel.dart';
import 'package:vetfindapp/Pages/LoadingScreen/loadingscreen.dart';
import 'package:vetfindapp/Pages/_helper/image_loader.dart';
import 'package:vetfindapp/Pages/apointment/show_appointment.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';

class Apointments extends StatefulWidget {
  const Apointments({Key? key}) : super(key: key);

  @override
  _ApointmentsState createState() => _ApointmentsState();
}

class _ApointmentsState extends State<Apointments> {
  final ScrollController _sc = ScrollController();
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  ClinicModel? clinic;
  List<Map<String,Object>> apointments = [];
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
    apointments = [];
    List _apointments = await ApointmentController.getApointments();
    _apointments.forEach((apointment) async {
      ClinicModel clinic = await ClinicController.getClinic(apointment.clinic_id??'');
      setState(() {  
        apointments.add({
          "apointment":apointment,
          "clinic": clinic,
        });
      });
    });
  }

  refreshPage(){
    refresh = !refresh;
  }

  void removeApointment(ClinicApointmentModel apointment) async {
    if(await LoadingScreen1.showAlertDialog1(context,'Are you sure to cancel?',18)){
      await ApointmentController.removeApointment(apointment.id??"");
      setState(() {
        apointments.removeWhere((data) => data['apointment'] == apointment);
      });
      CherryToast.success(title: Text("Remove Successfuly!")).show(context);
    }
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

  Future<dynamic> showAppointment(ClinicApointmentModel _apointment){
    return showDialog(
      context: context,
      builder: (context) => ShowAppointment(apointment: _apointment)
    );
  }

  Widget apointment(Map _apointments) {
    ClinicApointmentModel? apointment = _apointments['apointment'];
    ClinicModel? clinic = _apointments['clinic'];
    return Card(
      elevation: 5,
      child: ListTile(
        tileColor: apointment?.pet_owner_read_status == 'true' ? text1Color : text7Color,
        style: ListTileStyle.list,
        leading: clinic?.clinic_img != "" ? ImageLoader.loadImageNetwork(clinic?.clinic_img??"",50.0,50.0) : FaIcon(Icons.store,size: 50),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(clinic?.clinic_name??""),
            Text("${DateFormat.yMd().format(DateTime.parse(apointment?.schedule_datetime??""))}")
          ],
        ),
        subtitle: Text(apointment?.status??"",style: TextStyle(color: statusColor(apointment?.status)),),
        trailing: Container(
          // width: 90,
          child: IconButton(
            icon: FaIcon(Icons.cancel,size: 35,color: text4Color,),
            onPressed: () async => removeApointment(apointment!),
          ),
        ),
        onTap: ()=> showAppointment(apointment!),
      ),
    );   
  }

  List<Widget> apointmentList(){
    if(apointments.isEmpty){
      return [Center(child: Text("No Apointment"),)];
    }
    return apointments.map((Map data) => apointment(data)).toList();
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
              children: apointmentList(),
            ),
          ),
        ),
      ),
    );
  }
}
