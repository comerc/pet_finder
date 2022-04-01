// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:extended_image/extended_image.dart';
import 'package:pet_finder/import.dart';

// TODO: как сделать splash для элемента списка LedgerScreen и пункта меню UnitScreen?

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    required this.url,
    this.radius = 32,
    this.borderRadius = 12,
    this.onTap,
  }) : super(key: key);

  final String url;
  final double radius;
  final double borderRadius;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.circular(borderRadius),
        // type: MaterialType.circle,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        // color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.white.withOpacity(0.24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Ink.image(
              fit: BoxFit.cover,
              image: getImageProvider(url),
            ),
          ),
        ),
      ),
    );
  }
}
