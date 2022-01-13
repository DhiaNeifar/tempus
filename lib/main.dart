import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'sign_in.dart';
import 'widgets/Admin_screens/admin_screen.dart';
import '/widgets/Admin_screens/class_screen.dart';
import '/widgets/Admin_screens/classes_list.dart';
import '/widgets/Admin_screens/add_student.dart';
import 'package:first_app/widgets/Admin_screens/teachers_list.dart';
import 'package:first_app/widgets/Admin_screens/add_teacher.dart';
import 'package:first_app/user_screen.dart';
import 'package:first_app/widgets/student_screens/student_screen.dart';
import 'package:first_app/widgets/teacher_screens/teacher_screen.dart';
import 'package:first_app/widgets/Admin_screens/main_schedule.dart';
import 'package:first_app/widgets/Admin_screens/add_event.dart';
import 'package:first_app/widgets/student_screens/student_schedule.dart';
import 'package:first_app/widgets/teacher_screens/teacher_schedule.dart';
import 'package:first_app/widgets/teacher_screens/today_list.dart';
import 'widgets/student_screens/student_absence.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: deepPurpleAccent,
  ));
  runApp(const TempusApp());
}

class TempusApp extends StatelessWidget {
  const TempusApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tempus',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        AdminScreen.screentitle: (context) => const AdminScreen(),
        SignIn.screentitle: (context) => const SignIn(),
        ClassesList.screentitle: (context) => const ClassesList(),
        UserScreen.screentitle: (context) => const UserScreen(),
        ClassScreen.screentitle: (context) => const ClassScreen(),
        AddStudent.screentitle: (context) => const AddStudent(),
        TeachersList.screentitle: (context) => const TeachersList(),
        AddTeacher.screentitle: (context) => const AddTeacher(),
        StudentScreen.screentitle: (context) => const StudentScreen(),
        TeacherScreen.screentitle: (context) => const TeacherScreen(),
        MainSchedule.screentitle: (context) => const MainSchedule(),
        Addeventwidget.screentitle: (context) => const Addeventwidget(),
        TeacherSchedule.screentitle: (context) => const TeacherSchedule(),
        TodayList.screentitle: (context) => const TodayList(),
        StudentSchedule.screentitle: (context) => const StudentSchedule(),
        StudentAbsence.screentitle: (context) => const StudentAbsence(),
      },
      title: 'Tempus',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: deepPurpleAccent);
          }
          if (!snapshot.hasData) {
            return const SignIn();
          }
          return const UserScreen();
        },
      ),
    );
  }
}
