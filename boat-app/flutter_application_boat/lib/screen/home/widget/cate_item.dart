import 'package:flutter/material.dart';
import 'package:flutter_application_boat/models/cate_model.dart';
import 'package:flutter_application_boat/screen/product/product_detail_screen.dart';

import '../../components/title_text.dart';
import '../../themes/light_color.dart';

class CateGridItem extends StatefulWidget {
  final CategoryBoat cate;
  const CateGridItem({super.key, required this.cate});
  @override
  State<CateGridItem> createState() => _CateGridItemState();
}

class _CateGridItemState extends State<CateGridItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 200,
        decoration: const BoxDecoration(
          color: LightColor.background,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: true ? 20 : 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: 0,
                top: 0,
                child: IconButton(
                  icon: const Icon(
                    false ? Icons.favorite : Icons.favorite_border,
                    color: false ? LightColor.red : LightColor.iconColor,
                  ),
                  onPressed: () {},
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductDetailPage())),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const SizedBox(height: false ? 15 : 15),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: LightColor.orange.withAlpha(40),
                          ),
                          Image.network(
                            widget.cate.lstImgURL![0].toString(),
                            width: 200,
                            height: 200,
                          )
                        ],
                      ),
                    ),
                    // SizedBox(height: 5),
                    TitleText(
                      text: widget.cate.name.toString(),
                      fontSize: false ? 16 : 14,
                    ),

                    TitleText(
                      text: widget.cate.pricePerDay.toString() + " \$",
                      fontSize: false ? 18 : 16,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
