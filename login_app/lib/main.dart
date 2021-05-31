import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/user_book_office_space.dart';
import 'screens/user_homepage.dart';
import 'screens/user_view_office_spaces.dart';
import 'screens/user_view_current_bookings.dart';
import 'models/authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MultiProvider(
    providers: [
        ChangeNotifierProvider.value(
        value: Authentication(),
    )
        ],
      child: MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
        home: LoginScreen(),
        routes: {

          Register.routeName: (ctx)=> Register(),
          LoginScreen.routeName: (ctx)=> LoginScreen(),
          HomeScreen.routeName: (ctx)=> HomeScreen(),
          UserHomepage.routeName: (ctx)=> UserHomepage(),
          UserBookOfficeSpace.routeName: (ctx)=> UserBookOfficeSpace(),
          UserViewOfficeSpaces.routeName: (ctx)=> UserViewOfficeSpaces(),
          UserViewCurrentBookings.routeName: (ctx)=> UserViewCurrentBookings()
        },
    ));
  }
}