// ignore_for_file: prefer_const_constructors
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart' as ct_res;
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetfindapp/Model/clinic.dart';
import 'package:vetfindapp/Model/pet.dart';
import 'package:vetfindapp/Services/geo_location.dart';


class MapClinic extends StatefulWidget {
  const MapClinic({super.key});

  @override
  State<MapClinic> createState() => _MapClinicState();
}

class _MapClinicState extends State<MapClinic> {
  final _mapController = MapController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<TextEditingController> text = [];
  List<AnimalData>? selectedAnimalCategory = [];
  List<ClinicService>? selectedClinicServices = [];
  LatLng _currentlatlng = LatLng(0, 0);
  final _accessToken = "pk.eyJ1IjoiaWFucmV5MjU4IiwiYSI6ImNrYjI3eXF0cTA4bjgyd28yeGJta2dtNmQifQ.LtqueENclx7vVAp6IfEusA";
  final _typeMap = "mapbox.mapbox-streets-v8";
  final List<Map> _sampleData = [
                                  {"name":"PetVet","image":"assets/images/PetVet.png","lat":"8.4753081","lng":"124.6716228"},
                                  {"name":"Cats And Dog","image":"assets/images/cats_and_dogs.png","lat":"8.483989","lng":"124.6599067"}
                                ];

  @override
  initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
      }
    });
    getLocation();
  }

  Future getLocation({zoom: 18.0}) async {
    Position position = await GeolocationModule.getPosition();
    setState(() {
      _currentlatlng = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentlatlng, zoom);
    });
  }

  List<Marker> generateStoreMarker(){
    return _sampleData.map((data)=>
      Marker(
        height: 80,
        width: 80,
        rotate: true,
        point: LatLng(double.parse(data['lat']),double.parse(data['lng'])), 
        builder: (context) => Container(
          margin: EdgeInsets.only(bottom: 20),
          child: ListTile(
            title: Center(
              child: Image.asset(data['image'],fit: BoxFit.contain),
            ),
            subtitle: Text(data['name'],textAlign: TextAlign.center,),
            onTap: (){
              Navigator.popAndPushNamed(context, '/vet_clinic');
            },
          ),
        )
      )
    ).toList();
  }

  Widget searchBox(){
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: text[0],
        keyboardType: TextInputType.name,
        style: TextStyle(fontSize: 20, color: Color.fromRGBO(66,74,109, 1)),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          fillColor: Color.fromRGBO(229,229,229,1),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(66,74,109, 1)),
            borderRadius: BorderRadius.circular(5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none
          ),
          hintText: 'Search'
        ),
      ),
    );
  }

  Widget filterCategory(){
    return FilterListWidget(
      themeData: FilterListThemeData(
        context,
        backgroundColor: Color.fromRGBO(66,74,109, 1),
        controlButtonBarTheme: ControlButtonBarThemeData(
          context,
          backgroundColor: Colors.transparent
          )
      ),
      hideHeader: true,
      listData: AnimalData.getSampleList(),
      selectedListData: selectedAnimalCategory,
      hideSearchField: true,
      hideSelectedTextCount: true,
      controlButtons: [],
      validateSelectedItem: (selectedAnimalCategory,selected){
        return selectedAnimalCategory!.contains(selected);
      }, 
      choiceChipLabel: (item){
        return item!.name;
      }, 
      onItemSearch: (data,item){
        return true;
      },
      applyButtonText: 'Set',
      onApplyButtonClick: (list){
        selectedAnimalCategory = list;
        CherryToast.info(
          title: Text('Category Set',textAlign: TextAlign.center,),
          animationDuration: Duration(milliseconds: 500),
          toastDuration: Duration(milliseconds: 1000),
          displayCloseButton: false,
          toastPosition: ct_res.Position.bottom,
        ).show(context);
      },
    );
  }
  
  Widget filterServices(){
    return FilterListWidget(
      themeData: FilterListThemeData(
        context,
        backgroundColor: Color.fromRGBO(66,74,109, 1),
        controlButtonBarTheme: ControlButtonBarThemeData(
          context,
          backgroundColor: Colors.transparent
          )
      ),
      hideHeader: true,
      listData: ClinicService.getSampleServices(),
      selectedListData: selectedClinicServices,
      hideSearchField: true,
      hideSelectedTextCount: true,
      controlButtons: [],
      validateSelectedItem: (selectedClinicServices,selected){
        return selectedClinicServices!.contains(selected);
      }, 
      choiceChipLabel: (item){
        return item!.name;
      }, 
      onItemSearch: (data,item){
        return true;
      },
      applyButtonText: 'Apply and Search',
      onApplyButtonClick: (list){
        selectedClinicServices = list;
        Navigator.pop(context);
        getLocation(zoom: 14.5);
        CherryToast.info(
          title: Text('Searching ...',textAlign: TextAlign.center,),
          animationDuration: Duration(milliseconds: 400),
          toastDuration: Duration(seconds: 2),
          displayCloseButton: false,
          toastPosition: ct_res.Position.bottom,
        ).show(context);
      },
    );
  }

  Widget drawerContainer(){
    selectedAnimalCategory = [];
    selectedClinicServices = [];
    return ListView(
      children: [        
        SizedBox(
          height: 75,
          child: searchBox()
        ),
        Divider(
          height: 5,
        ),
        SizedBox(
          height: 25,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text('Category',style: TextStyle(fontSize: 18),),
          )
        ),
        SizedBox(
          height: 260,
          child: Container(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: filterCategory(),
          )
        ),
        Divider(
          height: 5,
        ),
        SizedBox(
          height: 25,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text('Services',style: TextStyle(fontSize: 18),),
          )
        ),
        SizedBox(
          height: 420,
          child: Container(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: filterServices(),
          )
        ),
      ],
    );
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
          actions: [
            IconButton(
              onPressed: (){
                _scaffoldKey.currentState?.openEndDrawer();
              }, 
              icon: FaIcon(Icons.filter_list_rounded)
            )
          ],
        ),
        body: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: _currentlatlng,
          ),
          children: [
            TileLayer(
              minZoom: 0,
              maxZoom: 18,
              urlTemplate: "https://api.mapbox.com/styles/v1/ianrey258/ckb28ett60xnh1iry8wtx3tlx/tiles/256/{z}/{x}/{y}@2x?access_token=$_accessToken",
              additionalOptions: {
                'accessToken': _accessToken,
                'id': _typeMap
              },
            ),
            MarkerLayer(
              markers: [
                Marker(
                  height: 150,
                  width: 150,
                  point: _currentlatlng, 
                  builder: (context)=> Container(
                    child: IconButton(
                      icon: FaIcon(Icons.man),
                      iconSize: 30,
                      onPressed: () {
                      },
                    ),
                  ),
                  rotate: true
                )
              ] + generateStoreMarker(),
            ),
          ],
        ),
        endDrawer: Drawer(
          width: size.width*.7,
          // backgroundColor: Color.fromRGBO(19,50,64,1),
          backgroundColor:  Color.fromRGBO(66,74,109, 1),
          child: drawerContainer(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            getLocation();
          },
          child: FaIcon(Icons.add_circle_outlined),
        ),
      ),
    );
  }
}