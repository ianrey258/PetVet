

import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class GeolocationModule{
  static final String _accessToken = "pk.eyJ1IjoiaWFucmV5MjU4IiwiYSI6ImNrYjI3eXF0cTA4bjgyd28yeGJta2dtNmQifQ.LtqueENclx7vVAp6IfEusA";
  static final String _typeMap = "mapbox.mapbox-streets-v8";

  GeolocationModule();

  static Future<Position> getPosition() async {
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
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  static Future<List<LatLng>> getListRoutes(String sourceLng,String sourceLat,String destinationLng,String destinationLat) async {
  List<LatLng> points = [];
  final Uri url = Uri(
    scheme: 'https',
    host: 'api.mapbox.com',
    path: '/directions/v5/mapbox/walking/'+sourceLng+','+sourceLat+';'+destinationLng+','+destinationLat+'',
    queryParameters: {
      'overview':'full',
      'geometries':'geojson',
      'access_token':_accessToken,
    }
  );

  try{
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final parse = jsonDecode(response.body);
      final wayPoints = parse['routes'][0]['geometry']['coordinates'] as List;
      wayPoints.forEach((element) {
        points.add(LatLng(element[1],element[0]));
      });
    }else{
      print(response.body);
    }
  }catch(e){
    print(e);
  }
  return points;
}
}