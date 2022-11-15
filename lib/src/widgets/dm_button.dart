import 'package:dm_components/src/common/defines.dart';
import 'package:flutter/material.dart';

bool _buttonPressed = true;

class DMButton extends StatelessWidget {
  const DMButton({
    Key key,
    @required this.onPressed,
    @required this.child,
    this.backgroundColor,
    this.height,
    this.width,
    this.borderColor,
    this.borderRadius,
    this.gradient,
    this.expanded = false,
    this.buttonType = DMButtonType.flat,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;
  final bool expanded;
  final Color backgroundColor;
  final double height;
  final double width;
  final Color borderColor;
  final BorderRadius borderRadius;
  final Gradient gradient;
  final DMButtonType buttonType;

  factory DMButton.icon({
    @required VoidCallback onPressed,
    @required Widget icon,
    @required Widget label,
    Color backgroundColor,
    double height,
    double width,
    Color borderColor,
    BorderRadius borderRadius,
    DMPosition iconPosition,
    Gradient gradient,
    double spacing,
    DMButtonType buttonType,
  }) = _DMButton;

  @override
  Widget build(BuildContext context) {
    final Widget buttonChild = expanded
        ? Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                child: child,
              ),
            ],
          )
        : child;

    return _getButton(
      borderRadius,
      gradient,
      backgroundColor,
      onPressed,
      height,
      width,
      borderColor,
      buttonType,
      buttonChild,
    );
  }
}

class _DMButton extends DMButton with MaterialButtonWithIconMixin {
  _DMButton({
    @required VoidCallback onPressed,
    @required this.icon,
    @required this.label,
    Color backgroundColor,
    double height,
    double width,
    Color borderColor,
    BorderRadius borderRadius,
    Gradient gradient,
    DMButtonType buttonType = DMButtonType.flat,
    this.iconPosition = DMPosition.right,
    this.spacing = 0.0,
    Key key,
  })  : assert(icon != null),
        assert(label != null),
        super(
          onPressed: onPressed,
          backgroundColor: backgroundColor,
          height: height,
          width: width,
          borderColor: borderColor,
          borderRadius: borderRadius,
          gradient: gradient,
          child: null,
          buttonType: buttonType,
        );

  final DMPosition iconPosition;
  final double spacing;
  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    final bool isHorizontal =
        (iconPosition == DMPosition.left || iconPosition == DMPosition.right);
    final SizedBox spaceBox =
        isHorizontal ? SizedBox(width: spacing) : SizedBox(height: spacing);
    final List<Widget> children =
        (iconPosition == DMPosition.left || iconPosition == DMPosition.top)
            ? [icon, spaceBox, label]
            : [label, spaceBox, icon];
    final Widget buttonChild = isHorizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: children,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          );

    return _getButton(
      borderRadius,
      gradient,
      backgroundColor,
      onPressed,
      height,
      width,
      borderColor,
      buttonType,
      buttonChild,
    );
  }
}

Widget _getButton(
  BorderRadius borderRadius,
  Gradient gradient,
  Color backgroundColor,
  VoidCallback onPressed,
  double height,
  double width,
  Color borderColor,
  DMButtonType buttonType,
  Widget buttonChild,
) {
  return Listener(
    onPointerDown: (details) {
      _buttonPressed = true;
    },
    onPointerUp: (details) {
      _buttonPressed = false;
    },
    child: Container(
      width: buttonType == DMButtonType.flat ? width : width + 2,
      height: buttonType == DMButtonType.flat ? height : height + 2,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: buttonType == DMButtonType.flat
            ? null
            : [
                _buttonPressed
                    ? BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: Offset(0, 0),
                      )
                    : BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      )
              ],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Ink(
          width: buttonType == DMButtonType.flat ? width : width - 2,
          height: buttonType == DMButtonType.flat ? height : height - 2,
          decoration: BoxDecoration(
            color: backgroundColor,
            gradient: gradient,
            borderRadius: borderRadius,
            border: borderColor == null ? null : Border.all(color: borderColor),
          ),
          child: Container(
              constraints: BoxConstraints(),
              alignment: Alignment.center,
              child: buttonChild),
        ),
        //splashColor: Colors.white70,
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
    ),
  );
}