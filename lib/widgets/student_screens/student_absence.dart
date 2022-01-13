import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAbsence extends StatelessWidget {
  static const screentitle = '/StudentAbsenceScreen';
  const StudentAbsence({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appbardecoration,
        title: const Text("Absence"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('absence')
              .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots()
              .asBroadcastStream(),
          builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: deepPurpleAccent,
                ),
              );
            } else {
              var docs = snapshot.data!.docs;
              var length = docs.length;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.all(0),
                    height: 30,
                    child: Text(
                      'You have ' + length.toString() + ' absences',
                      style: textstyle,
                    ),
                  ),
                  Expanded(
                    child: length == 0
                        ? const Center(
                            child: Text('Empty...',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 28,
                                    fontFamily: 'OpenSans')))
                        : ListView.builder(
                            itemCount: length,
                            itemBuilder: (ctx, index) {
                              return Container(
                                height: 100,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: customCard(
                                    'Subject: ${docs[index]['matiere']}\nTeacher: ${capitalize(docs[index]['teacher'])}\nTime: ${dateformatstring(extracttime(docs[index]['day'])).toString()}'),
                              );
                            },
                          ),
                  )
                ],
              );
            }
          }),
    );
  }
}
