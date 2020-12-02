import 'package:flutter/material.dart';

class CustomDropdownField extends StatefulWidget {
  final String displayText;
  final List<String> dropdownItems;
  final bool fullWidth;
  final Function itemSelected;

  CustomDropdownField({
    @required this.displayText,
    @required this.dropdownItems,
    this.fullWidth,
    this.itemSelected
  });

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              flex: widget.fullWidth ? 15 : 2,
              child: Text(widget.displayText)
            ),
            Expanded(
              flex: 1,
              child: Icon(Icons.arrow_drop_down)
            )
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0)
        ),
      ),
      itemBuilder: (context) {
        return widget.dropdownItems.map((String item) {
          return PopupMenuItem(
            value: item,
            child: widget.fullWidth ? Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: Text(item)
                  )
                ]
              )
            ) : Text(item)
          );
        }).toList();
      },
      onSelected: (String value) => widget.itemSelected(value),
    );
  }
}
