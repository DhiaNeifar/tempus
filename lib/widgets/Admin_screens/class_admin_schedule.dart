import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final List<TimeRegion> regions = <TimeRegion>[];

class ClassAdminScheduleScreen extends StatelessWidget {
  final String classe;
  const ClassAdminScheduleScreen({Key? key, required this.classe})
      : super(key: key);
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
            .where('class', isEqualTo: classe)
            .snapshots()
            .asBroadcastStream(),
        builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: deepPurpleAccent),
            );
          } else {
            List<Appointment> meetings = [];
            var docs = snapshot.data!.docs;
            for (int i = 0; i < docs.length; i++) {
              var var1 = dateformatdatetime(extracttime(docs[i]['from']));
              var var2 = dateformatdatetime(extracttime(docs[i]['to']));
              final DateTime startTime = DateTime(var1.year, var1.month,
                  var1.day, var1.hour, var1.minute, var1.second);
              final DateTime endTime = DateTime(var1.year, var1.month, var1.day,
                  var2.hour, var2.minute, var2.second);
              var appointment = Appointment(
                subject: '${docs[i]['Subject']} ${docs[i]['teacher']}',
                startTime: startTime,
                endTime: endTime,
                id: docs[i].id,
              );
              if (!meetings.contains(appointment)) {
                meetings.add(appointment);
              }
            }
            var devicesizeheight = MediaQuery.of(context).size.height;
            return Scaffold(
              body: InteractiveViewer(
                child: SfCalendar(
                  view: CalendarView.workWeek,
                  firstDayOfWeek: 1,
                  timeSlotViewSettings: TimeSlotViewSettings(
                    startHour: 7,
                    endHour: 19,
                    nonWorkingDays: const <int>[DateTime.sunday],
                    timeIntervalHeight: devicesizeheight / 14,
                    dateFormat: 'd',
                    dayFormat: 'EEE',
                  ),
                  allowViewNavigation: false,
                  appointmentTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontFamily: 'Roboto'),
                  dataSource: MeetingDataSource(meetings),
                  monthViewSettings: const MonthViewSettings(
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.indicator),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
