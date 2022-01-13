import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/utilities/constants.dart';
import 'package:first_app/widgets/teacher_screens/teacher_schedule.dart';
import 'package:first_app/widgets/teacher_screens/teacherinformationcard.dart';
import 'package:first_app/widgets/teacher_screens/today_list.dart';
import 'package:flutter/material.dart';

import 'package:first_app/sign_in.dart';

class TeacherAppDrawer extends StatelessWidget {
  final List data;
  const TeacherAppDrawer({Key? key, required this.data}) : super(key: key);

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
              title: const Text("Teacher Information Card"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TeacherInformationCardScreen(userdata: data)),
                );
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
              title: const Text("Today"),
              onTap: () {
                Navigator.of(context).popAndPushNamed(TodayList.screentitle);
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
                    .popAndPushNamed(TeacherSchedule.screentitle);
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
