import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/leave/allowed_dates_data.dart';
import 'package:etms/data/datasources/request/leave/leave_carry_data.dart';
import 'package:etms/presentation/apply_leave/widgets/leave_status_item_list.dart';
import 'package:etms/presentation/apply_leave/widgets/photo_attachement.dart';
import 'package:etms/presentation/controllers/leave_controller.dart';
import 'package:etms/presentation/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../../data/datasources/request/apply_leave/apply_leave_data.dart';
import '../../data/datasources/response/allowed_date_response.dart';
import '../../data/datasources/response/apply_leave/apply_leave_response.dart';

class LeaveView extends StatefulWidget {
  const LeaveView({super.key});

  @override
  State<LeaveView> createState() => _LeaveViewState();
}

class _LeaveViewState extends State<LeaveView> {
  String selectedLeaveType = '';
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
  List<AllowedDateResponse> dateList = [];
  List<AllowedDateResponse> dateDetailList = [];
  double sumOfDates = 0.0;
  bool isExpanded=true;
  var attachmentStateKey = GlobalKey<PhotoAttachmentViewState>();

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

    AllowedDatesData data=AllowedDatesData(
        leaveStartDate: DateFormat('dd/MM/yyyy').parse(_startDateController.text).dMY(),
        leaveEndDate: DateFormat('dd/MM/yyyy').parse(_endDateController.text).dMY(),
        unitId: '1',
        leaveTypeId: typeId,
        empSysId: sysId
    );
    await controller.getAllowedDates(data: data, start: start, end: end);
    setState(() {
      dateList = controller.allowedDateList;
      dateDetailList = controller.allowedDateDetail;
    });
    double sum = 0.0;
    for(var i =0 ;i<dateList.length;i++){
      sum+=dateList[i].duration!.toDouble();
    }
    setState(() {
      sumOfDates = sum;
    });
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

  setData(bool fromData, bool toData){
    setState(() {
      fromData=toData;
    });
  }

