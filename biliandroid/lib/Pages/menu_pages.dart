import 'package:biliandroid/Components/micbutton.dart';
import 'package:biliandroid/components/camerabutton.dart';
import 'package:biliandroid/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuPages extends StatefulWidget {
  const MenuPages({super.key});

  @override
  State<MenuPages> createState() => _MenuPagesState();
}

class _MenuPagesState extends State<MenuPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.menu,
          color: Colors.grey[900],
          ),
          centerTitle: true,
          title: Text(
            "BILI Test App",
            style: GoogleFonts.montserrat(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold)
          ),
        ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bili Test Menu Pages', style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  //button
                  CameraButton(text: 'Start Tracking!', onTap: (){
                    Navigator.pushNamed(context, '/trackingpages');
                  }),

                  const SizedBox(height: 20),

                  MicButton(text: 'Start Speaking!', onTap: (){
                    Navigator.pushNamed(context, '/speechtotext');
                  })
                  ],
                ),
                  //image
                  Image.asset('assets/images/hello.png', height: 100,)
              ],
            ),
          ),
        ],
        )
    );
  }
}