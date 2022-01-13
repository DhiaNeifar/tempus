import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:first_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var _secureText1 = true;
var _secureText2 = true;

class AddStudent extends StatefulWidget {
  static const screentitle = '/addstudentScreen';
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  Future<void> _addstudent(classname) async {
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailcontroller.text.trim(),
              password: _passwordcontroller.text.trim());
      try {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
          {
            'name': _namecontroller.text.trim(),
            'familyname': _lastnamecontroller.text.trim(),
            'email': _emailcontroller.text.trim(),
            'imagepath': '',
            'status': 'student',
            'class': classname,
            'time':
                Timestamp((_dateTime.millisecondsSinceEpoch / 1000).toInt(), 0),
          },
        ).then(
          (_) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('A new student has been added succesfully!'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Confirm')),
                ],
              ),
            );
          },
        );
      } catch (err) {
        FirebaseAuth.instance.currentUser!.delete();
        throw (err.toString());
      }
    } on FirebaseAuthException catch (err) {
      throw (err.toString());
    } catch (err) {
      throw (err.toString());
    }
  }

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _passwordconfirmationcontroller =
      TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _lastnamecontroller = TextEditingController();
  var _dateTime;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var classname = ModalRoute.of(context)?.settings.arguments;
    var devicedata = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Add Student"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: decoration,
              ),
              SafeArea(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white54,
                    ),
                    alignment: Alignment.center,
                    height: 3 * devicedata.height / 4,
                    width: 7 * devicedata.width / 8,
                    child: Column(
                      children: [
                        Flexible(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: _emailcontroller,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter the Email Address...',
                                        labelText: 'Email Address',
                                        labelStyle: labelStyle,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !value.contains('@supcom.tn')) {
                                          return 'Please enter a valid Email address!';
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      controller: _passwordcontroller,
                                      obscureText: _secureText2,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(_secureText2
                                              ? Icons.remove_rounded
                                              : Icons.remove_red_eye_outlined),
                                          onPressed: () {
                                            setState(() {
                                              _secureText2 = !_secureText2;
                                            });
                                          },
                                        ),
                                        hintText: 'Enter the Password...',
                                        labelText: 'Password',
                                        labelStyle: labelStyle,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length < 5) {
                                          return 'Please enter a valid Password!';
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      controller:
                                          _passwordconfirmationcontroller,
                                      obscureText: _secureText1,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(_secureText1
                                              ? Icons.remove_rounded
                                              : Icons.remove_red_eye_outlined),
                                          onPressed: () {
                                            setState(() {
                                              _secureText1 = !_secureText1;
                                            });
                                          },
                                        ),
                                        hintText: 'Confirm Password...',
                                        labelText: 'Password Confirmation',
                                        labelStyle: labelStyle,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value != _passwordcontroller.text) {
                                          return 'The passwords don\'t match!';
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      controller: _namecontroller,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter Student Name...',
                                        labelText: 'Name',
                                        labelStyle: labelStyle,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Empty!';
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      controller: _lastnamecontroller,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter Student LastName...',
                                        labelText: 'LastName',
                                        labelStyle: labelStyle,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Empty!';
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextButton(
                                      child: _dateTime == null
                                          ? const Text(
                                              'No date has been entered yet!',
                                              style: textstyle2,
                                            )
                                          : Center(
                                              child: Text(
                                                  _dateTime
                                                      .toIso8601String()
                                                      .split('T')[0],
                                                  style: textstyle2),
                                            ),
                                      onPressed: () {
                                        if (_dateTime == null) {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1950),
                                            lastDate: DateTime(2050),
                                          ).then(
                                            (value) {
                                              setState(
                                                () {
                                                  _dateTime = value;
                                                },
                                              );
                                            },
                                          );
                                        } else {
                                          showDatePicker(
                                            context: context,
                                            initialDate: _dateTime,
                                            firstDate: DateTime(1950),
                                            lastDate: DateTime(2050),
                                          ).then(
                                            (value) {
                                              setState(
                                                () {
                                                  _dateTime = value;
                                                },
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                final isValid =
                                    _formKey.currentState!.validate();
                                FocusScope.of(context).unfocus();
                                if (isValid) {
                                  _formKey.currentState!.save();
                                  _addstudent(classname);
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text(
                                'validate',
                                style: TextStyle(
                                  color: deeppurple,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
