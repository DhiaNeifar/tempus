import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  final int duration;
  final Widget gotopage;

  const SplashPage({
    Key? key,
    required this.duration,
    required this.gotopage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: duration), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => gotopage));
    });
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(249, 166, 2, 1),
              Colors.amber,
              Color.fromRGBO(252, 226, 5, 1),
            ],
          )),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(140),
          child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 80,
              child: Image.asset('lib/assets/images/hourglassgif.gif')),
        )
      ],
    );
  }
}
