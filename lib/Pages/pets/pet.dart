import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetfindapp/Controller/PetController.dart';
import 'package:vetfindapp/Model/petModel.dart';
import 'package:vetfindapp/Pages/_helper/image_loader.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';


class Pet extends StatefulWidget {
  final PetModel? data;
  const Pet({Key? key,this.data}) : super(key: key);

  @override
  _PetState createState() => _PetState();
}

class _PetState extends State<Pet> {
  final ScrollController _sc = ScrollController();
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  String local_img_path = "";
  PetModel? pet = PetModel("","","","","","");
  List<String> pet_types = AnimalData.getAnimalTypes();

  @override
  initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
      }
    });
  }

  // @override
  // void dispose() {
  //   text[1].dispose();
  //   super.dispose();
  // }

  Future<bool> validation() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      setState(() {
        pet?.pet_name = text[0].text;
        pet?.pet_type = text[1].text;
        pet?.pet_gender = text[2].text;
      });
      return true;
    }
    return false;
  }

  Future<bool> afterValidate() async {
    try {
        PetModel result = pet!;
        if(pet?.id == ""){
          result = await PetController.insertPet(text);
        }
        if(local_img_path.isNotEmpty){
          result.pet_img = await PetController.setPetPicture(result.id??"", pet?.pet_img??"");
        }
        await PetController.updatePet(result);
        return true;
      } catch (e) {
        return false;
      }
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
  
  Widget _dropDownFormField(String name, int controller) {
    List<DropdownMenuEntry> choices = [];
    if(name == "Type"){
      choices = pet_types.map((data) => DropdownMenuEntry(value: data, label: data)).toList();
    }
    if(name == "Gender"){
      choices = ["Male","Female"].map((data) => DropdownMenuEntry(value: data, label: data)).toList();
    }
    return Container(
      padding: EdgeInsets.all(0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
            child: DropdownMenu(
              controller: text[controller],
              initialSelection: text[controller].text,
              dropdownMenuEntries: choices,
              inputDecorationTheme: InputDecorationTheme(
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
            ),
          ),
        ],
      ),
    );
  }

  Widget formPet(){
    return Form(
      key: _key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 110,
            child: Center(
              child: IconButton(
                iconSize: 100,
                onPressed: () async {
                  final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery,);
                    if(image != null){
                      Future.delayed(Duration(seconds: 2),(){
                        setState(() {
                          pet?.pet_img = image.path;
                          local_img_path = image.path;
                        });
                      });
                    }
                },
                icon: local_img_path == "" && pet?.pet_img != "" ? ImageLoader.loadImageNetwork(pet?.pet_img??"",100.0,100.0) : local_img_path != "" ? ImageLoader.loadImageFile(local_img_path,100.0,100.0) : FaIcon(Icons.add_a_photo_rounded,size: 100,)
              ),
            ),
          ),
          _textFormField("Pet Name", 0, TextInputType.name),
          _dropDownFormField("Type", 1),
          _dropDownFormField("Gender", 2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setState(() {
      final data = ModalRoute.of(context)!.settings.arguments;
      if(data != null){
        pet = data as PetModel;
        text[0].text = pet?.pet_name??"";
        text[1].text = pet?.pet_type??"";
        text[2].text = pet?.pet_gender??"";
      }
    });
    return AlertDialog(
      title: Text('Pet Detail',style: TextStyle(fontSize: 20,color: text2Color),),
      content: Container(
        height: size.height*.35,
        child: SizedBox(
          height: size.height*.30,
          width: double.infinity,
          child: SingleChildScrollView(
            child: formPet()
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            
          }, 
          child: Text('Cancel',style: TextStyle(color: text1Color),),
          style: buttonStyleA(80, 30, 25, text4Color),
        ),
        TextButton(
          onPressed: () async { 
            if(!await validation()){
              return null;
            }
            if(await afterValidate()){
              Navigator.pop(context);
              CherryToast.success(
                title: Text((pet?.id != "" ? 'Save Successfully!':'Pet Added!')),
                toastPosition: Position.bottom,
                displayCloseButton: false,
                animationType: AnimationType.fromRight,
              ).show(context);
            }else{
              CherryToast.error(
                title: Text((pet?.id != "" ? 'Error Save!':'Error on Add!')),
                toastPosition: Position.bottom,
                displayCloseButton: false,
                animationType: AnimationType.fromRight,
              ).show(context);
            }
            
          }, 
          child: Text((pet?.id != "" ? 'Save':'Add'),style: TextStyle(color: text1Color),),
          style: buttonStyleA(80, 30, 25, primaryColor),
        )
      ],
    );
  }
}
