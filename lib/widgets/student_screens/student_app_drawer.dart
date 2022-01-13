import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/utilities/constants.dart';
import 'package:first_app/widgets/student_screens/student_absence.dart';
import 'package:first_app/widgets/student_screens/student_schedule.dart';
import 'package:first_app/widgets/student_screens/studentinformationcard.dart';
import 'package:flutter/material.dart';

import 'package:first_app/sign_in.dart';

class StudentAppDrawer extends StatelessWidget {
  final List data;
  const StudentAppDrawer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              backgroundColor: deeppurple,
              automaticallyImplyLeading: false,
              title: const Text('Check Information!'),
            ),
            ListTile(
              leading: const Icon(
                Icons.check,
                color: deeppurple,
              ),
              title: const Text("Student Information Card"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StudentInformationCardScreen(userdata: data)),
                );
              },
            ),
            const Divider(
              thickness: 3,
            ),
            ListTile(
              leading: const Icon(
                Icons.calendar_today,
                color: deeppurple,
              ),
              title: const Text("Check Schedule"),
              onTap: () {
                Navigator.of(context)
                    .popAndPushNamed(StudentSchedule.screentitle);
              },
            ),
            const Divider(
              thickness: 3,
            ),
            ListTile(
              leading: const Icon(
                Icons.add,
                color: deeppurple,
              ),
              title: const Text("Absence"),
              onTap: () {
                Navigator.of(context)
                    .popAndPushNamed(StudentAbsence.screentitle);
              },
            ),
            const Divider(
              thickness: 3,
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                color: deeppurple,
              ),
              title: const Text("Log Out"),
              onTap: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
                Navigator.of(context).popAndPushNamed(SignIn.screentitle);
              },
            ),
            const Divider(
              thickness: 3,
            ),
          ],
        ),
      ),
    );
  }
}
