import 'package:flutter/material.dart';
import 'package:flutter_application_boat/models/order_model.dart';
import 'package:flutter_application_boat/screen/home/widget/apoinmentcart.dart';
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
  void initState() {
    setState(() async {
      var token = "";
      Consumer<UI>(builder: (context, ui, child) {
        token = ui.userToken;

        return Text("");
      });
      await ApiService().getorders(token).then((value) {
        hisOrder = value;
      });
    });
    // userinfo = "response";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: Text(
                "Next Appointments",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                AppointmentCard(
                  name: "Dorothy Nelson",
                  dateTime: "09 Jan 2020, 8am - 10am",
                  padding: 16,
                ),
                AppointmentCard(
                  name: "Carl Pope",
                  dateTime: "09 Jan 2020, 11am - 02pm",
                  padding: 16,
                ),
                AppointmentCard(
                  name: "Ora Murray",
                  dateTime: "10 Jan 2020, 9am - 10am",
                  padding: 16,
                ),
                AppointmentCard(
                  name: "Dorothy Nelson",
                  dateTime: "09 Jan 2020, 8am - 10am",
                  padding: 16,
                ),
                AppointmentCard(
                  name: "Carl Pope",
                  dateTime: "09 Jan 2020, 11am - 02pm",
                  padding: 16,
                ),
                AppointmentCard(
                  name: "Ora Murray",
                  dateTime: "10 Jan 2020, 9am - 10am",
                  padding: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
