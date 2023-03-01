// ignore_for_file: prefer_const_constructors
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetfindapp/Controller/PetController.dart';
import 'package:vetfindapp/Controller/UserController.dart';
import 'package:vetfindapp/Model/petModel.dart';
import 'package:vetfindapp/Model/userModel.dart';
import 'package:vetfindapp/Pages/_helper/image_loader.dart';
import 'package:vetfindapp/Pages/pets/pet.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';


class Pets extends StatefulWidget {
  const Pets({super.key});

  @override
  State<Pets> createState() => _PetsState();
}

class _PetsState extends State<Pets> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<FormState>();
  List<TextEditingController> text = [];

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

  initLoadData()async {
    // final id = await DataStorage.getData('id');
    // user = await UserController.getUser(id);
    // setState(() {
    //   user = user;
    //   text[0].text = user?.username??""; 
    //   text[1].text = user?.fullname??""; 
    //   text[2].text = user?.birthdate??""; 
    //   text[3].text = user?.address??""; 
    //   text[4].text = user?.email??""; 
    // });
  }

  Future<dynamic> showPetDialog([PetModel? pet]){
    return showDialog(
      context: context,
      builder: (context) => Pet(),
      routeSettings: pet != null ? RouteSettings(arguments: pet): null
    );
  }

  Widget showPets(List<PetModel> _pets){
    return ListView(
      children: _pets.map((pet) =>
        ListTile(
          leading: CircleAvatar(
            radius: 50,
            backgroundColor: text0Color,
            child: ClipOval(
              child: pet.pet_img != "" ? ImageLoader.loadImageNetwork(pet.pet_img??"",50.0,50.0) : FaIcon(Icons.pets,size: 50),
            ),
          ),
          title: Text(pet.pet_name??""),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(pet.pet_type??""),
              Text(pet.pet_gender??""),
            ],
          ),
          trailing: Container(
            child: IconButton(
              icon: FaIcon(Icons.edit_square,size: 35,),
              onPressed: () async => await showPetDialog(pet),
            ),
          ),
        ) 
      ).toList(),
    ); 
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: text1Color,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Image.asset(logoImg,fit: BoxFit.contain),
          actions: [
            Center(
              child: Container(
                padding: EdgeInsets.only(right: 10),
                child: RichText(
                  text: TextSpan(
                    text: "Add",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: text1Color
                    ),
                    recognizer: TapGestureRecognizer()..onTap =() async {
                      showPetDialog();
                    }
                  )
                ),
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          height: size.height,
          child: StreamBuilder(
              stream: PetController.getPetList().asStream(),
              builder: (BuildContext context, AsyncSnapshot<List<PetModel>> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                if(snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty){
                  return showPets(snapshot.data!);
                }
                if(snapshot.connectionState == ConnectionState.done && snapshot.data!.isEmpty){
                  return Center(child: Text('No Pets',style: TextStyle(color: text2Color),));
                }
                return Container();
              },
            ),
        )
      ),
    );
  }
}