import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/widgets/Admin_screens/add_student.dart';
import 'package:first_app/widgets/Admin_screens/class_admin_schedule.dart';
import 'package:flutter/material.dart';

import 'package:first_app/utilities/constants.dart';

TextEditingController _studentnamecontroller = TextEditingController();
TextEditingController _studentfamilynamecontroller = TextEditingController();
TextEditingController _classcontroller = TextEditingController();
var _dateTime;

class ClassScreen extends StatefulWidget {
  static const screentitle = '/ClassScreenScreen';
  const ClassScreen({Key? key}) : super(key: key);

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  var _waiting = false;

  Future<void> _deleteStudent(String studentId) async {
    _waiting = true;
    FirebaseFirestore.instance
        .collection('users')
        .doc(studentId)
        .delete()
        .then((_) {
      setState(() {
        _waiting = false;
      });
    });
  }

  Future<void> _modifyStudent(String studentid, String newname,
      String newfamilyname, String newclass) async {
    _waiting = true;
    FirebaseFirestore.instance
        .collection('users')
        .doc(studentid)
        .get()
        .then((value) {
      FirebaseFirestore.instance.collection('users').doc(studentid).set({
        'name': newname == '' ? value['name'] : newname,
        'familyname': newfamilyname == '' ? value['familyname'] : newfamilyname,
        'class': newclass == '' ? value['class'] : newclass,
        'imagepath': '',
        'time': _dateTime == null
            ? value['time']
            : Timestamp((_dateTime.millisecondsSinceEpoch / 1000).toInt(), 0),
        'status': 'student',
      }).then((_) {
        setState(() {
          _waiting = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var classname = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appbardecoration,
        title: Text("Class " + classname.toString() + " Overview"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('status', isEqualTo: 'student')
            .where('class', isEqualTo: classname)
            .snapshots()
            .asBroadcastStream(),
        builder:
            (BuildContext ctx, AsyncSnapshot<QuerySnapshot> studentsnapshot) {
          if (!studentsnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: deepPurpleAccent),
            );
          } else {
            var docs = studentsnapshot.data!.docs;
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
                    "Students' List",
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
                          ? const Center(child: CircularProgressIndicator(color: deepPurpleAccent))
                          : ListView.builder(
                              itemCount: length,
                              itemBuilder: (ctx, index) {
                                return Container(
                                  height: 100,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Dismissible(
                                      key: ValueKey(docs[index].id.toString()),
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
                                                  "Do you want to delete student ${docs[index]['name']} ${docs[index]['familyname']}?"),
                                              content: const Text(
                                                  "To confirm choice, click Yes, otherwise No."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'No',
                                                    style: textstyle2,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _deleteStudent(docs[index]
                                                        .id
                                                        .toString());
                                                    Navigator.of(context).pop();
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
                                                  "You want to modify Student Coordinates?"),
                                              content: const Text(
                                                  "Please enter down below the new Student Coordinates"),
                                              actions: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  height: 150,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          controller:
                                                              _studentnamecontroller,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                "Student Name",
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              _studentfamilynamecontroller,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                "Student FamilyName",
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              _classcontroller,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                "Student Class",
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
                                                              context: context,
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
                                                      CrossAxisAlignment.center,
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
                                                        _modifyStudent(
                                                            docs[index].id,
                                                            _studentnamecontroller
                                                                .text,
                                                            _studentfamilynamecontroller
                                                                .text,
                                                            _classcontroller
                                                                .text);
                                                        setState(() {
                                                          _studentnamecontroller
                                                              .text = '';
                                                          _studentfamilynamecontroller
                                                              .text = '';
                                                          _classcontroller
                                                              .text = '';
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const FittedBox(
                                                        child: Text(
                                                          'change Student Coordinates',
                                                          style: TextStyle(
                                                              color:
                                                                  deeppurple),
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
                                );
                              },
                            ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddStudent.screentitle,
                        arguments: classname);
                  },
                  child: const Text(
                    'Add a Student',
                    style: textstyle2,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ClassAdminScheduleScreen(classe: classname.toString(),),),
                );
                  },
                  child: const Text(
                    'Check Schedule',
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
