import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/data/datasources/request/allowed_dates_data.dart';
import 'package:etms/data/datasources/request/leave_carry_data.dart';
import 'package:etms/data/datasources/response/leave_carry_response.dart';
import 'package:etms/presentation/apply_leave/widgets/leave_status_item_list.dart';
import 'package:etms/presentation/apply_leave/widgets/photo_attachement.dart';
import 'package:etms/presentation/controllers/leave_controller.dart';
import 'package:etms/presentation/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../../data/datasources/response/leave_list_response.dart';
import '../../data/datasources/response/leave_type_response.dart';

class LeaveView extends StatefulWidget {
  const LeaveView({super.key});

  @override
  State<LeaveView> createState() => _LeaveViewState();
}

class _LeaveViewState extends State<LeaveView> {
  String selectedLeaveType = '';
  // List<String> leaveTypeList = ['','Annual Leave', 'Child Care Leave', 'Sick Leave', 'No Pay Leave'];
  // List<String> leaveTypeList = [''];
  List<String> typeStringList = [''];
  List<LeaveTypeData> leaveTypeList=[];
  TextEditingController _remarkController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  LeaveController controller = Get.find();
  bool showGetDatesButton = false;
  List<LeaveReportDataResponse> leaveList = [];
  LeaveCarryResponse leaveCarry=LeaveCarryResponse();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.clearLeaveReportList();
    controller.clearLeaveCarry();
    getLeaveTypes();
  }

  getLeaveTypes() async{
    await controller.getLeaveTypes();
    setState(() {
      leaveTypeList.addAll(controller.leaveTypes);
      typeStringList.addAll(controller.leaveTypes.map((element) => element.leaveTypeName.toString()).toList());
    });

    // for(var i=0;i<controller.leaveTypes.length;i++){
    //   leaveTypeList.add(controller.leaveTypes[i].leaveTypeName.toString());
    // }
    // setState(() {
    //   leaveTypeList=controller.leaveTypes.value;
    // });
  }

  getAllowedDates() async {
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;
    String typeId = leaveTypeList[typeStringList.indexOf(selectedLeaveType)-1].leaveTypeID.toString();

    DateTime leaveStart = DateFormat('dd/MM/yyyy').parse(_startDateController.text);
    String formattedLeaveStart = DateFormat('dd MMM yyyy').format(leaveStart);

    DateTime leaveEnd = DateFormat('dd/MM/yyyy').parse(_endDateController.text);
    String formattedLeaveEnd = DateFormat('dd MMM yyyy').format(leaveEnd);

    print("KJFDJ IS $leaveStart and $formattedLeaveStart and $formattedLeaveEnd");

    AllowedDatesData data=AllowedDatesData(
        leaveStartDate: DateFormat('dd MMM yyyy').format(DateFormat('dd/MM/yyyy').parse(_startDateController.text)),
      leaveEndDate: DateFormat('dd MMM yyyy').format(DateFormat('dd/MM/yyyy').parse(_endDateController.text)),
      unitId: '1',
      leaveTypeId: typeId,
      empSysId: sysId
    );
    print("JFKDSJ KLIS ${data.toJson()}");
    await controller.getAllowedDates(data: data);
  }

  getLeaveCarry() async{
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;
    String typeId = leaveTypeList[typeStringList.indexOf(selectedLeaveType)-1].leaveTypeID.toString();
    String until = DateFormat('dd MMM yyyy').format(DateTime.now());
    LeaveCarryData data = LeaveCarryData(empSysId: sysId, leaveTypeId: typeId, unitl: until, leaveAppId: '0');
    await controller.getLeaveCarry(data: data);
    setState(() {
      leaveCarry=controller.leaveCarry.value;
    });
  }

  Widget statusItem(String count, String text){
    return  Column(
      children: [
        Text(count),
        Text(text)
      ],
    );
  }
  
  Widget datePick(TextEditingController controller){
    return  SizedBox(
      width: context.width/2.5,
      child: TextFormField(
          controller: controller,
          readOnly: true,
          style:  latoRegular,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
              hintText: "dd/MM/yyyy",
              hintStyle: latoRegular,
              errorStyle: latoRegular.copyWith(color: ColorResources.error),
              filled: true,
              fillColor: ColorResources.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: ColorResources.border)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: ColorResources.border)
              ),
              suffixIcon: Icon(Icons.calendar_month, color: ColorResources.black,)
          ),
          onTap: (){
            if(selectedLeaveType.isEmpty){
              'Please select leave type'.alert();
            }
            else{
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                        content: SizedBox(
                          height: 300,
                          child:
                          SfDateRangePicker(
                            todayHighlightColor: ColorResources.primary500,
                            selectionColor: ColorResources.primary500,
                            selectionTextStyle: TextStyle(color: ColorResources.white),
                            headerHeight: 40,
                            showActionButtons: true,
                            onCancel: (){
                              Navigator.pop(context);
                            },
                            onSubmit: (Object? value){
                              if(value is DateTime){
                                if(controller.text!=DateFormat('dd/MM/yyyy').format(value)){
                                  setState(() {
                                    controller.text=DateFormat('dd/MM/yyyy').format(value);
                                  });
                                  print(_startDateController.text);
                                  print(_endDateController.text);
                                  // DateTime parsedDate = DateFormat('dd/MM/yyyy').parseStrict(_startDateController.text);
                                  // print("PPPP $parsedDate");

                                  DateTime start = DateFormat('dd/MM/yyyy').parseStrict(_startDateController.text);
                                  DateTime end = DateFormat('dd/MM/yyyy').parseStrict(_endDateController.text);
                                  print("DNNN ");
                                  print(start);
                                  print(end);
                                  if(end.isBefore(start)){
                                    setState(() {
                                      showGetDatesButton=false;
                                    });
                                    'Please select the valid date range'.alert();
                                  }
                                  else{
                                    print("HELKJ LOOKK");
                                    setState(() {
                                      showGetDatesButton=true;
                                    });
                                  }
                                }
                              }
                              Navigator.pop(context);
                            },
                            selectionMode: DateRangePickerSelectionMode.single,
                          ),
                        )
                    );
                  });
            }
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Leave Type").paddingOnly(top: 20,bottom: 10),
              Container(
                decoration: BoxDecoration(
                    color: ColorResources.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Color(0xff475772))
                ),
                child: DropdownButton(
                    isExpanded: true,
                    value: selectedLeaveType,
                    underline: Container(),
                    icon: Icon(FeatherIcons.chevronDown, color: ColorResources.black,),
                    items: typeStringList.map((leaveType) {
                      return DropdownMenuItem<String>(
                        // enabled: township != leaveTypeList[0],
                        // enabled: true,
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
                      getLeaveCarry();
                    }),
              ),
              if(leaveCarry.balance!=null)
                // Text("HELKRJKLERJ"),
              LeaveStatusItemList(
                  carry: leaveCarry.leaveCarry!.toDouble(),
                  entitled: leaveCarry.entitled!.toDouble(),
                  additional: leaveCarry.leaveAdditional!.toDouble(),
                  forfeit: leaveCarry.leaveForfeit!.toDouble(),
                  taken: leaveCarry.leaveTaken!.toDouble(),
                  balance: leaveCarry.balance!.toDouble()),
                // LeaveStatusItemList(
                //     carry: leaveList[0].carry!,
                //     entitled: leaveList[0].entitled!,
                //     additional: leaveList[0].additional!,
                //     forfeit: leaveList[0].forfeit!,
                //     taken: leaveList[0].taken!,
                //     balance: leaveList[0].balance!),

              // if(selectedLeaveType!='')
              //   LeaveStatusItemList(
              //     carry: 1,
              //     forfeit: 3,
              //     entitled: 5,
              //     taken: 3,
              //     additional: 7,
              //     balance: 9,
              //   ).paddingOnly(top: 20, bottom: 10),
              if(selectedLeaveType.isNotEmpty && leaveTypeList[typeStringList.indexOf(selectedLeaveType)-1].leaveTypeID==2)
                PhotoAttachmentView(),
              // Text("${leaveTypeList}"),
              // if(leaveTypeList[typeStringList.indexOf(selectedLeaveType)-1].leaveTypeID==2)
              //   PhotoAttachmentView(),

              // if(selectedLeaveType.toLowerCase().contains('sick'))
              //   PhotoAttachmentView(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("From Date").paddingOnly(top: 20, bottom: 10),
                      datePick(_startDateController)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("To Date").paddingOnly(top: 20, bottom: 10),
                      datePick(_endDateController)
                    ],
                  )
                ],
              ),
             Text(showGetDatesButton.toString()),
             if( _startDateController.text.isNotEmpty && _endDateController.text.isNotEmpty && showGetDatesButton)
              CustomButton(
                  onTap: (){
                    getAllowedDates();
                  },
                  text: 'View All Half Leave Days').paddingOnly(top: 20,bottom: 10),
              Text("Remark").paddingOnly(top: 20, bottom: 10),
              SimpleTextFormField(
                  controller: _remarkController,
                  hintText: 'Why do you want to apply leave?',
                  validationText: '', maxLine: 5,).paddingOnly(bottom: 70),
            ],
          )
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CustomButton(onTap: (){}, text: 'Submit',).paddingOnly(bottom: 20)
        )
      ],
    );
  }
}