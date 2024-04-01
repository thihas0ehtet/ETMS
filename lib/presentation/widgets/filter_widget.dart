import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app/config/config.dart';

typedef void OnChangeDateTime(DateTime newDate);

class FilterWidget extends StatefulWidget {
  OnChangeDateTime onDateTimeChanged;
  VoidCallback onFilterConfirm;
  Widget filteredDateWidget;
  FilterWidget({super.key, required this.onDateTimeChanged, required this.onFilterConfirm, required this.filteredDateWidget});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: ColorResources.white,
                context: context,
                elevation: 10,
                builder: (BuildContext context){
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: (){Navigator.pop(context);},
                                  child: SvgPicture.asset('assets/images/back.svg',width: 20,height: 20),
                                ).paddingOnly(right: 10),
                                Text('Filter')
                              ],
                            ),
                            TextButton(
                              onPressed:()=>widget.onFilterConfirm(),
                                child: Text('Done',
                                  style: latoSemibold.copyWith(color: ColorResources.primary600),)
                            )
                          ],
                        ).paddingAll(10),
                        Container(
                          color: Colors.white,
                          height: 150,
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                  dateTimePickerTextStyle: latoRegular
                              ),
                            ),
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.monthYear,
                              initialDateTime: DateTime.now(),
                              minimumYear: 2008,
                              maximumYear: DateTime.now().year,
                              dateOrder: DatePickerDateOrder.ymd,
                              onDateTimeChanged:(DateTime newDate)=>widget.onDateTimeChanged(newDate),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
            );
          },
          child: Container(
              padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
              decoration: BoxDecoration(
                  color: ColorResources.white,
                  border: Border.all(color: ColorResources.primary500),
                  borderRadius: BorderRadius.all(Radius.circular(4))
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FeatherIcons.sliders, color: ColorResources.black, size: 20,).paddingOnly(right: 10),
                  Text('Filter',style: latoRegular,)
                ],
              )
          ),
        ).paddingOnly(right: 12),
        widget.filteredDateWidget
        // Text(DateFormat('yyyy / MMMM').format(filteredDate),style: latoRegular,)
      ],
    );
  }
}
