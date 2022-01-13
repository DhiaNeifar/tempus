import 'package:first_app/utilities/constants.dart';
import 'package:flutter/material.dart';

class TeacherInformationCardScreen extends StatelessWidget {
  static const screentitle = '/TeacherInformationCardScreen';
  final List userdata;
  const TeacherInformationCardScreen({Key? key, required this.userdata})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var devicesize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: decoration,
          ),
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text('My Profile', style: usernametextStyle),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          height: devicesize.height / 5,
                          width: devicesize.height / 5,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(devicesize.height / 5),
                            child: userdata[0] != ''
                                ? FadeInImage(
                                    placeholder: const AssetImage(
                                        'lib/assets/images/placeholder.png'),
                                    image: NetworkImage(
                                      userdata[0],
                                    ),
                                    fit: BoxFit.fill,
                                  )
                                : Image.asset(
                                    'lib/assets/images/placeholder.png'),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          capitalize(userdata[1]) +
                              ' ' +
                              capitalize(userdata[2]),
                          style: nametextstyle,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: RichText(
                          text: const TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Status: ',
                                style: coordinatestextStyle,
                              ),
                              TextSpan(text: 'Teacher', style: answertextstyle),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Card(
                            shadowColor: Colors.redAccent,
                            elevation: 10,
                            color: Colors.deepPurple.shade300,
                            child: ListTile(
                              title: const Text('Birthdate',
                                  style: TextStyle(color: white)),
                              subtitle: Text(
                                  dateformatstring(extracttime(userdata[3]))),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Card(
                            shadowColor: Colors.redAccent,
                            elevation: 10,
                            color: Colors.deepPurple.shade300,
                            child: ListTile(
                              title: const Text('Email Address',
                                  style: TextStyle(color: white)),
                              subtitle: Text(userdata[4]),
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
        ],
      ),
    );
  }
}
