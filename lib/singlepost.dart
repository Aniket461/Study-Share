import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;


class SinglePost extends StatefulWidget {
  SinglePost({Key key, this.name, this.postedBy,
  this.author, this.category, this.imurl1, this.imurl2, this.imurl3, this.number,
   this.posteddat, this.price, this.subcategory, this.description,
  
  }) : super(key: key);
  final String name;
  final String postedBy;
  final String author;
  final String posteddat;
  final String imurl1;
  final String imurl2;
  final String imurl3;
  final String price;
  final String category;
  final String subcategory;
  final String number;
  final String description;
  
  
  
  
  
  @override
  _SinglePost createState() => _SinglePost();
}

class _SinglePost extends State<SinglePost> {

  //   void initState() {
  //   super.initState();
  //   WidgetsBinding.instance
  //       .addPostFrameCallback((_) => setData(),

  //       );
  // }


  @override
  Widget build(BuildContext context) {

final Imageurls = [
                  widget.imurl1,
                  widget.imurl2,
                  widget.imurl3,
                ];

return Scaffold(
  appBar: AppBar(title:Text("Study Share", style:TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.bold))),
body: ListView(children: <Widget>[

 SizedBox(height:30.0),
 CarouselSlider(
          options: CarouselOptions(
            height: 250
          ),
          items: Imageurls.map((item) => Container(
            child: Center(
              child: Container(
                width: 200,
                height:260,
                child:CachedNetworkImage(
        imageUrl: item,
        placeholder: (context, url) => Container(
          width:10,height:10,
          child:Center(child:CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(Icons.error),
     )),
            ),
          )).toList(),
        ),
                 SizedBox(height:10.0),  
  Text(widget.name, style: TextStyle(fontFamily:"Montserrat", fontSize:20.0, fontWeight:FontWeight.bold), textAlign: TextAlign.center,),
  
  Padding(padding: EdgeInsets.only(left:30.0,top: 20.0),

  child:Column(children:[
    
    Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    Text("Author: ",style:TextStyle(fontFamily:"Montserrat", fontSize:16.0, fontWeight:FontWeight.bold),),
    Text(widget.author,style:TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight:FontWeight.bold, color: Colors.grey),),
  ],),
  
  SizedBox(height: 8.0,),

  Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    Text("Description: ",style:TextStyle(fontFamily:"Montserrat", fontSize:16.0, fontWeight:FontWeight.bold),),
    Container(
      width:200,
      child:Text(widget.description,style:TextStyle(fontFamily:"Montserrat", fontSize:13.0, fontWeight:FontWeight.bold, color: Colors.grey),textAlign:TextAlign.left, ),
   ) ],),
  
  SizedBox(height: 8.0,),

  Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    Text("Category: ",style:TextStyle(fontFamily:"Montserrat", fontSize:16.0, fontWeight:FontWeight.bold),),
    Text(widget.category,style:TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight:FontWeight.bold, color: Colors.grey),),
  ],),
  
  SizedBox(height: 8.0,),
  Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    Text("Sub-Category: ",style:TextStyle(fontFamily:"Montserrat", fontSize:16.0, fontWeight:FontWeight.bold),),
    Text(widget.subcategory,style:TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight:FontWeight.bold, color: Colors.grey),),
  ],),
  SizedBox(height: 8.0,),
  Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    Text("Price: ",style:TextStyle(fontFamily:"Montserrat", fontSize:16.0, fontWeight:FontWeight.bold),),
    Text("₹ "+widget.price,style:TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight:FontWeight.bold, color: Colors.grey),),
  ],),
    SizedBox(height: 8.0,),
  Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    Text("Posted-by: ",style:TextStyle(fontFamily:"Montserrat", fontSize:14.0, fontWeight:FontWeight.bold),),
    Text(widget.postedBy,style:TextStyle(fontFamily:"Montserrat", fontSize:13.0, fontWeight:FontWeight.bold, color: Colors.grey),),
  ],),

    SizedBox(height: 8.0,),
  Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    Text("Posted-At: ",style:TextStyle(fontFamily:"Montserrat", fontSize:14.0, fontWeight:FontWeight.bold),),
    Text(widget.posteddat,style:TextStyle(fontFamily:"Montserrat", fontSize:13.0, fontWeight:FontWeight.bold, color: Colors.grey),),
  ],),
  
  ]  
  )
  ),
SizedBox(height:20.0),
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children:[
    RaisedButton(onPressed: (){
           UrlLauncher.launch('mailto:${widget.postedBy}');
      
    },
    color: Colors.deepPurple,
     child: Row(children:[Icon(Icons.email, color: Colors.white,),Text("Email", style: TextStyle(fontFamily:"Montserrat",color: Colors.white),),])),
    SizedBox(width:30.0),
    RaisedButton(onPressed: (){
      
    UrlLauncher.launch('tel:+91'+widget.number);
    },
    color: Colors.deepPurple,
     child: Row(children:[Icon(Icons.phone,color: Colors.white,),Text("Call",style: TextStyle(fontFamily:"Montserrat",color: Colors.white)),])),
  ]),
  SizedBox(height:20.0),
],),

);


  }
}




        //if mail 
