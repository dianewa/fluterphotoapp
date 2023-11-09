import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smile_app/connectiostring/api_connection.dart';
import 'package:smile_app/screens/HomePage.dart';
import 'package:smile_app/screens/LoginPage.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:smile_app/screens/circle_button.dart';
import 'package:smile_app/screens/update_user.dart';


class Dashbord extends StatefulWidget {
  @override
  State<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  String user_id="";
  String token="";
  String last_names="";
  String user_email="";
  String first_name="";
  String User_role="";
  String user_picture="";

  PageController pageController = PageController();
  int selectedIndex = 0;


  @override
  void initState(){
    super.initState();
    getCred();
  }

  void getCred() async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    setState(() {
      user_id=pref.getString("user_id")!;
      token=pref.getString("token")!;
      user_picture=pref.getString("user_picture")!;
      last_names=pref.getString("last_names")!;
      first_name=pref.getString("first_name")!;
      user_email=pref.getString("user_email")!;
      User_role=pref.getString("User_role")!;
    });
  }

  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: 80,
        title: const Text("Smile_Memes",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
        actions: [
          // Circlebutton(
          //   icon: Icons.search,
          //   iconSize: 30,
          //   onPressed: (){},
          // ),
          Circlebutton(
            icon: Icons.notification_important_outlined,
            iconSize: 30,
            onPressed: (){},
          )

        ],
      ),
      drawer: DrawerContent(context),
      bottomNavigationBar: bottonNavButton(),
      body:  body(child),
    );
  }

  Column body(List<Widget> child) {
    return Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: onPageChanged,
              itemCount: child.length,
              itemBuilder: (context, index) {
                return Container(
                  child: child[index],
                );
              },
            ),
          ),
        ]
    );
  }

  Drawer DrawerContent(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(left: 30),
            height: 200, // Set the desired height here
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.green, // Change this to your desired background color
            ),
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                // color: Colors.red, // Change this to your desired background color
              ),
              accountName: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(first_name, style: const TextStyle(color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
                  Text(last_names, style: TextStyle(color: Colors.black)),
                ],
              ),
              accountEmail: Text(user_email, style: const TextStyle(color: Colors.black)),
              currentAccountPicture: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    height: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Image.network(
                        '${Connection_String.profile}${user_picture}',
                        width: 40,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )


                ],
              ),
            ),
          ),

          ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateUserScreen(
                        userId: user_id,
                        currentfirst_name: first_name,
                        currentlast_names: last_names,
                        currentuser_email: user_email,
                        currentuser_picture: user_picture,
                        currentuser_password: '', // Pass the appropriate value here
                        User_role: User_role,
                      ),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.update),
                    SizedBox(width: 10),
                    Text('Update'),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: () async {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  await pref.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text("Logout"),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  BottomAppBar bottonNavButton() {
    return BottomAppBar(
      elevation: 0,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < bottomIcons.length; i++)
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = i;
                    pageController.jumpToPage(i);
                  });
                },
                child: Row(
                  children: [
                    if (i != 0) // Add a condition to skip the divider at the start
                      VerticalDivider(width: 8),
                    SizedBox(width: 16,),
                    Icon(
                      bottomIcons[i],
                      color: selectedIndex == i
                          ? Colors.green
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ],
                ),
              ),


          ],
        ),
      ),
    );
  }


}
List<Widget> child = [
  HomePage(),
  Container(),
  Container(color: Color.fromARGB(255, 11, 248, 189),),
  Container(color: Color.fromARGB(255, 63, 240, 47),),
];

List<IconData> bottomIcons = [
  Icons.home,
  Icons.post_add,
  Icons.list,
  Icons.add,
];