import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studyshare/products.dart';
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
import 'chat.dart';
import 'awstest.dart';


class EditProfile extends StatefulWidget{
   @override
  Myedit createState() => Myedit();
}

class Myedit extends State<EditProfile>{
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => {
        getData(),
        
        });
        }
final _formkey = GlobalKey<FormState>();

var controller = TextEditingController();
var controller1 = TextEditingController();
var controller2 = TextEditingController();
var controller3 = TextEditingController();
var controller4 = TextEditingController();
var controller5 = TextEditingController();
// File _image ;
String name = "";
String number = "";
String third = "";
String city = "";
String district = "";
String state = "";
String country = "";

getData() async{
  var str = Firestore.instance.collection(globals.userName).document('Profile_Data');
str.get().then((value) => {
  setState((){
    // proimage = value["Image"].toString();
    controller.text = value["name"].toString();
    controller1.text = value["mobile"].toString();
    controller2.text = value["city"].toString();
    controller3.text = value["district"].toString();
    controller4.text = value["country"].toString();
    controller5.text = value["state"].toString();
  }),
});
}


saveData(String name,String number,String city,String district,String state,String country){

Firestore.instance
  .collection(globals.userName)
    .document('Profile_Data').setData({"name": name, "mobile": number, "city": city,"district": district,"country": country,"state": state,}, merge: true);
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

  @override
  Widget build(BuildContext context) {
  

  
  return Scaffold(
    appBar: AppBar(title:Text("Study Share", style:TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.bold))),
    body: Column(children:[
        SizedBox(height:10),
        Text("Hi, "+globals.userName, style: TextStyle(fontFamily:"Montserrat", fontSize:18.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
        SizedBox(height:6),
        Text("Update your profile", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold, color: Colors.grey),textAlign: TextAlign.center,),
        SizedBox(height:20),
        
        // Center(child:CircleAvatar(radius: 72.0,backgroundColor: Colors.black ,child:CircleAvatar(backgroundImage: FileImage(_image), radius: 70.0,))),
        // SizedBox(height: 20.0,),
       Form(key: _formkey, child:Expanded(child:ListView(
          children:[

          Padding(padding:EdgeInsets.only(left:30.0) ,child:Text("Full Name:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),),
                    Padding(padding: EdgeInsets.only(left:30.0,right:30.0),
                    child: TextFormField(
                      // initialValue: name,
                      controller: controller,
                      style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter your name";
                        }
                      },
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
                      
                      // initialValue: number,
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
                      // initialValue: city,
                      controller: controller2,
                      style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter your City";
                        }
                      },
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
                      // initialValue: district,
                      controller: controller3,
                      style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter your District";
                        }
                      },
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
                      // initialValue: state,
                      controller: controller4,
                      style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter your State";
                        }
                      },
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
                      // initialValue: country,
                      controller: controller5,
                      style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter your country";
                        }
                      },
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
  padding:EdgeInsets.only(left: 115.0, right: 115.0),
  child:RaisedButton( color: Colors.deepPurple,onPressed: (){
    
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
 content: Text("All fields are mandatory, refiill them again..."),
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
    print("number $number $name $city $state $country $district");
    // uploadImage(_image);
    showAlertDialog(context);
    Future.delayed(Duration(milliseconds: 15000),

    (){saveData(name, number,city, district, state, country);
    showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Successful",style: TextStyle(color:Colors.green),),
 content: Text("Profile updated successfully!! $name and $number"),
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
});
      }
    }
},
child: Row(children:[
  Icon(Icons.update, color: Colors.white),
  SizedBox(width: 5,),
  Text("Update", style: TextStyle(fontFamily:"Montserrat", fontSize:16, color: Colors.white),)]),
)),

SizedBox(height:30),         
          ]
        )),
       
        ),
      ])
  );
  
  }
}