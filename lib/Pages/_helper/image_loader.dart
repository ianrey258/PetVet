import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vetfindapp/Controller/FileController.dart';

class ImageLoader  {

  static Widget loadImageNetwork(String path,[double width = 120.0,double hieght = 120.0]){
    return FutureBuilder(
      future: FileController.getFileURL(path),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != ""){
          try{
            return Image.network(snapshot.data,height: hieght,width: width,fit: BoxFit.fill,);
          }catch(e){
            return const Center(
              widthFactor: 2,
              heightFactor: 2,
              child: CircularProgressIndicator()
            );
          }
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            widthFactor: 2,
            heightFactor: 2,
            child: CircularProgressIndicator()
          );
        }
        return Container();
      }
    );
  }
  
  static Widget loadImageFile(String path,[width = 120.0,hieght = 120.0]){
    File file = File(path); 
    return Image.file(file,height: hieght,width: width,fit: BoxFit.fill,);
  }
  
}

