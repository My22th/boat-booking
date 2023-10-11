import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/ui.dart';

class SelectedDateWidget extends StatefulWidget {
  const SelectedDateWidget({super.key});

  @override
  State<StatefulWidget> createState() => _SelectedDate();
}

class _SelectedDate extends State<SelectedDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedDate>(builder: (context, ui, child) {
      return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(right: 0, bottom: 0),
            child: Column(
              children: [
                const Text(
                  'Choose a date range',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black),
                ),
                Text(
                  (ui.getfromdate != null && ui.gettodate != null)
                      ? "${DateFormat('dd/MM/yyyy').format(ui.getfromdate!)} - ${DateFormat('dd/MM/yyyy').format(ui.gettodate!)}"
                      : "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ],
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showCustomDateRangePicker(
              context,
              dismissible: true,
              minimumDate: DateTime.now().subtract(const Duration(days: 90)),
              maximumDate: DateTime.now().add(const Duration(days: 90)),
              endDate: ui.gettodate,
              startDate: ui.getfromdate,
              backgroundColor: Colors.white,
              primaryColor: Colors.green,
              onApplyClick: (start, end) {
                ui.fromdate = start;
                ui.todate = end;
              },
              onCancelClick: () {},
            );
          },
          tooltip: 'choose date Range',
          child: const Icon(Icons.calendar_today_outlined, color: Colors.white),
        ),
      );
    });
  }
}
