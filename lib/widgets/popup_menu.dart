import 'package:flutter/material.dart';
import 'package:vietagri/helpers/custom_popup_menu.dart';

Widget popupMenu(
    {String tooltip,
    Function onSelect,
    List<CustomPopupMenu> options,
    BuildContext context,
    IconData icon}) {
  return PopupMenuButton(
    tooltip: tooltip,
    onSelected: onSelect,
    icon: icon != null ? Icon(icon) : Icon(Icons.more_vert),
    itemBuilder: (context) {
      return options.map((CustomPopupMenu option) {
        return PopupMenuItem(value: option, child: option.title);
      }).toList();
    },
  );
}
