import 'package:flutter/material.dart';

import '../special_widgets/status_button.dart';

class WelcomePage extends StatelessWidget {
  static const screentitle = 'welcome_page';
  const WelcomePage({Key? key}) : super(key: key);
  static const gifsrc = 'lib/assets/images/gif.gif';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.3,
                child: Positioned.fill(
                  child: Image.asset(gifsrc, fit: BoxFit.cover),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: Image.asset(
                        'lib/assets/images/hourglass.png',
                        width: 150,
                      ),
                      radius: 100,
                      backgroundColor: const Color.fromRGBO(239, 239, 65, 0.3),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text("Welcome To Tempus!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Are you a : ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    const Button(
                      status: 'Student',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Button(
                      status: 'Teacher',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Button(
                      status: 'Administrator',
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
