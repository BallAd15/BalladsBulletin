import 'package:flutter/material.dart';
import 'package:news_app/pages/home.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 70),
          child: Column(
            children: [
              Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    "assets/images/launchpage.gif",
                    width: MediaQuery.of(context).size.width/1.1,
                    height: MediaQuery.of(context).size.height/1.8,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              Text("Curating the latest news\n       specially for you", style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.0,),
              Text(
                "Coffee? Keys? Read on the go,\n        Ballad's Bulletin is here!", 
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 40.0,),
        
              GestureDetector(
                onTap:() {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  child: Material(
                    borderRadius: BorderRadius.circular(30),
                    elevation: 5.0,
                    child: Container(
                      
                      width: MediaQuery.of(context).size.width/1.2,
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 230, 15, 12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}