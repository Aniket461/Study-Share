import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'details.dart';
import 'main.dart';
import 'addproducts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'singlepost.dart';
import 'MyPosts.dart';
import 'accessories.dart';
import 'freepdf.dart';
import 'package:file_picker/file_picker.dart';
import 'products.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:amazon_s3_cognito/aws_region.dart';
import 'package:path/path.dart' as path;



class MyAddPdf extends StatefulWidget {
  
  @override
  _MyAddPdf createState() => _MyAddPdf();
}

class _MyAddPdf extends State<MyAddPdf> {

String pdf_url = "";
File file2;
String name = "default";
String dropdownValue = 'School';
String subcat = "default";


addpdf() async{
File file = await FilePicker.getFile(type: FileType.custom,allowedExtensions: ['pdf', 'doc']);
setState(() {
  file2 = file;
});

}

String pdfurl = "";

uploadpdf() async{
//   String fileName = '$name.pdf';
// StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
//   StorageUploadTask uploadTask = reference.putFile(file2);
//   StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
  

  showAlertDialog(context);
  pdfurl = await AmazonS3Cognito.upload(
                    file2.path,
                    "studyshare/pdfs",
                    "us-east-1:f5901a55-ef2a-4e23-87b9-38fc4956c29a",
                    path.basename(file2.path),
                    AwsRegion.US_EAST_1,
                    AwsRegion.US_EAST_1);


String pdf_url = "https://studyshare.s3.amazonaws.com/pdfs/"+path.basename(file2.path);


  // pdf_url = (await downloadUrl.ref.getDownloadURL()); 
  // await uploadTask.onComplete;
  saveDataInPost(name, dropdownValue, subcat, pdf_url);
  saveDataInUser(name, dropdownValue, subcat, pdf_url); 
  showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Successful",style: TextStyle(color:Colors.green),),
 content: Text("$name successfully added!!"),
 actions: <Widget>[
   FlatButton(onPressed: ()=>{
     
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => MyPdf()),
  (Route<dynamic> route) => false,
)
  } ,child:Text("close"))
 ],
);
});
}

showAlertDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
               CircularProgressIndicator(),
               Container(margin: EdgeInsets.only(left: 5),child:Text("Saving file.." , style: TextStyle(fontFamily:"Montserrat"),),
               ),
            ],),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );
    }



saveDataInPost(String name, String category, String subcat,String pdfUrl){

  DocumentReference documentReference = Firestore.instance.collection("pdfs").document(name);
    Map<String,String> details = {
    "name": name,
    "category": category,
    "timestamp": DateTime.now().toString(),
    "pdfurl":pdfUrl,
    "subcat": subcat,
    "search": name.replaceAll(" ", "").toLowerCase(),
    };
    documentReference.setData(details).whenComplete(() =>print("$name created"));
}


saveDataInUser(String name, String category, String subcat,String pdfUrl){
  DocumentReference documentReference = Firestore.instance.collection(globals.userName).document("pdf").collection(globals.userName).document(name);
    Map<String,String> details = {
    "name": name,
    "category": category,
    "timestamp": DateTime.now().toString(),
    "subcat": subcat,
    "pdfurl":pdfUrl,
    "search": name.replaceAll(" ", "").toLowerCase(),
    

    };
    documentReference.setData(details).whenComplete(() =>print("$name created"));

}