  Widget showDatePickAlert({required dateController, required bool checkFirst, required bool checkSecond,
  required bool isFromDate}){
    String pickedDate=dateController.text;
    return AlertDialog(
        backgroundColor: ColorResources.white,
        surfaceTintColor: ColorResources.white,
        content: StatefulBuilder(
          builder: (context,setState){
            return Wrap(
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
                      checkColor: ColorResources.white,
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
                      checkColor: ColorResources.white,
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
                  ).paddingOnly(top: 5,left: 5,bottom: 5),

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
                          child: Text('Cancel', textAlign: TextAlign.center,
                            style: latoRegular.copyWith(color: ColorResources.text50),),
                        )
                    ),
                    InkWell(
                        onTap: (){
                          if(!checkFirst && !checkSecond){
                            setState((){
                              requireHalfLeaveSelect=true;
                            });
                          } else{
                            if(isFromDate){
                              setData(fromCheckFirstHalf, checkFirst);
                              setData(fromCheckSecondHalf, checkSecond);
                              setState((){
                                fromCheckFirstHalf=checkFirst;
                                fromCheckSecondHalf=checkSecond;
                              });
                            } else{
                              setData(toCheckFirstHalf, checkFirst);
                              setData(toCheckSecondHalf, checkSecond);
                              setState((){
                                toCheckFirstHalf=checkFirst;
                                toCheckSecondHalf=checkSecond;
                              });
                            }setState((){
                              dateController.text=pickedDate.toString();
                              requireHalfLeaveSelect=false;
                            });
                             // check to date and work api automatically
                            if(isFromDate!=true){
                              DateTime start = DateFormat('dd/MM/yyyy').parseStrict(_startDateController.text);
                              DateTime end = DateFormat('dd/MM/yyyy').parseStrict(_endDateController.text);
                              if(end.isBefore(start)){
                                'Please select the valid date range'.alert();
                              }
                              else{
                                getAllowedDates();

                                Navigator.of(context).pop();
                              }
                            } else{
                              DateTime start = DateFormat('dd/MM/yyyy').parseStrict(_startDateController.text);
                              DateTime end = DateFormat('dd/MM/yyyy').parseStrict(_endDateController.text);
                              if(start.isBefore(end)){
                                getAllowedDates();
                              }
                              Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                            }
                          }
                        },
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          // margin: EdgeInsets.only(left: 20,right: 20),
                          decoration: BoxDecoration(
                              color: ColorResources.primary800,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: ColorResources.border)
                          ),
                          child: Text('Confirm', textAlign: TextAlign.center, style: latoRegular.copyWith(color: ColorResources.text50),),
                        )
                    )
                  ],
                )
              ],
            );
          },
        )
    );
  }

  resetData(){
    _remarkController.clear();
    _startDateController.clear();
    _endDateController.clear();
    selectedLeaveType=='';
    dateList.clear();
    attachmentStateKey.currentState!.clearImageFile();
    _startDateController.text=DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    _endDateController.text=DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    setState(() {});
    getLeaveCarry();
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
              suffixIcon: Container(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: SvgPicture.asset('assets/images/date picker.svg'))
          ),
          onTap: (){
            if(selectedLeaveType.isEmpty){
              'Please select leave type'.alert();
            }
            else{
              showDialog(
                context: context,
                builder: (context) {
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
              LeaveStatusItemList(
                  carry: leaveCarry.leaveCarry!.toDouble(),
                  entitled: leaveCarry.entitled!.toDouble(),
                  additional: leaveCarry.leaveAdditional!.toDouble(),
                  forfeit: leaveCarry.leaveForfeit!.toDouble(),
                  taken: leaveCarry.leaveTaken!.toDouble(),
                  balance: leaveCarry.balance!.toDouble()).paddingOnly(top: 10,bottom: 5),
              if(selectedLeaveType.isNotEmpty && leaveTypeList[typeStringList.indexOf(selectedLeaveType)-1].fileUploadable==true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PhotoAttachmentView(key: attachmentStateKey,),
                  ],
                ),
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
             if(dateList.isNotEmpty)
               Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Total Leaves $sumOfDates Days'),
                       GestureDetector(
                         onTap: () {
                           setState(() {
                             isExpanded=!isExpanded;
                           });
                         },
                         child: Row(
                           children: [
                             Text('More Detail',style: latoRegular.copyWith(color: ColorResources.primary500),),
                             Icon(isExpanded?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up, color: ColorResources.primary500,)
                           ],
                         ),
                       ),
                     ],
                   ),
                   if(!isExpanded)
                   SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     child: FittedBox(
                       child: DataTable(
                         columnSpacing: 10,
                         headingRowColor:   MaterialStateColor.resolveWith((states) => ColorResources.primary200),
                         columns: <DataColumn>[
                           DataColumn(
                             label: Expanded(
                               child: Text(
                                 'Date',
                                 textAlign: TextAlign.center,
                                 style: latoRegular,
                               ),
                             ),
                           ),
                           DataColumn(
                             label: Expanded(
                               child: Text(
                                 'Day',
                                 textAlign: TextAlign.center,
                                 style: latoRegular,
                               ),
                             ),
                           ),
                           DataColumn(
                             label: Flexible(
                               child: Text(
                                 'Leave Type',
                                 textAlign: TextAlign.center,
                                 style: latoRegular,
                               ),
                             ),
                           ),
                           DataColumn(
                             label: Expanded(
                               child: Text(
                                 'Duration',
                                 textAlign: TextAlign.center,
                                 style: latoRegular,
                               ),
                             ),
                           ),
                         ],
                         rows:
                         List.generate(
                             dateDetailList.length,
                                 (index) =>
                             DataRow(
                               color: MaterialStateProperty.all<Color>(index%2==0?ColorResources.white:ColorResources.primary50),
                               cells: <DataCell>[
                                 DataCell(
                                     Center(
                                         child: Text(DateTime.parse(dateDetailList[index].leaveDate.toString()).dMY().toString(),
                                             style: latoRegular))),
                                 DataCell(
                                     Center(
                                         child: Text(dateDetailList[index].days.toString(), style: latoRegular))),
                                 DataCell(
                                     Center(
                                         child: Text(dateDetailList[index].halfType.toString(),style: latoRegular))),
                                 DataCell(
                                     Center(
                                         child: Text(dateDetailList[index].duration.toString(),style: latoRegular)))
                               ],
                             )
                         ),
                       ),
                     ).paddingOnly(top: 10),
                   ),
                 ],
               ).paddingOnly(top: 20),
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
          child: CustomButton(onTap: () async {
            if(sumOfDates>0){
              String typeId = leaveTypeList[typeStringList.indexOf(selectedLeaveType)-1].leaveTypeID.toString();
              List<LeaveProposalDetail> detailList=[];
              detailList.addAll(
                  dateList.map((element) =>
                  LeaveProposalDetail(
                    leaveProposeDetailID: element.leaveApplicationDetailID,
                    leaveProposeID: element.leaveAppID,
                    leaveTypeID: typeId,
                    leaveDate: element.leaveDate,
                    leaveAMPM: element.leaveAMPM,
                    leaveDuration: element.duration,
                    leaveStatus: 0,
                    leaveStatus2: 0)
                  ).toList());

              SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
              String sysId= await _sharedPrefs.getEmpSysId;
              ApplyLeaveData data = ApplyLeaveData(
                leaveProposeID: 1,
                empSysID: sysId,
                leaveStartDate: DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSZ').format(DateTime.parse(DateFormat('dd/MM/yyyy').parse(_startDateController.text).toString())).toString(),
                leaveEndDate: DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSZ').format(DateTime.parse(DateFormat('dd/MM/yyyy').parse(_endDateController.text).toString())).toString(),
                duration: sumOfDates,
                notifiedTo: 2,
                notifiedTo2: null,
                leaveProposeDate: DateTime.now().toString(),
                remark: _remarkController.text,
                leaveTypeId: typeId,
                leaveProposalDetail: detailList
              );
              if(sumOfDates>leaveCarry.balance!.toDouble()){
                'You have only ${leaveCarry.balance} days left for carry forward.'.error();
              } else{
                if(selectedLeaveType.isNotEmpty && leaveTypeList[typeStringList.indexOf(selectedLeaveType)-1].fileUploadable==true){
                  if(attachmentStateKey.currentState!.getImageFile()==null){
                    'Please take the attachment photo'.error();
                  } else{
                    bool success = await controller.saveLeaveApplication(data: data, imageFile: attachmentStateKey.currentState!.getImageFile());
                    if(success){
                      resetData();
                    }
                  }

                } else{
                  bool success = await controller.saveLeaveApplication(data: data);
                  if(success){
                    resetData();
                  }
                }
              }
            } else{
              'There are no available dates left for leave during the selected period.'.error();
            }
          }, text: 'Submit',).paddingOnly(bottom: 20)
        )
      ],
    );
  }
}