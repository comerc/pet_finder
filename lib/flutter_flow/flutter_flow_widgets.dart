import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FFButtonOptions {
  const FFButtonOptions({
    this.textStyle,
    this.elevation,
    this.height,
    this.width,
    this.padding,
    this.color,
    this.disabledColor,
    this.disabledTextColor,
    this.splashColor,
    this.iconSize,
    this.iconColor,
    this.iconPadding,
    this.borderRadius,
    this.borderSide,
  });

  final TextStyle textStyle;
  final double elevation;
  final double height;
  final double width;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color disabledColor;
  final Color disabledTextColor;
  final Color splashColor;
  final double iconSize;
  final Color iconColor;
  final EdgeInsetsGeometry iconPadding;
  final double borderRadius;
  final BorderSide borderSide;
}

class FFButtonWidget extends StatefulWidget {
  const FFButtonWidget({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.icon,
    this.iconData,
    @required this.options,
    this.showLoadingIndicator = true,
  }) : super(key: key);

  final String text;
  final Widget icon;
  final IconData iconData;
  final Function() onPressed;
  final FFButtonOptions options;
  final bool showLoadingIndicator;

  @override
  State<FFButtonWidget> createState() => _FFButtonWidgetState();
}

class _FFButtonWidgetState extends State<FFButtonWidget> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Widget textWidget = loading
        ? Center(
            child: Container(
              width: 23,
              height: 23,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.options.textStyle.color ?? Colors.white,
                ),
              ),
            ),
          )
        : AutoSizeText(
            widget.text,
            style: widget.options.textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );

    final onPressed = widget.showLoadingIndicator
        ? () async {
            if (loading) {
              return;
            }
            setState(() => loading = true);
            try {
              await widget.onPressed();
            } catch (e) {
              print('On pressed error:\n$e');
            }
            setState(() => loading = false);
          }
        : () => widget.onPressed();

    if (widget.icon != null || widget.iconData != null) {
      textWidget = Flexible(child: textWidget);
      return Container(
        height: widget.options.height,
        width: widget.options.width,
        child: RaisedButton.icon(
          icon: Padding(
            padding: widget.options.iconPadding ?? EdgeInsets.zero,
            child: widget.icon ??
                FaIcon(
                  widget.iconData,
                  size: widget.options.iconSize,
                  color: widget.options.iconColor ??
                      widget.options.textStyle.color,
                ),
          ),
          label: textWidget,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.options.borderRadius),
            side: widget.options.borderSide ?? BorderSide.none,
          ),
          color: widget.options.color,
          colorBrightness:
              ThemeData.estimateBrightnessForColor(widget.options.color),
          textColor: widget.options.textStyle.color,
          disabledColor: widget.options.disabledColor,
          disabledTextColor: widget.options.disabledTextColor,
          elevation: widget.options.elevation,
          splashColor: widget.options.splashColor,
        ),
      );
    }

    return Container(
      height: widget.options.height,
      width: widget.options.width,
      child: RaisedButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(widget.options.borderRadius ?? 28),
          side: widget.options.borderSide ?? BorderSide.none,
        ),
        textColor: widget.options.textStyle.color,
        color: widget.options.color,
        colorBrightness:
            ThemeData.estimateBrightnessForColor(widget.options.color),
        disabledColor: widget.options.disabledColor,
        disabledTextColor: widget.options.disabledTextColor,
        padding: widget.options.padding,
        elevation: widget.options.elevation,
        child: textWidget,
      ),
    );
  }
}
