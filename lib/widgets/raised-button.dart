import 'package:flutter/material.dart';

Widget raisedButton(
    {showIcon = false,
    Icon icon,
    Text label,
    Function onPressed,
    Color color,
    Color textColor,
    FocusNode focusNode}) {
  if (showIcon) {
    return RaisedButton.icon(
      icon: icon,
      label: label,
      onPressed: onPressed,
      color: color,
      textColor: textColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusNode: focusNode,
      padding: EdgeInsets.symmetric(vertical: 19.0),
    );
  } else {
    return RaisedButton(
      child: label,
      onPressed: onPressed,
      color: color,
      textColor: textColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(vertical: 19.0),
    );
  }
}
