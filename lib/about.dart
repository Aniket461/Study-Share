import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class About extends StatefulWidget{
     @override
  _About createState() => _About();
}

class _About extends State<About>{
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title:Text("Study Share", style:TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.bold))),
              
              body:
              ListView(children:[
                
                Center(child:Image.asset('assets/images/iconss.png', width:150)),

                Padding(padding: EdgeInsets.only(left: 20, right:20), child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Study Share is a books and resources sharing/selling app, where you can put ads for all your used/brand new books and resources with an appropriate price to make it available to someone in need of it.",
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 15,),textAlign: TextAlign.justify),
                  SizedBox(height: 8,),
                  Text("Not only you can buy/sell, but also you can put ads for swapping books with someone interested in it and also has a book of your taste.",
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 15,),textAlign: TextAlign.justify),
                  SizedBox(height: 8,),
                  Text("The app is built using Flutter as tech stack and uses AWS for storage and Firebase's Firecloud for database.",
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 15,),textAlign: TextAlign.justify),
                  SizedBox(height: 8,),
                 Text("Study Share is created by Aniket Surve, A creative Tech enthusiast and an IT Engineer by profession.",
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 15,),textAlign: TextAlign.justify),
                  Text("You can reach out to me at my website!!",
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 15,),textAlign: TextAlign.justify),
                  OutlineButton(onPressed: (){
                    UrlLauncher.launch("https://aniwebsite.netlify.com");
                  }, child:Text("Visit my Website",style: TextStyle(fontFamily: "Montserrat", fontSize: 16,color: Colors.deepPurple),)),

  SizedBox(height: 20.0,),
              ],)),
              ]),
    );
    
     }




}