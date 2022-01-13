import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/widgets/Admin_screens/class_screen.dart';
import 'package:flutter/material.dart';

import '/utilities/constants.dart';

TextEditingController _classnamecontroller = TextEditingController();

class ClassesList extends StatefulWidget {
  static const screentitle = '/ClassesList';
  const ClassesList({Key? key}) : super(key: key);
  @override
  State<ClassesList> createState() => _ClassesListState();
}

class _ClassesListState extends State<ClassesList> {
  var _waiting = false;

  Future<void> _addClass(String classname) async {
    _waiting = true;
    FirebaseFirestore.instance
        .collection('classes')
        .add({'id': classname, 'name': classname}).then((_) {
      setState(() {
        _waiting = false;
      });
    });
  }

  Future<void> _modifyClass(String classnameid, String classname1) async {
    _waiting = true;
    FirebaseFirestore.instance
        .collection('classes')
        .doc(classnameid)
        .set({'name': classname1}).then((_) {
      setState(() {
        _waiting = false;
      });
    });
  }

  Future<void> _deleteClass(String jobId) async {
    _waiting = true;
    FirebaseFirestore.instance
        .collection('classes')
        .doc(jobId)
        .delete()
        .then((_) {
      setState(() {
        _waiting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appbardecoration,
        title: const Text("Classes Overview"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('classes')
            .snapshots()
            .asBroadcastStream(),
        builder:
            (BuildContext ctx, AsyncSnapshot<QuerySnapshot> classSnapshot) {
          if (!classSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: deepPurpleAccent
              ),
            );
          } else {
            var docs = classSnapshot.data!.docs;
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
                    "Classes' List",
                    style: textstyle2,
                  ),
                ),
                Expanded(
                  child: length == 0
                      ? const Center(
                          child: Text('Empty...', style: classnameStyle),
                        )
                      : _waiting
                          ? const Center(
                              child: CircularProgressIndicator(color: deepPurpleAccent),
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
                                      Navigator.of(context).pushNamed(
                                          ClassScreen.screentitle,
                                          arguments: docs[index]['name']);
                                    },
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
                                                  "Do you want to delete class ${docs[index]['name']}?"),
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
                                                    _deleteClass(docs[index]
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
                                                  "You want to modify class name?"),
                                              content: const Text(
                                                  "Please enter down below the new class name"),
                                              actions: [
                                                TextFormField(
                                                  controller:
                                                      _classnamecontroller,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: "Class Name",
                                                    border:
                                                        OutlineInputBorder(),
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
                                                        if (_classnamecontroller
                                                                .text ==
                                                            '') {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                              content: const Text(
                                                                  'No name was given. Please, check again!'),
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .errorColor,
                                                            ),
                                                          );
                                                        } else {
                                                          _modifyClass(
                                                              docs[index].id,
                                                              _classnamecontroller
                                                                  .text);
                                                          setState(() {
                                                            _classnamecontroller
                                                                .text = '';
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                      child: const Text(
                                                        'change Class name',
                                                        style: textstyle2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      child: customCard(docs[index]['name']),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("You want to add a new class?"),
                        content: const Text(
                            "Please enter down below the class name"),
                        actions: [
                          TextFormField(
                            controller: _classnamecontroller,
                            decoration: const InputDecoration(
                              labelText: "Class Name",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Return', style: textstyle2),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_classnamecontroller.text == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 2),
                                        content: const Text(
                                            'No name was given. Please, check again!'),
                                        backgroundColor:
                                            Theme.of(context).errorColor,
                                      ),
                                    );
                                  } else {
                                    _addClass(_classnamecontroller.text);
                                    setState(() {
                                      _classnamecontroller.text = '';
                                    });
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text(
                                  'Add Class',
                                  style: textstyle2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Center(
                    child: Text(
                      'Add A Class!',
                      style: textstyle2,
                    ),
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
