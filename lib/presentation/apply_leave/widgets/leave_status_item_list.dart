import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveStatusItemList extends StatelessWidget {
  double carry;
  double entitled;
  double additional;
  double forfeit;
  double taken;
  double balance;
  LeaveStatusItemList({super.key, required this.carry, required this.entitled, required this.additional,
  required this.forfeit, required this.taken, required this.balance});

  Widget statusItem(String count, String text){
    return  Card(
      elevation: 1,
      color: Colors.white,
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.all(Radius.circular(5)),
      //     border: Border.all(color: ColorResources.border)
      // ),
      child: Container(
        // width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(text),
            Text(count)
            // Container(
            //     padding: EdgeInsets.only(left: 22, right: 22),
            //     child: Text(leaveList[0].carry.toString()))
          ],
        )
            .paddingOnly(left: 10,right: 10,top: 5,bottom: 5),
      ),
    );
    //   Column(
    //   children: [
    //     Text(count),
    //     Text(text)
    //   ],
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          statusItem(carry.toString(),'Carry'),
          statusItem(forfeit.toString(),'Forfeit'),
          statusItem(entitled.toString(),'Entitled'),
          statusItem(taken.toString(),'Taken'),
          statusItem(additional.toString(),'Additional'),
          statusItem(balance.toString(),'Balance'),
        ],
      ),
    )
    //   Card(
    //     elevation: 2,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       children: [
    //         Column(
    //           children: [
    //             statusItem(carry.toString(),'Carry').paddingOnly(bottom: 20),
    //             statusItem(forfeit.toString(),'Forfeit'),
    //           ],
    //         ),
    //         Column(
    //           children: [
    //             statusItem(entitled.toString(),'Entitled').paddingOnly(bottom: 20),
    //             statusItem(taken.toString(),'Taken'),
    //           ],
    //         ),
    //         Column(
    //           children: [
    //             statusItem(additional.toString(),'Additional').paddingOnly(bottom: 20),
    //             statusItem(balance.toString(),'Balance'),
    //           ],
    //         )
    //       ],
    //     ).paddingOnly(top: 10,bottom: 10)
    // )
    ;
  }
}
