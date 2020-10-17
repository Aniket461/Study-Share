import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
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
import 'bookforbook.dart';



class AddSwap extends StatefulWidget {
  
  @override
  _AddSwap createState() => _AddSwap();
}

class _AddSwap extends State<AddSwap> {

String dropdownValue = 'School';
String name = "default";
String author = "";
String genreIntrested = "";
String ifschool = "1st";
String ifcollege = "11th";
String subcat = "default";
String desc = "";


void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getnumber(),

        );
  }




final _formkey = GlobalKey<FormState>();
String userNumber = "";
String profile_pic = "";
String profile_name = "";
String city = "";
String state = "";
getnumber() async{
  var str = Firestore.instance.collection(globals.userName).document('Profile_Data');
str.get().then((value) => {
  setState((){
    userNumber = value["mobile"].toString();
    profile_pic = value["Image"].toString();
     profile_name = value['name'].toString();
city = value['city'].toString();
state = value['state'].toString();

  }),
});
}

saveDataInUser(String name, String author, String genreIn, String category, String url1, String subcat, String desc, String postedby){
  DocumentReference documentReference = Firestore.instance.collection(globals.userName).document("swap").collection(globals.userName).document(name);
    Map<String,String> details = {
    "name": name,
    "author": author,
    "genreInterested": genreIn,
    "category": category,
    "url1": url1,
    "timestamp": DateTime.now().toString(),
    "subcat": subcat,
    "description": desc,
    "Postedby": postedby,
    "mobile": userNumber,
    "profile_url": profile_pic,
    "postedName": profile_name,
    "search": name.replaceAll(" ", "").toLowerCase(),
    "city": city,
    "state": state,

    };
    documentReference.setData(details).whenComplete(() =>print("$name created"));

}

saveDataInPost(String name, String author, String genreIn, String category, String url1, String subcat, String desc, String postedby){

  print("1"+url1);
  DocumentReference documentReference = Firestore.instance.collection("swap").document(name);
    Map<String,String> details = {
    "name": name,
    "author": author,
    "genreInterested": genreIn,
    "category": category,
    "url1": url1,
    "timestamp": DateTime.now().toString(),
    "subcat": subcat,
    "description": desc,
    "Postedby": postedby,
    "mobile": userNumber,
    "postedName": profile_name,
    "profile_url": profile_pic,
    "search": name.replaceAll(" ", "").toLowerCase(),
    "city": city,
    "state": state,

    };
    documentReference.setData(details).whenComplete(() =>print("$name created"));

}

final picker = ImagePicker();

File _image;
Future chooseFile1() async{
final pickedFile = await picker.getImage(source: ImageSource.gallery);
setState(() {
  _image = File(pickedFile.path);
});
}

