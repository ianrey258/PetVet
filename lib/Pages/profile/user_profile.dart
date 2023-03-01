// ignore_for_file: prefer_const_constructors
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetfindapp/Controller/UserController.dart';
import 'package:vetfindapp/Model/userModel.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';



class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<FormState>();
  bool obscure = true;
  UserModel? user;
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
    final id = await DataStorage.getData('id');
    user = await UserController.getUser(id);
    setState(() {
      user = user;
      text[0].text = user?.username??""; 
      text[1].text = user?.fullname??""; 
      text[2].text = user?.birthdate??""; 
      text[3].text = user?.address??""; 
      text[4].text = user?.email??""; 
    });
  }

  validation() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      // LoadingScreen1.showLoadingNoMsg(context);
      try {
        var result = await UserController.updateUserProfile(text);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
  
  Widget _textFormField(String name, int controller, TextInputType type) {
    var read_only = name == "Email Address" ? true : false;
    var obscures = name != 'Password' ? false : obscure;
    Widget showPassword = name != 'Password'
        ? SizedBox.shrink()
        : IconButton(
            icon: FaIcon(
              FontAwesomeIcons.eyeSlash,
              color: secondaryColor,
            ),
            onPressed: () {
              setState(() {
                obscure = obscure ? false : true;
              });
            },
          );

    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: TextStyle(color: secondaryColor),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: TextFormField(
              obscureText: obscures,
              readOnly: read_only,
              keyboardType: type,
              controller: text[controller],
              style: TextStyle(fontSize: 18, color: secondaryColor),
              cursorColor: secondaryColor,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                fillColor: text3Color,
                filled: true,
                // labelText: name,
                suffixIcon: showPassword,
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

  Widget resetPassword(){
    return TextButton(
      onPressed: () async {
        UserController.sendResetPassword(user?.email??"");
        CherryToast.success(title: Text("Email Sent!")).show(context);
      },
      child: Text("Send Reset Password",style: TextStyle(color: secondaryColor),),
      style: buttonStyleA(100, 50, 10, primaryColor),
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
                    text: "Save",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: text1Color
                    ),
                    recognizer: TapGestureRecognizer()..onTap =() async {
                      if(!(await validation())){
                        return CherryToast.error(title: Text("Update Unsuccessful!"),toastPosition: Position.bottom,).show(context);
                      }
                      return CherryToast.success(title: Text("Update Successfuly!"),toastPosition: Position.bottom).show(context);
                    }
                  )
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Container(
              padding: EdgeInsets.all(10),
              height: size.height,
              child: ListView(
                children: [
                  _textFormField("Username",0,TextInputType.name),
                  _textFormField("FullName",1,TextInputType.name),
                  _textFormField("Birthdate",2,TextInputType.datetime),
                  _textFormField("Address",3,TextInputType.streetAddress),
                  _textFormField("Email Address",4,TextInputType.emailAddress),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: resetPassword(),
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}