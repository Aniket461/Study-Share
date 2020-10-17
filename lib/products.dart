import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studyshare/bookforbook.dart';
import 'package:studyshare/editprofile.dart';
import 'about.dart';
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
import 'editprofile.dart';
import 'singleperson.dart';

class MyProduct extends StatefulWidget {
  
  @override
  _MyProduct createState() => _MyProduct();
}

class _MyProduct extends State<MyProduct> {

 void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => getpro(),
        

        );
  }

bool check = false;
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
List<Map<dynamic,dynamic>> all= new List(); 

void signOutGoogle() async{
  await googleSignIn.signOut();
  SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('email');
            prefs.remove('photo');
            
  
   globals.userName = "";
   globals.purl = '';
   print("User Sign Out");
 
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => MyApp()),
  (Route<dynamic> route) => false,
);
}

TextEditingController searchcont = new TextEditingController();
String search = "";
String proimage = "";

getpro() async{
var str = Firestore.instance.collection(globals.userName).document('Profile_Data');
str.get().then((value) => {
  setState((){
    proimage = value["Image"].toString();
  }),
});

CollectionReference prod = Firestore.instance.collection("posts");
QuerySnapshot c = await prod.orderBy('timestamp').getDocuments();
var templist = c.documents.reversed;
templist.map((DocumentSnapshot doc){

all.add(doc.data);
return doc.data;

}).toList();

getProducts();
}

String li = "";
getProducts() async {

CollectionReference prod = Firestore.instance.collection("posts");
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
Firestore.instance.collection("posts")
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
getpro();
}


@override
  Widget build(BuildContext context) {
print("profile photo"+proimage);
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
        actions: globals.userName != '' ? <Widget>[IconButton(icon: Icon(Icons.power_settings_new), onPressed: (){
          signOutGoogle();
        })]
        : <Widget>[]
        
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
     Text("Showing result for Books", style: TextStyle(fontFamily:"Montserrat", fontSize:18.0),textAlign: TextAlign.center,),
SizedBox(height:10.0),

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
                  Padding(padding:EdgeInsets.only(top:20.0, bottom:20.0),child:Column(children:[
                    Row(children:[
                      SizedBox(width:15.0),
                      CircleAvatar(radius: 24.0,backgroundColor: Colors.black ,child:CircleAvatar(backgroundImage: NetworkImage(document['profile_url']),  radius: 22.0,)),
                      SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          RichText(text: 
                       TextSpan(text:document['postedName'], style: TextStyle(fontFamily:"Montserrat", fontSize: 16.0, fontWeight:FontWeight.bold, color:Colors.black), 
                       recognizer: TapGestureRecognizer()
                         ..onTap = (){
                           print(document['postedName']);
                          Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SinglePerson(user:document['Postedby'])),
);
                         }
                       )
                       ), 
                      // Text(document['postedName'], style:TextStyle(fontFamily:"Montserrat", fontSize: 16.0, fontWeight:FontWeight.bold)),
                      SizedBox(height: 4.0),
                      Text(formattedDate, style:TextStyle(fontFamily:"Montserrat", fontSize: 12.0)),
                      ]),
                    
                    ]),
SizedBox(height:15.0),

Row(children: <Widget>[

SizedBox(width: 30.0,),
Flexible(child: Container(child: 
Text(document['description'], style: TextStyle(fontFamily:"Montserrat", fontSize: 17.0, color: Colors.black, fontWeight: FontWeight.w100)),
 )
 ),
SizedBox(width:20.0),

]),

SizedBox(height:12.0),

                    CarouselSlider(
                      carouselController: _controller,
          options: CarouselOptions(
            height: 250
          ),
          items: Imageurls.map((item) => Container(
            child: Center(
              child: Container(
                width: 200,
                height:260,
                // child:Image.network(item, fit: BoxFit.fill,)
                
child:CachedNetworkImage(
        imageUrl: item,
        placeholder: (context, url) => Container(
          width:10,height:10,
          child:Center(child:CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(Icons.error),
     ),
                ),
            ),
          )).toList(),
        ),
                    
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
   children:[
IconButton(onPressed:(){
  _controller.previousPage();
},icon:Icon(Icons.arrow_left), color: Colors.black,),
IconButton(onPressed:(){
_controller.nextPage();
},icon:Icon(Icons.arrow_right), color: Colors.black,),
]),                    
                    SizedBox(height:10.0),
                  Text(document['name'],style: TextStyle(color:Colors.black, fontFamily: 'Montserrat', fontSize: 22.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  SizedBox(height:10.0),
                  
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text("Price:",style: TextStyle(color:Colors.black, fontFamily: 'Montserrat', fontSize: 20.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  SizedBox(width:5),
                  Text("₹ "+document['price'],style: TextStyle(color:Colors.black, fontFamily: 'Montserrat', fontSize: 18.0),textAlign: TextAlign.center,),
                  ],),

SizedBox(height:5.0),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                    Icon(Icons.location_on, color: Colors.grey, size:16.0),
                    Text(document['city'],style: TextStyle(color:Colors.black, fontFamily: 'Montserrat', fontSize: 12.0)),
                  Text(", ",style: TextStyle(color:Colors.black, fontFamily: 'Montserrat', fontSize: 12.0)),
                  Text(document['state'],style: TextStyle(color:Colors.black, fontFamily: 'Montserrat', fontSize: 12.0)),
                  
                  ]),

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

}, child:Text("Get Details", style: TextStyle(fontFamily:"Montserrat", color:Colors.white),), color:Colors.deepPurple),

                  ])
                );
              })
              :
              check == false?
              Padding(padding: EdgeInsets.only(top:50.0),child:Text("Loading...", style: TextStyle(fontFamily: "Montserrat", fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,))
              :Padding(padding: EdgeInsets.only(top:50.0),child:Text("No result found!!", style: TextStyle(fontFamily: "Montserrat", fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
              
)
// Row(
//   mainAxisAlignment: MainAxisAlignment.end,
//   children:[FloatingActionButton(onPressed: (){

// Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AddProduct()),
//             );

//   },child:Icon(Icons.add)),
//   SizedBox(width:20.0),
//   ]),

// SizedBox(height:15.0),
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
              MaterialPageRoute(builder: (context) => AddProduct()),
            );

  },child:Icon(Icons.add)),

 );

  }
}