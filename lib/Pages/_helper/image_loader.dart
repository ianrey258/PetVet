import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vetfindapp/Controller/FileController.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';
import 'package:shimmer/shimmer.dart';

class ImageLoader  {

  static Widget loadImageNetwork(String path,[double width = 120.0,double hieght = 120.0]){
    return FutureBuilder(
      future: FileController.getFileURL(path),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != ""){
          try{
            // return Image.network(snapshot.data,height: hieght,width: width,fit: BoxFit.fill,);
            // return Image.network(snapshot.data,height: hieght,w\idth: width,fit: BoxFit.fill,filterQuality: FilterQuality.low,);
            return FastCachedImage(
              url: snapshot.data,
              height: hieght,
              width: width,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.low,
              loadingBuilder: (context,progress)=> Shimmer(
                child: SizedBox(
                  width: width,
                  height: hieght,
                ), 
                gradient: LinearGradient(colors: [text7Color,secondaryColor])
              ),
            );
          }catch(e){
            return Center(
              widthFactor: 2,
              heightFactor: 2,
              child: Shimmer(
                child: SizedBox(
                  width: width,
                  height: hieght,
                ), 
                gradient: LinearGradient(colors: [text7Color,secondaryColor])
              ),
            );
          }
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            widthFactor: 2,
            heightFactor: 2,
            child: Shimmer(
              child: SizedBox(
                width: width,
                height: hieght,
              ), 
              gradient: LinearGradient(colors: [text7Color,secondaryColor])
            ),
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

