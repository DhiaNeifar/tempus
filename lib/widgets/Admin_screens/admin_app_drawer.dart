import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/utilities/constants.dart';
import 'package:first_app/widgets/Admin_screens/main_schedule.dart';
import 'package:flutter/material.dart';

import 'admininformationcard.dart';
import 'package:first_app/sign_in.dart';
import 'package:first_app/widgets/Admin_screens/classes_list.dart';
import 'package:first_app/widgets/Admin_screens/teachers_list.dart';

class AdminAppDrawer extends StatelessWidget {
  final List data;
  const AdminAppDrawer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.deepPurpleAccent,
              automaticallyImplyLeading: false,
              title: const Text('Check Information!'),
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: deeppurple,
              ),
              title: const Text("Admin Information Card"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AdminInformationCardScreen(userdata: data)),
                );
              },
            ),
            const Divider(
              thickness: 3,
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: deeppurple,
              ),
              title: const Text("Manage Classes"),
              onTap: () {
                Navigator.popAndPushNamed(context, ClassesList.screentitle);
              },
            ),
            const Divider(
              thickness: 3,
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: deeppurple,
              ),
              title: const Text("Manage Teachers"),
              onTap: () {
                Navigator.of(context).popAndPushNamed(TeachersList.screentitle);
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
              title: const Text("Schedule"),
              onTap: () {
                Navigator.of(context).popAndPushNamed(MainSchedule.screentitle);
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
