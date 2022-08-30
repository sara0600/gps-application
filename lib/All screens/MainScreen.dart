import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gps_app/All%20screens/Choices.dart';
class MainScreen  extends StatelessWidget {
  static const String idScreen='enter';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height:35.0),
              Image(
                image: AssetImage("assets/main screen icon.jpg"),
                width:400.0,
                height:350.0,

                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),


                Text(
                  "Autonomous Car",
                  style: TextStyle(
                      fontSize: 30.0,
                          color:Colors.purple[400],
                  ),
                  textAlign: TextAlign.center,

              ),
              Padding(
                  padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 1.0,),
                  RaisedButton( color:Colors.purple,
                    textColor: Colors.white,
                    child: Container(
                      height: 50.0,
                      child: Center(
                        child: Text(
                          'Enter',
                          style: TextStyle(fontSize: 20),

                        ),
                      ),
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30)
                    ),
                    onPressed: (){
                      Navigator.pushNamedAndRemoveUntil(context, Choices.idScreen, (route) => false);
                    },
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
}
