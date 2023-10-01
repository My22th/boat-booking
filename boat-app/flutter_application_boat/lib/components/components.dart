import 'package:flutter/material.dart';

class TopScreenImage extends StatelessWidget {
  const TopScreenImage({super.key, required this.screenImageName});
  final String screenImageName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage('assets/images/$screenImageName'),
          ),
        ),
      ),
    );
  }
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key, required this.title, required this.color});
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          color: Color(color.value),
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

List<double> getStopsColors(bool isDark) {
  return isDark ? [0.0, 1.0] : [0, 1];
}

List<Color> getColors(bool cl) => cl
    ? [
        const Color.fromRGBO(48, 207, 208, 1),
        const Color.fromRGBO(51, 8, 103, 1),
      ]
    : [
        const Color.fromRGBO(168, 237, 234, 1),
        const Color.fromRGBO(254, 214, 227, 1),
      ];
