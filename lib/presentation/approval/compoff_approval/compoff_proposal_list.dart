import 'package:etms/app/utils/dateTime_format.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/config.dart';
import '../../../data/datasources/response/approval/comp_approval_data_response.dart';
import '../../controllers/approval_controller.dart';
import '../../widgets/custom_button.dart';

class CompOffRequestListView extends StatefulWidget {
  const CompOffRequestListView({super.key});

  @override
  State<CompOffRequestListView> createState() => _CompOffRequestListViewState();
}

class _CompOffRequestListViewState extends State<CompOffRequestListView> {
  ApprovalController approvalController = Get.find();
  List<CompApprovalDataResponse> list = [];
  DateTime filteredDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async{
    await approvalController.getCompOffApprovalList();
    setState(() {
      list = approvalController.compOffApprovalList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Obx(() =>  approvalController.compOffRequestListLoading.value?Center(child: Container(),)
          :list.isEmpty?Center(child: Text('There is no data.')).paddingOnly(top: 30):
      Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index){
            CompApprovalDataResponse data = list[index];
            return GestureDetector(
              child: Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    // side: BorderSide(color: Colors.white, width: 0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // decoration: BoxDecoration(
                  //   color: ColorResources.white,
                  // ),
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
                                Text(data.empName.toString(), style: latoMedium.copyWith(fontSize: 15),),
                              ],
                            ),
                            Flexible(child: Text(DateTime.parse(data.requestedTime.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                          ],
                        ).paddingOnly(bottom: 10),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(child: Text('Worked Date', style: latoSemibold,).paddingOnly(right: 10)),
                            Flexible(child: Text(DateTime.parse(data.attDat.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                          ],
                        ).paddingOnly(bottom: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('Duration', style: latoSemibold,).paddingOnly(right: 10),
                                Text(data.duration.toString(), style: latoRegular.copyWith(fontSize: 14),),
                              ],
                            ),
                            CustomButton(
                                width: 100,
                                paddingTop: 7,
                                paddingBottom: 7,
                                onTap: ()=>{},
                                text: 'Check')
                          ],
                        ),
                      ],
                    ),
                  )
                // .paddingOnly(left: 10, right: 10, top: 10, bottom: 10),
              ),
            );
          },
        ),
      ));
  }
}
