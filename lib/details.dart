import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class MyDetail extends StatefulWidget {
  
  @override
  _MyDetail createState() => _MyDetail();
}

class _MyDetail extends State<MyDetail> {
void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => {
          if(globals.userName == ""){
            setState(()=>{
              check = true
            })
          }
          else{
            checkdata()
          }
        }

        );
  }
File _image ;
String name = "";
String number = "";
String third = "";
String city = "";
String district = "";
String state = "";
String country = "";

bool check = false;
final picker = ImagePicker();
Future chooseFile() async{

final pickedFile = await picker.getImage(source: ImageSource.gallery);
setState(() {
  _image = File(pickedFile.path);
});
}


showAlertDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
               CircularProgressIndicator(),
               Container(margin: EdgeInsets.only(left: 5),child:Text("Saving Data.." , style: TextStyle(fontFamily:"Montserrat"),),
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
String pictureurl = "";
uploadImage(File image) async{
  showAlertDialog(context);
  StorageReference reference = FirebaseStorage.instance.ref().child(image.path.toString());
  StorageUploadTask uploadTask = reference.putFile(image);
  StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
  pictureurl = (await downloadUrl.ref.getDownloadURL());
    // Future.delayed(Duration(milliseconds: 15000),
    saveData(name, number, pictureurl,city, district, state, country);
    showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Successful",style: TextStyle(color:Colors.green),),
 content: Text("Profile successfully created!!"),
 actions: <Widget>[
   FlatButton(onPressed: ()=>{
     
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => MyProduct()),
  (Route<dynamic> route) => false,
)
  } ,child:Text("close"))
 ],
);
});
// });
}


saveData(String named, String numberd, String pictureurl, String cityd, String districtd, String stated, String countryd){
  DocumentReference documentReference = Firestore.instance.collection(globals.userName).document("Profile_Data");
    Map<String,String> details = {
    "name": named,
    "mobile": numberd,
    "Image": pictureurl,
    "city":cityd,
    "district":districtd,
    "state":stated,
    "country":countryd
    };
    documentReference.setData(details).whenComplete(() =>print("$name created"));

}


final _formkey = GlobalKey<FormState>();

checkdata() async{
final snapshot = await Firestore.instance.collection(globals.userName).getDocuments();
print(snapshot.documents.length);
if(snapshot.documents.length == 0){
  print(snapshot.documents);
  setState(()=>{

check = true

  });
}
else{
  print(snapshot.documents);
   setState(()=>{


check = false

  });
}
}

