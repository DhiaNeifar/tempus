import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/utilities/constants.dart';
import 'package:flutter/material.dart';

List l = [];
var j = 0;

class TeacherAbsence extends StatefulWidget {
  static const screentitle = '/TeacherAbsenceScreen';
  final Map<String, dynamic> list;
  const TeacherAbsence({Key? key, required this.list})
      : super(
          key: key,
        );

  @override
  State<TeacherAbsence> createState() => _TeacherAbsenceState();
}

class _TeacherAbsenceState extends State<TeacherAbsence> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appbardecoration,
        leading: const CloseButton(),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
            ),
            onPressed: () async {
              var variable = await FirebaseFirestore.instance
                  .collection('users')
                  .where('status', isEqualTo: 'student')
                  .where('class', isEqualTo: widget.list['class'])
                  .get();

              var now = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();
              for (int i = 0; i < variable.docs.length; i++) {
                if (l[i] == true) {
                  var document = variable.docs;
                  try {
                    await FirebaseFirestore.instance.collection('absence').add({
                      'matiere': widget.list['matiere'],
                      'name': document[i]['name'],
                      'familyname': document[i]['familyname'],
                      'id': document[i].id,
                      'teacher': widget.list['teacher'],
                      'day': Timestamp(now, 0),
                    }).then((_) {
                      if (i == variable.docs.length) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text(
                                "Absence sheet has been submitted succesfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    });
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: const Text(
                            "Something didn't go well! Please check your internet first!"),
                        backgroundColor: Theme.of(context).errorColor,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text(err.toString()),
                        backgroundColor: Theme.of(context).errorColor,
                      ),
                    );
                  }
                }
              }
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.done,
            ),
            label: const Text("SUBMIT"),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('status', isEqualTo: 'student')
            .where('class', isEqualTo: widget.list['class'])
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

            for (int i = 0; i < length; i++) {
              if (j == 0) {
                l.add(false);
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
                    "Students' List",
                    style: textstyle2,
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
                              child: Card(
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            '${capitalize(docs[index]['name'])} ${capitalize(docs[index]['familyname'])}',
                                            style: textstyle1,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Checkbox(
                                          checkColor: deeppurple,
                                          value: l[index],
                                          onChanged: (_) {
                                            setState(() {
                                              j++;
                                              l[index] = !l[index];
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
