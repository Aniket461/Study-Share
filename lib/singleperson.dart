import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studyshare/products.dart';
import 'package:studyshare/singleitem.dart';
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

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;


class SinglePerson extends StatefulWidget{

SinglePerson({Key key,this.user}) : super(key: key);
String user;
   @override
  _SinglePerson createState() => _SinglePerson();
}

class _SinglePerson extends State<SinglePerson>{
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => {
        getData(),
        
        });}


showAlertDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
               CircularProgressIndicator(),
               Container(margin: EdgeInsets.only(left: 5),child:Text("Loading.." , style: TextStyle(fontFamily:"Montserrat"),),
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



String proimage = "";
String name = "";
String city = "";
String state = "";
String sel = "books";
String main = "";
List <Map<dynamic,dynamic>> all = new List();

List <Map<dynamic,dynamic>> all1 = new List();
bool check =false;
String tp = "";
getData() async{
  
  var str = Firestore.instance.collection(widget.user).document('Profile_Data');
str.get().then((value) => {
  setState((){
    proimage = value["Image"].toString();
    name = value["name"].toString();
    city = value["city"].toString();
    state = value["state"].toString();
  }),
});
// showAlertDialog(context);
CollectionReference prod = Firestore.instance.collection(widget.user).document("posts").collection(widget.user);
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
});
}


Color p = Colors.deepPurple;
Color w = Colors.white;
Color change = Colors.white;
getBooks() async{
  all.clear();
CollectionReference prod = Firestore.instance.collection(widget.user).document("posts").collection(widget.user);
QuerySnapshot c = await prod.orderBy('timestamp').getDocuments();
var templist = c.documents.reversed;
templist.map((DocumentSnapshot doc){

all.add(doc.data);
return doc.data;

}).toList();
print(all[0]);
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
CollectionReference prod = Firestore.instance.collection(widget.user).document("accessories").collection(widget.user);
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
CollectionReference prod = Firestore.instance.collection(widget.user).document("swap").collection(widget.user);
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


  @override
  Widget build(BuildContext context) {
   
  
            return Scaffold(
              appBar: AppBar(
                title:Text("Study Share", style:TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.bold)),
              ),
              body:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                 SizedBox(height: 10.0,),
                 Center(child:CircleAvatar(radius: 55.0,backgroundColor: Colors.black ,child:CircleAvatar(backgroundImage: NetworkImage(proimage), radius: 100.0,))),
                 SizedBox(height: 6.0,),
                 Text(name, style:TextStyle(fontFamily: "Montserrat", fontSize:22.0, fontWeight:FontWeight.bold), textAlign: TextAlign.center,),
                 SizedBox(height:3),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                   Icon(Icons.location_on, size: 13,),
                 Text(city, style:TextStyle(fontFamily: "Montserrat", fontSize:13.0, fontWeight:FontWeight.w100), textAlign: TextAlign.center,),
                 Text(",", style:TextStyle(fontFamily: "Montserrat", fontSize:13.0, fontWeight:FontWeight.w100), textAlign: TextAlign.center,),
                 Text(state, style:TextStyle(fontFamily: "Montserrat", fontSize:13.0, fontWeight:FontWeight.w100), textAlign: TextAlign.center,),
                 ],),
                 SizedBox(height: 8,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children:[Text("$name's posts", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,color: Colors.grey),),
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
final CarouselController _controller = CarouselController();

  
                return 
                Padding(padding:EdgeInsets.only(top:10, bottom:10),
                child: Column(children:[

                    Text(document['name'], style: TextStyle(fontFamily:"Montserrat", fontSize:22, fontWeight:FontWeight.bold),textAlign:TextAlign.center),
                   SizedBox(height: 5,),
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
                   SizedBox(height: 6.0,),
                 Row(children:[
                   SizedBox(width: 30,),
                   Text("Posted At: ",style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
                   Text(formattedDate,style: TextStyle(fontFamily:"Montserrat", fontSize:14.0,),),]),
                 SizedBox(height: 10.0,),

sel == "books"?
RaisedButton(onPressed: (){
print(document['description'],);
 Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SinglePost(name:document['name'],
              postedBy: document['Postedby'],
              author: document['author'],
              category: document['category'],
              imurl1:  document['url1'],
              imurl2: document['url2'],
              imurl3: document['url3'],
              number: document['mobile'],
              posteddat: formattedDate,
              price: document['price'],
              subcategory: document['subcat'],  
              description: document['description'],
              )));

}, child:Text("Get Details", style: TextStyle(fontFamily:"Montserrat", color:Colors.white),), color:Colors.deepPurple)
:
RaisedButton(onPressed: (){
print(document['description'],);
 Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SingleItem(name:document['name'],
              postedBy: document['Postedby'],
              author: document['condition'],
              category: document['category'],
              imurl1:  document['url1'],
              imurl2: document['url2'],
              imurl3: document['url3'],
              number: document['mobile'],
              posteddat: formattedDate,
              price: document['price'],
              subcategory: document['subcat'],  
              description: document['description'],
              )));

}, child:Text("Get Details", style: TextStyle(fontFamily:"Montserrat", color:Colors.white),), color:Colors.deepPurple),


                ]),);

              }
)
:
check == false?
Column(children:[
  
  SizedBox(height:100),
  Text("Loading....",style: TextStyle(fontFamily:"Montserrat", fontSize:16, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
])
:Column(children:[
  SizedBox(height:100),Text("No post yet...",style: TextStyle(fontFamily:"Montserrat", fontSize:16, fontWeight: FontWeight.bold))
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
                  document['url1'] ];

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
                    
                  ]));

              })

:
check == false?
Column(children:[
  
  SizedBox(height:100),
  Text("Loading....",style: TextStyle(fontFamily:"Montserrat", fontSize:16, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
])
:Column(children:[
  SizedBox(height:100),Text("No post yet...",style: TextStyle(fontFamily:"Montserrat", fontSize:16, fontWeight: FontWeight.bold))
])

) 
     ],)
   );


  }
  }
  