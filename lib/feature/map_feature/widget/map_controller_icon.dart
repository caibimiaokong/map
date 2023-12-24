import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class MapControllerButton extends StatelessWidget {
  const MapControllerButton({
    super.key,
    required this.svgPath,
  });

  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60,
        height: 60,
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SvgPicture.string(svgPath),
        ));
  }
}
