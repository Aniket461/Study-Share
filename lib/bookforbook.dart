import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studyshare/addswap.dart';
import 'MyPosts.dart';
import 'about.dart';
import 'accessories.dart';
import 'chat.dart';
import 'editprofile.dart';
import 'freepdf.dart';
import 'globals.dart' as globals;

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
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
import 'package:amazon_s3_cognito/aws_region.dart';
import 'package:path/path.dart' as path;



class BookforBook extends StatefulWidget {
  
  @override
  _BookforBook createState() => _BookforBook();
}

class _BookforBook extends State<BookforBook> {


 void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => getpro(),
        

        );
  }

List<Map<dynamic,dynamic>> all= new List(); 

bool check = false;
String proimage = "";
TextEditingController searchcont = new TextEditingController();
String search = "";
getpro() async{
var str = Firestore.instance.collection(globals.userName).document('Profile_Data');
str.get().then((value) => {
  setState((){
    proimage = value["Image"].toString();
  }),
});

// CollectionReference prod = Firestore.instance.collection("swap");
// QuerySnapshot c = await prod.orderBy('timestamp').getDocuments();
// var templist = c.documents.reversed;
// templist.map((DocumentSnapshot doc){

// all.add(doc.data);
// return doc.data;

// }).toList();

getProducts();
}

String li = "";
getProducts() async {

CollectionReference prod = Firestore.instance.collection("swap");
QuerySnapshot c = await prod.orderBy('timestamp').getDocuments();
var templist = c.documents.reversed;
templist.map((DocumentSnapshot doc){

all.add(doc.data);
return doc.data;

}).toList();

setState(() {
  li = "indise";
});
print("indise");
}


String searchh = "mic";

searchfunc() async{
  print(searchh.replaceAll(" ", ""));
Firestore.instance.collection("swap")
.where('search', isGreaterThanOrEqualTo:searchh.replaceAll(" ", "")).snapshots().listen((event) {event.documents.forEach((element) {all.add(element.data);});});

DocumentReference prod = Firestore.instance.collection("posts").document(searchh);
DocumentSnapshot c = await prod.get();
if(c.exists){
  print(true);
}
else{
  print(false);
}
setState(() {
  searchh = searchh;
});
// getpro();
}

  @override
  Widget build(BuildContext context) {
   
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
 return Scaffold(
   appBar: AppBar(
     
        title: Text("Study Share", style:TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.bold)),
        leading: IconButton(icon: Icon(Icons.dehaze), onPressed:(){
          if(_scaffoldKey.currentState.isDrawerOpen == false){
            _scaffoldKey.currentState.openDrawer();
          }else{
            _scaffoldKey.currentState.openEndDrawer();
          }
        }),
      ),
      
   body:
   Scaffold(
   
   body:Column(children: <Widget>[
   
    SizedBox(height:20.0),
  Row(mainAxisAlignment: MainAxisAlignment.center,
  children:[
    SizedBox(width:50.0),
    Flexible(child:TextField(
              controller: searchcont,
             onChanged: (value) {
              
              
              Future.delayed(Duration(milliseconds: 500),()=>{
              searchh = value.toLowerCase(),
              all.clear(),   
              check = true,  
              searchfunc(),      
              });
             }, 
              style: TextStyle(color: Colors.black,    fontSize:20.0,),
                decoration: new InputDecoration(
                  hintText:"Search for a Book..",
                    enabledBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black)
                        )
                ),
            ),),
SizedBox(width:10.0),
IconButton(icon: Icon(Icons.search), iconSize: 45.0, color: Colors.black, onPressed: ()=>{

setState(()=>{
            search = searchcont.text.toString().trim().replaceAll(" ","-"),
          }),
          

}),

SizedBox(width:50.0),

            ]),

SizedBox(height:10.0),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      Text("Book",style: TextStyle(fontFamily:"Montserrat", fontSize:20.0, fontWeight:FontWeight.bold, color: Colors.grey),),
      SizedBox(width:10.0),
            Icon(Icons.swap_horizontal_circle),
            SizedBox(width:10.0),
            Text("Book",style: TextStyle(fontFamily:"Montserrat", fontSize:20.0, fontWeight:FontWeight.bold, color: Colors.grey),),
      
    ],),
