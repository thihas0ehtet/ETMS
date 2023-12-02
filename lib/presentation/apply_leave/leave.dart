import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/allowed_dates_data.dart';
import 'package:etms/data/datasources/request/leave_carry_data.dart';
import 'package:etms/data/datasources/response/apply_leave/leave_carry_response.dart';
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
import '../../data/datasources/response/apply_leave/leave_list_response.dart';
import '../../data/datasources/response/apply_leave/apply_leave_response.dart';

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
  DateTime selectedDate = DateTime.now();
  bool fromCheckFirstHalf = true;
  bool fromCheckSecondHalf = true;
  bool toCheckFirstHalf = true;
  bool toCheckSecondHalf = true;
  bool requireHalfLeaveSelect = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.clearLeaveReportList();
    controller.clearLeaveCarry();
    _startDateController.text=DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    _endDateController.text=DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
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
    int start = -1;
    if(fromCheckFirstHalf && fromCheckSecondHalf){
      start=2;
    } else if(fromCheckSecondHalf){
      start =1;
    } else if(fromCheckFirstHalf){
      start = 0;
    }

    int end = -1;
    if(toCheckFirstHalf && toCheckSecondHalf){
      end=2;
    } else if(toCheckSecondHalf){
      end =1;
    } else if(toCheckFirstHalf){
      end = 0;
    }

    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;
    String typeId = leaveTypeList[typeStringList.indexOf(selectedLeaveType)-1].leaveTypeID.toString();

    DateTime leaveStart = DateFormat('dd/MM/yyyy').parse(_startDateController.text);
    String formattedLeaveStart = DateFormat('dd MMM yyyy').format(leaveStart);
    DateTime leaveEnd = DateFormat('dd/MM/yyyy').parse(_endDateController.text);
    String formattedLeaveEnd = DateFormat('dd MMM yyyy').format(leaveEnd);

    AllowedDatesData data=AllowedDatesData(
        leaveStartDate: DateFormat('dd MMM yyyy').format(DateFormat('dd/MM/yyyy').parse(_startDateController.text)),
      leaveEndDate: DateFormat('dd MMM yyyy').format(DateFormat('dd/MM/yyyy').parse(_endDateController.text)),
      unitId: '1',
      leaveTypeId: typeId,
      empSysId: sysId
    );

    AllowedDatesData data1=AllowedDatesData(
        leaveStartDate: DateTime.parse(_startDateController.text).dMY(),
        leaveEndDate: DateTime.parse(_endDateController.text).dMY(),
        unitId: '1',
        leaveTypeId: typeId,
        empSysId: sysId
    );
    print("HELLO DAFJDFK JIS $data1 and $start and $end");
    // await controller.getAllowedDates(data: data, start: start, end: end);
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

  Widget showDatePickAlert({required dateController, required bool checkFirst, required bool checkSecond,
  required bool isFromDate}){
    String pickedDate=dateController.text;
    return StatefulBuilder(
        builder: (context,setState){
          return
            AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return
                  Wrap(
                    children: [
                      SfDateRangePicker(
                        showNavigationArrow: true,
                        todayHighlightColor: ColorResources.primary500,
                        selectionColor: ColorResources.primary500,
                        selectionTextStyle: TextStyle(color: ColorResources.white),
                        headerHeight: 40,
                        showActionButtons: false,
                        selectionMode: DateRangePickerSelectionMode.single,
                        onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
                          if (args.value is DateTime){
                            setState((){
                              pickedDate=DateFormat('dd/MM/yyyy').format(args.value);
                            });
                          }
                        },
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: checkFirst,
                            activeColor: ColorResources.primary800,
                            onChanged: (bool? value){
                              setState(() {
                                checkFirst=value!;
                              });
                            },
                          ),
                          Text(
                            '1st Half Leave',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: checkSecond,
                            activeColor: ColorResources.primary800,
                            onChanged: (value){
                              setState(() {
                                checkSecond=value!;
                              });
                            },
                          ),
                          Text(
                            '2nd Half Leave',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      if(requireHalfLeaveSelect)
                      Text('Please select half leave type', style: latoRegular.copyWith(color: ColorResources.error),
                      ).paddingOnly(top: 5,left: 5,bottom: 5)
                    ],
                  );
              }
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                      onTap: (){  Navigator.of(context).pop();},
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        decoration: BoxDecoration(
                            color: ColorResources.secondary700,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        // width: context.width/2,
                        child: Text('Cancel', textAlign: TextAlign.center,
                          style: latoRegular.copyWith(color: ColorResources.text50),),
                      )
                  ),
                  InkWell(
                      onTap: (){
                        // if use don't select one of these, show warning
                        if(!checkFirst && !checkSecond){
                          setState((){
                            requireHalfLeaveSelect=true;
                          });
                        } else{
                          if(isFromDate){
                            setState((){
                              fromCheckFirstHalf=checkFirst;
                              fromCheckSecondHalf=checkSecond;
                            });
                          } else{
                            setState((){
                              toCheckFirstHalf=checkFirst;
                              toCheckSecondHalf=checkSecond;
                            });
                          }
                          print("LJFDKLSJ LOOOOK $fromCheckFirstHalf and $fromCheckSecondHalf and $checkFirst and $checkSecond");

                          setState((){
                            dateController.text=pickedDate.toString();
                            requireHalfLeaveSelect=false;
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        width: 100,
                        // alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        // margin: EdgeInsets.only(left: 20,right: 20),
                        decoration: BoxDecoration(
                            color: ColorResources.primary800,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: ColorResources.border)
                        ),
                        // width: context.width/2,
                        child: Text('Confirm', textAlign: TextAlign.center, style: latoRegular.copyWith(color: ColorResources.text50),),
                      )
                  )
                ],
              )

              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              //   child: Text('Close'),
              // ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              //   child: Text('Close'),
              // ),
            ],
          );
        });
  }
  
  Widget datePick({required TextEditingController controller, required bool checkFirst, required bool checkSecond, required bool isFromDate}){
    return  SizedBox(
      width: context.width/2.5,
      child: TextFormField(
          controller: controller,
          readOnly: true,
          style:  latoRegular,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
              hintText: controller.text,
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
                builder: (BuildContext context) {
                  return showDatePickAlert(
                    dateController: controller,
                    checkFirst: checkFirst,
                    checkSecond: checkSecond,
                    isFromDate: isFromDate
                  );
                },
              );
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
                      datePick(controller: _startDateController,
                      checkFirst: fromCheckFirstHalf, checkSecond: fromCheckSecondHalf, isFromDate: true)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("To Date").paddingOnly(top: 20, bottom: 10),
                      datePick(controller: _endDateController,
                          checkFirst: toCheckFirstHalf, checkSecond: toCheckSecondHalf, isFromDate: false)
                    ],
                  )
                ],
              ),
             // Text(showGetDatesButton.toString()),
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