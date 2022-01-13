import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// Colors

const deeppurple = Colors.deepPurple;
const red = Colors.red;
const white = Colors.white;
const black = Colors.black;
const deepPurpleAccent = Colors.deepPurpleAccent;
const blue = Colors.blue;
const blueAccent = Colors.blueAccent;
const redAccent = Colors.redAccent;

//TextStyles

const classnameStyle =
    TextStyle(color: Colors.grey, fontSize: 28, fontFamily: 'OpneSans');

const labelStyle = TextStyle(
  fontSize: 20,
  color: deeppurple,
);
const kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

const kLabelStyle = TextStyle(
  color: white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

const welcometextstyle = TextStyle(
  color: white,
  fontSize: 30,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w400,
);

const usernametextStyle = TextStyle(
  color: white,
  fontSize: 45,
  fontWeight: FontWeight.bold,
  fontFamily: 'DancingScript',
);

var introductiontextstyle = TextStyle(
  color: Colors.grey.shade700,
  fontSize: 20,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w400,
);

const tempusdeftextstyle = TextStyle(
  color: white,
  fontSize: 20,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w400,
);

const nametextstyle = TextStyle(
  color: white,
  fontSize: 20,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w400,
);

const coordinatestextStyle = TextStyle(
  color: white,
  fontSize: 30,
  fontWeight: FontWeight.w400,
  fontFamily: 'OpenSans',
);

const answertextstyle = TextStyle(
  color: white,
  fontSize: 25,
  fontWeight: FontWeight.bold,
  fontFamily: 'DancingScript',
);

const textstyle = TextStyle(
  color: black,
  fontSize: 25,
  fontWeight: FontWeight.w300,
  fontFamily: 'OpenSans',
);

const textstyle1 = TextStyle(
  color: white,
  fontSize: 35,
  fontWeight: FontWeight.w300,
  fontFamily: 'OpenSans',
);

const textstyle1_1 = TextStyle(
  color: white,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

const textstyle2 = TextStyle(
  color: deeppurple,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

const textstyle3 = TextStyle(
  color: Colors.blue,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

const textstyle4 = TextStyle(
  color: red,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

// Sign in Styles

var kBoxDecorationStyle = BoxDecoration(
  color: deepPurpleAccent,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

const loginStyle = TextStyle(
  color: deepPurpleAccent,
  letterSpacing: 1.5,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

//Decoration

const decoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [blue, blueAccent, redAccent, red],
    stops: [0.1, 0.2, 0.8, 1],
  ),
);

var infodecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      blue.withOpacity(0.85),
      blueAccent.withOpacity(0.85),
      redAccent.withOpacity(0.85),
      red.withOpacity(0.85)
    ],
    stops: const [0.1, 0.2, 0.8, 1],
  ),
);

const drawerdecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [blue, blueAccent, redAccent, red],
    stops: [0.1, 0.2, 0.8, 1],
  ),
);

const tempusdecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(15)),
  gradient: LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [blue, blueAccent, redAccent, red],
    stops: [0.1, 0.2, 0.8, 1],
  ),
);

const listdecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(15)),
  gradient: LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [blue, blueAccent, redAccent, red],
    stops: [0.1, 0.2, 0.8, 1],
  ),
);

var appbardecoration = Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [blue, deeppurple, red],
      stops: [0.0, 0.5, 1],
    ),
  ),
);

//functions

String capitalize(String string) {
  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}

int extracttime(string) {
  return int.parse(string.toString().split('=')[1].split(',')[0]);
}

String dateformatstring(timestamp) {
  return DateFormat.yMMMd()
      .format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
}

DateTime dateformatdatetime(numberofseconds) {
  return DateTime.fromMillisecondsSinceEpoch(numberofseconds * 1000);
}

Widget customCard(String string) {
  return Card(
    color: Colors.transparent,
    elevation: 6,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Colors.pink.shade700,
            Colors.purple,
          ],
          stops: const [0.1, 0.7],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            string,
            style: textstyle1,
          ),
        ),
      ),
    ),
  );
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
