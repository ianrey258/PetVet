// ignore_for_file: prefer_const_constructors
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart' as ct_res;
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetfindapp/Controller/ClinicController.dart';
import 'package:vetfindapp/Model/clinicModel.dart';
import 'package:vetfindapp/Model/petModel.dart';
import 'package:vetfindapp/Pages/_helper/image_loader.dart';
import 'package:vetfindapp/Services/geo_location.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';


class MapClinic extends StatefulWidget {
  final ClinicModel? data;
  const MapClinic({super.key,this.data});

  @override
  State<MapClinic> createState() => _MapClinicState();
}

class _MapClinicState extends State<MapClinic> {
  final _mapController = MapController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<TextEditingController> text = [];
  // List<AnimalData>? selectedAnimalCategory = [];
  List<ClinicService>? selectedClinicServices = [];
  List<ClinicService>? filterClinicServices = [];
  LatLng _currentlatlng = LatLng(0, 0);
  ClinicModel? clinic;
  List<ClinicModel>? Clinics;
  List<LatLng> _points = [];
  final _accessToken = "pk.eyJ1IjoiaWFucmV5MjU4IiwiYSI6ImNrYjI3eXF0cTA4bjgyd28yeGJta2dtNmQifQ.LtqueENclx7vVAp6IfEusA";
  final _typeMap = "mapbox.mapbox-streets-v8";

