import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:essgate/res/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Home extends StatefulWidget {
  int id;
  String name;
  String hash;
  Home({super.key,required this.id,required this.hash,required this.name});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: [BarcodeFormat.all]
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Center(child: SvgPicture.asset('assets/essential.svg'))),
      body: Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 100,),
          Text("Scan QR Code",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 20)),),
          SizedBox(height: 30,),
          Center(
            child: Container(
              height:MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.black
                ),
                borderRadius: BorderRadius.circular(10)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: MobileScanner(
                  controller: controller,
                  // fit: BoxFit.contain,
                  onDetect: (capture) async {
                    final List<Barcode> barcodes = capture.barcodes;
                    final Uint8List? image = capture.image;
                    print(barcodes[0].rawValue == widget.hash);
                    if(barcodes[0].rawValue == widget.hash)
                      approve(barcodes[0].rawValue!);
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor:Colors.red,content: Text("Not a valid QR",style: GoogleFonts.poppins(),)));
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> approve(String hash) async{
     final url = "http://$host/token=<str:token>/gatepass/leave_id=${widget.id}/hash=$hash";
     try{
       final response = await http.post(Uri.parse(url));
       if(response.statusCode == 200){
         await _showBottomSheet();
         print("approved");
       }
       print(response.body);
     }
     catch(e){

     }
  }
  void _closeBottomSheetAfterDelay() {
    // Close the BottomSheet after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }
  Future<void> _showBottomSheet() async{
    _closeBottomSheetAfterDelay();
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true, // Set to true to allow a height greater than the screen height
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
              // Lottie.ne
              // SizedBox(height: 16),
              Text(
                'Approved',
                style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              Icon(Icons.verified, color: Colors.green,size:70,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Name",style: GoogleFonts.poppins(fontSize: 30),),
                  Text(widget.name.toUpperCase(),style: GoogleFonts.poppins(fontSize: 30)),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
