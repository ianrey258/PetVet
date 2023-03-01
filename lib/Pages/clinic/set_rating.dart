import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:vetfindapp/Model/clinicModel.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';

class SetRating extends StatefulWidget {
  final ClinicData? data;
  const SetRating({Key? key,this.data}) : super(key: key);

  @override
  _SetRatingState createState() => _SetRatingState();
}

class _SetRatingState extends State<SetRating> {
  final ScrollController _sc = ScrollController();
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  ClinicData? clinic;

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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setState(() {
      clinic = widget.data;
    });

    return RatingDialog(
      title: Text(clinic?.name??"",textAlign: TextAlign.center),
      image: Image.asset(clinic?.img??"",fit: BoxFit.contain,width: 50,height: 50),
      message: Text('Rate me and have a comment for my clinic services!',textAlign: TextAlign.center,style: TextStyle(fontSize: 15),), 
      submitButtonText: 'Submit', 
      onSubmitted: (response){  
        CherryToast(
          icon: FontAwesomeIcons.star,
          iconColor: text6Color,
          themeColor: text6Color,
          title: Text('Thanks for Rating!'),
          toastPosition: Position.bottom,
          displayCloseButton: false,
          animationType: AnimationType.fromTop,
        ).show(context);
      }
    );
  }
}