  @override
  initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
      }
    });
    Future.delayed(Duration(seconds: 1),()async {
      if(ModalRoute.of(super.context)!.settings.arguments != null){
        final data = ModalRoute.of(super.context)!.settings.arguments as ClinicModel;
        setState(() {
          clinic = data;
        });
    }
    clinic?.clinic_name != null ? getLocationStore() : getLocation();
    });
    initLoadData();
  }

  initLoadData()async {
    List clinic_list = await ClinicController.getClinics();
    List<String> clinic_services = await ClinicController.getClinicServices();
    setState(() {
      Clinics = clinic_list as List<ClinicModel>;
      filterClinicServices = ClinicService.getListClinicServices(clinic_services);
      if(filterClinicServices!.isEmpty){
        filterClinicServices = ClinicService.getSampleServices();
      }
    });
  }

  Future getLocation({zoom: 18.0}) async {
    Position position = await GeolocationModule.getPosition();
    setState(() {
      _currentlatlng = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentlatlng, zoom);
    });
  }
  
  Future getLocationStore({zoom: 15.0}) async {
    Future.delayed(Duration(seconds: 1),()async {
      Position position = await GeolocationModule.getPosition();
      LatLng _storelatlng = LatLng(double.parse(clinic!.clinic_lat??"0"),double.parse(clinic!.clinic_long??"0"));
      List<LatLng> list_points = await GeolocationModule.getListRoutes(position.longitude.toString(),position.latitude.toString(), clinic!.clinic_long??"0" ,clinic!.clinic_lat??"0");
      print(list_points);
      setState(() {
        _currentlatlng = LatLng(position.latitude, position.longitude);
        _mapController.move(_storelatlng, zoom);
        // _points = [_currentlatlng,_storelatlng];
        _points = list_points;
      });
    });
  }

  bool checkStoreOnFilter(ClinicModel data,List<String> services){
    bool hasService = false;
    services.forEach((service) { 
      selectedClinicServices?.forEach((filter) { 
        if(!hasService && service == filter.name){
          hasService = !hasService;
        }
      });
    });
    LatLng _storelatlng = LatLng(double.parse(data!.clinic_lat??"0"),double.parse(data!.clinic_long??"0"));
    if(hasService) _mapController.move(_storelatlng, 14.5);
    return hasService;
  }

  List<Marker> generateStoreMarker(){
    if(Clinics == null){
      return [];
    }
    return Clinics!.map((ClinicModel data)=>
      !checkStoreOnFilter(data,data.services.map((e) => e.toString()).toList()) && selectedClinicServices!.isNotEmpty
      ? Marker(point: LatLng(0, 0), builder: (context)=>SizedBox.shrink())
      : 
      Marker(
        height: 80,
        width: 80,
        rotate: true,
        point: LatLng(double.parse(data.clinic_lat??"0"),double.parse(data.clinic_long??"0")), 
        builder: (context) => Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Center(
              child: data.clinic_img != "" || data.clinic_img != null ? ImageLoader.loadImageNetwork(data.clinic_img??"",80.0,80.0) : FaIcon(FontAwesomeIcons.store,size: 80,color: text1Color),
            ),
            subtitle: Text(data.clinic_name??"",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
            onTap: (){
              // if(clinic?.name != null){
              //   Navigator.pop(context);
              //   Navigator.popAndPushNamed(context, '/vet_clinic',arguments: data);
              // } else {
              // }
              Navigator.pushNamed(context, '/vet_clinic',arguments: data);
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
        style: TextStyle(fontSize: 20, color: secondaryColor),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          fillColor: text3Color,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: secondaryColor),
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

  // Widget filterCategory(){
  //   return FilterListWidget(
  //     themeData: FilterListThemeData(
  //       context,
  //       backgroundColor: secondaryColor,
  //       controlButtonBarTheme: ControlButtonBarThemeData(
  //         context,
  //         backgroundColor: text0Color
  //         )
  //     ),
  //     hideHeader: true,
  //     listData: AnimalData.getSampleList(),
  //     selectedListData: selectedAnimalCategory,
  //     hideSearchField: true,
  //     hideSelectedTextCount: true,
  //     controlButtons: [],
  //     validateSelectedItem: (selectedAnimalCategory,selected){
  //       return selectedAnimalCategory!.contains(selected);
  //     }, 
  //     choiceChipLabel: (item){
  //       return item!.name;
  //     }, 
  //     onItemSearch: (data,item){
  //       return true;
  //     },
  //     applyButtonText: 'Set',
  //     onApplyButtonClick: (list){
  //       selectedAnimalCategory = list;
  //       CherryToast.info(
  //         title: Text('Category Set',textAlign: TextAlign.center,),
  //         animationDuration: Duration(milliseconds: 500),
  //         toastDuration: Duration(milliseconds: 1000),
  //         displayCloseButton: false,
  //         toastPosition: ct_res.Position.bottom,
  //       ).show(context);
  //     },
  //   );
  // }
  
  Widget filterServices(){
    return FilterListWidget(
      themeData: FilterListThemeData(
        context,
        backgroundColor: secondaryColor,
        headerTheme: HeaderThemeData(
          headerTextStyle: TextStyle(color: text1Color,fontSize: 20, fontWeight: FontWeight.bold),
          backgroundColor: secondaryColor
        ),
        controlButtonBarTheme: ControlButtonBarThemeData(
          context,
          backgroundColor: text0Color
          )
      ),
      listData: filterClinicServices,
      headlineText: 'Find Services',
      selectedListData: selectedClinicServices,
      hideSelectedTextCount: true,
      controlButtons: [],
      validateSelectedItem: (selectedClinicServices,selected){
        return selectedClinicServices!.contains(selected);
      }, 
      choiceChipLabel: (item){
        return item!.name;
      }, 
      onItemSearch: (item,search){
        return item.name?.toLowerCase().contains(search)??false ? true : item.name?.contains(search)??false;
      },
      // resetButtonText: 'Reset',
      applyButtonText: 'Search',
      onApplyButtonClick: (list){
        _points = [];
        selectedClinicServices = list;
        Navigator.pop(context);
        // getLocation(zoom: 14.5);
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

  Widget drawerContainer(Size size){
    return ListView(
      children: [        
        // SizedBox(
        //   height: 75,
        //   child: searchBox()
        // ),
        Divider(
          height: 5,
        ),
        // SizedBox(
        //   height: 25,
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 10),
        //     child: Text('Category',style: TextStyle(fontSize: 18),),
        //   )
        // ),
        // SizedBox(
        //   height: 260,
        //   child: Container(
        //     padding: const EdgeInsets.only(left: 10,right: 10),
        //     child: filterCategory(),
        //   )
        // ),
        // Divider(
        //   height: 5,
        // ),
        // SizedBox(
        //   height: 25,
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 10),
        //     child: Text('Services',style: TextStyle(fontSize: 18),),
        //   )
        // ),
        SizedBox(
          height: size.height*0.9,
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
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: text1Color,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Image.asset(logoImg,fit: BoxFit.contain),
          actions: [
            IconButton(
              onPressed: (){
                // selectedAnimalCategory = [];
                selectedClinicServices = [];
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
            PolylineLayer(
              polylines: [
                Polyline(
                  useStrokeWidthInMeter: false,
                  points: _points,
                  strokeWidth: 5,
                  color: primaryColor
                ),
              ],
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
                ),
              ] + generateStoreMarker(),
            ),
          ],
        ),
        endDrawer: Drawer(
          width: size.width*.7,
          // backgroundColor: alternativeColor,
          backgroundColor:  secondaryColor,
          child: drawerContainer(size),
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