String pictureUrl1 = "";
uploadImage1(File image) async{
  // StorageReference reference = FirebaseStorage.instance.ref().child(image.path.toString());
  // StorageUploadTask uploadTask = reference.putFile(image);
  // StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
  // pictureUrl1 = (await downloadUrl.ref.getDownloadURL());

showAlertDialog(context);

pictureUrl1 = await AmazonS3Cognito.upload(
                    image.path,
                    "studyshare",
                    "us-east-1:f5901a55-ef2a-4e23-87b9-38fc4956c29a",
                    path.basename(image.path),
                    AwsRegion.US_EAST_1,
                    AwsRegion.US_EAST_1);

setState((){

pictureUrl1 = "https://studyshare-resized.s3.amazonaws.com/"+path.basename(image.path);

});

                    print(pictureUrl1);

saveDataInUser(name, author, genreIntrested, dropdownValue,pictureUrl1, subcat, desc, globals.userName);
saveDataInPost(name, author, genreIntrested, dropdownValue, pictureUrl1, subcat, desc, globals.userName);


showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Successful",style: TextStyle(color:Colors.green),),
 content: Text("Book successfully Listed!!"),
 actions: <Widget>[
   FlatButton(onPressed: ()=>{
     
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => BookforBook()),
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


var controller = TextEditingController();
var controller1 = TextEditingController();
var controller2 = TextEditingController();
var controller3 = TextEditingController();
@override
Widget build(BuildContext context) {
return Scaffold(

appBar: AppBar(title: Text("Study Share", style:TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.bold))),
body: Column(children:[
  Padding(padding:EdgeInsets.only(top:20.0, left:50.0, right:50.0),
    child:Text("Fill the below details to list book for a swap..", style: TextStyle(fontFamily:"Montserrat", fontSize:18.0),textAlign: TextAlign.center,),),
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
                          return "Please enter your name";
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
child:Text("Author's Name:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
  ),
Padding(padding:EdgeInsets.only(top:0.0, left:50.0, right:50.0),
child:TextFormField(

  style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter Author name";
                        }
                      },
                      controller: controller1,
                      onSaved: (val){
                        setState(() {
                          author = val;
                        });
                      }
)),


SizedBox(height:15.0),

  Padding(padding:EdgeInsets.only(top:0.0, left:30.0, right:50.0),
child:Text("Little Description:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
  ),
Padding(padding:EdgeInsets.only(top:0.0, left:50.0, right:50.0),
child:TextFormField(

  style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter description";
                        }
                      },
                      controller: controller2,
                      maxLines:null,
                      keyboardType: TextInputType.multiline,
                      onSaved: (val){
                        setState(() {
                          desc = val;
                        });
                      }
)),



SizedBox(height:15.0),

  Padding(padding:EdgeInsets.only(top:0.0, left:30.0, right:50.0),
child:Text("Genre Interested:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
  ),

Padding(padding:EdgeInsets.only(top:0.0, left:50.0, right:50.0),
child:TextFormField(
  style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      validator: (value){
                        if(value.isEmpty){
                          return "PLease enter genres you are interested in";
                        }
                      },
                      controller: controller3,
                      maxLines:null,
                      keyboardType: TextInputType.multiline,
                      onSaved: (val){
                        setState(() {
                          genreIntrested = val;
                        });
                      }
)),

SizedBox(height:15.0),
Padding(padding:EdgeInsets.only(top:0.0, left:30.0, right:50.0),
child:Text("Upload a picture:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
  ),
SizedBox(height:8.0),
Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[


_image == null ? OutlineButton(padding:EdgeInsets.all(20.0) ,onPressed: () {
  chooseFile1();
}, child: Icon(Icons.add, size: 30.0,),)
: CircleAvatar(radius: 42.0,backgroundColor: Colors.black ,child:CircleAvatar(backgroundImage: FileImage(_image), radius: 70.0,)),
],),

SizedBox(height:5.0),
Padding(padding:EdgeInsets.only(top:0.0, left:30.0, right:50.0),
child:Text("*make sure the picture is of good quality", style: TextStyle(fontFamily:"Montserrat", fontSize:10.0, color: Colors.red, fontWeight: FontWeight.bold),),
  ),

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

SizedBox(height:10.0),

Center(child:RaisedButton(color: Colors.green,onPressed: (){
final form = _formkey.currentState;
  if(form.validate()){

    if(_image == null){

      
showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Error",style: TextStyle(color:Colors.red),),
 content: Text("Please enter an Image"),
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
    uploadImage1(_image);
//   showAlertDialog(context);

// Future.delayed(Duration(milliseconds: 30000),(){
// saveDataInUser(name, author, genreIntrested, dropdownValue,pictureUrl1, subcat, desc, globals.userName);
// saveDataInPost(name, author, genreIntrested, dropdownValue, pictureUrl1, subcat, desc, globals.userName);


// showDialog(context: context, builder: (BuildContext context){
// return AlertDialog(
//  title: Text("Successful",style: TextStyle(color:Colors.green),),
//  content: Text("Book successfully Listed!!"),
//  actions: <Widget>[
//    FlatButton(onPressed: ()=>{
     
// Navigator.pushAndRemoveUntil(
//   context,
//   MaterialPageRoute(builder: (context) => BookforBook()),
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
child:Text("Submit", style: TextStyle(fontFamily:"Montserrat",fontWeight: FontWeight.bold),))),

SizedBox(height:20.0),

]),))


]),


);

}
}