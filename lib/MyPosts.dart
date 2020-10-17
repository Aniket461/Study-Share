import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class MyPosts extends StatefulWidget {
  
  @override
  _MyPosts createState() => _MyPosts();
}

class _MyPosts extends State<MyPosts> {

List<Map<dynamic,dynamic>> all= new List(); 

 void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => getBooks(),
        

        );
  }
String cc = "1";
bool check = false;
getPosts() async {

CollectionReference prod = Firestore.instance.collection(globals.userName).document('posts').collection(globals.userName);
QuerySnapshot c = await prod.orderBy('timestamp').getDocuments();
var templist = c.documents.reversed;
templist.map((DocumentSnapshot doc){

all.add(doc.data);
return doc.data;

}).toList();
print(all.length);
if(all.length == 0){
setState(() {
  cc = "2";
  check = true;
});  
}
setState(() {
  cc = "2";
  check = true;
});
}
String sel = "books";
String main = "";
List <Map<dynamic,dynamic>> all1 = new List();


Color p = Colors.deepPurple;
Color w = Colors.white;
Color change = Colors.white;
String tp ="";
getBooks() async{
  all.clear();
CollectionReference prod = Firestore.instance.collection(globals.userName).document("posts").collection(globals.userName);
QuerySnapshot c = await prod.orderBy('timestamp').getDocuments();
var templist = c.documents.reversed;
templist.map((DocumentSnapshot doc){

all.add(doc.data);
return doc.data;

}).toList();
// print(all[0]);
if(all.length == 0){
setState(() {
  check = true;
});  
}

setState(() {
  tp = "check";
  sel = "books";
});
}

var col = "white";

getAccess() async{
  all.clear();
CollectionReference prod = Firestore.instance.collection(globals.userName).document("accessories").collection(globals.userName);
QuerySnapshot c = await prod.orderBy('timestamp').getDocuments();
var templist = c.documents.reversed;
templist.map((DocumentSnapshot doc){

all.add(doc.data);
return doc.data;

}).toList();
if(all.length == 0){
setState(() {
  check = true;
});  
}
setState(() {
  tp = "check";
  change = p;
  sel = "access";
});
}

getSwap() async {
  all1.clear();
CollectionReference prod = Firestore.instance.collection(globals.userName).document("swap").collection(globals.userName);
QuerySnapshot c = await prod.orderBy('timestamp').getDocuments();
var templist = c.documents.reversed;
templist.map((DocumentSnapshot doc){

all1.add(doc.data);
return doc.data;

}).toList();
print(all1.length);
// print(all1[0]);
if(all1.length == 0){
setState(() {
  check = true;
});  
}
setState(() {
  tp = "check";
  change = p;
  main="swap";
  sel = "swap";
});}




showAlertDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
               CircularProgressIndicator(),
               Container(margin: EdgeInsets.only(left: 5),child:Text("Deleting Post.." , style: TextStyle(fontFamily:"Montserrat"),),
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
body: 
Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children:[
  SizedBox(height:20.0),
  Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children:[Text(globals.userName+"'s posts", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,color: Colors.grey),),
                 Icon(Icons.arrow_downward, size: 19,color: Colors.grey,) ]),
         SizedBox(height: 5,),
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children:[
         SizedBox( width:80,child:RaisedButton(
           color: sel == 'books'? Colors.green : Colors.white,
  onPressed: (){
    setState(() {
      sel = "books";
      main= "";
      check = false;
    });
    getBooks();
  }, child:Text("Books",style:TextStyle(fontFamily:"Montserrat", fontSize:12.0,color: Colors.black)))),

SizedBox(width:3),
SizedBox( width:110,child:RaisedButton(
  highlightColor: Colors.deepPurple,
  color: sel == 'access'? Colors.green : Colors.white,
  onPressed: (){
    setState(() {
      sel = "access";
       main= "";
       check = false;
    });
    getAccess();

  }, child:Text("Accessories",style:TextStyle(fontFamily:"Montserrat", fontSize:12.0,color: Colors.black)))),

SizedBox(width:3),
SizedBox( width:80,child:RaisedButton(
           color: sel == 'swap'? Colors.green : Colors.white,
  onPressed: (){
    setState(() {
      sel = "swap";
      main = "swap";
      check = false;
    });
    getSwap();
  },
   child:Text("Swap",style:TextStyle(fontFamily:"Montserrat", fontSize:12.0,color: Colors.black)))),
]),

