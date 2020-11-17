import 'package:flutter/material.dart';
import 'package:pet_finder/import.dart';

// TODO: перенести в minsk8
// TODO: validator isRequired errorText
// TODO: FocusScope.of(context).unfocus();

class SelectField<T> extends StatefulWidget {
  SelectField({
    Key key,
    this.tooltip,
    this.label,
    this.title,
    this.values,
    this.initialValue,
    this.getValueTitle,
    this.getValueSubtitle,
  }) : super(key: key);

  final String tooltip;
  final String label;
  final String title;
  final List<T> values;
  final T initialValue;
  final String Function(T value) getValueTitle;
  final String Function(T value) getValueSubtitle;

  @override
  SelectFieldState createState() => SelectFieldState<T>();
}

class SelectFieldState<T> extends State<SelectField<T>> {
  T _value;
  T get value => _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Tooltip(
        message: widget.tooltip,
        child: Material(
          child: InkWell(
            onTap: _onTap,
            child: Row(
              children: <Widget>[
                SizedBox(width: 16),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(widget.label),
                ),
                Spacer(),
                if (value != null) Text(widget.getValueTitle(value)),
                SizedBox(width: 16),
                Icon(
                  Icons.navigate_next,
                  color: Colors.black.withOpacity(0.3),
                  size: kButtonIconSize,
                ),
                SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 32),
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 16),
              // TODO: ListBox не нужен?
              // ListBox(
              ListView.separated(
                shrinkWrap: true,
                itemCount: widget.values.length,
                itemBuilder: (BuildContext context, int index) {
                  final value = widget.values[index];
                  final selected = _value == value;
                  return Material(
                    color:
                        selected ? Colors.grey.withOpacity(0.2) : Colors.white,
                    child: InkWell(
                      onLongPress:
                          () {}, // чтобы сократить время для splashColor
                      onTap: () {
                        navigator.pop();
                        setState(() {
                          _value = value;
                        });
                      },
                      child: ListTile(
                        title: Text(widget.getValueTitle(value)),
                        subtitle: widget.getValueSubtitle == null
                            ? null
                            : Text(widget.getValueSubtitle(value)),
                        // selected: selected,
                        trailing: selected
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.red,
                                  size: kButtonIconSize,
                                ),
                              )
                            : null,
                        dense: true,
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 8);
                },
              ),
              SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
