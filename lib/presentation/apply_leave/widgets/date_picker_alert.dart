import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../app/config/config.dart';

class MyAlertDialog extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?>? onCheckboxChanged;

  MyAlertDialog({
    required this.isChecked,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (context,setState){
          return  AlertDialog(
            content: Wrap(
              children: [
                SfDateRangePicker(
                  showNavigationArrow: true,
                  todayHighlightColor: ColorResources.primary500,
                  selectionColor: ColorResources.primary500,
                  selectionTextStyle: TextStyle(color: ColorResources.white),
                  headerHeight: 40,
                  showActionButtons: false,
                  selectionMode: DateRangePickerSelectionMode.single,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      // onChanged: onCheckboxChanged,
                      onChanged: (value){
                        print("VALUE IS $value");
                        setState(() {
                          isChecked!=!isChecked;
                        });
                      },
                    ),
                    Text(
                      '1st Half Leave',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: onCheckboxChanged,
                    ),
                    Text(
                      '2nd Half Leave',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        });
  }
}