import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/utilities/constants.dart';
import 'package:first_app/widgets/Admin_screens/add_event.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

List<Appointment> meetings = [];

class MainSchedule extends StatelessWidget {
  static const screentitle = '/schedulescreen';
  const MainSchedule({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(
          color: Colors.blue,
        ),
        toolbarHeight: 20,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Schedule')
            .snapshots()
            .asBroadcastStream(),
        builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: deepPurpleAccent),
            );
          } else {
            var docs = snapshot.data!.docs;
            for (int i = 0; i < docs.length; i++) {
              var var1 = dateformatdatetime(extracttime(docs[i]['from']));
              var var2 = dateformatdatetime(extracttime(docs[i]['to']));
              final DateTime startTime = DateTime(var1.year, var1.month,
                  var1.day, var1.hour, var1.minute, var1.second);
              final DateTime endTime = DateTime(var1.year, var1.month, var1.day,
                  var2.hour, var2.minute, var2.second);
              var appointment = Appointment(
                subject:
                    '${docs[i]['Subject']} ${docs[i]['teacher']} ${docs[i]['class']}',
                startTime: startTime,
                endTime: endTime,
                id: docs[i].id,
              );
              if (!meetings.contains(appointment)) {
                meetings.add(appointment);
              }
            }
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushNamed(Addeventwidget.screentitle);
                },
              ),
              body: SfCalendar(
                view: CalendarView.schedule,
                allowViewNavigation: false,
                onLongPress: (value) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title:
                          const Text('Do you want to delete the appointment?'),
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
                          onPressed: () async {
                            var id = value.appointments![0].id;
                            FirebaseFirestore.instance
                                .collection('Schedule')
                                .doc(value.appointments![0].id)
                                .delete();
                            for (int i = 0; i < meetings.length; i++) {
                              if (meetings[i].id == id) {
                                meetings.removeAt(i);
                              }
                            }
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
                },
                appointmentTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Roboto'),
                dataSource: MeetingDataSource(meetings),
                monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.indicator),
              ),
            );
          }
        },
      ),
    );
  }
}
