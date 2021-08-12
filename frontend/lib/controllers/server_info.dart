import 'package:frontend/frontend/front_end_globals.dart' as globals;

String getServer() {
  if (globals.getIfOnPC()) { //If on PC
    return 'http://localhost:5001/coviduous-api/us-central1/app/api/';
  } else { //Else, on mobile
    return 'http://10.0.2.2:5001/coviduous-api/us-central1/app/api/';
  }
}