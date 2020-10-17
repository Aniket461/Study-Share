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


class AddProduct extends StatefulWidget {
  
  @override
  _AddProduct createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct> {

String dropdownValue = 'School';
String name = "default";
String author = "";
String price = "";
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

saveDataInUser(String name, String author, String price, String category, String url1, String url2, String url3, String subcat, String desc, String postedby){
  DocumentReference documentReference = Firestore.instance.collection(globals.userName).document("posts").collection(globals.userName).document(name);
    Map<String,String> details = {
    "name": name,
    "author": author,
    "price": price,
    "category": category,
    "url1": url1,
    "url2": url2,
    "url3": url3,
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

saveDataInPost(String name, String author, String price, String category, String url1, String url2, String url3, String subcat, String desc, String postedby){

  print("1"+url1);
  print("1"+url2);
  print("1"+url3);
  DocumentReference documentReference = Firestore.instance.collection("posts").document(name);
    Map<String,String> details = {
    "name": name,
    "author": author,
    "price": price,
    "category": category,
    "url1": url1,
    "url2": url2,
    "url3": url3,
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
File _image2;
Future chooseFile2() async{
final pickedFile = await picker.getImage(source: ImageSource.gallery);
setState(() {
  _image2 = File(pickedFile.path);
});
}

File _image3;
Future chooseFile3() async{
final pickedFile = await picker.getImage(source: ImageSource.gallery);
setState(() {
  _image3 = File(pickedFile.path);
});
}



String pictureUrl2 = "";
uploadImage2(File image) async{
  // StorageReference reference = FirebaseStorage.instance.ref().child(image.path.toString());
  // StorageUploadTask uploadTask = reference.putFile(image);
  // StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
  // pictureUrl2 = (await downloadUrl.ref.getDownloadURL());
  // pictureUrl2 = await SimpleS3.uploadFile(
  //                   image,
  //                   "studyshare/images",
  //                   "us-east-1:f5901a55-ef2a-4e23-87b9-38fc4956c29a",                    
  //                   AWSRegions.usEast1,
  //                   fileName:path.basename(image.path),
  //                  );


setState((){

pictureUrl2 = "https://studyshare.s3.amazonaws.com/images/"+path.basename(image.path);

});

                    print(pictureUrl2);



}


String pictureUrl3 = "";
uploadImage3(File image) async{
  // StorageReference reference = FirebaseStorage.instance.ref().child(image.path.toString());
  // StorageUploadTask uploadTask = reference.putFile(image);
  // StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
  // pictureUrl3 = (await downloadUrl.ref.getDownloadURL());
  // print("main"+pictureUrl3);

  // pictureUrl3 = await SimpleS3.uploadFile(
  //                   image,
  //                   "studyshare/images",
  //                   "us-east-1:f5901a55-ef2a-4e23-87b9-38fc4956c29a",                    
  //                   AWSRegions.usEast1,
  //                   fileName:path.basename(image.path),
  //                  );

setState((){

pictureUrl3 = "https://studyshare-resized.s3.amazonaws.com/"+path.basename(image.path);

});

                    print(pictureUrl3);


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




String pictureUrl1 = "";

uploadImage1(File image) async{
  // StorageReference reference = FirebaseStorage.instance.ref().child(image.path.toString());
  // StorageUploadTask uploadTask = reference.putFile(image);
  // StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
  // pictureUrl1 = (await downloadUrl.ref.getDownloadURL());

showAlertDialog(context);

try{
pictureUrl1 = await AmazonS3Cognito.upload(
                    image.path,
                    "studyshare",
                    "us-east-1:f5901a55-ef2a-4e23-87b9-38fc4956c29a",
                    path.basename(image.path),
                    AwsRegion.US_EAST_1,
                    AwsRegion.US_EAST_1);

} on Exception catch(e){
print(e);
print("3rd");
}

setState((){

pictureUrl1 = "https://studyshare-resized.s3.amazonaws.com/"+path.basename(image.path);

});

                    print(pictureUrl1);

try{
 pictureUrl2 = await AmazonS3Cognito.upload(
                    _image2.path,
                    "studyshare",
                    "us-east-1:f5901a55-ef2a-4e23-87b9-38fc4956c29a",
                    path.basename(_image2.path),
                    AwsRegion.US_EAST_1,
                    AwsRegion.US_EAST_1);

} on Exception catch(e){

print(e);
print("3rd");
}

setState((){

pictureUrl2 = "https://studyshare-resized.s3.amazonaws.com/"+path.basename(_image2.path);

});

                    print(pictureUrl2);


try{
 pictureUrl3 = await AmazonS3Cognito.upload(
                    _image3.path,
                    "studyshare",
                    "us-east-1:f5901a55-ef2a-4e23-87b9-38fc4956c29a",
                    path.basename(_image3.path),
                    AwsRegion.US_EAST_1,
                    AwsRegion.US_EAST_1);
} on Exception catch(e){
print(e);
print("3rd");
}


setState((){
pictureUrl3 = "https://studyshare-resized.s3.amazonaws.com/"+path.basename(_image3.path);
});

                    print(pictureUrl3);

  
  // uploadImage2(_image2);
  // uploadImage3(_image3);
saveDataInUser(name, author, price, dropdownValue,pictureUrl1, pictureUrl2, pictureUrl3, subcat, desc, globals.userName);
saveDataInPost(name, author, price, dropdownValue, pictureUrl1,pictureUrl2,pictureUrl3, subcat, desc, globals.userName);
showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Successful",style: TextStyle(color:Colors.green),),
 content: Text("$name successfully listed for selling!!"),
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
    child:Text("Fill the below details to list book for selling..", style: TextStyle(fontFamily:"Montserrat", fontSize:18.0),textAlign: TextAlign.center,),),
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
child:Text("Description:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
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
child:Text("Price(in ₹):", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
  ),

Padding(padding:EdgeInsets.only(top:0.0, left:50.0, right:150.0),
child:TextFormField(
  style: TextStyle(fontFamily:"Montserrat", fontSize:15.0,),
                      validator: (value){
                        String pattern =r'(^[0-9]{1,10}$)';
    RegExp regex = new RegExp(pattern);
                        if(!regex.hasMatch(value)){
                          return "Please enter a valid price";
                        }
                      },
                      controller: controller3,
                      onSaved: (val){
                        setState(() {
                          price = val;
                        });
                      }
)),

SizedBox(height:15.0),
Padding(padding:EdgeInsets.only(top:0.0, left:30.0, right:50.0),
child:Text("Upload pictures:", style: TextStyle(fontFamily:"Montserrat", fontSize:15.0, fontWeight: FontWeight.bold),),
  ),
SizedBox(height:8.0),
Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[


_image == null ? OutlineButton(padding:EdgeInsets.all(20.0) ,onPressed: () {
  chooseFile1();
}, child: Icon(Icons.add, size: 30.0,),)
: CircleAvatar(radius: 42.0,backgroundColor: Colors.black ,child:CircleAvatar(backgroundImage: FileImage(_image), radius: 70.0,)),

_image2== null ? OutlineButton(padding:EdgeInsets.all(20.0) ,onPressed: () {
  chooseFile2();
}, child: Icon(Icons.add, size: 30.0,),)
: CircleAvatar(radius: 42.0,backgroundColor: Colors.black ,child:CircleAvatar(backgroundImage: FileImage(_image2), radius: 70.0,)),


_image3==null ? OutlineButton(padding:EdgeInsets.all(20.0) ,onPressed: () {

  chooseFile3();
  
}, child: Icon(Icons.add, size: 30.0,),)
: CircleAvatar(radius: 42.0,backgroundColor: Colors.black ,child:CircleAvatar(backgroundImage: FileImage(_image3), radius: 70.0,)),


],),
SizedBox(height:5.0),
Padding(padding:EdgeInsets.only(top:0.0, left:30.0, right:50.0),
child:Text("*make sure the pictures are of good quality", style: TextStyle(fontFamily:"Montserrat", fontSize:10.0, color: Colors.red, fontWeight: FontWeight.bold),),
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

    name = controller.value.text;
    author = controller1.value.text;
    desc = controller2.value.text;
    price = controller3.value.text;
    // state = controller4.value.text;
    // country = controller5.value.text;

  if(form.validate()){

    if(_image == null || _image2 == null || _image3 == null){

      
showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Error",style: TextStyle(color:Colors.red),),
 content: Text("Please enter all three images"),
 actions: <Widget>[
   FlatButton(onPressed: ()=>{
     Navigator.of(context).pop()
  } ,child:Text("close"))
 ],
);
});

    }


  else if(name == "default" || name == "" ||author == "" ||desc == "" ||price == "" ){
      controller.clear();
      controller1.clear();
      controller2.clear();
      controller3.clear();
      // controller4.clear();
      // controller5.clear();
showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Error",style: TextStyle(color:Colors.red),),
 content: Text("All fields are mandatory, Please refill them again..."),
 actions: <Widget>[
   FlatButton(onPressed: ()=>{

Navigator.of(context).pop(),

  } ,child:Text("close"))
 ],
);
});
    }

    else{
    form.save();
    uploadImage1(_image);
//     uploadImage2(_image2);
//     uploadImage3(_image3);
//   showAlertDialog(context);

// Future.delayed(Duration(milliseconds: 30000),(){
// saveDataInUser(name, author, price, dropdownValue,pictureUrl1, pictureUrl2, pictureUrl3, subcat, desc, globals.userName);
// saveDataInPost(name, author, price, dropdownValue, pictureUrl1,pictureUrl2,pictureUrl3, subcat, desc, globals.userName);


// showDialog(context: context, builder: (BuildContext context){
// return AlertDialog(
//  title: Text("Successful",style: TextStyle(color:Colors.green),),
//  content: Text("$name successfully listed for selling!!"),
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
// // }); 
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