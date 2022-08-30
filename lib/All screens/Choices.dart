import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gps_app/All%20screens/Gps.dart';


class Choices extends StatelessWidget {
  static const String idScreen='selection';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height:60),



              Text(
                "Select what you want",
                style: TextStyle(
                  fontSize: 30.0,
                  color:Colors.purple[400],
                ),
                textAlign: TextAlign.center,

              ),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 1.0,),
                    RaisedButton( color:Colors.purple,
                      textColor: Colors.white,
                      child: Container(
                        height: 60,
                        child: Center(
                          child: Text(
                            'Gps',
                            style: TextStyle(fontSize: 50),

                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30)
                      ),
                      onPressed: (){
                      print('hello');
                      Navigator.pushNamedAndRemoveUntil(context,Gps.idScreen, (route) => false);
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
