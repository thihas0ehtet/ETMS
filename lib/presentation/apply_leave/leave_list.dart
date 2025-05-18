import 'package:etms/app/config/config.dart';
import 'package:etms/data/datasources/request/leave/leave_report_data.dart';
import 'package:etms/data/datasources/response/apply_leave/apply_leave_response.dart';
import 'package:etms/presentation/apply_leave/widgets/leave_status_item_list.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/datasources/shared_preference_helper.dart';
import '../controllers/leave_controller.dart';
import '../widgets/custom_button.dart';

class LeaveListView extends StatefulWidget {
  const LeaveListView({super.key});

  @override
  State<LeaveListView> createState() => _LeaveListViewState();
}

class _LeaveListViewState extends State<LeaveListView> {
  String selectedLeaveType = '';
  List<String> typeStringList = [''];
  List<LeaveTypeData> leaveTypeList=[];
  String selectedYear = DateTime.now().year.toString();
  List<String>? yearList=['2008'];
  LeaveController controller = Get.find();
  bool filledAllData = true;
  List<LeaveReportDataResponse> leaveList = [];

  @override
  void initState() {
    for(var i=2001;i<=DateTime.now().year;i++){
      yearList!.add(i.toString());
    }
    super.initState();
    controller.clearLeaveReportList();
    getLeaveTypes();
  }

  getLeaveTypes() async{
    await controller.getLeaveTypes();
    setState(() {
      leaveTypeList.addAll(controller.leaveTypes);
      typeStringList.addAll(controller.leaveTypes.map((element) => element.leaveTypeName.toString()).toList());
    });
  }

  getLeaveReportList() async{
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;
    String typeId = leaveTypeList[typeStringList.indexOf(selectedLeaveType)-1].leaveTypeID.toString();
    LeaveReportData leaveReportData=LeaveReportData(
        emp_sys_id: sysId,
        ltype: typeId,
        leaveyear: selectedYear,
        active: 'A',
        uid: '1',
        unit_id: '0'
    );
    await controller.getLeaveReportList(data: leaveReportData);
    setState(() {
      leaveList=controller.leaveReportList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Please Select Year & Leave Type', style: latoMedium.copyWith(fontSize: 17),).paddingOnly(top: 20, bottom: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: context.width/2-30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Year").paddingOnly(bottom: 10),
                    Container(
                      decoration: BoxDecoration(
                          color: ColorResources.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Color(0xff475772))
                      ),
                      child: DropdownButton(
                          dropdownColor: ColorResources.white,
                          isExpanded: true,
                          value: selectedYear,
                          underline: Container(),
                          icon: Icon(FeatherIcons.chevronDown, color: ColorResources.black,),
                          items: yearList!.map((year) {
                            return DropdownMenuItem<String>(
                              // enabled: township != leaveTypeList[0],
                              // enabled: true,
                              value: year,
                              child: Text(year,
                                style: latoRegular.copyWith(color: selectedLeaveType==''
                                    ? ColorResources.text300
                                    : ColorResources.text500),).paddingOnly(left: 14),
                            );
                          }).toList(),
                          onChanged: (dynamic value) {
                            if (value != selectedYear) {
                              setState(() {
                                selectedYear = value!;
                              });
                            }
                          }),
                    ).paddingOnly(bottom: 20),
                  ],
                ),
              ),
              SizedBox(
                width: context.width/2-30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Leave Type").paddingOnly(bottom: 10),
                    Container(
                      decoration: BoxDecoration(
                          color: ColorResources.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Color(0xff475772))
                      ),
                      child: DropdownButton(
                          dropdownColor: ColorResources.white,
                          isExpanded: true,
                          value: selectedLeaveType,
                          underline: Container(),
                          icon: Icon(FeatherIcons.chevronDown, color: ColorResources.black,),
                          items: typeStringList.map((leaveType) {
                            return DropdownMenuItem<String>(
                              value: leaveType,
                              child: Text(leaveType.toString()==''?'Select Leave Type':leaveType.toString(),
                                style: latoRegular.copyWith(color: selectedLeaveType==''
                                    ? ColorResources.text300
                                    : ColorResources.text500),).paddingOnly(left: 14),
                            );
                          }).toList(),
                          onChanged: (dynamic value) {
                            if (value != selectedLeaveType) {
                              setState(() {
                                selectedLeaveType = value!;
                              });
                            }
                          }),
                    ),
                    if(filledAllData==false)
                      Text('Please Select Leave Type',style: latoRegular.copyWith(color: ColorResources.error),),
                  ],
                ),
              )
            ],
          ),
          CustomButton(
            onTap: (){
              if(selectedLeaveType.isEmpty){
                setState(() {
                  filledAllData=false;
                });
              }
              else{
                setState(() {
                  filledAllData=true;
                });
                getLeaveReportList();
              }
            },
            text: 'View Leave List',).paddingOnly(top:10),
          leaveList.isNotEmpty?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Showing ${selectedLeaveType} Reports in $selectedYear').paddingOnly(top: 20,bottom: 15),
                  LeaveStatusItemList(
                      carry: leaveList[0].carry!,
                      entitled: leaveList[0].entitled!,
                      additional: leaveList[0].additional!,
                      forfeit: leaveList[0].forfeit!,
                      taken: leaveList[0].taken!,
                      balance: leaveList[0].balance!).paddingOnly(bottom: 15),
                  Container(
                    height: 40,
                    color: ColorResources.primary200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Date'),
                        Text('Duration')
                      ],
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: leaveList.length,
                      itemBuilder: (context,index){
                        return
                          leaveList[index].leaveDate.toString()!="null"?
                          Container(
                            height: 40,
                            color: index%2==0?ColorResources.secondary500:ColorResources.primary50,
                            child:   Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(leaveList[index].leaveDate.toString())).toString()),
                                Text(leaveList[index].duration.toString())
                              ],
                            ),
                          ):Container(
                            height: 40,
                            color: index%2==0?ColorResources.secondary500:ColorResources.primary50,
                            child:   Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('-'),
                                Text('-')
                              ],
                            ),
                          )
                        ;
                      }),
                ],
              ).paddingOnly(bottom: 20):Container(),

        ],
      ),
    );
  }
}
