import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class MapClinic extends StatefulWidget {
  const MapClinic({super.key});

  @override
  State<MapClinic> createState() => _MapClinicState();
}

class _MapClinicState extends State<MapClinic> {
  MapController _mapController = MapController();
  double _currentLat = 0;
  double _currentLng = 0;

  @override
  initState() {
    super.initState();
    setState(() {
    });
    getLocation();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future getLocation() async {
      Position position = await _determinePosition();
      setState(() {
        _currentLat = position.latitude;
        _currentLng = position.longitude;
      });
      // return _geoLocation.longitude != null ? LatLng(double.parse(_geoLocation.latitude), double.parse(_geoLocation.longitude)) : LatLng(0.0,0.0);
    }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Image.asset('assets/images/Logo.png',fit: BoxFit.contain),
          actions: [
            IconButton(
              onPressed: (){}, 
              icon: FaIcon(FontAwesomeIcons.user)
            )
          ],
        ),
        body: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(_currentLat, _currentLng),
            zoom: 9.2,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://api.mapbox.com/styles/v1/ianrey258/ckb28ett60xnh1iry8wtx3tlx/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaWFucmV5MjU4IiwiYSI6ImNrYjI3eXF0cTA4bjgyd28yeGJta2dtNmQifQ.LtqueENclx7vVAp6IfEusA",
              additionalOptions: {
                'accessToken': 'pk.eyJ1IjoiaWFucmV5MjU4IiwiYSI6ImNrYjI3eXF0cTA4bjgyd28yeGJta2dtNmQifQ.LtqueENclx7vVAp6IfEusA',
                'id': 'mapbox.mapbox-streets-v8'
              }
            ),
          ],
        )
      ),
    );
  }
}