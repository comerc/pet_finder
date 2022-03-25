import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/imports.dart';

class Unit extends StatefulWidget {
  const Unit({
    Key? key,
    required this.unit,
  }) : super(key: key);

  final UnitModel unit;

  @override
  State<Unit> createState() => _UnitState();
}

class _UnitState extends State<Unit> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        _buildImage(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: _buildBadge(),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildTitle(),
              ),
            ],
          ),
        ),
        _buildBottom(),
      ],
    );
  }

  Widget _buildImage({required Widget child}) {
    final unit = widget.unit;
    final width = MediaQuery.of(context).size.width;
    return Hero(
      tag: unit.imageUrl,
      child: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: getImageProvider(unit.imageUrl),
            // TODO: вертикальные фотки не обрезать, а добавлять поля
            fit: BoxFit.cover,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.white.withOpacity(0.24),
            onTap: () {
              navigator.push(UnitScreen(unit: unit).getRoute());
            },
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final unit = widget.unit;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: <Color>[
            Colors.grey.withOpacity(0.0),
            Colors.black.withOpacity(0.4),
          ],
        ),
      ),
      padding: EdgeInsets.only(
        left: 8,
        top: 32,
        right: 8,
        bottom: 8,
      ),
      child: Text(
        unit.title,
        // style: Theme.of(context).textTheme.titleLarge,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.white),

        // style: TextStyle(
        //   fontSize: 18,
        //   fontWeight: FontWeight.w600,
        //   color: Colors.white,
        // ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildBottom() {
    // if (!_isBottom) {
    //   return SizedBox(
    //     height: kButtonHeight,
    //   );
    // }
    return Row(
      children: <Widget>[
        // if (unit.price == null) GiftButton(unit) else PriceButton(unit),

        Spacer(),
        // Icon(
        //   Icons.share,
        // ),
        // SizedBox(width: 16),
        // TextButton.icon(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.share,
        //   ),
        //   label: Text(""),
        // ),
        Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(4),
          clipBehavior: Clip.antiAlias,
          child: Tooltip(
            preferBelow: false,
            message: 'Share',
            child: InkWell(
              onTap: () {
                // TODO: реализовать DeepLink
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Icon(
                  Icons.share,
                  // color: Colors.black.withOpacity(0.8),
                  // size: iconSize,
                ),
              ),
            ),
          ),
        ),
        Tooltip(
          preferBelow: false,
          message: 'Favorite',
          child: TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border,
              ),
              label: Text("123")),
        ),

        // SizedBox(
        //   width: kButtonWidth,
        //   height: kButtonHeight,
        //   child: ShareButton(unit),
        // ),
        // SizedBox(
        //   width: kButtonWidth,
        //   height: kButtonHeight,
        //   child: WishButton(unit),
        // ),
      ],
    );
  }

  Widget _buildBadge() {
    final unit = widget.unit;
    return Container(
      color: unit.sex == SexValue.male
          ? Colors.blueAccent.withOpacity(0.8)
          : Colors.redAccent.withOpacity(0.8),
      padding: EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 12),
      child: Row(
        children: [
          Icon(
            unit.sex == SexValue.male ? Icons.male : Icons.female,
            color: Colors.white,
          ),
          Text(
            formatAge(unit),
            style: TextStyle(
              // fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
