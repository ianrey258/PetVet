// ignore_for_file: prefer_const_constructors
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:vetfindapp/Controller/ApointmentController.dart';
import 'package:vetfindapp/Controller/RatingController.dart';
import 'package:vetfindapp/Controller/UserController.dart';
import 'package:vetfindapp/Model/clinicModel.dart';
import 'package:vetfindapp/Model/reviewModel.dart';
import 'package:vetfindapp/Model/userModel.dart';
import 'package:vetfindapp/Pages/_helper/image_loader.dart';
import 'package:vetfindapp/Pages/clinic/set_appointment.dart';
import 'package:vetfindapp/Pages/clinic/set_rating.dart';
import 'package:vetfindapp/Services/firebase_messaging.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';
import 'package:badges/badges.dart' as badges;

class VetClinic extends StatefulWidget {
  final ClinicData? data;
  const VetClinic({super.key,this.data});

  @override
  State<VetClinic> createState() => _VetClinicState();
}

class _VetClinicState extends State<VetClinic> {
  List<TextEditingController> text = [];
  int unread_appointment = 0;
  double clinic_rating = 0.0;
  final _key = GlobalKey<FormState>();
  ClinicModel? clinic;
  UserModel? user;
  final ImagePicker _picker = ImagePicker();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _services = ['Surgical','Anesthesi','Laboratory','Dietary Counseling']; 
  List<Map<String,dynamic>> reviewsList = [];

