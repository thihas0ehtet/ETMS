import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/presentation/controllers/claim_controller.dart';
import 'package:etms/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/config/color_resources.dart';
import '../../../app/config/font_family.dart';
import '../../../data/datasources/response/claim/claim_history_response.dart';

class OtherClaimHistoryView extends StatefulWidget {
  const OtherClaimHistoryView({super.key});

  @override
  State<OtherClaimHistoryView> createState() => _OtherClaimHistoryViewState();
}

class _OtherClaimHistoryViewState extends State<OtherClaimHistoryView> {
  ClaimController controller = Get.find();
  DateTime _selectedDate = DateTime.now();
  DateTime filteredDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(DateFormat('yyyy / MMMM').format(DateTime.now()));
  }

  getData(String inputDate) async{
    DateTime parsedMonth = DateFormat('yyyy / MMMM').parse(inputDate);
    DateTime startOfMonth = DateTime(parsedMonth.year, parsedMonth.month, 1);
    await controller.getClaimHistory(selectedDate: startOfMonth.dMY()!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorResources.white,
          appBar: MyAppBar(title: 'Other Claim History'),
          body: Column(
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
                    getData(DateFormat('yyyy / MMMM').format(filteredDate).toString());
                  },
                  filteredDateWidget: Text(DateFormat('yyyy / MMMM').format(filteredDate),style: latoRegular,)
              ).paddingOnly(left: 20,right: 20, top: 20),
              Obx(() => controller.claimHistoryLoading.value? Container():
              controller.claimHistory.isEmpty?
              Center(child: Text('There is no data.')).paddingOnly(top: 30):
              Expanded(
                  child: ListView.builder(
                      itemCount: controller.claimHistory.length,
                      itemBuilder: (context, index){
                        ClaimHistoryResponse data = controller.claimHistory[index];
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
                                    Flexible(child: Text(data.claimGroup!, style: latoSemibold)),
                                    Text(DateTime.parse(data.receiptDate!).dMY().toString()).paddingOnly(left: 10)
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(child: Text('Claim Name', style: latoSemibold)),
                                    Text(data.claim!).paddingOnly(left: 10)
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(child: Text('Amount', style: latoSemibold)),
                                    Text(data.amount.toString()).paddingOnly(left: 10)
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Status', style: latoSemibold,),
                                    Text(data.status.toString()).paddingOnly(left: 10)
                                  ],
                                ),
                              ],
                            ).paddingAll(10),
                          ).paddingOnly(left: 10, right: 10, top: 10, bottom: 5),
                        ).paddingOnly(bottom: 9);
                      }).paddingAll(20)
              ))
            ],
          ),
        ));
  }
}
