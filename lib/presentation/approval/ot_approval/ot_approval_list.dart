import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/response/approval/ot_approval_list_response.dart';
import 'package:etms/presentation/approval/ot_approval/ot_approval_detail.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/config/config.dart';
import '../../controllers/approval_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/filter_widget.dart';


class OTApprovalListView extends StatefulWidget {
  const OTApprovalListView({super.key});

  @override
  State<OTApprovalListView> createState() => _OTApprovalListViewState();
}

class _OTApprovalListViewState extends State<OTApprovalListView> {
  ApprovalController approvalController = Get.find();
  List<OTApprovalLevel2Response> list = [];
  DateTime filteredDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async{
    String startOfMonth = DateTime(filteredDate.year, filteredDate.month, 1).dMY().toString();
    await approvalController.getOtApprovalList(selectedDate: startOfMonth);
    setState(() {
      list = approvalController.otApprovalList;
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
    return
      Column(
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

                DateTime parsedMonth = DateFormat('yyyy / MMMM').parse(DateFormat('yyyy / MMMM').format(filteredDate).toString());
                DateTime startOfMonth = DateTime(parsedMonth.year, parsedMonth.month, 1);
                getData();
              },
              filteredDateWidget: Text(DateFormat('yyyy / MMMM').format(filteredDate),style: latoRegular,)
          ),
          Obx(() =>  approvalController.otApprovalListLoading.value?Center(child: Container(),)
              :list.isEmpty?Center(child: Text('There is no data.')).paddingOnly(top: 30):
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index){
                OTApprovalLevel2Response data = list[index];
                return GestureDetector(
                  child: Card(
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(FeatherIcons.user, color: ColorResources.primary500, size: 18,).paddingOnly(right: 10),
                                    Text(data.eMPNAME.toString(), style: latoMedium.copyWith(fontSize: 15),),
                                  ],
                                ),
                                Flexible(child: Text(DateTime.parse(data.attDat.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                              ],
                            ).paddingOnly(bottom: 10),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('From', style: latoSemibold,).paddingOnly(right: 10),
                                Flexible(child: Text(DateTime.parse(data.oTSTime.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                              ],).paddingOnly(bottom: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(child: Text('To', style: latoSemibold,).paddingOnly(right: 10)),
                                Flexible(child: Text(DateTime.parse(data.oTETime.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                              ],
                            ).paddingOnly(bottom: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(child: Text('OT Hour', style: latoSemibold,).paddingOnly(right: 10)),
                                Flexible(child: Text(data.oTHrs.toString(), style: latoRegular.copyWith(fontSize: 14),)),
                              ],
                            ).paddingOnly(bottom: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('Rate', style: latoSemibold,).paddingOnly(right: 10),
                                    Text(data.oTRatCas.toString(), style: latoRegular.copyWith(fontSize: 14),),
                                  ],
                                ),
                                CustomButton(
                                    width: 100,
                                    paddingTop: 7,
                                    paddingBottom: 7,
                                    onTap: (){
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: ColorResources.white,
                                          context: context,
                                          elevation: 10,
                                          useSafeArea: true,
                                          builder: (BuildContext context){
                                            return OTApprovalDetailView(data: data, selectedDate: DateTime(filteredDate.year, filteredDate.month, 1).dMY().toString(),);
                                          });
                                    },
                                    text: 'Check')
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                );
              },
            ),
          )
          )
        ],
      );
  }
}
