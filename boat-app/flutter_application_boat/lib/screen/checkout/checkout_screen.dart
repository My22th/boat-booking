import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/ui.dart';
import '../../repo/payment.dart';
import '../../themes/light_color.dart';
import '../../themes/theme.dart';

class CheckOutScreen extends StatefulWidget {
  static var id = "checkout_page";

  const CheckOutScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MyCheckout();
}

class _MyCheckout extends State<CheckOutScreen> {
  static const EventChannel eventChannel =
      EventChannel('flutter.native/eventPayOrder');
  static const MethodChannel platform =
      MethodChannel('flutter.native/channelPayOrder');
  final textStyle = TextStyle(color: Colors.black54);
  final valueStyle = TextStyle(
      color: Colors.black45, fontSize: 18.0, fontWeight: FontWeight.w400);
  String zpTransToken = "";
  String payResult = "";
  String payAmount = "10000";
  bool showResult = false;
  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    }
  }

  void _onEvent(dynamic event) {
    print("_onEvent: '$event'.");
    var res = Map<String, dynamic>.from(event);
    setState(() {
      if (res["errorCode"] == 1) {
        payResult = "Thanh toán thành công";
        Consumer<Cart>(builder: (context, ui, child) {
          return Text("");
        });
      } else if (res["errorCode"] == 4) {
        payResult = "User hủy thanh toán";
      } else {
        payResult = "Giao dịch thất bại";
      }
    });
  }

  void _onError(Object error) {
    print("_onError: '$error'.");
    setState(() {
      payResult = "Giao dịch thất bại";
    });
  }

  // Button Create Order
  Widget _btnCreateOrder(String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: GestureDetector(
          onTap: () async {
            int amount = int.parse(value);
            if (amount < 1000 || amount > 1000000) {
              setState(() {
                zpTransToken = "Invalid Amount";
              });
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  });
              var result = await createOrder(amount);
              if (result != null) {
                Navigator.pop(context);
                zpTransToken = result.zptranstoken;
                setState(() {
                  zpTransToken = result.zptranstoken;
                  showResult = true;
                });
              }
            }
          },
          child: Container(
              height: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text("Create Order",
                  style: TextStyle(color: Colors.white, fontSize: 20.0))),
        ),
      );

  /// Build Button Pay
  Widget _btnPay(String zpToken) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Visibility(
        visible: showResult,
        child: GestureDetector(
          onTap: () async {
            String response = "";
            try {
              final String result =
                  await platform.invokeMethod('payOrder', {"zptoken": zpToken});
              response = result;
              print("payOrder Result: '$result'.");
            } on PlatformException catch (e) {
              print("Failed to Invoke: '${e.message}'.");
              response = "Thanh toán thất bại";
            }
            print(response);
            setState(() {
              payResult = response;
            });
          },
          child: Container(
              height: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text("Pay",
                  style: TextStyle(color: Colors.white, fontSize: 20.0))),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedDate>(builder: (context, sd, child) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xfffbfbfb),
                Color(0xfff7f7f7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _appBar(),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Amount',
                    icon: Icon(Icons.attach_money),
                  ),
                  initialValue: payAmount,
                  onChanged: (value) {
                    setState(() {
                      payAmount = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                _btnCreateOrder(payAmount),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Visibility(
                    child: Text(
                      "zptranstoken:",
                      style: textStyle,
                    ),
                    visible: showResult,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    zpTransToken,
                    style: valueStyle,
                  ),
                ),
                _btnPay(zpTransToken),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Visibility(
                      child: Text("Transaction status:", style: textStyle),
                      visible: showResult),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    payResult,
                    style: valueStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: 15,
            padding: 12,
            isOutLine: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _icon(
    IconData icon, {
    Color color = LightColor.iconColor,
    double size = 20,
    double padding = 10,
    bool isOutLine = false,
    Function? onPressed,
  }) {
    return InkWell(
      onTap: () => onPressed!(),
      child: Container(
        height: 40,
        width: 40,
        padding: EdgeInsets.all(padding),
        // margin: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          border: Border.all(
              color: LightColor.iconColor,
              style: isOutLine ? BorderStyle.solid : BorderStyle.none),
          borderRadius: const BorderRadius.all(Radius.circular(13)),
          color: isOutLine
              ? Colors.transparent
              : Theme.of(context).colorScheme.background,
          boxShadow: const <BoxShadow>[
            BoxShadow(
                color: Color(0xfff8f8f8),
                blurRadius: 5,
                spreadRadius: 10,
                offset: Offset(5, 5)),
          ],
        ),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}
