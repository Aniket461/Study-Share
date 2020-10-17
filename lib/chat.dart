import 'dart:async';

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

class Chat extends StatefulWidget {
  
  @override
  _Chat createState() => _Chat();
}

class _Chat extends State<Chat> {
Timer timerDil ;

@override
  void deactivate() {
    
    
    timerDil.cancel();
    print("from deactivate");
    // TODO: implement deactivate
    super.deactivate();
  }

@override
  void dispose() {
    // TODO: implement dispose
    
    timerDil.cancel();
    print("from dispose");
    super.dispose();
  }

void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getnumber(),

        );
  }

String profile_pic = "";
String profile_name = "";
List<Map<dynamic,dynamic>> messages= new List(); 

getnumber() async{
  var str = Firestore.instance.collection(globals.userName).document('Profile_Data');
str.get().then((value) => {
  setState((){
    profile_pic = value["Image"].toString();
     profile_name = value['name'].toString();
  }),
});

getMessage();
}

uploadMessage(String message, String date) async{
DocumentReference documentReference = Firestore.instance.collection("forum").document(date);
    Map<String,String> details = {
    "timestamp": date,
    "postedName": profile_name,
    "profile_url": profile_pic,
    "message":message,
    };
    documentReference.setData(details).whenComplete(() =>print("$message sent"));
    getMessage();
}

String tp = "";
getMessage() async {
messages.clear();
CollectionReference prod = Firestore.instance.collection("forum");
QuerySnapshot c = await prod.orderBy('timestamp').getDocuments();
var templist = c.documents;
templist.map((DocumentSnapshot doc){

messages.add(doc.data);
return doc.data;

}).toList();
print("messages");
print(messages[0]['message']);
setState(() {
  tp = "check";
});
print(messages[0]);
 timerDil =Timer.periodic(Duration(seconds: 20), (time) {
  if(mounted){ 
  setState(() {
    String s = time.toString();
  });
  }
  else{
    
  }
});

}


final _formkey = GlobalKey<FormState>();

String tim = "default";

var controller3 = TextEditingController();
ScrollController controller = new ScrollController();
String message = "";

  @override
  Widget build(BuildContext context) {

return Scaffold(

appBar: AppBar(title: Text("Study Share", style:TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.bold)),
actions: <Widget>[],
),
body:Column(children:[
  SizedBox(height:10.0),
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
  children:[Text("Forum", style: TextStyle(fontFamily:"Montserrat", fontSize:20.0, fontWeight:FontWeight.bold),),
  IconButton(icon: Icon(Icons.refresh), onPressed: (){ if(mounted){ 
  setState(() {
    String s = "check";
  });
  }}
  )
  ]
  ),
  SizedBox(height:10.0),
  Expanded(child:ListView.builder(

   
              itemCount: messages.length,
              controller: controller,
              
              itemBuilder: ( context,index){
                final document = messages[index];
                controller.jumpTo(controller.position.maxScrollExtent);
                                var dated = DateTime.parse(document['timestamp']);
var formattedDate = "${dated.day}-${dated.month}-${dated.year}";
print("test");
// // print(globals.timer);
// timerDil =Timer.periodic(Duration(seconds: 30), (time) {
//   if(mounted){ 
//   setState(() {
//     String s = time.toString();
//   });
//   }
//   else{
    
//   }
// });

return 
Column(
  crossAxisAlignment:CrossAxisAlignment.start,

  children: <Widget>[
Row(children: <Widget>[
  SizedBox(width:10.0),
  CircleAvatar(radius: 18.0,backgroundColor: Colors.black ,child:CircleAvatar(backgroundImage: NetworkImage(document['profile_url']),  radius: 16.0,)),
                      SizedBox(width: 5.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[Text(document['postedName'], style: TextStyle(fontFamily:"Montserrat", fontSize:14, fontWeight:FontWeight.bold),),
                  Text(formattedDate, style: TextStyle(fontFamily:"Montserrat", fontSize:10, fontWeight:FontWeight.w100),),
                   ]),   
],),
SizedBox(height:0.0),
Padding(padding:EdgeInsets.only(left:40.0, right: 10.0),child:Text(document["message"],style: TextStyle(fontFamily:"Montserrat", fontSize:15, fontWeight:FontWeight.w200), textAlign: TextAlign.left,),),
  SizedBox(height:5.0),
  
  ]);
              
              }
  ),
              ),
 
 
  Form(key: _formkey,child:Row(children: <Widget>[
    SizedBox(width:20.0),
    Flexible( child:
   TextFormField(
  style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      validator: (value){
                       
                       if(value.isEmpty){
                         return
                         "Empty message!!";
                       }
                                            },
                      controller: controller3,
                      onSaved: (val){
                        setState(() {
                          message = val;
                        });
                      }
),),
    SizedBox(width:10.0),
   IconButton(icon: Icon(Icons.send), onPressed: (){
final form = _formkey.currentState;
  if(form.validate()){
form.save();
var date = DateTime.now().toString();
uploadMessage(message,date);
controller3.clear();
messages.clear();
       }

   }, color: Colors.black,),
   SizedBox(width:10.0),
   
   ],)),
SizedBox(height: 15.0,),
]),

);

  }

}