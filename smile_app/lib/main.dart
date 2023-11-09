import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:smile_app/screens/Dashbord.dart';
import 'package:smile_app/screens/LoginPage.dart';
import 'package:smile_app/screens/bottomnav.dart';
import 'package:smile_app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "my app",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity:  VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white
      ),
      home:splash_screen(),
  )
  );
  }


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'smile app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      
      home:  MyHomePage(),);
  }
}



class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    checkLoggedInStatus();
  }
void checkLoggedInStatus() async{
  SharedPreferences pref=await SharedPreferences.getInstance();
  String? val=pref.getString("token");
  if(val!=null){
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context)=>Dashbord()), (route)=>false
    );
  }

}

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 219, 219),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Smile app',
                          style: TextStyle(
                            fontSize: 22.0,
                            letterSpacing: 2.8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            const Column(
              children: [
                Text(
                  'bring nature home',
                  style: TextStyle(
                    color: Color.fromARGB(255, 100, 98, 98),
                    fontSize: 16.0,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Here users enjoy Trending Memes',
                  style: TextStyle(
                    color: Color.fromARGB(255, 100, 98, 98),
                    fontSize: 16.0,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 300,
              width: 200,
              child: Image.asset('assets/images/OIP.png'),
            ),
            SizedBox(height: 25,),
            GestureDetector(
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => LoginPage()),
                  );
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Join us',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 22.0,
                        letterSpacing: 2.8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Icon(Icons.arrow_forward)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


