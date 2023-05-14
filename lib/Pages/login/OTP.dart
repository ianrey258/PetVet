// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetfindapp/Controller/UserController.dart';
import 'package:vetfindapp/Pages/LoadingScreen/LoadingScreen.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';
import 'package:pinput/pinput.dart';

class OTP extends StatefulWidget {
  final List<TextEditingController>? text;
  const OTP({super.key,this.text});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  bool obscure = true;
  Color focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
  Color fillColor = Color.fromRGBO(243, 246, 249, 0);
  Color borderColor = Color.fromRGBO(23, 171, 144, 0.4);
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  EmailOTP myauth = EmailOTP();

  @override
  initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
      }
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _setSendOTP() async {
    myauth.setSMTP(
      host: smtp_host,
      auth: true,
      username: smtp_email,
      password: smtp_key,
      secure: "TLS",
      port: 587
    );
    myauth.setConfig(
      appEmail: "vetfinder@mail.com",
      appName: "Vet Finder",
      userEmail: text[0].text,
      otpLength: 4,
      otpType: OTPType.digitsOnly
    );
    await myauth.sendOTP();
  }

  void _verifiedUser() async {
    if(!await UserController.loginUser(text)){
      return CherryToast.error(title: Text("Error Login!", style: TextStyle(fontSize: 12),),).show(context);
    }
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, '/dashboard');
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        color: text1Color,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
    );

    setState((){
      final data = ModalRoute.of(context)!.settings.arguments as List<TextEditingController>;
      if(data.isNotEmpty && text[0].text == ''){
        text = data;
        if(text.length > 0){
          _setSendOTP();
        }
      }
    });

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Container(
              height: size.height*.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Verification",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: 50,),
                  Text("Enter the otp code sent on the email",style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                  SizedBox(height: 20,),
                  Center(
                    child: Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Directionality(
                            // Specify direction if desired
                            textDirection: TextDirection.ltr,
                            child: Pinput(
                              controller: pinController,
                              focusNode: focusNode,
                              androidSmsAutofillMethod:
                                  AndroidSmsAutofillMethod.smsUserConsentApi,
                              listenForMultipleSmsOnAndroid: true,
                              defaultPinTheme: defaultPinTheme,
                              validator: (value) {
                                return myauth.verifyOTP(otp: value) ? null : 'Wrong Code';
                              },
                              // onClipboardFound: (value) {
                              //   debugPrint('onClipboardFound: $value');
                              //   pinController.setText(value);
                              // },
                              hapticFeedbackType: HapticFeedbackType.heavyImpact,
                              onCompleted: (pin) {
                                if(myauth.verifyOTP(otp: pin)){
                                  _verifiedUser();
                                }
                                debugPrint('onCompleted: $pin');

                              },
                              onChanged: (value) {
                                debugPrint('onChanged: $value');
                              },
                              cursor: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 9),
                                    width: 22,
                                    height: 1,
                                    color: focusedBorderColor,
                                  ),
                                ],
                              ),
                              focusedPinTheme: defaultPinTheme.copyWith(
                                decoration: defaultPinTheme.decoration!.copyWith(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: focusedBorderColor),
                                ),
                              ),
                              submittedPinTheme: defaultPinTheme.copyWith(
                                decoration: defaultPinTheme.decoration!.copyWith(
                                  color: fillColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: focusedBorderColor),
                                ),
                              ),
                              errorPinTheme: defaultPinTheme.copyBorderWith(
                                border: Border.all(color: Colors.redAccent),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          TextButton(
                            onPressed: () async {
                              focusNode.unfocus();
                              // _key.currentState!.validate();
                              print(await myauth.sendOTP());
                            },
                            child: const Text('Resend Code'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}