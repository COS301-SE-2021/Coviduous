// necessary imports
import 'screens/signup_screen.dart';
import 'models/authentication.dart';

// pass a class as param in runApp
void main() => runApp(MyApp());

// classes
class MyApp extends StatelessWidget{
  // every widget has a build
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