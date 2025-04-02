// ignore_for_file: file_names

import 'package:bca_student_app/pages/screens/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
 
 var wtController = TextEditingController();
 var ftController = TextEditingController();
 var inController = TextEditingController();
 var result = "";
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center( 
        child: SizedBox(
        width: 300,
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Text('BMI', style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w900
          ),),

          SizedBox(height: 21,),
          TextField(
            controller: wtController ,
            decoration: InputDecoration(
              label: Text("Enter your weight"),
              prefixIcon: Icon(Icons.line_weight) 
            ), 
              keyboardType: TextInputType.number,
          ),
          SizedBox(height: 21,),
          TextField(
            controller: ftController,
            decoration: InputDecoration(
              label: Text("Enter your height(in feet)"),
              prefixIcon: Icon(Icons.height) 
          ),
          keyboardType: TextInputType.number,),
          SizedBox(height: 21,),

          TextField(
            controller: inController,
            decoration: InputDecoration(
              label: Text("Enter your height(in inches)"),
              prefixIcon: Icon(Icons.height) 
          ),
                    keyboardType: TextInputType.number,),
           SizedBox(height: 21,),
           ElevatedButton(onPressed:(){

            var wt = wtController.text;
            var ft = ftController.text;
            var inch = inController.text;

            if(wt!="" && ft!="" && inch !=""){
              //BMI calculation


              var iWt = int.parse(wt);
              var ift = int.parse(ft);
              var iInch = int.parse(inch);
              

              var tInch = (ift * 12) + iInch;
              var tCm = tInch*2.54;

              var tM = tCm/100;
              var bmi = iWt/(tM*tM);
                setState(() {
            result = "Your BMi is : $bmi";

                });
            } 
            else{
              setState(() {
                result="Please fill all the required blanks!";
                
              });
            }


           }, child: Text("Calculate")),
          Text(result, style: TextStyle(fontSize: 16),)
        ]))  ),
        bottomNavigationBar: BottomNavigationBarExampleApp(),
        );
}

}