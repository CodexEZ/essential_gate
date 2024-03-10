import 'dart:convert';
import 'dart:core';
import 'dart:ffi';
import 'package:essgate/pages/Home.dart';
import 'package:essgate/pages/application_list.dart';
import 'package:essgate/pages/tabview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '../res/url.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final url = "http://$host/token%3D%3Cstr:token%3E/warden/login";
  double iconSize = 23.0;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  Icon visibility = Icon(Icons.visibility_off_rounded,size: 23,color: Colors.black,);
  bool obscure = true;
  @override
  void initState(){
    super.initState();
    loadData();
  }
  void loadData(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var login = prefs.getBool('login') ?? false;
      if (login){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Hero(tag: "anim", child: SizedBox(height: 200, child: SvgPicture.asset('assets/essential.svg'))),
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(color: Colors.black54, blurRadius: 30)
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Warden Login",
                      style:
                      TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 50),
                    TextFormField(
                      controller: username,
                      textAlign: TextAlign.justify,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration:  InputDecoration(
                          hintText: "Username",
                          isDense: true,
                          prefixIcon: IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.person,size: iconSize,color: Colors.black,)
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                          enabledBorder:OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey, width: 2),
                              borderRadius:
                              BorderRadius.all(Radius.circular(8))),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)))),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller:password,
                      textAlign: TextAlign.justify,
                      keyboardType: TextInputType.text,
                      obscureText: obscure,
                      maxLines: 1,
                      decoration:  InputDecoration(
                          hintText: "Password",
                          isDense: true,
                          prefixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  if(obscure)
                                    visibility = Icon(Icons.visibility_rounded,size: iconSize,color: Colors.black,);
                                  else
                                    visibility = Icon(Icons.visibility_off_rounded,size: iconSize,color: Colors.black,);
                                  obscure = !obscure;

                                });
                              },
                              icon: visibility
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey, width: 2),
                              borderRadius:
                              BorderRadius.all(Radius.circular(8))),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)))),
                    ),
                    const SizedBox(height: 50),
                    GestureDetector(
                      onTap: () async {
                        bool nav = await login(username: username.text, password: password.text,context: context);
                        print(nav);
                        if(nav) {
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) => const Applications()));
                        }
                      },
                      child: Container(
                        height: 75,
                        width: 75,
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                            BorderRadius.all(Radius.circular(50))),
                        child: const Icon(Icons.chevron_right_rounded,
                            color: Colors.white, size: 70),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

  Future<bool> login({
    required String username,
    required String password,
    required BuildContext context
  }) async{
    final url = Uri.parse(this.url);
    final Map<String, dynamic> data = {
      'id': username,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final msg = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('login', true);
        prefs.setString('user', msg['data']['id']);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${msg["status"]}'),
              duration: Duration(seconds: 2), // Optional: Set the duration
              action: SnackBarAction(
                label: 'Action',
                onPressed: () {
                  // Handle action press
                },
              ),
            ));
        print(prefs.getString('user'));
        return true;
        print('Success! Response body: ${response.body}');
      } else {
        final msg = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${msg["error"]}'),
              duration: Duration(seconds: 2), // Optional: Set the duration
              action: SnackBarAction(
                label: 'Action',
                onPressed: () {
                  // Handle action press
                },
              ),
            )
        );
        print('Error! Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }

    return false;
  }
}
