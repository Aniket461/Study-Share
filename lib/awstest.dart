import 'dart:io';

import 'package:amazon_s3_cognito/aws_region.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'details.dart';
import 'main.dart';
import 'products.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path/path.dart' as path;

class Awstest extends StatefulWidget{

  @override
  _Awstest createState() => _Awstest();
}

class _Awstest extends State<Awstest>{
  final picker = ImagePicker();

  
  File _image2;
Future chooseFile2() async{
final pickedFile = await picker.getImage(source: ImageSource.gallery);
setState(() {
  _image2 = File(pickedFile.path);
});
}


String uploadedImageUrl = "";
uploadData() async{
  print("inside upload data");
 uploadedImageUrl = await AmazonS3Cognito.upload(
                    _image2.path,
                    "studyshare/images",
                    "us-east-1:f5901a55-ef2a-4e23-87b9-38fc4956c29a",
                    path.basename(_image2.path),
                    AwsRegion.US_EAST_1,
                    AwsRegion.US_EAST_1);

                    print(uploadedImageUrl);

}

  @override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title:Text("Study Share")),
body:Column(children: <Widget>[


_image2 == null ? OutlineButton(padding:EdgeInsets.all(20.0) ,onPressed: () {
  chooseFile2();
}, child: Icon(Icons.add, size: 30.0,),)
: CircleAvatar(radius: 42.0,backgroundColor: Colors.black ,child:CircleAvatar(backgroundImage: FileImage(_image2), radius: 70.0,)),


uploadedImageUrl == "" ? RaisedButton(onPressed: (){
  uploadData();
}, child: Text("submit"),)

:
CachedNetworkImage(
        imageUrl: "https://studyshare.s3.amazonaws.com/images/"+path.basename(_image2.path),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
     ),
],)


);
}

}