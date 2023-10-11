import 'package:flutter/material.dart';
import 'package:flutter_application_boat/models/cate_model.dart';
import 'package:flutter_application_boat/screen/home/widget/shopping_cart_screen.dart';
import 'package:provider/provider.dart';

import '../../components/bottom_navigation_bar.dart';
import '../../components/title_text.dart';
import '../../models/base_model.dart';
import '../../models/ui.dart';
import '../../themes/light_color.dart';
import '../../themes/theme.dart';
import 'widget/home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = 'home_screen';
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CurrentPage currentpage = CurrentPage.home;
  late List<CategoryBoat> cb;

  void onBottomIconPressed(int index) {
    if (index == 0) {
      setState(() {
        currentpage = CurrentPage.home;
      });
    } else if (index == 1) {
      setState(() {
        currentpage = CurrentPage.flollow;
      });
    } else if (index == 2) {
      setState(() {
        currentpage = CurrentPage.cart;
      });
    } else {
      setState(() {
        currentpage = CurrentPage.info;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _appBar() {
    return Consumer<UI>(builder: (context, ui, child) {
      return Container(
        padding: AppTheme.padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RotatedBox(
              quarterTurns: 4,
              child: _icon(Icons.sort, color: Colors.black54),
            ),
          ],
        ),
      );
    });
  }

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(13)),
          color: const Color.fromRGBO(188, 215, 130, 1),
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget _title() {
    return Container(
        margin: AppTheme.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText(
                  text: currentpage.index == 0
                      ? "Our"
                      : currentpage.index == 1
                          ? "Follow"
                          : "Your",
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
                TitleText(
                  text: currentpage.index == 0
                      ? "Products"
                      : currentpage.index == 1
                          ? "Product"
                          : currentpage.index == 2
                              ? "Cart"
                              : "Information",
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            const Spacer(),
            currentpage.index == 2
                ? Container(
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.delete_outline,
                      color: LightColor.orange,
                    ),
                  )
                : const SizedBox()
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: AppTheme.fullHeight(context) - 50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xfffbfbfb),
                      Color(0xfff7f7f7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _appBar(),
                    _title(),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeInToLinear,
                        switchOutCurve: Curves.easeOutBack,
                        child: currentpage == CurrentPage.home
                            ? HomePage(
                                title: 'Home',
                              )
                            : currentpage == CurrentPage.cart
                                ? const ShoppingCartPage()
                                : const Align(
                                    alignment: Alignment.topCenter,
                                    child: null,
                                  ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CustomBottomNavigationBar(
                onIconPresedCallback: onBottomIconPressed,
              ),
            )
          ],
        ),
      ),
    );
  }
}
