import 'package:flutter/material.dart';
import 'package:login_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

class UserHomepage extends StatefulWidget {
  static const routeName = "/user";
  @override
  _UserHomepageState createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false, //Prevent the back button from showing up
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Welcome user')
        ),
        body: Stack (
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigoAccent,
                    Colors.deepPurpleAccent,
                  ]
                )
              )
            ),
            Container (
              alignment: Alignment.topCenter,
              margin: EdgeInsets.all(20.0),
              child: Image(
                alignment: Alignment.bottomCenter,
                image: NetworkImage('https://placeholder.com/wp-content/uploads/2018/10/placeholder.com-logo1.png'),
                width: double.maxFinite,
                height: 180,
              ),
            ),
            Center(
              child: Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container (
                  height: 164,
                  width: 300,
                  padding: EdgeInsets.all(10),
                  child: Column (
                    children: <Widget>[
                      ElevatedButton (
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo, //Button color
                        ),
                        child: Row (
                          children: <Widget>[
                            Text('View office space'),
                            Icon(Icons.library_books)
                          ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Placeholder'),
                                content: Text('View office space'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Okay'),
                                    onPressed: (){
                                      Navigator.of(ctx).pop();
                                    },
                                  )
                                ],
                              )
                          );
                        }
                      ),
                      ElevatedButton (
                          style: ElevatedButton.styleFrom(
                            primary: Colors.indigo, //Button color
                          ),
                          child: Row (
                              children: <Widget>[
                                Text('Book office space'),
                                Icon(Icons.book)
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                              crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Placeholder'),
                                  content: Text('Book office space'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Okay'),
                                      onPressed: (){
                                        Navigator.of(ctx).pop();
                                      },
                                    )
                                  ],
                                )
                            );
                          }
                      ),
                      ElevatedButton (
                          style: ElevatedButton.styleFrom(
                            primary: Colors.indigo, //Button color
                          ),
                          child: Row (
                              children: <Widget>[
                                Text('View current bookings'),
                                Icon(Icons.access_alarm)
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                              crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Placeholder'),
                                  content: Text('View current bookings'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Okay'),
                                      onPressed: (){
                                        Navigator.of(ctx).pop();
                                      },
                                    )
                                  ],
                                )
                            );
                          }
                      ),
                    ]
                  )
                )
              )
            ),
            Container (
              alignment: Alignment.bottomRight,
              child: Card (
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container (
                  height: 50,
                  width: double.maxFinite,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.indigo, //Button color
                    ),
                    child: Text('Log out'),
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                        title: Text('Placeholder'),
                        content: Text('Are you sure you want to log out?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Yes'),
                            onPressed: (){
                              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                            },
                          ),
                          TextButton(
                            child: Text('No'),
                            onPressed: (){
                              Navigator.of(ctx).pop();
                            },
                          )
                        ],
                      ));
                    },
                  )
                ),
              ),
            )
          ]
        )
      ),
    );
  }
}