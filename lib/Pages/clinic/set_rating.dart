import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:vetfindapp/Controller/RatingController.dart';
import 'package:vetfindapp/Model/clinicModel.dart';
import 'package:vetfindapp/Model/reviewModel.dart';
import 'package:vetfindapp/Pages/_helper/image_loader.dart';
import 'package:vetfindapp/Services/firebase_messaging.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';

class SetRating extends StatefulWidget {
  final ClinicModel? data;
  const SetRating({Key? key,this.data}) : super(key: key);

  @override
  _SetRatingState createState() => _SetRatingState();
}

class _SetRatingState extends State<SetRating> {
  final ScrollController _sc = ScrollController();
  DateTime datatime = DateTime.now();
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  ClinicModel? clinic;
  RatingReviewModel? rating_review = RatingReviewModel(null,null,null,null,null); 

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
    RatingReviewModel _review_clinic = await RatingReviewController.getRatingReviewClinic(clinic?.id);
    if(_review_clinic.id != null){
      setState(() {
        rating_review = _review_clinic;
      });
    }
  }

  Future submitRating(rating,comment) async {
    String user_id = await DataStorage.getData('id');
    rating_review?.user_id = user_id;
    rating_review?.comment = comment;
    rating_review?.datatime = datatime.toString();
    rating_review?.rate = rating.toString();

    FirebaseMessagingService.sendMessageNotification(notification_type[2], "${await DataStorage.getData('username')} rated you ${rating_review?.rate!.split('.').first} star", 'Rating', rating_review?.comment??'', clinic!.fcm_tokens!,{});
    if (rating_review?.id != null){
      return await RatingReviewController.updateRatingReviewClinic(clinic?.id, rating_review!);
    }
    return await RatingReviewController.setRatingReviewClinic(clinic?.id, rating_review!);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setState(() {
      clinic = widget.data;
    });

    return RatingDialog(
      title: Text(clinic?.clinic_name??"",textAlign: TextAlign.center),
      image: clinic?.clinic_img != "" || clinic?.clinic_img != null ? ImageLoader.loadImageNetwork(clinic?.clinic_img??"",100.0,100.0) : FaIcon(FontAwesomeIcons.store,size: 50,color: text1Color),
      message: Text('Rate me and have a comment for my clinic services!',textAlign: TextAlign.center,style: TextStyle(fontSize: 15),), 
      submitButtonText: 'Submit', 
      initialRating: double.parse(rating_review?.rate??'0.0')??0.0, 
      commentHint: rating_review?.comment??'',
      onSubmitted: (RatingDialogResponse response) {

        if(response.rating == 0 || response.comment.isEmpty){
          CherryToast(
            icon: FontAwesomeIcons.warning,
            iconColor: text4Color,
            themeColor: text4Color,
            title: Text('Error Input Rating!'),
            toastPosition: Position.bottom,
            displayCloseButton: false,
            animationType: AnimationType.fromTop,
          ).show(context);
        }
        submitRating(response.rating, response.comment);
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
