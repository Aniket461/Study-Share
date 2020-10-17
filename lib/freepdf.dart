import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studyshare/products.dart';
import 'about.dart';
import 'bookforbook.dart';
import 'chat.dart';
import 'editprofile.dart';
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
import 'addfreepdf.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;


class MyPdf extends StatefulWidget {
  
  @override
  _MyPdf createState() => _MyPdf();
}

class _MyPdf extends State<MyPdf> {
List<Map<dynamic,dynamic>> all= new List(); 


bool check = false;

 void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => getpro(),
        

        );
  }


String setin = "";

getPdf() async {

CollectionReference prod = Firestore.instance.collection("pdfs");
QuerySnapshot c = await prod.orderBy('timestamp').getDocuments();
var templist = c.documents.reversed;
templist.map((DocumentSnapshot doc){

all.add(doc.data);
return doc.data;

}).toList();
print("aove pdf");
print(all[0]['subcat']);
setState((){
setin = "check";
});
print(all[0]);
}

getpro() async{
var str = Firestore.instance.collection(globals.userName).document('Profile_Data');
str.get().then((value) => {
  setState((){
    proimage = value["Image"].toString();
  }),
});
getPdf();
}


              TextEditingController searchcont = new TextEditingController();
String search = "";
String proimage = "";
String searchh = "All Books";

searchfunc() async{
  print(searchh.replaceAll(" ", ""));
Firestore.instance.collection("pdfs")
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
}

@override
  Widget build(BuildContext context) {

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
 
return Scaffold(
  appBar: AppBar(title:Text("Study Share", style:TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.bold)),
  leading: IconButton(icon: Icon(Icons.dehaze), onPressed:(){
          if(_scaffoldKey.currentState.isDrawerOpen == false){
            _scaffoldKey.currentState.openDrawer();
          }else{
            _scaffoldKey.currentState.openEndDrawer();
          }
        }),),
  body:
  Scaffold(
  body:Column(children:[
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
                  hintText:"Search for Books..",
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
    Center(child:Text("Showing results for '$searchh'", textAlign: TextAlign.center, style: TextStyle(fontFamily:"Montserrat", fontSize:20.0, fontWeight:FontWeight.bold, color: Colors.grey),),),
    SizedBox(height:10.0),
    
Expanded(child:  
all.length != 0 ?
ListView.builder(
              itemCount: all.length,
              itemBuilder: ( context,index){
                final document = all[index];
                                var date = DateTime.parse(document['timestamp']);
var formattedDate = "${date.day}-${date.month}-${date.year}";


return 
Column(
  children: <Widget>[

Text(document['name'], textAlign: TextAlign.center, style: TextStyle(fontFamily:"Montserrat", fontSize:20.0, fontWeight:FontWeight.bold),),

SizedBox(height: 10.0,),
Row(
  children: <Widget>[
SizedBox(width:50.0),
Text("Category: ",style: TextStyle(fontFamily:"Montserrat", fontSize:14.0, fontWeight:FontWeight.bold),),
Text(document["category"],style: TextStyle(fontFamily:"Montserrat", fontSize:13.0,),),
],),
SizedBox(height: 10.0,),

Row(
  children: <Widget>[
SizedBox(width:50.0),
Text("Sub-category: ",style: TextStyle(fontFamily:"Montserrat", fontSize:14.0, fontWeight:FontWeight.bold),),
Text(document["subcat"],style: TextStyle(fontFamily:"Montserrat", fontSize:13.0,),),
],),

SizedBox(height: 10.0,),
Row(children: <Widget>[
SizedBox(width:50.0),

  Text("Posted-at: ",style: TextStyle(fontFamily:"Montserrat", fontSize:14.0, fontWeight:FontWeight.bold),),
  Text(formattedDate,style: TextStyle(fontFamily:"Montserrat", fontSize:13),),
],),
SizedBox(height: 10.0,),

Container(width: 140.0,child:RaisedButton(color: Colors.green,onPressed: (){
 UrlLauncher.launch(document['pdfurl']);
},
child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children:[
  Icon(Icons.file_download),
  Text("Download",style: TextStyle(fontFamily:"Montserrat",))]))),


SizedBox(height:30.0),

  ],
);

              })
              :
              check == false?
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
                Text("Hi, "+globals.userName,style: TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.bold, fontSize: 15.0,)),
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
            }
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
                    title: Text("Book for Book", style: TextStyle(fontFamily:"Montserrat", fontSize:18.0),),
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookforBook()),
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
              MaterialPageRoute(builder: (context) => MyAddPdf()),
            );

  },child:Icon(Icons.add)),

);


}
}