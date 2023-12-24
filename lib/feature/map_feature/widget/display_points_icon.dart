import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class GoogleMapIcon extends StatelessWidget {
  final String imagePath;
  final bool isMultip;
  const GoogleMapIcon(
      {Key? key, required this.imagePath, required this.isMultip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isMultip
                ? const Color.fromARGB(255, 23, 233, 4)
                : const Color.fromARGB(255, 211, 170, 35),
            width: 3.0,
          ),
        ),
        child: SvgPicture.string(imagePath));
  }
}
