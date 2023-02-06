// ignore_for_file: prefer_const_constructors
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:banner_carousel/banner_carousel.dart';

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

  Widget drawerContainerItem(icon,text){
    return ListTile(
      leading: FaIcon(icon,size: 25,color: Colors.white,),
      title: Center(
        child: Text(text,style: TextStyle(fontSize: 25),),
      ),
      trailing: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
      onTap: (){
        Navigator.pop(context);
        text == "Home" ? _scaffoldKey.currentState?.closeDrawer()
        : text == "Map" ?  Navigator.pushNamed(context, '/map_clinic')
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

  Widget greetings(){
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Column(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5,left: 5),
            child: const Text("Hi! User",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5,left: 5),
            child: const Text('Good Morning!',style: TextStyle(fontSize: 20,color: Colors.black),),
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
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(Size.square(100)),
              backgroundColor: MaterialStateProperty.all(Color.fromRGBO(66,74,109, 1)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))
                )
              )
            ),
            onPressed: (){}, 
            child: Center(
              child: FaIcon(icon,size: 60,),
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(text,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.grey),),
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

  Widget vetClinic({image='assets/images/cats_and_dogs.png',required title,required address}){
    return Container(
      margin: EdgeInsets.only(top: 5,bottom: 5),
      height: 90,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        color: Colors.grey,
        margin: EdgeInsets.all(1),
        child: ListTile(
          isThreeLine: true,
          leading: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)
            ),
            child: Image.asset(image,height: double.infinity,width: 50)
          ),
          title: Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
          subtitle: Text(address,style: TextStyle(fontSize: 15,color: Colors.black),),
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
            Navigator.popAndPushNamed(context, '/vet_clinic');
          },
        ),
      ),
    );
  }

  List<Widget> vetClinics(){
    return [
      vetClinic(title: 'Cats and Dog',address: 'Cagayan De Oro City'),
      vetClinic(image: 'assets/images/PetVet.png',title: 'PetVet',address: 'Cagayan De Oro City'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Image.asset('assets/images/Logo.png',fit: BoxFit.contain),
          leading: Container(),
          actions: [
            IconButton(
              onPressed: (){}, 
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
                Text("Category",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
                categoryFilter(),
                Text("Nearby Veterinary",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
              ] + vetClinics(),
            ),
          )
        ),
        drawer: Drawer(
          width: size.width*.6,
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
            if(value == 2){
              Navigator.pushNamed(context, '/map_clinic');
            }
          },
        ),
      ),
    );
  }
}