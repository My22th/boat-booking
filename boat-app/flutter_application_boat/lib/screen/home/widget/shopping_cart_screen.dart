// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_boat/models/cart_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/title_text.dart';
import '../../../data_source/api_service.dart';
import '../../../models/ui.dart';
import '../../../repo/payment.dart';
import '../../../themes/light_color.dart';
import '../../../themes/theme.dart';
import '../home_screen.dart';

class ShoppingCartPage extends StatefulWidget {
  static var id = "shoppingcart_page";

  @override
  State<StatefulWidget> createState() => _ShoppingCart();
  // TODO: implement createState
}

class _ShoppingCart extends State<ShoppingCartPage> {
  @override
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

  Widget _cartItems() {
    return Consumer<Cart>(builder: (context, ui, child) {
      return Column(
          children: ui.cart!.map((x) => _item(x, context, ui)).toList());
    });
  }

  Widget _item(CartModel model, BuildContext context, Cart ui) {
    return SizedBox(
      height: 80,
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: LightColor.lightGrey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    left: -20,
                    bottom: -20,
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(13)),
                        child: Image.network(
                            model.cate.lstImgURL![0].toString(),
                            width: 90,
                            height: 90,
                            alignment: Alignment.center,
                            fit: BoxFit.fill)
                        // color: Theme.of(context).backgroundColor,
                        )),
              ],
            ),
          ),
          Expanded(
              child: ListTile(
                  title: TitleText(
                    text: model.cate.name.toString(),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      const TitleText(
                        text: '\$ ',
                        color: LightColor.red,
                        fontSize: 12,
                      ),
                      TitleText(
                        text: model.cate.pricePerDay.toString(),
                        fontSize: 14,
                      ),
                    ],
                  ),
                  trailing: Container(
                    width: 100,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: LightColor.lightGrey.withAlpha(150),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(children: [
                      TitleText(
                        text:
                            'x${model.todate.difference(model.formdate).inDays} days',
                        fontSize: 12,
                      ),
                      Center(
                        child: Text(
                          "${DateFormat("dd/MM/yyyy").format(model.formdate)} - ${DateFormat("dd/MM/yyyy").format(model.todate)}",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ]),
                  ))),
          InkWell(
            child: const Icon(Icons.delete),
            onTap: () async {
              if (await confirm(
                context,
                title: const Text('Confirm'),
                content: const Text('Would you like to remove?'),
                textOK: const Text('Yes'),
                textCancel: const Text('No'),
              )) {
                ui.removeToCart = model;
                return print('pressedOK');
              }
              return print('pressedCancel');
            },
          ),
        ],
      ),
    );
  }

  Widget _price() {
    return Consumer<Cart>(builder: (context, ui, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TitleText(
            text: '${ui.cart!.length} Items',
            color: LightColor.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          TitleText(
            text: '\$${getPrice(ui)}',
            fontSize: 18,
          ),
        ],
      );
    });
  }

  Widget _submitButton(
      BuildContext context, Cart uis, String userToken, int paytype) {
    return TextButton(
      onPressed: () async {
        BookingRes bks = BookingRes(isErr: false, mess: []);
        await ApiService().booking(uis.cart!, userToken).then((value) {
          bks = value;
        });
        if (bks.isErr) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: TitleText(text: bks.mess.toString(), fontSize: 20),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          if (paytype == 0) {
            uis.clearCart = true;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: TitleText(text: bks.mess.toString(), fontSize: 20),
                  actions: [
                    TextButton(
                      child: const Text("Order success"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            Navigator.push(context,
                MaterialPageRoute(builder: (contexts) => const HomeScreen()));
          } else {
            double price = 0;

            uis.cart!.forEach((x) {
              price += (x.cate.pricePerDay! *
                  x.todate.difference(x.formdate).inDays)!;
            });

            var result = await createOrder(2100 * price.toInt());
            uis.clearCart = true;
            if (result != null) {
              // Navigator.pop(context);
              zpTransToken = result.zptranstoken;
              setState(() {
                zpTransToken = result.zptranstoken;
                showResult = true;
              });
              String response = "";
              try {
                final String resultrs = await platform
                    .invokeMethod('payOrder', {"zptoken": result.zptranstoken});
                response = resultrs;
                print("payOrder Result: '$resultrs'.");
              } on PlatformException catch (e) {
                print("Failed to Invoke: '${e.message}'.");
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content:
                          TitleText(text: bks.mess.toString(), fontSize: 20),
                      actions: [
                        TextButton(
                          child: const Text("Payment Fail"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
                response = "Thanh toán thất bại";
              }
              print(response);

              setState(() {
                payResult = response;
              });

              if (response == "Payment Success") {
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content:
                          TitleText(text: bks.mess.toString(), fontSize: 20),
                      actions: [
                        TextButton(
                          child: const Text("Payment Fail"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }
          }
        }
        print("OrderRes:${bks.mess}");

        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => const CheckOutScreen()));
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
            paytype == 0 ? LightColor.grey : LightColor.skyBlue),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 4),
        width: AppTheme.fullWidth(context) * .85,
        child: TitleText(
          text: paytype == 0 ? 'Pay with cash' : 'Pay with zalopay',
          color: LightColor.background,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  double getPrice(Cart ui) {
    double price = 0;

    ui.cart!.forEach((x) {
      price += (x.cate.pricePerDay! * x.todate.difference(x.formdate).inDays)!;
    });
    return price;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.padding,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _cartItems(),
            const Divider(
              thickness: 1,
              height: 70,
            ),
            _price(),
            const SizedBox(height: 30),
            Consumer<Cart>(builder: (context, uis, child) {
              if (uis.cart!.isNotEmpty) {
                return Consumer<UI>(builder: (context, ui, child) {
                  return Column(children: [
                    _submitButton(context, uis, ui.userToken, 0),
                    _submitButton(context, uis, ui.userToken, 1)
                  ]);
                });
              }
              return Text("");
            }),
          ],
        ),
      ),
    );
  }
}