  @override
  initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
      }
    });
    FirebaseMessagingService.initPermission();
    FirebaseMessagingService.initListenerForground(context);
    FirebaseMessagingService.awesomeNotificationButtonListener(context);
    initLoadData();
    setUnreadApointmentBadge();
  }

  initLoadData()async {
    final id = await DataStorage.getData('id');
    user = await UserController.getUser(id);
    reviewsList = [];
    clinic_rating = await RatingReviewController.getRatingClinic(clinic?.id);
    List clinic_revews_list = await RatingReviewController.getRatingReviewClinicList(clinic?.id);
    clinic_revews_list.forEach((clinic_review) async { 
      RatingReviewModel clinic_rev = clinic_review;
      UserModel user_review = await UserController.getUser(clinic_rev.user_id??'');
      setState(() {
        reviewsList.add({
          "user": user_review,
          "review": clinic_rev
        });
      });
    });
    setState(() {
      user = user;
      clinic_rating = clinic_rating; 
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

  Future setUnreadApointmentBadge() async {
    List user_appointment_list = await ApointmentController.getUnreadApointments()??[];
    if(unread_appointment != user_appointment_list.length){
      setState(() {
        unread_appointment = user_appointment_list.length;
      });
    }
  }

  logout(){
    UserController.logoutUser();
    Navigator.popAndPushNamed(context,'/loading_screen');
  }

  Future<dynamic> showSetAppointment(){
    return showDialog(
      context: context,
      builder: (context) => SetAppointment(clinic: clinic)
    );
  }
  
  Future<dynamic> showSetRating(){
    return showDialog(
      context: context,
      builder: (context) => SetRating(data: clinic)
    );
  }

  Widget drawerContainerItem(icon,text){
    return ListTile(
      leading: FaIcon(icon,size: 25,color: text1Color,),
      title: "Apointments" == text && unread_appointment != 0 ? Container(
        child: badges.Badge(
          position: badges.BadgePosition.topEnd(top: -10, end: -12),
          showBadge: true,
          ignorePointer: false,
          onTap: () {},
          badgeContent: Text(unread_appointment.toString()),
          child: Text(text,style: TextStyle(fontSize: 25),),
        ), 
      ) : Text(text,style: TextStyle(fontSize: 25),),
      trailing: Icon(Icons.arrow_forward_ios_sharp,color: text1Color,),
      onTap: (){
        Navigator.pop(context);
        text == "Home" ? Navigator.popAndPushNamed(context,'/dashboard')
        : text == "Map" ? Navigator.pushNamed(context, '/map_clinic')
        : text == "Apointments" ? Navigator.pushNamed(context, '/apointments')
        : text == "Messages" ? Navigator.pushNamed(context, '/messages')
        : text == "Pets" ? Navigator.pushNamed(context, '/pets')
        : text == "History" ? ''
        : text == "Settings" ? ''
        : text == "Logout" ? logout()
        : null;
      },
    );
  }
  
  Widget profileImage(){
    return IconButton(
      onPressed: () async {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if(image != null){
          String img_path = await UserController.setUserPicture(image?.path??"");
          Future.delayed(Duration(seconds: 2),(){
            setState(() {
              user?.profile_img = img_path;
            });
          });
        }
      }, 
      icon: CircleAvatar(
        radius: 100,
        backgroundColor: text0Color,
        child: ClipOval(
          child: user?.profile_img != "" ? ImageLoader.loadImageNetwork(user?.profile_img??"",150.0,150.0) : FaIcon(FontAwesomeIcons.circleUser,size: 150,color: text1Color,),
        ),
      )
    );
  }

  Widget drawerContainer(){
    return ListView(
      children: [        
        SizedBox(
          height: 200,
          child: Container(
            child: profileImage()
          ),
        ),
        SizedBox(
          height: 50,
          child: Center(
            child: Text(user?.username??"",style: TextStyle(fontSize: 25),),
          ),
        ),
        drawerContainerItem(Icons.home,'Home'),
        drawerContainerItem(FontAwesomeIcons.mapLocationDot,'Map'),
        drawerContainerItem(FontAwesomeIcons.objectGroup,'Apointments'),
        drawerContainerItem(FontAwesomeIcons.message,'Messages'),
        drawerContainerItem(Icons.pets,'Pets'),
        // drawerContainerItem(Icons.history,'History'),
        // drawerContainerItem(FontAwesomeIcons.userGear,'Settings'),
        drawerContainerItem(Icons.logout,'Logout'),
      ],
    );
  }

  BottomNavigationBarItem buttomNavigationItem(icon){
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: FaIcon(icon),
      ),
      label: ""
    );
  }

  Widget clinicDetails(clinicname,rating,distance){
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          ListTile(
            title: Text(clinicname??"",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: text2Color),),
            trailing: Container(
              child: TextButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/message',arguments: clinic);
                }, 
                child: Text('Send Message',style: TextStyle(color: text1Color),),
                style: buttonStyleA(115, 30, 25, primaryColor)
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Text(distance,style: TextStyle(fontSize: 18,color: text7Color),),
                  VerticalDivider(
                    width: 10,
                    color: text7Color,
                    thickness: 0.9,
                  ),
                  SmoothStarRating(
                    starCount: 5,
                    rating: rating,
                    color: text6Color,
                    onRatingChanged: (rating) {
                      showSetRating().then((value) => initLoadData());
                    },
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 10,
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Wrap(
              children: clinic!.services.map((service)=>Padding(
                padding:EdgeInsets.all(2.0),
                child: FilterChip(
                  backgroundColor: text1Color,
                  side: BorderSide(color: primaryColor,),
                  label: Text(service??"",style: TextStyle(color: text2Color,fontSize: 10),),
                  onSelected: (value){},
                ) 
              )).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget clinicAddress(address){
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          Container(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(address??"",style: TextStyle(color: text2Color, fontSize: 12),),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 30),
            child: MaterialButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.pushNamed(context, '/map_clinic',arguments: clinic);
              },
              child: clinic!.clinic_img != "" || clinic!.clinic_img != null ? ImageLoader.loadImageNetwork(clinic!.clinic_img??"",150.0,150.0) : Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget clinicRatingReviews(rating){
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ListTile(
        title: Text('Rating and Reviews'),
        subtitle: SmoothStarRating(
          starCount: 5,
          rating: rating,
          color: text6Color,
        ),
        trailing: Container(
          padding: EdgeInsets.only(right: 10,bottom: 18),
          child: RichText(
            text: TextSpan(
              text: reviewsList.length.toString(),
              style: TextStyle(color: text7Color,fontSize: 15),
              recognizer: TapGestureRecognizer()..onTap =() => {}
            ),
          ),
        ),
      ),
    );
  }

  Widget clinicReviewsItem(UserModel? user,RatingReviewModel? review){
    return ListTile(
      contentPadding: EdgeInsets.all(5),
      style: ListTileStyle.list,
      leading: user?.profile_img != "" ? ImageLoader.loadImageNetwork(user?.profile_img??"",50.0,50.0) : FaIcon(FontAwesomeIcons.user,size: 50),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(user?.fullname??""),
          Text(DateFormat.yMd().format(DateTime.parse(review?.datatime??""))),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(review?.comment??""),
          SmoothStarRating(
            starCount: 5,
            rating: double.parse(review?.rate??'0.0'),
            color: text6Color,
          ),
        ],
      ),
    );
  }
  
  Widget clinicReviews(){
    return Column(
      children: reviewsList.map((_user_review) => clinicReviewsItem(_user_review['user'],_user_review['review'])).toList(),
    );
    // return SizedBox(
    //   height: 100,
    //   width: double.infinity,
    //   child: ListTile(
    //     title: Text('Rating and Reviews'),
    //     subtitle: SmoothStarRating(
    //       starCount: 5,
    //       rating: rating,
    //       color: text6Color,
    //     ),
    //     trailing: Container(
    //       padding: EdgeInsets.only(right: 10,bottom: 18),
    //       child: RichText(
    //         text: TextSpan(
    //           text: "See All",
    //           style: TextStyle(color: text7Color,fontSize: 12),
    //           recognizer: TapGestureRecognizer()..onTap =() => {}
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setState(() {
      final data = ModalRoute.of(context)!.settings.arguments as ClinicModel;
      clinic = data;
    });
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: text1Color,
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverAppBar(
              foregroundColor: text0Color,
              backgroundColor: text0Color,
              forceElevated: false,
              expandedHeight: MediaQuery.of(context).size.height*.4,
              pinned: false,
              toolbarHeight: 50,
              leading: Container(),
              actions: [
                IconButton(
                  onPressed: (){
                     Navigator.popAndPushNamed(context, '/dashboard');
                  }, 
                  icon: FaIcon(FontAwesomeIcons.xmark,color: text1Color,)
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: clinic!.clinic_img_banner != "" || clinic!.clinic_img_banner != null ? ImageLoader.loadImageNetwork(clinic!.clinic_img_banner??"",150.0,150.0) : Container(),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                clinicDetails(clinic?.clinic_name,clinic_rating,'1.3 Kilometers'),
                Divider(),
                clinicAddress(clinic?.clinic_address),
                clinicRatingReviews(clinic_rating),
                clinicReviews(),
                SizedBox.square(dimension: 80,)
              ]),
            ),
          ],
        ),
        drawer: Drawer(
          width: size.width*.7,
          backgroundColor: alternativeColor,
          child: drawerContainer(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: secondaryColor,
          selectedItemColor: primaryColor,
          unselectedItemColor: text1Color,
          currentIndex: 1,
          elevation: 0,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            buttomNavigationItem(FontAwesomeIcons.bars),
            buttomNavigationItem(FontAwesomeIcons.house),
            buttomNavigationItem(FontAwesomeIcons.mapLocationDot),
          ],
          onTap: (value) {
            if(value == 0){
              _scaffoldKey.currentState?.openDrawer();
            }
            if(value == 1){
              Navigator.popAndPushNamed(context, '/dashboard');
            }
            if(value == 2){
              Navigator.pushNamed(context, '/map_clinic');
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Set Appointment'),
          backgroundColor: text4Color,
          onPressed: (){
            showSetAppointment();
          },
        ),
      ),
    );
  }
}