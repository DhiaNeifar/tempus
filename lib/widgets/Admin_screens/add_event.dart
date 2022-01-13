import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Addeventwidget extends StatefulWidget {
  static const screentitle = '/Addeventwidget';
  const Addeventwidget({Key? key}) : super(key: key);
  @override
  State<Addeventwidget> createState() => _AddeventwidgetState();
}

class _AddeventwidgetState extends State<Addeventwidget> {
  final TextEditingController _subjectnamecontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _teacherid;
  var _teachername;
  var _classid;
  var _classname;

  var _chosenteacher = false;
  var _chosenclass = false;
  var _teacherbuttonclicked = false;
  var _classbuttonclicked = false;

  var _daybuttonclicked = false;
  var _chosenday;

  var _fromtimebuttonclicked = false;
  var _chosenfromtime;

  var _totimebuttonclicked = false;
  var _chosentotime;

  Future<DateTime?> _getDay() async {
    final day = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2023),
    );
    if (day == null) {
      return day;
    } else {
      setState(() {
        _daybuttonclicked = true;
        _chosenday = day;
      });
      return day;
    }
  }

  Future<TimeOfDay?> _getfromtime() async {
    final timeOfDay = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 8, minute: 00));
    if (timeOfDay == null) {
      return timeOfDay;
    } else {
      setState(() {
        _fromtimebuttonclicked = true;
        _chosenfromtime = timeOfDay;
      });
      return timeOfDay;
    }
  }

  Future<TimeOfDay?> _gettotime() async {
    final timeOfDay = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 8, minute: 00));
    if (timeOfDay == null) {
      return timeOfDay;
    } else {
      setState(() {
        _totimebuttonclicked = true;
        _chosentotime = timeOfDay;
      });
      return timeOfDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('Schedule').get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Text("error"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          var documents = snapshot.data.docs;
          var length = documents.length;
          List<Map> listcopy = [];
          for (int i = 0; i < length; i++) {
            listcopy.add({
              'class': documents[i]['class'],
              'classid': documents[i]['classid'],
              'from': documents[i]['from'],
              'to': documents[i]['to'],
              'teacher': documents[i]['teacher'],
              'teacherid': documents[i]['teacherid'],
            });
          }
          var devicesize = MediaQuery.of(context).size;
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
                  onPressed: () {
                    final isValid = _formKey.currentState!.validate();
                    FocusScope.of(context).unfocus();
                    if (isValid &&
                        _chosenteacher &&
                        _chosenclass &&
                        _daybuttonclicked &&
                        _fromtimebuttonclicked &&
                        _totimebuttonclicked) {
                      _formKey.currentState!.save();
                      var from = DateTime(
                        _chosenday.year,
                        _chosenday.month,
                        _chosenday.day,
                        _chosenfromtime.hour,
                        _chosenfromtime.minute,
                      );
                      var to = DateTime(
                        _chosenday.year,
                        _chosenday.month,
                        _chosenday.day,
                        _chosentotime.hour,
                        _chosentotime.minute,
                      );
                      if (to.difference(from).inSeconds <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            content:
                                const Text("Check 'FROM' time and 'TO' time!"),
                            backgroundColor: Theme.of(context).errorColor,
                          ),
                        );
                      } else {
                        var _from = Timestamp(
                            (from.millisecondsSinceEpoch ~/ 1000).toInt(), 0);
                        var _to = Timestamp(
                            (to.millisecondsSinceEpoch ~/ 1000).toInt(), 0);
                        var _verificationteacher = true;
                        var _verificationclass = true;
                        for (int i = 0; i < length; i++) {
                          if (_classid == listcopy[i]['classid']) {
                            if ((listcopy[i]['from'].seconds <= _from.seconds &&
                                    _from.seconds <
                                        listcopy[i]['to'].seconds) ||
                                (listcopy[i]['from'].seconds < _to.seconds &&
                                    _to.seconds <= listcopy[i]['to'].seconds)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  content:
                                      const Text("Chevauchement ta3 class!"),
                                  backgroundColor: Theme.of(context).errorColor,
                                ),
                              );
                              _verificationclass = false;
                            }
                          }
                          if (_teacherid == listcopy[i]['teacherid']) {
                            if ((listcopy[i]['from'].seconds <= _from.seconds &&
                                    _from.seconds <
                                        listcopy[i]['to'].seconds) ||
                                (listcopy[i]['from'].seconds < _to.seconds &&
                                    _to.seconds <= listcopy[i]['to'].seconds)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  content:
                                      const Text("Chevauchement ta3 prof!"),
                                  backgroundColor: Theme.of(context).errorColor,
                                ),
                              );
                              _verificationteacher = false;
                            }
                          }
                        }
                        if (_verificationclass && _verificationteacher) {
                          FirebaseFirestore.instance
                              .collection('Schedule')
                              .add({
                            'Subject': _subjectnamecontroller.text,
                            'teacher': _teachername,
                            'teacherid': _teacherid,
                            'class': _classname,
                            'classid': _classid,
                            'from': _from,
                            'to': _to,
                          }).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text("The event has been added!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          });
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content:
                              const Text("Invalid input! Please check again!"),
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.done,
                  ),
                  label: const Text("SAVE"),
                ),
              ],
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: TextFormField(
                        controller: _subjectnamecontroller,
                        decoration: const InputDecoration(
                            hintText: 'Enter Subject Name...',
                            labelText: 'Subject Name',
                            labelStyle: labelStyle),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Empty Field!';
                          }
                        },
                      ),
                    ),
                    !_teacherbuttonclicked
                        ? const SizedBox(height: 0)
                        : Container(
                            padding: const EdgeInsets.only(
                                top: 30, left: 30, right: 30),
                            height: devicesize.height / 4,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .where('status', isEqualTo: 'teacher')
                                  .snapshots()
                                  .asBroadcastStream(),
                              builder: (BuildContext ctx,
                                  AsyncSnapshot<QuerySnapshot>
                                      teachersnapshot) {
                                if (!teachersnapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(color: deepPurpleAccent),
                                  );
                                } else {
                                  var docs = teachersnapshot.data!.docs;
                                  var length = docs.length;
                                  return ListView.builder(
                                    itemCount: length,
                                    itemBuilder: (ctx, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _teacherid = docs[index].id;
                                            _teachername = docs[index]['name'] +
                                                ' ' +
                                                docs[index]['familyname'];
                                            _teacherbuttonclicked =
                                                !_teacherbuttonclicked;
                                            _chosenteacher = true;
                                          });
                                        },
                                        child: Card(
                                          child: Center(
                                            child: Text(
                                              '${docs[index]['name']} ${docs[index]['familyname']}',
                                              style: textstyle4,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                    TextButton(
                      onPressed: () {
                        setState(
                          () {
                            _teacherbuttonclicked = !_teacherbuttonclicked;
                          },
                        );
                      },
                      child: _chosenteacher
                          ? Text(
                              _teachername,
                              style: textstyle4,
                            )
                          : const Text(
                              'Choose Teacher',
                              style: textstyle2,
                            ),
                    ),
                    !_classbuttonclicked
                        ? const SizedBox(height: 0)
                        : Container(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, right: 35, left: 35),
                            height: devicesize.height / 4,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('classes')
                                  .snapshots()
                                  .asBroadcastStream(),
                              builder: (BuildContext ctx,
                                  AsyncSnapshot<QuerySnapshot> classsnapshot) {
                                if (!classsnapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(color: deepPurpleAccent,),
                                  );
                                } else {
                                  var docs = classsnapshot.data!.docs;
                                  var length = docs.length;
                                  return ListView.builder(
                                    itemCount: length,
                                    itemBuilder: (ctx, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _classid = docs[index].id;
                                            _classname = docs[index]['name'];
                                            _classbuttonclicked =
                                                !_classbuttonclicked;
                                            _chosenclass = true;
                                          });
                                        },
                                        child: Card(
                                          elevation: 0,
                                          child: Center(
                                            child: Text(
                                              '${docs[index]['name']}',
                                              style: textstyle4,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                    TextButton(
                      onPressed: () {
                        setState(
                          () {
                            _classbuttonclicked = !_classbuttonclicked;
                          },
                        );
                      },
                      child: _chosenclass
                          ? Text(
                              _classname,
                              style: textstyle4,
                            )
                          : const Text(
                              'Choose Class',
                              style: textstyle2,
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: const Text(
                              'The Day',
                              style: textstyle3,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  !_daybuttonclicked
                                      ? const Text(
                                          'no day chosen yet!',
                                          style: textstyle2,
                                        )
                                      : Text(
                                          DateFormat.yMMMEd()
                                              .format((_chosenday)),
                                          style: textstyle4,
                                        ),
                                  IconButton(
                                    onPressed: () {
                                      _getDay();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: const Text(
                              'FROM',
                              style: textstyle3,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  !_fromtimebuttonclicked
                                      ? const Text(
                                          'no date chosen yet!',
                                          style: textstyle2,
                                        )
                                      : Text(
                                          _chosenfromtime
                                              .toString()
                                              .split('(')[1]
                                              .split(')')[0],
                                          style: textstyle4,
                                        ),
                                  IconButton(
                                    onPressed: () {
                                      _getfromtime();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: const Text(
                              'TO',
                              style: textstyle3,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  !_totimebuttonclicked
                                      ? const Text(
                                          'no date chosen yet!',
                                          style: textstyle2,
                                        )
                                      : Text(
                                          _chosentotime
                                              .toString()
                                              .split('(')[1]
                                              .split(')')[0],
                                          style: textstyle4,
                                        ),
                                  IconButton(
                                    onPressed: () {
                                      _gettotime();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Column(
            children: const [
              Center(
                child: Text('Loading...'),
              ),
              Center(
                child: LinearProgressIndicator(
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
