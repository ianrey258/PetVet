// ignore_for_file: prefer_const_constructors
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:vetfindapp/Pages/clinic/set_appointment.dart';
import 'package:vetfindapp/Pages/clinic/set_rating.dart';

class VetClinic extends StatefulWidget {
  const VetClinic({super.key});

  @override
  State<VetClinic> createState() => _VetClinicState();
}

class _VetClinicState extends State<VetClinic> {
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _services = ['Surgical','Anesthesi','Laboratory','Dietary Counseling']; 

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

  Future<dynamic> showSetAppointment(){
    return showDialog(
      context: context,
      builder: (context) => const SetAppointment()
    );
  }
  
  Future<dynamic> showSetRating(){
    return showDialog(
      context: context,
      builder: (context) => const SetRating()
    );
  }

  Widget drawerContainerItem(icon,text){
    return ListTile(
      leading: FaIcon(icon,size: 25,color: Colors.white,),
      title: Center(
        child: Text(text,style: TextStyle(fontSize: 25),),
      ),
      trailing: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
      onTap: (){
        Navigator.pop(context);
        text == "Home" ? Navigator.popAndPushNamed(context,'/dashboard')
        : text == "Map" ? Navigator.pushNamed(context, '/map_clinic')
        : text == "Category" ? ''
        : text == "Pets" ? ''
        : text == "History" ? ''
        : text == "Settings" ? ''
        : text == "Logout" ? Navigator.popAndPushNamed(context,'/login')
        : null;
      },
    );
  }
  Widget drawerContainer(){
    return ListView(
      children: [        
        SizedBox(
          height: 200,
          child: Container(
            child: IconButton(
              onPressed: (){}, 
              icon: FaIcon(FontAwesomeIcons.circleUser,size: 150,color: Colors.white,)
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: Center(
            child: Text('User',style: TextStyle(fontSize: 25),),
          ),
        ),
        drawerContainerItem(Icons.home,'Home'),
        drawerContainerItem(FontAwesomeIcons.mapLocationDot,'Map'),
        drawerContainerItem(FontAwesomeIcons.objectGroup,'Category'),
        drawerContainerItem(Icons.pets,'Pets'),
        drawerContainerItem(Icons.history,'History'),
        drawerContainerItem(FontAwesomeIcons.userGear,'Settings'),
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
      height: 200,
      width: double.infinity,
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          ListTile(
            title: Text(clinicname,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black),),
            trailing: Container(
              child: TextButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/message');
                }, 
                child: Text('Send Message',style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.only()),
                  fixedSize: MaterialStateProperty.all(Size(100, 30)),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                    )
                  )
                ),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Text(distance,style: TextStyle(fontSize: 18,color: Colors.grey),),
                  VerticalDivider(
                    width: 10,
                    color: Colors.grey,
                    thickness: 0.9,
                  ),
                  SmoothStarRating(
                    starCount: 5,
                    rating: rating,
                    color: Colors.yellow,
                    onRatingChanged: (rating){
                      showSetRating();
                    },
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Wrap(
              children: _services.map((e)=>Padding(
                padding:EdgeInsets.all(2.0),
                child: FilterChip(
                  backgroundColor: Colors.lightBlue,
                  label: Text(e,style: TextStyle(color: Colors.white,fontSize: 10),),
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
              child: Text(address,style: TextStyle(color: Colors.black, fontSize: 18),),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 30),
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(0))
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/map_clinic');
              },
              child: Image.asset('assets/images/cats_and_dogs_banner.png',fit: BoxFit.cover,width: 150,),
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
          color: Colors.yellow,
        ),
        trailing: Container(
          padding: EdgeInsets.only(right: 10,bottom: 18),
          child: RichText(
            text: TextSpan(
              text: "See All",
              style: TextStyle(color: Colors.grey,fontSize: 12),
              recognizer: TapGestureRecognizer()..onTap =() => {}
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverAppBar(
              foregroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
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
                  icon: FaIcon(FontAwesomeIcons.xmark,color: Colors.white,)
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset('assets/images/cats_and_dogs_banner.png',fit: BoxFit.cover),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                clinicDetails("Cats And Dog",4.0,'1.3 Kilometers'),
                Divider(),
                clinicAddress('Vamenta Carmen, Cagayan de Oro City'),
                clinicRatingReviews(4.0),
                SizedBox.square(dimension: 80,)
              ]),
            ),
          ],
        ),
        drawer: Drawer(
          width: size.width*.7,
          backgroundColor: Color.fromRGBO(19,50,64,1),
          child: drawerContainer(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(66,74,109, 1),
          selectedItemColor: Color.fromRGBO(0,207,253,1),
          unselectedItemColor: Colors.white,
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
          backgroundColor: Colors.red,
          onPressed: (){
            showSetAppointment();
          },
        ),
      ),
    );
  }
}