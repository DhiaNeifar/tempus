import 'package:first_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

Future<dynamic> verifyConnection(ctx) async {
  var result = await Connectivity().checkConnectivity();

  if (result == ConnectivityResult.none) {
    return showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: const Text("Problem with connection!"),
        content: const Text("Neither Wifi nor MobileData is On!"),
        actions: [
          TextButton(
            onPressed: () async {
              var result1 = await Connectivity().checkConnectivity();
              if (result1 != ConnectivityResult.none) {
                Navigator.of(ctx).pop();
              }
            },
            child: const Text(
              'Okay',
              style: textstyle2,
            ),
          ),
        ],
      ),
    );
  }
}
