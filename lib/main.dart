import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'details.dart';


void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Study Share'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setData(),

        );
  }

void setData() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
     if(!prefs.containsKey('email')){

       globals.userName = "";
       globals.purl = "";
       globals.log = prefs.getString('logged');

     }
else{
setState(() {
     globals.userName = prefs.getString('email');
    //  = googleSignIn.currentUser.email;
    globals.purl = prefs.getString('photo');
    globals.log = prefs.getString('logged');
  });}
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);
  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  setState(() {
     globals.userName = googleSignIn.currentUser.email;
     globals.purl = googleSignIn.currentUser.photoUrl;
   });
  SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email',googleSignIn.currentUser.email);
            prefs.setString('photo',googleSignIn.currentUser.photoUrl);
            prefs.setString('logged',"yes");

  return 'signInWithGoogle succeeded: $user';
}
void signOutGoogle() async{
  await googleSignIn.signOut();
  SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('email');
            prefs.remove('photo');
            prefs.setString('logged', "no");
  
   globals.userName = "";
   globals.purl = '';
   print("User Sign Out");
 
Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      
      globals.userName == '' ?
      
       Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Image.asset('assets/images/iconss.png', width: 300,),
          // Text("Welcome to Study Share", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0, fontFamily: "Montserrat")),
          OutlineButton(onPressed: () =>{
            signInWithGoogle()
          },color: Colors.white,padding: EdgeInsets.only(top:5,bottom:5, left: 5),child: SizedBox(width:150, child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[Image.asset('assets/images/google_logo.png', width: 40,),SizedBox(width:15),
          Text("Login", style: TextStyle(fontFamily:"Montserrat", fontSize: 18.0),)]))),
        ]
        )
        ) 
        : MyDetail(),
     );
  }
}
