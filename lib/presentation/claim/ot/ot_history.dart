import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/response/claim/ot_overall_response.dart';
import 'package:etms/presentation/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/config/config.dart';
import '../../controllers/claim_controller.dart';

class OTHistoryView extends StatefulWidget {
  const OTHistoryView({super.key});

  @override
  State<OTHistoryView> createState() => _OTHistoryViewState();
}

class _OTHistoryViewState extends State<OTHistoryView> {
  ClaimController controller = Get.find();
  List<OtOverallResponse> dataList = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async{
    await controller.getOtOverallList();
    setState(() {
      dataList = controller.otOverallList;
      isLoading = false;
    });
  }

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
    return SafeArea(child: Scaffold(
      backgroundColor: ColorResources.secondaryBackground,
      appBar: MyAppBar(title: 'OT History'),
      body: dataList.isEmpty&&isLoading==false? Center(child: Text('There is no data.')):
      ListView.builder(
        shrinkWrap: true,
        itemCount: dataList.length,
          itemBuilder: (context,index){
            OtOverallResponse data = dataList[index];
            return Material(
              elevation: 1,
              color: ColorResources.secondary500,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(child: Text('You Worked Overtime', style: latoSemibold.copyWith(fontSize: 16),
                        )),
                        Text(DateTime.parse(data.attDat!).dMY().toString()).paddingOnly(left: 10)
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('From', style: latoSemibold,).paddingOnly(right: 10).paddingOnly(right: 10),
                            Text(DateFormat('hh:mm a').format(DateTime.parse(data.sTime!)).toString(),)
                          ],
                        ),
                        Row(
                          children: [
                            Text('To', style: latoSemibold,).paddingOnly(right: 10),
                            Text(DateFormat('hh:mm a').format(DateTime.parse(data.eTime!)).toString(),)
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text('OT Hour', style: latoSemibold,).paddingOnly(right: 10),
                        Text(data.oTHrs.toString())
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text('Rate', style: latoSemibold,).paddingOnly(right: 10),
                        Text(data.rate.toString())
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Remark', style: latoSemibold,).paddingOnly(right: 10),
                        Expanded(child: Text(data.remark??'-'))
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.only(left: 10,right: 10,top: 4,bottom: 4),
                        decoration: BoxDecoration(
                            color: generateColor(data.status.toString()),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Text(data.status.toString(),style: latoRegular.copyWith(
                            color: generateTextColor(data.status.toString())),
                        ),
                      ),
                    ),
                  ],
                ).paddingAll(10),
              ).paddingOnly(left: 10, right: 10, top: 10, bottom: 5),
            ).paddingOnly(bottom: 9);
          }).paddingAll(20)
    ));
  }
}
