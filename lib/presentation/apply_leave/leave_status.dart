import 'package:etms/app/config/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../widgets/filter_widget.dart';

class LeaveStatusView extends StatefulWidget {
  const LeaveStatusView({super.key});

  @override
  State<LeaveStatusView> createState() => _LeaveStatusViewState();
}

class _LeaveStatusViewState extends State<LeaveStatusView> {
  DateTime filteredDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          FilterWidget(
              onDateTimeChanged: (DateTime newDate){
                setState(() {
                  _selectedDate = newDate;
                });
              },
              onFilterConfirm: (){
                setState(() {
                  filteredDate=_selectedDate;
                });
                Navigator.pop(context);
              },
              filteredDateWidget: Text(DateFormat('yyyy / MMMM').format(filteredDate),style: latoRegular,)
          ).paddingOnly(left: 20,right: 20, top: 20),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
              itemBuilder: (context,index){
            return Container(
                color: ColorResources.white,
                child:
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sick Leave', style: latoSemibold.copyWith(fontSize: 15),).paddingOnly(bottom: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('From', style: latoMedium,).paddingOnly(right: 8),
                                Column(
                                  children: [
                                    Text('26/9/23', style: latoRegular,),
                                    Text('(Evening-half)',
                                      style: latoRegular.copyWith(color: ColorResources.primary500),)
                                  ],
                                ).paddingOnly(right: 20),
                                Text('To', style: latoMedium,).paddingOnly(right: 8),
                                Column(
                                  children: [
                                    Text('27/9/23',style: latoRegular,),
                                    Text('(Evening-half)',
                                      style: latoRegular.copyWith(color: ColorResources.primary500),)
                                  ],
                                ),
                              ],
                            )

                          ],
                        ).paddingOnly(right: 10),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(left: 10,right: 10,top: 4,bottom: 4),
                            decoration: BoxDecoration(
                                color: ColorResources.green,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Text('Approved',style: latoRegular.copyWith(color: ColorResources.white),),
                          ),
                        )
                      ],
                    ).paddingOnly(left: 20, right: 20, top: 10,bottom: 5),
                    if(index!=4)
                    Divider(color: ColorResources.border,)
                    else
                      SizedBox(height: 10,)
                  ],
                )
            );
          }).paddingOnly(top: 7)
        ],
      ),
    );
  }
}