final _formkey = GlobalKey<FormState>();
var controller = TextEditingController();
@override
  Widget build(BuildContext context) {

return Scaffold(
  appBar: AppBar(title:Text("Study Share", style:TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.bold))),
  body:Column(children:[
  Padding(padding:EdgeInsets.only(top:20.0, left:50.0, right:50.0),
    child:Text("Fill the below details to upload a Book PDF.", style: TextStyle(fontFamily:"Montserrat", fontSize:18.0),textAlign: TextAlign.center,),),
SizedBox(height: 30.0,),

Form(key: _formkey, child:Expanded(child: ListView(children:[
Padding(padding:EdgeInsets.only(top:0.0, left:30.0, right:50.0),
child:Text("Name of the Book:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
  ),
Padding(padding:EdgeInsets.only(top:0.0, left:50.0, right:50.0),
child:TextFormField(

style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter book name";
                        }
                      },
                      controller: controller,
                      onSaved: (val){
                        setState(() {
                          name = val;
                        });
                      }

)),

SizedBox(height:15.0),
Padding(padding:EdgeInsets.only(top:0.0, left:30.0, right:50.0),
child:Text("Select file:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
  ),
  SizedBox(height:10.0),
file2 == null ? 
Padding(padding:EdgeInsets.only(left:100.0, right:100.0), child:
Container(
  height:70, width:70,
  child: 
OutlineButton(padding:EdgeInsets.all(20.0) ,onPressed: () {
  addpdf();
}, child: Icon(Icons.add, size: 30.0,),)))
: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children:[
  Icon(Icons.file_upload),
  Text("$name.pdf", style: TextStyle(fontFamily:"Montserrat", fontSize:18.0, fontWeight:FontWeight.bold),),
  ]),

SizedBox(height:15.0),

  Padding(padding:EdgeInsets.only(top:0.0, left:30.0, right:50.0),
child:Text("Book Category:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
  ),

Padding(padding:EdgeInsets.only(top:0.0, left:50.0, right:220.0),
child:DropdownButton<String>(
      value: dropdownValue,
      // icon: Icon(Icons.arrow_downward),
      // iconSize: 24,
       elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        print(newValue);
        
        setState(() {
          
          dropdownValue = newValue;
          subcat = "default";
        });
        
      },
      items: <String>['School', 'College', 'Degree', 'Others']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    )),


dropdownValue == "School"?

Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children:[
  Padding(padding:EdgeInsets.only(top:0.0, left:30.0, right:0.0),
child:Text("School Std:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
  ),
Padding(padding:EdgeInsets.only(top:0.0, left:50.0, right:0.0),
child:DropdownButton<String>(
      value: subcat,
      // icon: Icon(Icons.arrow_downward),
      // iconSize: 24,
       elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        print(newValue);
        
        setState(() {
          
          subcat = newValue;
        });
        
      },
      items: <String>['default','1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th', '9th', '10th']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ))
  ])
    :
  dropdownValue == "College" ?
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children:[
  Padding(padding:EdgeInsets.only(top:0.0, left:30.0, right:0.0),
child:Text("College Std:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
  ),
Padding(padding:EdgeInsets.only(top:0.0, left:50.0, right:0.0),
child:DropdownButton<String>(
      value: subcat,
      // icon: Icon(Icons.arrow_downward),
      // iconSize: 24,
       elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        print(newValue);
        
        setState(() {
          
          subcat = newValue;

        });
        
      },
      items: <String>['default','11th', '12th']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ))
  ])
    :
      dropdownValue == "Degree" ?
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children:[
  Padding(padding:EdgeInsets.only(top:0.0, left:30.0, right:0.0),
child:Text("Specify degree:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
  ),
Padding(padding:EdgeInsets.only(top:0.0, left:50.0, right:0.0),
child:DropdownButton<String>(
      value: subcat,
      // icon: Icon(Icons.arrow_downward),
      // iconSize: 24,
       elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        print(newValue);
        
        setState(() {
          
          subcat = newValue;
        });
        
      },
      items: <String>['default','Btech', 'BE','BBA']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ))
  ])
  :
     dropdownValue == "Others" ?
     Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children:[

         Padding(padding:EdgeInsets.only(top:0.0, left:30.0, right:50.0),
child:Text("Specify a sub category:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
  ),

Padding(padding:EdgeInsets.only(top:0.0, left:50.0, right:0.0),
child:DropdownButton<String>(
      value: subcat,
      // icon: Icon(Icons.arrow_downward),
      // iconSize: 24,
       elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        print(newValue);
        
        setState(() {
          
          subcat = newValue;
        });
        
      },
      items: <String>['default','Scifi', 'Biography', 'Self Help', 'Personal Development', 'Mythology','Magic','Fiction','Erotica']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    )),
         ])

:Container(),


Center(child:RaisedButton(color: Colors.green,onPressed: (){
final form = _formkey.currentState;
  if(form.validate()){

    if(file2 == null){

      
showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Error",style: TextStyle(color:Colors.red),),
 content: Text("Please upload the pdf!!"),
 actions: <Widget>[
   FlatButton(onPressed: ()=>{
     Navigator.of(context).pop()
  } ,child:Text("close"))
 ],
);
});

    }
    else{
    form.save();
      showAlertDialog(context);
      uploadpdf();
// Future.delayed(Duration(milliseconds: 20000),(){  
//   saveDataInPost(name, dropdownValue, subcat, pdf_url);
//   saveDataInUser(name, dropdownValue, subcat, pdf_url);  
// showDialog(context: context, builder: (BuildContext context){
// return AlertDialog(
//  title: Text("Successful",style: TextStyle(color:Colors.green),),
//  content: Text("Book successfully added!! $name "),
//  actions: <Widget>[
//    FlatButton(onPressed: ()=>{
     
// Navigator.pushAndRemoveUntil(
//   context,
//   MaterialPageRoute(builder: (context) => MyPdf()),
//   (Route<dynamic> route) => false,
// )
//   } ,child:Text("close"))
//  ],
// );
// });
// }); 
    }
  }},
  child: Text("Submit"),
)),


])))
  ]),

);


}
}