SizedBox(height:10.0),

Expanded(child:  
all.length != 0 ?
ListView.builder(
      
       itemCount: all.length,
              itemBuilder: ( context,index){
                final document = all[index];
                print(document);
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
    
Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children:[
    RaisedButton(onPressed: (){
           UrlLauncher.launch('mailto:'+document['Postedby']);
      
    },
    color: Colors.deepPurple,
     child: Row(children:[Icon(Icons.email, color: Colors.white,size: 15.0,),Text("Email", style: TextStyle(fontFamily:"Montserrat",color: Colors.white, fontSize: 13.0),),])),
    SizedBox(width:15.0),
    RaisedButton(onPressed: (){
      
    UrlLauncher.launch('tel:+91'+document['mobile']);
    },
    color: Colors.deepPurple,
     child: Row(children:[Icon(Icons.phone,color: Colors.white,size: 15.0,),Text("Call",style: TextStyle(fontFamily:"Montserrat",color: Colors.white, fontSize: 13.0)),])),
  ]),

                ])
                    ]),
                    
                  ])
                  );
              }
)
 :check == false?
              Padding(padding: EdgeInsets.only(top:50.0),child:Text("Loading...", style: TextStyle(fontFamily: "Montserrat", fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,))
              :Padding(padding: EdgeInsets.only(top:50.0),child:Text("No result found!!", style: TextStyle(fontFamily: "Montserrat", fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
               )


   ]),
   key: _scaffoldKey,
drawer:Drawer(
        child:ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 220.0,
              child:DrawerHeader(
              child:Column(children: <Widget>[
                CircleAvatar(radius: 52.0,backgroundColor: Colors.black ,child:CircleAvatar(backgroundImage: NetworkImage(proimage), radius: 70.0,)),
                SizedBox(height: 10.0,),
                Text("Hi, "+globals.userName,style: TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.bold, fontSize: 15.0, color:Colors.black)),
               // SizedBox(height: 20.0,)
              SizedBox(width:120, child:OutlineButton(highlightedBorderColor: Colors.white,highlightElevation: 20,onPressed: (){
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfile()),
            );
              }, child:Text("Edit Profile", style:TextStyle(
                fontFamily:"Montserrat", color: Colors.white, fontWeight: FontWeight.bold,
              )))),
              
              ],),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
            )),
          ListTile(
            title: Text("My Posts", style: TextStyle(fontFamily:"Montserrat", fontSize:18.0),),
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPosts()),
            );
            },
          ),
          ListTile(
            
                    title: Text("Books", style: TextStyle(fontFamily:"Montserrat", fontSize:18.0),),
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyProduct()),
                    );
                    },
                  ),
          ListTile(
            title: Text("Accessories", style: TextStyle(fontFamily:"Montserrat", fontSize:18.0),),
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAccess()),
            );
            },
          ),

          ListTile(
                    title: Text("PDF Books", style: TextStyle(fontFamily:"Montserrat", fontSize:18.0),),
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyPdf()),
                    );
                    },
                  ),
                  
ListTile(
                    title: Text("Forum", style: TextStyle(fontFamily:"Montserrat", fontSize:18.0),),
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Chat()),
                    );
                    },
                  ),
                  ListTile(
                    title: Text("About Us", style: TextStyle(fontFamily:"Montserrat", fontSize:18.0),),
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => About()),
                    );
                    },
                  ),
          ],
        ),
      ),
   ),
floatingActionButton: FloatingActionButton(onPressed:(){ Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddSwap()),
            );

  },child:Icon(Icons.add)),

   );
  }

}