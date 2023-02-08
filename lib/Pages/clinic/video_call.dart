import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({Key? key}) : super(key: key);

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final ScrollController _sc = ScrollController();
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  @override
  initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SmartFaceCamera(
        autoCapture: false,
        showControls: false,
        defaultCameraLens: CameraLens.front,
        message: 'Sample Video Call',
        onCapture: (File? image){
        },
      )
    );
    
    // return SafeArea(
    //   child: Scaffold(
    //     backgroundColor: Colors.white,
    //     appBar: AppBar(
    //       elevation: 0,
    //       centerTitle: true,
    //       title: Text("Cats and Dogs",textAlign: TextAlign.center),
    //       actions: [
    //         IconButton(
    //           onPressed: (){}, 
    //           icon: FaIcon(FontAwesomeIcons.video)
    //         )
    //       ],
    //     ),
    //     body: Container(
    //       decoration: BoxDecoration(
    //         color: Colors.black
    //       ),
    //       child: Center(
    //         child: Camera(),
    //     )
    //   ),
    // );
  }
}
