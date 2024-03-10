import 'package:essgate/pages/Arrival.dart';
import 'package:essgate/pages/application_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Center(child: SvgPicture.asset('assets/essential.svg'),),
            actions: [
              IconButton(
                  onPressed: ()async{
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    pref.clear();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                  },
                  icon: Icon(Icons.logout,color: Colors.black,)
              )
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Text("Departure",style:  GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black,fontSize: 12)),),
                ),
                Tab(
                  icon: Text("Arrival",style:  GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black,fontSize: 12)),),
                )
              ],
            ),
          ),
        body:TabBarView(
          children: [
            Applications(),
            Arrival(),
          ], 
        ) ,
      ),
    ) ;
  }
}
