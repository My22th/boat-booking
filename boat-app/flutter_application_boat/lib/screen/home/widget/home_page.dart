import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data_source/api_service.dart';
import '../../../models/cate_model.dart';
import '../../../models/ui.dart';
import '../../../themes/light_color.dart';
import '../../../themes/theme.dart';
import 'cate_item.dart';
import 'selected_date.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 210,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        dragStartBehavior: DragStartBehavior.down,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // _search(),
            // SelectedDateWidget()
            SizedBox(
              width: 260.0,
              height: 45.0,
              child: _datePicker(),
            ),
            Consumer<SelectedDate>(
              builder: (context, ui, child) {
                if (ui.getfromdate != null && ui.gettodate != null) {
                  return _productWidget(
                      context, ui.getfromdate!, ui.gettodate!);
                }
                return Text("");
              },
            )
            // _productWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _datePicker() {
    return const SelectedDateWidget();
  }

  Widget _icons(IconData icon, {Color color = LightColor.iconColor}) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        child: Material(
          color: const Color.fromRGBO(188, 215, 130, 1),
          child: InkWell(
              borderRadius: BorderRadius.circular(30), //radius cho hiệu ứng
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(13)),
                    color: const Color.fromRGBO(188, 215, 130, 1),
                    boxShadow: AppTheme.shadow),
                child: Icon(
                  icon,
                  color: Color.fromARGB(255, 49, 50, 48),
                ),
              )),
        ));
  }

  Widget _productWidget(BuildContext context, DateTime fd, DateTime td) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: AppTheme.fullWidth(context),
        height: AppTheme.fullWidth(context) * .7,
        child: FutureBuilder<List<CategoryBoat>>(
          future: ApiService().getAllCate(fd, td),
          builder: (BuildContext context,
              AsyncSnapshot<List<CategoryBoat>> snapshot) {
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
                  List<CategoryBoat> data = snapshot.data!;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: AppTheme.fullWidth(context),
                    height: AppTheme.fullWidth(context) * .7,
                    child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 4 / 3,
                                mainAxisSpacing: 30,
                                crossAxisSpacing: 20),
                        padding: const EdgeInsets.only(left: 20),
                        scrollDirection: Axis.horizontal,
                        children: _renderItem(data)),
                  );
                }
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }

  List<Widget> _renderItem(List<CategoryBoat> data) {
    List<Widget> widgets = List.empty(growable: true);
    for (var element in data) {
      widgets.add(CateGridItem(cate: element));
    }
    return widgets;
  }

  Widget _search() {
    return Container(
      margin: AppTheme.padding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.lightGrey.withAlpha(100),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: const TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
                    prefixIcon: Icon(Icons.search, color: Colors.black54)),
              ),
            ),
          ),
          const SizedBox(width: 20),
          _icons(Icons.filter_list,
              color: const Color.fromRGBO(188, 215, 130, 1))
        ],
      ),
    );
  }
}
