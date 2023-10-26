import 'package:flutter/material.dart';
import 'package:flutter_application_boat/models/cart_model.dart';
import 'package:provider/provider.dart';

import '../../components/title_text.dart';
import '../../models/cate_model.dart';
import '../../models/ui.dart';
import '../../themes/light_color.dart';
import '../../themes/theme.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key, required this.cate}) : super(key: key);
  static String id = 'product_screen';
  final CategoryBoat? cate;
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late String currnentimg = widget.cate!.lstImgURL![0].toString();
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isLiked = true;
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
          _icon(isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? LightColor.red : LightColor.lightGrey,
              size: 15,
              padding: 12,
              isOutLine: false, onPressed: () {
            setState(() {
              isLiked = !isLiked;
            });
          }),
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
              : Theme.of(context).backgroundColor,
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

  Widget _productImage() {
    return AnimatedBuilder(
      builder: (context, child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: animation.value,
          child: child,
        );
      },
      animation: animation,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          const TitleText(
            text: "AIP",
            fontSize: 160,
            color: LightColor.lightGrey,
          ),
          Image.network(currnentimg.toString(),
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.fill)
        ],
      ),
    );
  }

  Widget _categoryWidget(List<String> img) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      width: AppTheme.fullWidth(context),
      height: 80,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: img.map((x) => _thumbnail(x)).toList()),
    );
  }

  Widget _thumbnail(String image) {
    return AnimatedBuilder(
      animation: animation,
      //  builder: null,
      builder: (context, child) => AnimatedOpacity(
        opacity: animation.value,
        duration: const Duration(milliseconds: 500),
        child: child,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: InkWell(
            onTap: () => setState(() {
                  currnentimg = image;
                }),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(13)),
                child: Image.network(image,
                    width: 80,
                    height: 50,
                    alignment: Alignment.center,
                    fit: BoxFit.fill)
                // color: Theme.of(context).backgroundColor,
                )),
      ),
    );
  }

  Widget _detailWidget() {
    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .53,
      minChildSize: .53,
      builder: (context, scrollController) {
        return Container(
          padding: AppTheme.padding.copyWith(bottom: 0),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: const BoxDecoration(
                        color: LightColor.iconColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TitleText(
                          text: widget.cate!.name.toString(), fontSize: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const TitleText(
                                text: "\$ ",
                                fontSize: 18,
                                color: LightColor.red,
                              ),
                              TitleText(
                                text: widget.cate!.pricePerDay.toString(),
                                fontSize: 25,
                              ),
                            ],
                          ),
                          const Row(
                            children: <Widget>[
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star_border, size: 17),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _availableSize(),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                _description(),
                _enginetype()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _availableSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleText(
          text: "Capacity Size",
          fontSize: 14,
        ),
        const SizedBox(height: 20),
        Row(
          children: <Widget>[Text(widget.cate!.capacity.toString())],
        )
      ],
    );
  }

  Widget _sizeWidget(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: !isSelected ? BorderStyle.solid : BorderStyle.none),
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        color:
            isSelected ? LightColor.orange : Theme.of(context).backgroundColor,
      ),
      child: TitleText(
        text: text,
        fontSize: 16,
        color: isSelected ? LightColor.background : LightColor.titleTextColor,
      ),
    );
  }

  Widget _availableColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _colorWidget(LightColor.yellowColor, isSelected: true),
            const SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.lightBlue),
            const SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.black),
            const SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.red),
            const SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.skyBlue),
          ],
        )
      ],
    );
  }

  Widget _colorWidget(Color color, {bool isSelected = false}) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: color.withAlpha(150),
      child: isSelected
          ? Icon(
              Icons.check_circle,
              color: color,
              size: 18,
            )
          : CircleAvatar(radius: 7, backgroundColor: color),
    );
  }

  Widget _description() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TitleText(
              text: "Decription Size",
              fontSize: 14,
            ),
            const SizedBox(height: 20),
            Text(widget.cate!.description.toString()),
          ],
        ));
  }

  Widget _enginetype() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const TitleText(
              text: "Engine Type",
              fontSize: 14,
            ),
            const SizedBox(height: 20),
            Text(widget.cate!.title.toString()),
          ],
        ));
  }

  Consumer<Cart> _flotingButton(DateTime fromdate, DateTime todate) {
    return Consumer<Cart>(builder: (context, ui, child) {
      return FloatingActionButton.extended(
          label: Positioned(
            left: 10,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 0,
              ),
              child: SizedBox(
                  width: 20,
                  child: Positioned(
                    left: 20,
                    child: CircleAvatar(
                      child: Text(
                          ui.cart == null ? "0" : ui.cart!.length.toString()),
                    ),
                  )),
            ),
          ),
          onPressed: () {
            if (ui.cart!.any((s) =>
                s.cate.categoryId == widget.cate!.categoryId &&
                (s.formdate == fromdate && s.todate == todate))) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const TitleText(
                        text: "You adrealy add item!", fontSize: 20),
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
              CartModel cartit = CartModel(
                  cate: widget.cate!, formdate: fromdate, todate: todate);
              ui.addToCart = cartit;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const TitleText(
                        text: "Add item to cart success!", fontSize: 20),
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
            }
          },
          backgroundColor: const Color.fromRGBO(230, 88, 41, 1),
          icon: Icon(Icons.shopping_basket,
              color:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedDate>(builder: (context, sd, child) {
      return Scaffold(
        floatingActionButton: _flotingButton(sd.getfromdate!, sd.gettodate!),
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
                    _productImage(),
                    _categoryWidget(widget.cate!.lstImgURL!.toList()),
                  ],
                ),
                _detailWidget(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
