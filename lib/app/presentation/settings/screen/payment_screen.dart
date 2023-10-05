import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_payment/in_app_payment.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = "payment";
  const PaymentScreen({super.key, required this.userId});

  final String userId;
//

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final pay = HNGPay();
  //final storage = AppStorage.instance;

  @override
  Widget build(BuildContext context) {
    // final user = storage.getUserData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'To get more credits in the app, you need to pay:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              '\$5 per month',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Platform.isAndroid
                ? pay.googlePay(
                    context,
                    amountToPay: "5",
                    userID: widget.userId,
                  )
                : pay.applePay(
                    context,
                    amountToPay: "5",
                    userID: widget.userId,
                  )
          ],
        ),
      ),
    );
  }
}
