import 'package:flutter/material.dart';
import 'package:flutter_application_boat/models/order_model.dart';
import 'package:flutter_application_boat/screen/home/widget/apoinmentcart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data_source/api_service.dart';
import '../../../models/ui.dart';

class HistoryOrder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryOrder();
}

class _HistoryOrder extends State<HistoryOrder> {
  List<Order> hisOrder = new List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Consumer<UI>(builder: (context, ui, child) {
      return Container(
          child: FutureBuilder<List<Order>>(
        future: ApiService().getorders(ui.userToken),
        builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text('An error occurred!'),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.error != null) {
                // ...
                // Do error handling stuff
                return const Center(
                  child: Text('An error occurred!'),
                );
              } else {
                List<Order> data = snapshot.data!;
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: _renderItem(data),
                );
              }
            } else {
              return Text("You don have orders");
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ));
    });
  }

  List<Widget> _renderItem(List<Order> data) {
    data = data.reversed.toList();
    List<Widget> widgets = List.empty(growable: true);
    for (var element in data) {
      widgets.addAll(<Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            child: Text(
              DateFormat("dd/MM/yyyy")
                      .format(element.bookingDate ?? DateTime.now())
                      .toString() +
                  " - " +
                  (element.paymentType == 1
                      ? "Pay with: ZaloPay"
                      : "Pay with: Cash"),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              AppointmentCard(
                name: element.boatName!.toString(),
                Payname: element.paymentType == 1 ? "ZaloPay" : "Cash",
                Price: element.price.toString(),
                dateTime:
                    "${DateFormat("dd/MM/yyyy").format(element.fromDate!)} - ${DateFormat("dd/MM/yyyy").format(element.toDate!)}",
                padding: 16,
              )
            ],
          ),
        ),
      ]);
    }
    return widgets;
  }
}
