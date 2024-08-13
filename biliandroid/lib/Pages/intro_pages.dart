import 'package:biliandroid/components/button.dart';
import 'package:biliandroid/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatelessWidget{
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor : primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 25),

            //App Name
            Text("BILI", style: GoogleFonts.montserrat(
              fontSize: 25,
              color: Colors.white,
            ),
            ),

            const SizedBox(height: 25),

            //icon
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Image.asset('assets/images/hello.png'),
            ),

            const SizedBox(height: 25),

            Text("TEST BILI APP",
              style: GoogleFonts.poppins(
                fontSize: 44,
                color: Colors.white,
            ),
            ),
            
            const SizedBox(height: 10),

            Text("TEST BILI APP 2", style: TextStyle(
              color: Colors.grey[300],
              height: 2,
            ),
            ),

            MyButton(
              text: "Get Started", 
              onTap: (){
                // go to menu
                Navigator.pushNamed(context, '/menupage');
            },)
        
          ],
          ),
      ),
    );
  }
}