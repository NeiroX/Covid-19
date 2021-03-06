import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:async';

import '../constant.dart';
import '../widgets/counter.dart';
import '../widgets/my_header.dart';

class HomeScreen extends StatefulWidget {

  final String startCountry;

  const HomeScreen({Key key, this.startCountry}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  double offset = 0;
  String currentCountry;
  int infected;
  int deaths;
  int recovered;
  int newInfected;
  int newDeaths;
  int newRecovered;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      currentCountry = widget.startCountry;
    });
    controller.addListener(onScroll);
    getCovidInfoAboutCountry();
  }

  void getCovidInfoAboutCountry() {
    var localCasesList = casesList;
    if (currentCountry == 'Global') {
      localCasesList = casesList['Global'];
    } else {
      for (var element in casesList['Countries']) {
        if (element['Slug'] ==
                currentCountry.toLowerCase().replaceAll(RegExp(' '), '-') ||
            element['Country'] == currentCountry) {
          localCasesList = element;
        }
      }
    }
    setState(() {
      infected = localCasesList['TotalConfirmed'];
      newInfected = localCasesList['NewConfirmed'];
      deaths = localCasesList['TotalDeaths'];
      newDeaths = localCasesList['NewDeaths'];
      recovered = localCasesList['TotalRecovered'];
      newRecovered = localCasesList['NewRecovered'];
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  String getNowDate() {
    var now = DateTime.now();
    var formattedText = DateFormat('LLLL d', 'en-US').format(now);
    return formattedText;
  }



  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "All you need",
              textBottom: "is stay at home.",
              offset: offset,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                      value: currentCountry,
                      items: kCountries
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          currentCountry = value;
                          getCovidInfoAboutCountry();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Case Update\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text: "Newest update ${getNowDate()}",
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      FlatButton(
                        onPressed: () {
                          _launchURL('https://covid19.who.int/table');
                        },
                        child: Text(
                          "See details",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Counter(
                          color: kInfectedColor,
                          number: infected,
                          newCases: newInfected,
                          title: "Infected",
                        ),
                        Counter(
                          color: kDeathColor,
                          number: deaths,
                          newCases: newDeaths,
                          title: "Deaths",
                        ),
                        Counter(
                          color: kRecovercolor,
                          number: recovered,
                          newCases: newRecovered,
                          title: "Recovered",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Spread of Virus",
                        style: kTitleTextstyle,
                      ),
                      FlatButton(
                        onPressed: () {
                          _launchURL('https://covid19.who.int/');
                        },
                        child: Text(
                          "See details",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(20),
                    height: 178,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/map.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
