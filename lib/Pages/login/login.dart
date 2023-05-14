// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetfindapp/Controller/UserController.dart';
import 'package:vetfindapp/Pages/LoadingScreen/LoadingScreen.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  bool obscure = true;

  @override
  initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
      }
    });
    UserController.logoutUser();
  }

  validation() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      LoadingScreen1.showLoadingNoMsg(context);
      try {
        var result = await UserController.verifyUser(text);
        return result;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  Widget _textFormField(String name, int controller, TextInputType type) {
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
              style: TextStyle(color: text1Color),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: TextFormField(
              obscureText: obscures,
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

  Widget loginButton(){
    return TextButton.icon(
      onPressed: () async {
        if(_key.currentState!.validate()){
          if(await validation()){
            Navigator.pop(context);
            Navigator.pushNamed(context, '/otp', arguments: text);
          }else{
            Navigator.pop(context);
            CherryToast.error(title: Text("Check Username/Password!", style: TextStyle(fontSize: 12),),).show(context);
          }
        }
      },
      icon: Padding(
        padding: EdgeInsets.only(left: 8),
        child: FaIcon(FontAwesomeIcons.arrowRight,color: text1Color, size: 30,),
      ),
      label: Text(""),
      style: buttonStyleA(30, 50, 10,primaryColor),
    );
  }

  Widget registerButton(){
    return RichText(
      text:TextSpan(
        text: "Dont have an Account",
        style: TextStyle(
          color: primaryColor
        ),
        recognizer: TapGestureRecognizer()..onTap =(){
          Navigator.pushNamed(context, '/register');
        }
      )
    );
  }
  
  Widget forgotPasswordButton(){
    return RichText(
      text:TextSpan(
        text: "Forgot password?",
        style: TextStyle(
          color: primaryColor
        ),
        recognizer: TapGestureRecognizer()..onTap =(){
          Navigator.pushNamed(context, '/forgot_password');
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Container(
              height: size.height*.95,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Image.asset(logoImg,fit: BoxFit.contain),
                    )
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          SizedBox(
                            height: 35,
                            child:Text(
                              "Welcome to VetFind",
                              style: TextStyle(
                                fontSize: 30
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                            child: Text(
                              "Sign in with your email or",
                              style: TextStyle(
                                fontSize: 15
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                            child: Text(
                              "password or sociel media to",
                              style: TextStyle(
                                fontSize: 15
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                            child: Text(
                              "continue",
                              style: TextStyle(
                                fontSize: 15
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  Expanded(
                    flex: 5,
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _textFormField("Email", 0, TextInputType.text),
                          _textFormField("Password", 1, TextInputType.visiblePassword),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: registerButton(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: forgotPasswordButton(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Center(child: loginButton()),
                          ),
                        ],
                      )
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      // child: Text("By Continuing you agree to "),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("By Continuing you agree to "),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "our "
                                ),
                                TextSpan(
                                  text: "terms and conditions",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold 
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap =() => {}
                                )
                              ]
                            )
                          ),
                        ],
                      ),
                    )
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}