// ignore_for_file: prefer_const_constructors
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:vetfindapp/Controller/FileController.dart';
import 'package:vetfindapp/Controller/UserController.dart';
import 'package:vetfindapp/Model/clinicModel.dart';
import 'package:vetfindapp/Model/userModel.dart';
import 'package:vetfindapp/Pages/_helper/image_loader.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool obscure = true;
  UserModel? user;
  final ImagePicker _picker = ImagePicker();
  List<BannerModel> listBanners = [
    BannerModel(imagePath: 'assets/images/puppy.png', id: "1",boxFit: BoxFit.contain),
    BannerModel(imagePath: 'assets/images/puppy.png', id: "2",boxFit: BoxFit.contain),
    BannerModel(imagePath: 'assets/images/puppy.png', id: "3",boxFit: BoxFit.contain),
    BannerModel(imagePath: 'assets/images/puppy.png', id: "4",boxFit: BoxFit.contain),
];

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

  logout(){
    UserController.logoutUser();
    Navigator.popAndPushNamed(context,'/loading_screen');
  }

  Widget drawerContainerItem(icon,text){
    return ListTile(
      leading: FaIcon(icon,size: 25,color: text1Color,),
      title: Center(
        child: Text(text,style: TextStyle(fontSize: 25),),
      ),
      trailing: Icon(Icons.arrow_forward_ios_sharp,color: text1Color,),
      onTap: (){
        Navigator.pop(context);
        text == "Home" ? _scaffoldKey.currentState?.closeDrawer()
        : text == "Map" ?  Navigator.pushNamed(context, '/map_clinic')
        : text == "Category" ? ''
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

  Widget greetings(){
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Column(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5,left: 5),
            child: Text(user?.username??"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: text2Color),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5,left: 5),
            child: Text('Good Morning!',style: TextStyle(fontSize: 20,color: text2Color),),
          )
        ],
      ),
    );
  }
  
  Widget feeds(){
    return SizedBox(
      height: 210,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(          
        ),
        child: BannerCarousel(
          banners: listBanners,
          margin: EdgeInsets.only(left: 10,right: 10),
          borderRadius: 10,
          height: 200,
          viewportFraction: .9,
          indicatorBottom: true,
          showIndicator: false,
          initialPage: 1,
        ),
      ),
    );
  }

  Widget categoryFilterItem(icon,text){
    return Container(
      height: 150,
      width: 100,
      padding: EdgeInsets.only(left: 5,right: 5),
      child: Column(
        children: [
          ElevatedButton(
            style: buttonStyleA(100,100,20,secondaryColor),
            onPressed: (){}, 
            child: Center(
              child: FaIcon(icon,size: 60,),
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(text,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: text7Color),),
          )
        ],
      ),
    );
  }
  
  Widget categoryFilter(){
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            categoryFilterItem(FontAwesomeIcons.paw,'Mammals'),
            categoryFilterItem(FontAwesomeIcons.staffSnake,'Reptile'),
            categoryFilterItem(FontAwesomeIcons.fish,'Fish'),
            categoryFilterItem(FontAwesomeIcons.dove,'Birds'),
            categoryFilterItem(FontAwesomeIcons.frog,'Amphibians'),
          ],
        ),
      ),
    );
  }

  Widget vetClinic(ClinicData data){
    return Container(
      margin: EdgeInsets.only(top: 5,bottom: 5),
      height: 90,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        color: text7Color,
        margin: EdgeInsets.all(1),
        child: ListTile(
          isThreeLine: true,
          leading: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)
            ),
            child: Image.asset(data.img??"",height: double.infinity,width: 50)
          ),
          title: Text(data.name??"",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: text2Color),),
          subtitle: Text(data.address??"",style: TextStyle(fontSize: 10,color: text2Color),),
          trailing: Container(
            width: 50,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50)
            ),
            child: Center(
              child: FaIcon(Icons.arrow_forward_ios_sharp,size: 30),
            ),
          ),
          onTap: (){
            Navigator.pushNamed(context, '/vet_clinic',arguments: data);
          },
        ),
      ),
    );
  }

  List<Widget> vetClinics(){
    return ClinicData.getSampleData().map((data) => vetClinic(data)).toList();
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
          leading: Container(),
          actions: [
            IconButton(
              onPressed: (){
                Navigator.pushNamed(context, "/user_profile");
              }, 
              icon: FaIcon(FontAwesomeIcons.user)
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 10,right: 10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                greetings(),
                feeds(),
                Text("Category",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: text2Color),),
                categoryFilter(),
                Text("Nearby Veterinary",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: text2Color),),
              ] + vetClinics(),
            ),
          )
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
            if(value == 2){
              Navigator.pushNamed(context, '/map_clinic');
            }
          },
        ),
      ),
    );
  }
}