import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';

class TestPayment extends StatefulWidget {
  TestPayment({Key key}) : super(key: key);

  @override
  _TestPaymentState createState() => _TestPaymentState();
}

class _TestPaymentState extends State<TestPayment> {
  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: MaterialButton(
                onPressed: () {
                  var options = {
                    'key': 'rzp_test_lsyCQNQAi3tQO4',
                    'amount': 1000000,
                    'name': 'Sort It',
                    'description': 'Class Fee',
                    'prefill': {
                      'contact': '8888888888',
                      'email': 'test@razorpay.com'
                    }
                  };
                  setState(() {
                    _razorpay.open(options);
                  });
                },
                child: Gtheme.stext("Test Payment"))),
      ),
    );
  }
}
