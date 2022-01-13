import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/utilities/constants.dart';
import 'package:first_app/widgets/Admin_screens/admin_screen.dart';
import 'package:first_app/widgets/student_screens/student_screen.dart';
import 'package:first_app/widgets/teacher_screens/teacher_screen.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  static const screentitle = '/userscreentitle';
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    var userid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userid.toString())
        .get()
        .then(
      (value) {
        if (value['status'] == 'admin') {
          Navigator.of(context).pushReplacementNamed(AdminScreen.screentitle);
        }
        if (value['status'] == 'student') {
          Navigator.of(context).pushReplacementNamed(StudentScreen.screentitle);
        }
        if (value['status'] == 'teacher') {
          Navigator.of(context).pushReplacementNamed(TeacherScreen.screentitle);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: deepPurpleAccent,
        ),
      ),
    );
  }
}
