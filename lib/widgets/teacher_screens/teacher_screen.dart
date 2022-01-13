import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/utilities/constants.dart';
import 'package:first_app/widgets/special_widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:first_app/widgets/teacher_screens/teacher_app_drawer.dart';

class TeacherScreen extends StatefulWidget {
  static const screentitle = '/TeacherScreenScreen';
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  var userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    var devicesize = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userId.toString()).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Text("error"),
          );
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          Navigator.pop;
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> userdata =
              snapshot.data!.data() as Map<String, dynamic>;
          List userdatacopy = [];
          userdata.forEach((key, value) {
            userdatacopy.add(value);
          });
          return Scaffold(
            extendBodyBehindAppBar: true,
            drawer: TeacherAppDrawer(data: userdatacopy),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(0),
                  height: double.infinity,
                  width: double.infinity,
                  child: HeaderWidget(
                      devicesize.height / 3, false, Icons.login_rounded),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: devicesize.height / 3,
                      width: devicesize.width,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: SafeArea(
                        child: Center(
                          child: FittedBox(
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  const TextSpan(
                                    text: 'Welcome ',
                                    style: welcometextstyle,
                                  ),
                                  TextSpan(
                                      text:
                                          '${capitalize(userdatacopy[1])} ${capitalize(userdatacopy[2])}',
                                      style: usernametextStyle),
                                  const TextSpan(
                                    text: '\n to ',
                                    style: welcometextstyle,
                                  ),
                                  const TextSpan(
                                      text: 'Tempus!',
                                      style: usernametextStyle),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: (2 * devicesize.height / 3),
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.all(10),
                              child: Card(
                                color: Colors.transparent,
                                borderOnForeground: false,
                                shadowColor: black,
                                elevation: 20,
                                child: Container(
                                  decoration: tempusdecoration,
                                  padding: const EdgeInsets.all(10),
                                  child:RichText(
                                      text: const TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Tempus ',
                                            style: usernametextStyle,
                                          ),
                                          TextSpan(
                                              text:
                                                  'is an application originally created and developped by four talented SUP\'COM students in order to pass Mobile Project. This application allows its user to access sensible informations such as absence, schedule whether you are a student, teacher or Administrator.',
                                              style: tempusdeftextstyle),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  maxRadius: 50,
                                  child: Image.asset(
                                      "lib/assets/logos/tempus.png"),
                                ),
                                CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                    "lib/assets/logos/SUP'COM.png",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: deepPurpleAccent,
            ),
          ),
        );
      },
    );
  }
}
