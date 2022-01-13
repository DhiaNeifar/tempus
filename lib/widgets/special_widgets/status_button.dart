import 'package:flutter/material.dart';

import '../../sign_in.dart';

class Button extends StatelessWidget {
  final String status;
  const Button({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(252, 226, 5, 1),
              Colors.amber,
              Color.fromRGBO(252, 226, 5, 1),
            ],
          ),
        ),
        width: 200,
        height: 60,
        padding: const EdgeInsets.all(10),
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, SignIn.screentitle);
            },
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
