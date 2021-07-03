import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutApp extends StatefulWidget {
  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      backgroundColor: Colors.purple,
      body: SafeArea(
        child: ListView(
          children: [
            Center(
              child: Text(
                'ABOUT APP',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5),
                borderRadius: BorderRadius.circular(18),
                color: Colors.purple,
              ),
              child: Text('''
              Micro Finance Savings was Created by David Okoroafor in Association With Ashpot Ng.
              This App was created for Management of locally organised financial savings Systems and Organisations.

              ''', style: TextStyle(color: Colors.white)),
            ),
            Center(
              child: Text(
                'HOW TO USE THIS APP',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple,
                border: Border.all(color: Colors.white, width: 5),
                borderRadius: BorderRadius.circular(19),
              ),
              child: Text('''
              To Create a New Record Tap on the add Persons Button below 
              Always make sure you add valid detail to avoid Validation errors 
              click on the add button to Make a Cash Deposit
              click on the Minus Button to Make a Cash Withdrawal
              click on the Edit Button to Edit Customers Details
              Click on the Delete button to Delete a Customer's record
              Upon every Action Made in this App an Alert will be sent to the Customer for Verification Purposes
              To Stop or Start Alert Click on the Generate Icon Button in the Menu
              ''', style: TextStyle(color: Colors.white)),
            ),
            Center(
              child: Text(
                'ABOUT DEVELOPER',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('DAVID OKOROAFOR'),
              tileColor: Colors.white,
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.white),
              title:
                  Text('+2349136164143', style: TextStyle(color: Colors.white)),
              tileColor: Colors.purple,
            ),
            ListTile(
              leading: Icon(Icons.mail),
              title: Text('okoroafordavid61@gmail.com'),
              tileColor: Colors.white,
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.twitter, color: Colors.blue),
              title: Text('@korafdavid', style: TextStyle(color: Colors.white)),
              tileColor: Colors.purple,
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
              title: Text('+2349136164143'),
              tileColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
