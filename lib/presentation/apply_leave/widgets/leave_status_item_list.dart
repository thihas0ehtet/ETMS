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
    return
      Material(
        elevation: 1,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(text),
            Text(count)
          ],
        )
            .paddingOnly(left: 10,right: 10,top: 5,bottom: 5),
      ).paddingOnly(right: 6,bottom: 3, top: 3);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
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
    );
  }
}
