import 'package:etms/app/utils/dateTime_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/config.dart';
import '../../../data/datasources/response/apply_leave/leave_status_response.dart';

class LeaveStatusList extends StatelessWidget {
  List<LeaveStatusResponse> list;
  LeaveStatusList({super.key, required this.list});

  Color generateColor(String text){
    if(text.toLowerCase()=='pending'){
      return ColorResources.yellow;
    }
    else if(text.toLowerCase().contains('reject')){
      return ColorResources.red;
    }
    return ColorResources.green;
  }

  Color generateTextColor(String text){
    if(text.toLowerCase()=='pending'){
      return Colors.black;
    }
    return ColorResources.white;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context,index){
          LeaveStatusResponse data = list[index];
          return Container(
              color: ColorResources.white,
              child:
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.leaveTypeName.toString(),
                              softWrap: true,
                              // overflow: TextOverflow.ellipsis,
                              style: latoSemibold.copyWith(fontSize: 15),
                            ).paddingOnly(bottom: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(DateTime.parse(data.leaveDate.toString()).dMYE().toString()),
                                SizedBox(width: 5,),
                              ],
                            ).paddingOnly(bottom: 5),
                            Text('(${data.halfType})',
                              style: latoRegular.copyWith(color: ColorResources.primary500),)
                            // Text('(Evening-half)',
                            //   style: latoRegular.copyWith(color: ColorResources.primary500),)

                          ],
                        ).paddingOnly(right: 10),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10,right: 10,top: 4,bottom: 4),
                          decoration: BoxDecoration(
                              color: generateColor(data.status.toString()),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Text(data.status.toString(),style: latoRegular.copyWith(color: generateTextColor(data.status.toString())),),
                        ),
                    ],
                  ).paddingOnly(left: 20, right: 20, top: 10,bottom: 5),
                  // if(index!=4)
                  Divider(color: ColorResources.border,)
                  // else
                  //   SizedBox(height: 10,)
                ],
              )
          );
        });
  }
}
