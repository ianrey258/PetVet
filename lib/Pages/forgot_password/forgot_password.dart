// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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

  Widget resetButton(){
    return TextButton.icon(
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
      onPressed: (){
        Navigator.pushNamed(context, '/reset_password');
      },
    );
  }

  Widget loginTextButton(){
    return RichText(
      text:TextSpan(
        text: "Already have an Account!",
        style: TextStyle(
          color: Color.fromRGBO(0,207,253,1)
        ),
        recognizer: TapGestureRecognizer()..onTap =() => Navigator.popAndPushNamed(context, '/login')
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Container(
              height: size.height*.80,
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
                              "Email Address",
                              style: TextStyle(
                                fontSize: 30
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                            child:Text(
                              "We just need some information",
                              style: TextStyle(
                                fontSize: 15
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                            child: Text(
                              "about your email",
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
                    flex: 6,
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _textFormField("Email", 0, TextInputType.text),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: loginTextButton(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Center(child: resetButton()),
                          ),
                        ],
                      )
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