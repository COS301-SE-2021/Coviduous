import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:frontend/models/health/covid_cases_data.dart';
import 'package:frontend/views/health/covid_info_center.dart';
import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;

class CovidStatistics extends StatefulWidget {
  static const routeName = "/covid_statistics";
  @override
  CovidStatisticsState createState() {
    return CovidStatisticsState();
  }
}

class CovidStatisticsState extends State<CovidStatistics> {
  bool isLoading = false;

  final GlobalKey<SfCartesianChartState> _covidStatsChartKey = GlobalKey();

  List<Map<String, num>> covidStatsList = [
    {"Confirmed": 0},
    {"Recovered": 0},
    {"Deaths" : 0},
    {"Total" : 0},
  ];

  int numberOfConfirmed = 0;
  int numberOfRecovered = 0;
  int numberOfDeaths = 0;
  int total = 0;

  String timestamp = DateTime.now().subtract(Duration(days:60)).year.toString() + '/'
      + DateTime.now().subtract(Duration(days:60)).month.toString().padLeft(2, '0') + ' to '
      + DateTime.now().year.toString() + '/' + DateTime.now().month.toString().padLeft(2, '0');

  num findLargestCaseDataNumber(List<CovidCasesData> data) {
    num temp = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].getNumCases() > temp) {
        temp = data[i].getNumCases();
      }
    }
    return temp;
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(CovidInformationCenter.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //Checking in case some COVID data could not be found
    if (globals.currentConfirmedData.isNotEmpty && globals.currentRecoveredData.isNotEmpty && globals.currentDeathsData.isNotEmpty) {
      numberOfRecovered = findLargestCaseDataNumber(globals.currentRecoveredData);
      numberOfDeaths = findLargestCaseDataNumber(globals.currentDeathsData);
      total = findLargestCaseDataNumber(globals.currentConfirmedData);
      numberOfConfirmed = total - numberOfRecovered - numberOfDeaths;

      covidStatsList = [
        {"Confirmed" : numberOfConfirmed},
        {"Recovered" : numberOfRecovered},
        {"Deaths" : numberOfDeaths},
        {"Total" : total}
      ];
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: globals.secondColor,
        child: isLoading == false ? Scaffold(
          appBar: AppBar(
            title:
            Text("South Africa COVID-19 statistics"),
            leading: BackButton(
              //Specify back button
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(CovidInformationCenter.routeName);
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              child: Container(
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom (
                        primary: Color(0xff03305A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Refresh'),
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        healthHelpers.getAllCovidData().then((result) {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                    ),
                  ],
                ),
              )
          ),
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              color: Color(0xff03305A),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                "Confirmed cases, recovered cases, and deaths since 22 January 2020",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SfCartesianChart(
                              key: _covidStatsChartKey,
                              primaryXAxis: CategoryAxis(
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  )
                              ),
                              primaryYAxis: NumericAxis(
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              series: <ChartSeries>[
                                ColumnSeries<Map<String, num>, String>(
                                  color: globals.firstColor,
                                  dataSource: covidStatsList,
                                  xValueMapper: (Map<String, num> data, _) => data.keys.first,
                                  yValueMapper: (Map<String, num> data, _) => data.values.first,
                                ),
                              ],
                            ),
                            Divider(
                              color: globals.lineColor,
                              thickness: 2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.fromLTRB(8, 25, 8, 25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Number of current cases: " + numberOfConfirmed.toString(),
                                          style: TextStyle(
                                              color: Color(0xff03305A),
                                              fontSize: MediaQuery.of(context).size.height * 0.01 * 2.5,
                                          )
                                      ),
                                      Icon(
                                        Icons.local_hospital,
                                        color: Color(0xff03305A),
                                        size: 35,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.fromLTRB(8, 25, 8, 25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Number of recoveries: " + numberOfRecovered.toString(),
                                          style: TextStyle(
                                              color: Color(0xffCC7A00),
                                              fontSize: MediaQuery.of(context).size.height * 0.01 * 2.5,
                                          )
                                      ),
                                      Icon(
                                        Icons.thumb_up,
                                        color: Color(0xffCC7A00),
                                        size: 35,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.fromLTRB(8, 25, 8, 25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Number of deaths: " + numberOfDeaths.toString(),
                                          style: TextStyle(
                                              color: globals.sixthColor,
                                              fontSize: MediaQuery.of(context).size.height * 0.01 * 2.5,
                                          )
                                      ),
                                      Icon(
                                        Icons.sick,
                                        color: globals.sixthColor,
                                        size: 35,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.fromLTRB(8, 25, 8, 25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total confirmed cases: " + total.toString(),
                                          style: TextStyle(
                                              color: globals.firstColor,
                                              fontSize: MediaQuery.of(context).size.height * 0.01 * 2.5,
                                          )
                                      ),
                                      Icon(
                                        Icons.thermostat_outlined,
                                        color: globals.firstColor,
                                        size: 35,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ) : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
