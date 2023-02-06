// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  }

  validation() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      // LoadingScreen1.showLoadingNoMsg(context);
      // try {
      //   var result = await FirebaseController.loginUser(text);
      //   return result;
      // } catch (e) {
      //   return false;
      // }
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
              color: Color.fromRGBO(66,74,109, 1),
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
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: TextFormField(
              obscureText: obscures,
              keyboardType: type,
              controller: text[controller],
              style: TextStyle(fontSize: 18, color: Color.fromRGBO(66,74,109, 1)),
              cursorColor: Color.fromRGBO(66,74,109, 1),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                fillColor: Color.fromRGBO(229,229,229,1),
                filled: true,
                // labelText: name,
                suffixIcon: showPassword,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(66,74,109, 1)),
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
      onPressed: (){
        Navigator.popAndPushNamed(context, '/dashboard');
      },
      icon: FaIcon(FontAwesomeIcons.arrowRight,color: Colors.white, size: 30,),
      label: Text(""),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.only(left: 8)),
        fixedSize: MaterialStateProperty.all(Size(30, 50)),
        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(0,207,253,1)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          )
        )
      ),
    );
  }

  Widget registerButton(){
    return RichText(
      text:TextSpan(
        text: "Dont have an Account",
        style: TextStyle(
          color: Color.fromRGBO(0,207,253,1)
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
          color: Color.fromRGBO(0,207,253,1)
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
                      child: Image.asset('assets/images/Logo.png',fit: BoxFit.contain),
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