var controller = TextEditingController();
var controller1 = TextEditingController();
var controller2 = TextEditingController();
var controller3 = TextEditingController();
var controller4 = TextEditingController();
var controller5 = TextEditingController();
@override
  Widget build(BuildContext context) {

  return Scaffold(
     
    body:
     check ?
    _image== null ? Padding(padding: EdgeInsets.only(top:30.0),
    child: 
      Center(child:Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text("Lets create your profile..",style: TextStyle(fontFamily: "Montserrat", fontSize:25.0),textAlign: TextAlign.center,),
        SizedBox(height:50),
        Text("Select an Avatar for yourself!",style: TextStyle(fontFamily: "Montserrat", fontSize:20.0),),
        SizedBox(height:10),
      SizedBox( width: 80,
      height: 80,
      child:FloatingActionButton( onPressed: ()=>{
        chooseFile(),
      },  child:Icon(Icons.add_a_photo, size: 45.0,)),
      )
      ])))
      
      : Column(children:[
        SizedBox(height:80),
        Text("Hi, "+globals.userName, style: TextStyle(fontFamily:"Montserrat", fontSize:20.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
        SizedBox(height:20),
        Center(child:CircleAvatar(radius: 72.0,backgroundColor: Colors.black ,child:CircleAvatar(backgroundImage: FileImage(_image), radius: 70.0,))),
        SizedBox(height: 20.0,),
       Form(key: _formkey, child:Expanded(child:ListView(
          children:[

          Padding(padding:EdgeInsets.only(left:30.0) ,child:Text("Full Name:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),),
                    Padding(padding: EdgeInsets.only(left:30.0,right:30.0),
                    child: TextFormField(
                      controller: controller,
                      style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      // validator: (value){
                      //   if(value.isEmpty){
                      //     return "Please enter your name";
                      //   }
                      // },
                      onSaved: (val){
                        setState(() {
                          name = val;
                        });
                      }
                    ),),
                    SizedBox(height:15),
                    Padding(padding:EdgeInsets.only(left:30.0) ,child:Text("Mobile Number:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),),
          Padding(padding: EdgeInsets.only(left:30.0,right:30.0),
                    child: TextFormField(
                      controller: controller1,
                      style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      validator: (value){
                        String pattern =r'(^(?:[+0]9)?[0-9]{10}$)';
        
    RegExp regex = new RegExp(pattern);
                        if(!regex.hasMatch(value)){
                          return "Please enter a valid phone number";
                        }
                      },
                      
                      onSaved: (val){
                        print("from on saved"+val);
                        setState(() {
                          number = val;
                        });
                      }
                    ),),
                    SizedBox(height:15),
         
         
          Padding(padding:EdgeInsets.only(left:30.0) ,child:Text("City:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),),
                    Padding(padding: EdgeInsets.only(left:30.0,right:30.0),
                    child: TextFormField(
                      controller: controller2,
                      style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      // validator: (value){
                      //   if(value.isEmpty){
                      //     return "Please enter your City";
                      //   }
                      // },
                      onSaved: (val){
                        setState(() {
                          city = val;
                        });
                      }
                    ),),
         
         SizedBox(height:15),
          Padding(padding:EdgeInsets.only(left:30.0) ,child:Text("District:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),),
                    Padding(padding: EdgeInsets.only(left:30.0,right:30.0),
                    child: TextFormField(
                      controller: controller3,
                      style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      // validator: (value){
                      //   if(value.isEmpty){
                      //     return "Please enter your District";
                      //   }
                      // },
                      onSaved: (val){
                        setState(() {
                          district = val;
                        });
                      }
                    ),),
         
         SizedBox(height:15),
          Padding(padding:EdgeInsets.only(left:30.0) ,child:Text("State:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),),
                    Padding(padding: EdgeInsets.only(left:30.0,right:30.0),
                    child: TextFormField(
                      controller: controller4,
                      style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      // validator: (value){
                      //   if(value.isEmpty){
                      //     return "Please enter your State";
                      //   }
                      // },
                      onSaved: (val){
                        setState(() {
                          state = val;
                        });
                      }
                    ),),
         SizedBox(height:15),
          Padding(padding:EdgeInsets.only(left:30.0) ,child:Text("Country:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),),
                    Padding(padding: EdgeInsets.only(left:30.0,right:30.0),
                    child: TextFormField(
                      controller: controller5,
                      style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      // validator: (value){
                      //   if(value.isEmpty){
                      //     return "Please enter your country";
                      //   }
                      // },
                      onSaved: (val){
                        print("from on saved country"+val);
                        setState(() {
                          country = val;
                        });
                      }
                    ),),
         
SizedBox(height:15),
                     Padding(padding:EdgeInsets.only(left:30.0) ,child:Text("Email Id:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),),
         Padding(padding: EdgeInsets.only(left:30.0,right:30.0),
                    child: Text(globals.userName, style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),)),

SizedBox(height:40),

Padding(
  padding:EdgeInsets.only(left: 90.0, right: 90.0),
  child:RaisedButton( color:Colors.green, onPressed: (){
    
    name = controller.value.text;
    number = controller1.value.text;
    city = controller2.value.text;
    district = controller3.value.text;
    state = controller4.value.text;
    country = controller5.value.text;

    if(name == "" ||number == "" ||city == "" ||district == "" ||country == "" ||state == ""){
      controller.clear();
      controller1.clear();
      controller2.clear();
      controller3.clear();
      controller4.clear();
      controller5.clear();
showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Error",style: TextStyle(color:Colors.red),),
 content: Text("All fields are mandatory, Please refiill them again..."),
 actions: <Widget>[
   FlatButton(onPressed: ()=>{

Navigator.of(context).pop(),

  } ,child:Text("close"))
 ],
);
});
    }
    else{
  final form = _formkey.currentState;
  if(form.validate()){
    form.save();
    print("form saved");
    print("number $number");
    uploadImage(_image);
//     showAlertDialog(context);
//     Future.delayed(Duration(milliseconds: 15000),
//     (){saveData(name, number, pictureurl,city, district, state, country);
//     showDialog(context: context, builder: (BuildContext context){
// return AlertDialog(
//  title: Text("Successful",style: TextStyle(color:Colors.green),),
//  content: Text("Profile successfully created!!"),
//  actions: <Widget>[
//    FlatButton(onPressed: ()=>{
     
// Navigator.pushAndRemoveUntil(
//   context,
//   MaterialPageRoute(builder: (context) => MyProduct()),
//   (Route<dynamic> route) => false,
// )
//   } ,child:Text("close"))
//  ],
// );
// });
// });
      }
    }
},
child: Text("Submit", style: TextStyle(fontFamily:"Montserrat", fontSize:20.0),),
)),

SizedBox(height:30),
                    
          ]
        )),
       
        ),
      ])
:MyProduct()

  
  );
  }

}