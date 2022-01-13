import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/widgets/teacher_screens/teacher_absence.dart';
import 'package:flutter/material.dart';
import '/utilities/constants.dart';

class TodayList extends StatelessWidget {
  static const screentitle = '/todaylistscreentitle';
  const TodayList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _now = DateTime.now();
    var _today = DateTime(
      _now.year,
      _now.month,
      _now.day,
    );
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appbardecoration,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Schedule')
            .where('teacherid',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
            .asBroadcastStream(),
        builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: deepPurpleAccent),
            );
          } else {
            var docs = snapshot.data!.docs;
            var length = docs.length;
            var document = [];
            var _newlength = 0;
            for (int i = 0; i < length; i++) {
              var doc =
                  dateformatdatetime(extracttime(docs[i]['from'].toString()));
              if ((doc.year == _today.year) &&
                  (doc.day == _today.day) &&
                  (doc.month == _today.month)) {
                document.add(docs[i]);
                _newlength++;
              }
            }
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
                  child: const Text(
                    "Today's List",
                    style: textstyle2,
                  ),
                ),
                Expanded(
                  child: length == 0
                      ? const Center(
                          child: Text('No work for today!'),
                        )
                      : ListView.builder(
                          itemCount: _newlength,
                          itemBuilder: (ctx, index) {
                            var fromtime = dateformatdatetime(
                                extracttime(document[index]['from']));
                            var from = fromtime.hour.toString();
                            var totime = dateformatdatetime(
                                extracttime(document[index]['to']));
                            var to = totime.hour.toString();
                            if (fromtime.minute == 0) {
                              from = from + ':00';
                            } else {
                              from = from + ':' + totime.minute.toString();
                            }
                            if (totime.minute == 0) {
                              to = to + ':00';
                            } else {
                              to = to + ':' + totime.minute.toString();
                            }
                            return Container(
                              height: 100,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: GestureDetector(
                                  onTap: () {
                                    var arguments = {
                                      'matiere': document[index]['Subject'],
                                      'class': document[index]['class'],
                                      'classid': document[index]['classid'],
                                      'teacher': document[index]['teacher'],
                                      'teacherid': document[index]['teacherid']
                                    };
                                    Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                TeacherAbsence(
                                                    list: arguments)));
                                  },
                                  child: customCard(
                                      'Subject: ${document[index]['Subject']}\nTime: ${from} - ${to}\nClass: ${document[index]['class']}')),
                            );
                          },
                        ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