main != "swap"?
Expanded(child:
all.length != 0 ?
ListView.builder(
              itemCount: all.length,
              itemBuilder: ( context,index){
                final document = all[index];
                print(document);
                final Imageurls = [
                  document['url1'],
                  document['url2'],
                  document['url3'], 
                ];
                 var date = DateTime.parse(document['timestamp']);
var formattedDate = "${date.day}-${date.month}-${date.year}";
               
                 return 
                  Padding(padding:EdgeInsets.only(top:20.0, bottom:20.0),child:Column(children:[
                 
                 
                 Text(document['name'], style: TextStyle(fontFamily:"Montserrat", fontSize:20.0, fontWeight: FontWeight.bold),),
                 SizedBox(height: 10.0,),
                 Row(
                   children:[
                     SizedBox(width:30.0),
                   Flexible(child:Text(document['description'],  style: TextStyle(fontFamily:"Montserrat", fontSize:16),),),
                   SizedBox(width:20.0),
                 ]),
                 SizedBox(height: 10.0,),
                 Row(children:[
                   SizedBox(width: 30,),
                   Text("Price: ",style: TextStyle(fontFamily:"Montserrat", fontSize:18.0, fontWeight: FontWeight.bold),),
                   Text("₹ "+document['price'],style: TextStyle(fontFamily:"Montserrat", fontSize:16.0,),),]),
                   SizedBox(height: 10.0,),
                 Row(children:[
                   SizedBox(width: 30,),
                   Text("Posted At: ",style: TextStyle(fontFamily:"Montserrat", fontSize:18.0, fontWeight: FontWeight.bold),),
                   Text(formattedDate,style: TextStyle(fontFamily:"Montserrat", fontSize:16.0,),),]),
                 SizedBox(height: 10.0,),
                 RaisedButton(onPressed: () async{

showAlertDialog(context);

if(sel == "books"){
await Firestore.instance.collection("posts").document(document['name']).delete();
await Firestore.instance.collection(globals.userName).document("posts").collection(globals.userName).document(document['name']).delete();
}
else if(sel == "access"){
await Firestore.instance.collection("accessories").document(document['name']).delete();
await Firestore.instance.collection(globals.userName).document("accessories").collection(globals.userName).document(document['name']).delete();
}
showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Deleted!",style: TextStyle(color:Colors.red),),
 content: Text("Post successfully deleted"),
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

                 }, child:Text("Delete Post", style: TextStyle(fontFamily:"Montserrat"),), color: Colors.red,),


                  ])
                  );
              
              }
)
:
check == false?
Column(children:[
  
  SizedBox(height:100),
  Text("Loading....",style: TextStyle(fontFamily:"Montserrat", fontSize:16, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
])
:Column(children:[
  SizedBox(height:100),Text("You haven't posted anything yet.",style: TextStyle(fontFamily:"Montserrat", fontSize:16, fontWeight: FontWeight.bold))
])

)
:
Expanded(child:
all1.length != 0 ?
ListView.builder(
              itemCount: all1.length,
              itemBuilder: ( context,index){
                final document = all1[index];
                print(document);
                final Imageurls = [
                  document['url1'],
                ];

  var date = DateTime.parse(document['timestamp']);
var formattedDate = "${date.day}-${date.month}-${date.year}";
               
                 return 
                  Padding(padding:EdgeInsets.only(top:20.0, bottom:20.0),child:Column(children:[
               

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
SizedBox(width: 15.0,),
Container(
                width: 100,
                height:200,
                // child:Image.network(item, fit: BoxFit.fill,)
                
child:CachedNetworkImage(
        imageUrl: document['url1'],
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width:10,height:10,
          child:Center(child:CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(Icons.error),
     ),
                ),
                
                SizedBox(width:15.0),
                Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                  
                  
                  Container(width:200,child:Text(document['name'], style: TextStyle(fontFamily:"Montserrat", fontSize:20.0, fontWeight:FontWeight.bold),textAlign: TextAlign.left,),
                   ), SizedBox(height:5),

                Row(children: <Widget>[
                 
                  Container(width:200 ,child: Text(document['description'],style: TextStyle(fontFamily:"Montserrat", fontSize:14.0, fontWeight:FontWeight.w100))),
                  SizedBox(width:20.0),
                ],),
 SizedBox(height:5),

                Row(children: <Widget>[
                  Text("Posted-by: ", style: TextStyle(fontFamily:"Montserrat", fontSize:14.0, fontWeight:FontWeight.bold),),
                  Row(children: <Widget>[
                 
                  Container(width:140 ,child: Text(document['postedName'],style: TextStyle(fontFamily:"Montserrat", fontSize:14.0, fontWeight:FontWeight.w100))),
                  // SizedBox(width:20.0),
                ],),
                ],)  ,
 SizedBox(height:5),
                Row(children: <Widget>[
                  Text("Posted-at: ", style: TextStyle(fontFamily:"Montserrat", fontSize:14.0, fontWeight:FontWeight.bold),),
                  Text(formattedDate, style: TextStyle(fontFamily:"Montserrat", fontSize:14.0, fontWeight:FontWeight.w100),),
                ],),  
SizedBox(height: 5.0,),
                  Text("Interested Genre:", style: TextStyle(fontFamily:"Montserrat", fontSize:14.0, fontWeight:FontWeight.bold),),
                  Row(children: <Widget>[
                 
                  Container(width:210 ,child: Text(document['genreInterested'],style: TextStyle(fontFamily:"Montserrat", fontSize:14.0, fontWeight:FontWeight.w100))),
                  // SizedBox(width:20.0),
                ],),
 SizedBox(height: 5.0,),
Row(
                    children:[
                    Icon(Icons.location_on, color: Colors.grey, size:16.0),
                    Text(document['city'],style: TextStyle(color:Colors.black, fontFamily: 'Montserrat', fontSize: 12.0)),
                  Text(", ",style: TextStyle(color:Colors.black, fontFamily: 'Montserrat', fontSize: 12.0)),
                  Text(document['state'],style: TextStyle(color:Colors.black, fontFamily: 'Montserrat', fontSize: 12.0)),
                  
                  ]),
 SizedBox(height: 5.0,),

                  ])

                      ]),
                 RaisedButton(onPressed: () async{

showAlertDialog(context);

// if(sel == "books"){
// await Firestore.instance.collection("posts").document(document['name']).delete();
// await Firestore.instance.collection(globals.userName).document("posts").collection(globals.userName).document(document['name']).delete();
// }
// else if(sel == "access"){
// await Firestore.instance.collection("accessories").document(document['name']).delete();
// await Firestore.instance.collection(globals.userName).document("accessories").collection(globals.userName).document(document['name']).delete();
// }

await Firestore.instance.collection("swap").document(document['name']).delete();
await Firestore.instance.collection(globals.userName).document("swap").collection(globals.userName).document(document['name']).delete();

showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Deleted!",style: TextStyle(color:Colors.red),),
 content: Text("Post successfully deleted"),
 actions: <Widget>[
   FlatButton(onPressed: ()=>{
     
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) =>  MyProduct()),
  (Route<dynamic> route) => false,
)
  } ,child:Text("close"))
 ],
);
});

                 }, child:Text("Delete Post", style: TextStyle(fontFamily:"Montserrat"),), color: Colors.red,),

                  ]));

              })
              
              :
              
              
check == false?
Column(children:[
  
  SizedBox(height:100),
  Text("Loading....",style: TextStyle(fontFamily:"Montserrat", fontSize:16, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
])
:Column(children:[
  SizedBox(height:100),Text("You haven't posted anything yet.",style: TextStyle(fontFamily:"Montserrat", fontSize:16, fontWeight: FontWeight.bold))
])

              )

])


    );
  }

}