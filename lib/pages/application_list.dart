import 'package:essgate/pages/Home.dart';
import 'package:essgate/pages/login.dart';
import 'package:essgate/res/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:essgate/data/LeaveViewApiModel.dart';
import 'package:http/http.dart' as http;
class Applications extends StatefulWidget {
  const Applications({super.key});

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  bool isLoading = true;
  List<LeaveViewApiModel> leaves= [];
  List<bool> isExpandedList = [] ;
  String? user;
  @override
  void initState(){
    super.initState();
    loaduserData();
  }
  void loaduserData(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        user = prefs.getString('user')??'none';
      });
    });
  }
  loadData(String? user,{String query = "pending",int start = 0,int end = 100}) async {
    String url = "http://$host/token=<str:token>/gate/leave/view/id=$user/query=${query}/start=$start/end=$end";
    print(url);
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200){
        setState(() {
          leaves = leaveViewApiModelFromJson(response.body);
          print(leaves);
          isExpandedList =  List.generate(leaves.length, (index) => false);
          isLoading = false;
        });
      }
    }
    catch(e) {
      print(e);
    }
  }
    @override
    Widget build(BuildContext context) {
    if(isLoading){
      loadData(user);
    }
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await loadData(user);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: leaves.length,
              itemBuilder: (context,index){
                return Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        children: [
                          Container(

                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child:ClipOval(
                              child: Image.network(
                                "http://$host/token=%3Cstr:token%3E/user=${leaves[index].student}/getImage",
                                fit: BoxFit.cover,
                                errorBuilder: (context,e,s){
                                  return Icon(Icons.person,color: Colors.grey.withOpacity(0.4),size: 40,);
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${leaves[index]!.student?.name}",style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 17,fontWeight: FontWeight.w600) ),),
                              SizedBox(height: 2,),
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(3)
                                ),
                                child: Row(
                                  children: [
                                    Text(leaves[index].profile?.branch! as String,style: GoogleFonts.poppins(),),
                                    Text(","),
                                    Text(leaves[index].profile!.batch!,style: GoogleFonts.poppins(),),
                                  ],
                                ),

                              ),
                              SizedBox(height:10),
                              isExpandedList[index]?expandedView(leaves[index]):SizedBox()
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          IconButton(onPressed: (){
                            setState(() {
                              isExpandedList[index] = !isExpandedList[index];
                            });
                          }, icon: isExpandedList[index]?Icon(Icons.keyboard_arrow_up_rounded,size: 40,):Icon(Icons.keyboard_arrow_down_rounded,size: 40,))
                        ],
                      ),
                    )
                );
              }
          ),
        ),
      ),
    );
  }
  Widget expandedView(LeaveViewApiModel model){
    return GestureDetector(
      onTap: (){},
      child: Container(
        width:MediaQuery.of(context).size.width -185,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Roll : ${model.profile!.rollNo}",style: GoogleFonts.poppins(),),
            Row(
              children: [
                Text("From : ",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("${model.departure!.day}.${model.departure!.month}.${model.departure!.year}",style:GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16))),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                Text("To : ",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),),
                Text("${model.arrival!.day}.${model.arrival!.month}.${model.arrival!.year}",),
              ],
            ),
            SizedBox(height: 5,),
            Text("Reason : ",style:GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold))),
            Text("${model.reason}",softWrap: true,style:GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16))),
            SizedBox(height: 15,),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black)
              ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(id: model.id!,hash:model.hash!,name: model.student!.name!,)));
                },
                child:Text("Scan QR",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),)
            )
          ],
        ),
      ),
    );
  }

}

