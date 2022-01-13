import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/widgets/Admin_screens/teacher_admin_schedule.dart';
import 'package:flutter/material.dart';

import 'package:first_app/utilities/constants.dart';
import 'package:first_app/widgets/Admin_screens/add_teacher.dart';

TextEditingController _teachernamecontroller = TextEditingController();
TextEditingController _teacherfamilynamecontroller = TextEditingController();
var _dateTime;

class TeachersList extends StatefulWidget {
  static const screentitle = '/TeachersList';
  const TeachersList({Key? key}) : super(key: key);

  @override
  _TeachersListState createState() => _TeachersListState();
}

class _TeachersListState extends State<TeachersList> {
  var _waiting = false;

  Future<void> _deleteTeacher(String teacherId) async {
    _waiting = true;
    FirebaseFirestore.instance
        .collection('users')
        .doc(teacherId)
        .delete()
        .then((_) {
      setState(() {
        _waiting = false;
      });
    });
  }

  Future<void> _modifyTeacher(
      String teacherid, String newname, String newfamilyname) async {
    _waiting = true;
    FirebaseFirestore.instance
        .collection('users')
        .doc(teacherid)
        .get()
        .then((value) {
      FirebaseFirestore.instance.collection('users').doc(teacherid).set({
        'name': newname == '' ? value['name'] : newname,
        'familyname': newfamilyname == '' ? value['familyname'] : newfamilyname,
        'imagepath': '',
        'time': _dateTime == null
            ? value['time']
            : Timestamp((_dateTime.millisecondsSinceEpoch / 1000).toInt(), 0),
        'status': 'teacher',
      }).then((_) {
        setState(() {
          _waiting = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appbardecoration,
        title: const Text("Teachers' List Overview"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('status', isEqualTo: 'teacher')
            .snapshots()
            .asBroadcastStream(),
        builder:
            (BuildContext ctx, AsyncSnapshot<QuerySnapshot> teachersnapshot) {
          if (!teachersnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: deepPurpleAccent),
            );
          } else {
            var docs = teachersnapshot.data!.docs;
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
                  child: const Text(
                    "Teachers' List",
                    style: textstyle2,
                  ),
                ),
                Expanded(
                  child: length == 0
                      ? const Center(
                          child: Text(
                            'Empty...',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 28,
                                fontFamily: 'OpneSans'),
                          ),
                        )
                      : _waiting
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: deepPurpleAccent),
                            )
                          : ListView.builder(
                              itemCount: length,
                              itemBuilder: (ctx, index) {
                                return Container(
                                  height: 100,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TeacherAdminScheduleScreen(
                                                  teacherid: docs[index].id),
                                        ),
                                      );
                                    },
                                    child: Dismissible(
                                        key:
                                            ValueKey(docs[index].id.toString()),
                                        background: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.blue,
                                                Colors.red,
                                              ],
                                              stops: [0.1, 0.9],
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                        ),
                                        secondaryBackground: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.blue,
                                                Colors.red,
                                              ],
                                              stops: [0.1, 0.9],
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                          alignment: Alignment.centerRight,
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                        ),
                                        confirmDismiss: (direction) async {
                                          if (direction ==
                                              DismissDirection.endToStart) {
                                            return await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                    "Do you want to delete teacher ${capitalize(docs[index]['name'])} ${capitalize(docs[index]['familyname'])}?"),
                                                content: const Text(
                                                    "To confirm choice, click Yes, otherwise No."),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'No',
                                                      style: textstyle2,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _deleteTeacher(docs[index]
                                                          .id
                                                          .toString());
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Yes',
                                                      style: textstyle2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    "You want to modify Teacher Coordinates?"),
                                                content: const Text(
                                                    "Please enter down below the new Teacher Coordinates"),
                                                actions: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    height: 150,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          TextFormField(
                                                            controller:
                                                                _teachernamecontroller,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  "Teacher Name",
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          TextFormField(
                                                            controller:
                                                                _teacherfamilynamecontroller,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  "Teacher FamilyName",
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          TextButton(
                                                            child: const Text(
                                                              'Click here to enter the date!',
                                                              style: textstyle2,
                                                            ),
                                                            onPressed: () {
                                                              showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        1950),
                                                                lastDate:
                                                                    DateTime(
                                                                        2050),
                                                              ).then(
                                                                (value) {
                                                                  setState(
                                                                    () {
                                                                      _dateTime =
                                                                          value;
                                                                    },
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Return',
                                                            style: textstyle2),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          _modifyTeacher(
                                                            docs[index].id,
                                                            _teachernamecontroller
                                                                .text,
                                                            _teacherfamilynamecontroller
                                                                .text,
                                                          );
                                                          setState(() {
                                                            _teachernamecontroller
                                                                .text = '';
                                                            _teacherfamilynamecontroller
                                                                .text = '';
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const FittedBox(
                                                          child: Center(
                                                            child: Text(
                                                              'change Teacher Coordinates',
                                                              style: TextStyle(
                                                                  color:
                                                                      deeppurple),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                        child: customCard(
                                            '${capitalize(docs[index]['name'])} ${capitalize(docs[index]['familyname'])}')),
                                  ),
                                );
                              },
                            ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddTeacher.screentitle);
                  },
                  child: const Text(
                    'Add Teacher',
                    style: textstyle2,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          }
        },
      ),
    );
  }
}
