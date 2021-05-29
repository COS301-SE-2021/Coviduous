import 'screens/signup_screen.dart';
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
          },
        ));
  }
}