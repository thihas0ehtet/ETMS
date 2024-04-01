import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/leave/leave_status_data.dart';
import 'package:etms/presentation/apply_leave/widgets/leave_status_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../../data/datasources/response/apply_leave/leave_status_response.dart';
import '../controllers/leave_controller.dart';
import '../widgets/filter_widget.dart';

class LeaveStatusView extends StatefulWidget {
  const LeaveStatusView({super.key});

  @override
  State<LeaveStatusView> createState() => _LeaveStatusViewState();
}

class _LeaveStatusViewState extends State<LeaveStatusView> {
  LeaveController controller = Get.find();

  DateTime filteredDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  List<LeaveStatusResponse> statusDetailList = [];
  List<LeaveStatusResponse> statusFirstList = [];
  List<LeaveStatusResponse> statusSecondList = [];


  @override
  void initState() {
    super.initState();
    getData(DateFormat('yyyy / MMMM').format(DateTime.now()));
  }

  getData(String inputDate) async{
    DateTime parsedMonth = DateFormat('yyyy / MMMM').parse(inputDate);
    DateTime startOfMonth = DateTime(parsedMonth.year, parsedMonth.month, 1);

    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;
    LeaveStatusData leaveStatusData = LeaveStatusData(
      empSysId: sysId,
      selectDate: startOfMonth.dMY()
    );

    await controller.getLeaveStatusList(data: leaveStatusData);
    setState(() {
      statusDetailList=controller.statusDetailList;
      statusFirstList=controller.statusFirstList;
      statusSecondList=controller.statusSecondList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
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
              getData(DateFormat('yyyy / MMMM').format(filteredDate).toString());
            },
            filteredDateWidget: Text(DateFormat('yyyy / MMMM').format(filteredDate),style: latoRegular,)
        ).paddingOnly(left: 20,right: 20, top: 20),
        SizedBox(height: 10),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              if(statusDetailList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
                    Text('Reviewed Leave', style: latoSemibold.copyWith(fontSize: 15, color: ColorResources.green),).paddingOnly(left: 10),
                    SizedBox(height: 10,),
                    LeaveStatusList(list: statusDetailList),
                    SizedBox(height: 20,)
                  ],
                ),
              // LeaveStatusList(list: statusDetailList),
              if(statusDetailList.isEmpty && statusFirstList.isEmpty && statusSecondList.isEmpty && controller.isStatusListLoading==false)
              Center(child: Text('There is no data.')).paddingOnly(top: 30),
              if(statusFirstList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
                    Text('Pending Leave (First Person Approval)', style: latoSemibold.copyWith(fontSize: 15, color: ColorResources.green),).paddingOnly(left: 10),
                    SizedBox(height: 10,),
                    LeaveStatusList(list: statusFirstList),
                    SizedBox(height: 20,)
                  ],
                ),
              if(statusSecondList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
                    Text('Pending Leave (Second Person Approval)', style: latoSemibold.copyWith(fontSize: 15, color: ColorResources.green),).paddingOnly(left: 10),
                    SizedBox(height: 10,),
                    LeaveStatusList(list: statusSecondList),
                    SizedBox(height: 20,)
                  ],
                ),
            ],
          ),
        )

      ],
    );
  }
}
