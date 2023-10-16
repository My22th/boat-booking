import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_boat/models/cart_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/title_text.dart';
import '../../../models/ui.dart';
import '../../../themes/light_color.dart';
import '../../../themes/theme.dart';
import '../../checkout/checkout_screen.dart';

class ShoppingCartPage extends StatelessWidget {
  static var id = "shoppingcart_page";

  const ShoppingCartPage({Key? key}) : super(key: key);

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

  Widget _submitButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CheckOutScreen()));
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(LightColor.orange),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 4),
        width: AppTheme.fullWidth(context) * .85,
        child: const TitleText(
          text: 'Next',
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
            Consumer<Cart>(builder: (context, ui, child) {
              if (ui.cart!.isNotEmpty) {
                return _submitButton(context);
              }
              return Text("");
            }),
          ],
        ),
      ),
    );
  }
}
