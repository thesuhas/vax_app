import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CoVaccine",
          style: TextStyle(
            color: Colors.amberAccent[200],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        brightness: Brightness.dark,
      ),
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
                Center(
                  child: Text(
                    "About The App",
                    style: TextStyle(
                      color: Colors.amberAccent[200],
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              SizedBox(height: 10,),
              Center(
                child: Image(image: AssetImage(
                    "images/logo_final.png",
                ),
                  width: 250,
                  height: 250,
                )
              ),
              SizedBox(height: 20,),
              Center(
                child: Text(
                  "\nThe code is completely open sourced and can be seen at:\n",
                  style: TextStyle(
                    color: Colors.amberAccent[200],
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: GestureDetector(
                  child: Text(
                    "GitHub Repo",
                    style: TextStyle(
                      color: Colors.amberAccent[200],
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () async{
                    print("tapped");
                    var url = "https://www.github.com/thesuhas/vax_app";
                    await launch(url);
                  },
                ),
              ),
              SizedBox(height: 30,),
              Center(
                child: Text(
                  "For any suggestions or clarifications, contact us at:\n",
                  style: TextStyle(
                    color: Colors.amberAccent[200],
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: GestureDetector(
                  child: Text(
                    "covidindiabot@gmail.com",
                    style: TextStyle(
                      color: Colors.amberAccent[200],
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () async{
                    print("tapped");
                    var url = "mailto:covidindiabot@gmail.com";
                    await launch(url);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
