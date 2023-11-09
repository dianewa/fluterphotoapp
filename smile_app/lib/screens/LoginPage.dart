import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smile_app/connectiostring/api_connection.dart';
import 'package:smile_app/form_validation/form_validations.dart';
import 'package:smile_app/screens/Dashbord.dart';
import 'package:smile_app/screens/sigUp.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isCircleAvatarVisible = false; // Track CircleAvatar visibility
  String _userPictureUrl = '';

  @override
  void initState() {
    super.initState();
    checkLoggedInStatus();
  }

  void checkLoggedInStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = pref.getString("token");
    if (val != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Dashbord()), (route) => false);
    }
  }

  Future<void> _loadUserPicture() async {
    try {
      setState(() {
        _isLoading = true;
      });
      var apiUrl =
          'http://192.168.1.94/flutter_test_project_API/user_account/load_user_picture.php'; // Replace with your API URL
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'user_email': _emailController.text,
        },
      );

      final Map<String, dynamic> data = json.decode(response.body);
      if (response.statusCode == 200 && data['success']) {
        setState(() {
          _userPictureUrl = data['user_picture'];
          _isCircleAvatarVisible = true; // Show CircleAvatar
        });
      } else {
        // Handle error loading the picture
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(data['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle network error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to connect to the server: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loginUser() async {
    try {
      setState(() {
        _isLoading = true;
      });

      var apiUrl = Connection_String.loginUser;
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'user_email': _emailController.text,
          'user_password': _passwordController.text,
        },
      );

      final Map<String, dynamic> data = json.decode(response.body);
      if (response.statusCode == 200 && data['success']) {
        final user = data['user'];
        final token = data['token'];
        refreshPostsCallback() {};
        pageroute(
            user['user_id'],
            token,
            user['user_picture'],
            user['user_email'],
            user['first_name'],
            user['last_names'],
            user['User_role']);
            print("Login Success");
            SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.clear();
            await showSuccessNotification();    
      } else {
        // Handle login error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(data['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle network error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to connect to the server: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void pageroute(
    String user_id,
    String token,
    String user_picture,
    String user_email,
    String last_names,
    String first_name,
    String User_role,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("user_id", user_id);
    await pref.setString("user_picture", user_picture);
    await pref.setString("user_email", user_email);
    await pref.setString("last_names", last_names);
    await pref.setString("first_name", first_name);
    await pref.setString("User_role", User_role);
    await pref.setString("token", token);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashbord()), (route) => false);
  }

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(17),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(color: Colors.green.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 160, 163, 160).withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _isCircleAvatarVisible
                                    ? Container(
                                        height: 130,
                                        width: 130,
                                        padding: EdgeInsets.all(1),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.white,
                                          backgroundImage:
                                              CachedNetworkImageProvider(_userPictureUrl),
                                        ),
                                      )
                                    : Column(
                                      children: [
                                   Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text("Username (Email)",
                                          style: TextStyle(
                                            fontSize: 26,
                                            color: Colors.black,
                                          ),),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                         const Icon(Icons.email,
                                         size: 30,),
                                         const SizedBox(width: 15,),
                                          Expanded(
                                            child: TextFormField(
                                              style: TextStyle(fontSize: 26),
                                      
                                              validator: Emailvalidator,
                                              controller: _emailController,
                                              autofocus: false,
                                              decoration: const InputDecoration(
                                                
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color.fromARGB(255, 114, 113, 113)),
                                                ),
                                    
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(width: 0.5),
                                                ),
                                                filled: true, // Set this to true to enable background color
                                                fillColor: Color.fromARGB(179, 217, 216, 216),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 26.0),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            await _loadUserPicture(); // Load user picture based on email
                                          }
                                        },
                                        child: Text('Next'),
                                      ),
                                    ],
                                  )

                                      ],
                                    ),
                              
                              ],
                            ),
                          ),
                        ),
      
                        // Step 2: Display user's picture
                        _isCircleAvatarVisible
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: TextFormField(
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_passwordController.text.isNotEmpty) {
                                        // Proceed with login
                                        loginUser();
                                      }
                                    },
                                    child: const Text('Login', style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 26
                                    ),),
                                  ),
                                ],
                              )
                            : SizedBox(),
      
                        // ... other code ...
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 42,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Not yet a member  ",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 102, 101, 128),
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateUserScreen()));
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> showSuccessNotification() async {
    final snackBar = successNotification();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  SnackBar successNotification() {
  return SnackBar(
    content: const Text(
      "Your user updated Successfully",
      style: TextStyle(
        color: Color.fromARGB(255, 229, 235, 229),
      ),
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    backgroundColor: Colors.green,
    margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100,
        right: 20,
        left: 30,
      ),
  );
}

}

