import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/claim/compoff_request_data.dart';
import 'package:etms/data/datasources/response/claim/comp_off_response.dart';
import 'package:etms/presentation/controllers/claim_controller.dart';
import 'package:etms/presentation/widgets/custom_button.dart';
import 'package:etms/presentation/widgets/my_app_bar.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../data/datasources/shared_preference_helper.dart';
import '../../widgets/simple_text_form.dart';

class CompOffClaimView extends StatefulWidget {
  const CompOffClaimView({super.key});

  @override
  State<CompOffClaimView> createState() => _CompOffClaimViewState();
}

class _CompOffClaimViewState extends State<CompOffClaimView> {
  TextEditingController _workedDateController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  ClaimController controller = Get.find();
  bool formExpand = true;
  bool listExpand = true;
  List<CompOffResponse> dataList = [];
  DateTime filteredDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  late int selectedYear;
  late int tempSelectedYear;
  late FixedExtentScrollController scrollController;
  bool requireHalfLeaveSelect = false;
  bool checkFirst = false;
  bool checkSecond = false;
  List<int> yearList = List.generate(DateTime.now().year - 2007, (index) => DateTime.now().year - index).reversed.toList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _workedDateController.text=DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    setState(() {
      selectedYear = DateTime.now().year;
      tempSelectedYear = DateTime.now().year;
      scrollController = FixedExtentScrollController(initialItem: selectedYear);
    });
    getData(year: DateTime.now().year);
  }

  resetData(){
    remarkController.clear();
    setState(() {});
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

  getData({required int year}) async{
    await controller.getCompOffList(year: year);
    setState(() {
      dataList=controller.compOffList;
    });
  }

  Widget showDatePickAlert(){
    String pickedDate=_workedDateController.text;
    return AlertDialog(
        backgroundColor: ColorResources.white,
        surfaceTintColor: ColorResources.white,
        content: StatefulBuilder(
          builder: (context,setState){
            return Wrap(
              children: [
                SfDateRangePicker(
                  initialSelectedDate: DateTime.now(),
                  showNavigationArrow: true,
                  todayHighlightColor: ColorResources.primary500,
                  selectionColor: ColorResources.primary500,
                  selectionTextStyle: TextStyle(color: ColorResources.white),
                  headerHeight: 40,
                  // showActionButtons: true,
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
                            setState((){
                              _workedDateController.text=pickedDate.toString();
                              requireHalfLeaveSelect=false;
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.only(top: 12, bottom: 12),
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
              ],
            );
          },
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorResources.secondaryBackground,
          appBar: MyAppBar(title: 'Comp-Off'),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Comp Off Request Form', style: latoMedium.copyWith(fontSize: 17),),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          formExpand=!formExpand;
                        });
                      },
                      child: Row(
                        children: [
                          Text('More Detail',style: latoRegular.copyWith(color: ColorResources.primary500),),
                          Icon(formExpand?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up, color: ColorResources.primary500,)
                        ],
                      ),
                    ),
                  ],
                ).paddingOnly(left: 20, right: 20),
                formExpand?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        Text('Worked Data',),
                        SizedBox(height: 5,),
                        TextFormField(
                            controller: _workedDateController,
                            readOnly: true,
                            style:  latoRegular,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
                                hintText: _workedDateController.text,
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
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return showDatePickAlert(
                                  );
                                },
                              );
                            }
                        ),
            
                        SizedBox(height: 20,),
                        Text('Remark', style: latoSemibold,).paddingOnly(bottom: 5),
                        SizedBox(height: 5,),
                        SimpleTextFormField(
                          controller: remarkController,
                          hintText: 'Why did you apply leave?',
                          maxLine: 2,
                        ),
                        SizedBox(height: 20,),
                        CustomButton(
                            onTap: () async{
                              double duration = 0.0;
                              if(checkFirst){
                                duration+=0.5;
                              }
                              if(checkSecond){
                                duration+=0.5;
                              }
                              if(duration>0){
                                SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
                                String sysId= await _sharedPrefs.getEmpSysId;
                                String attendance = DateTime.parse(DateFormat('dd/MM/yyyy').parse(_workedDateController.text).toString()).dMY().toString();
                                CompOffRequestData requestData = CompOffRequestData(
                                    empSysId: sysId,
                                    attDate: attendance,
                                    remark: remarkController.text,
                                    duration: duration
                                );
                                bool success = await controller.requestCompOff(data: requestData);
                                if(success){
                                  resetData();
                                }
                              } else{
                                'Please select for leave duration (Half Type Leave).'.error();
                              }
                            }, text: 'Submit')
                      ],
                    ).paddingOnly(left: 20, right: 20):Container(),
                Divider(color: Color(0xff475772),).paddingOnly(top: 10),
            
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Comp Off History', style: latoMedium.copyWith(fontSize: 17),),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          listExpand=!listExpand;
                        });
                      },
                      child: Row(
                        children: [
                          Text('More Detail',style: latoRegular.copyWith(color: ColorResources.primary500),),
                          Icon(listExpand?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up, color: ColorResources.primary500,)
                        ],
                      ),
                    ),
                  ],
                ).paddingOnly(left: 20, right: 20),
                if(listExpand)
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        showModalBottomSheet(
                            backgroundColor: ColorResources.white,
                            context: context,
                            elevation: 10,
                            builder: (BuildContext context){
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),)
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: (){Navigator.pop(context);},
                                              child: SvgPicture.asset('assets/images/back.svg',width: 20,height: 20),
                                            ).paddingOnly(right: 10),
                                            Text('Filter')
                                          ],
                                        ),
                                        TextButton(
                                            onPressed:(){
                                              setState(() {
                                                selectedYear=tempSelectedYear;
                                              });
                                              Navigator.pop(context);
                                              getData(year: selectedYear);
                                            },
                                            child: Text('Done',
                                              style: latoSemibold.copyWith(color: ColorResources.primary600),)
                                        )
                                      ],
                                    ).paddingAll(10),
                                    Container(
                                      color: Colors.white,
                                      height: 150,
                                      child: CupertinoTheme(
                                          data: CupertinoThemeData(
                                            textTheme: CupertinoTextThemeData(
                                                dateTimePickerTextStyle: latoRegular
                                            ),
                                          ),
                                          child: CupertinoPicker(
                                            itemExtent: 40,
                                            scrollController: scrollController,
                                            onSelectedItemChanged: (index) {
                                              setState(() {
                                                tempSelectedYear = yearList[index];
                                              });
                                            },
                                            children: List.generate(
                                                yearList.length,
                                                  (index) => Center(
                                                child: Text(
                                                  '${yearList[index]}',
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            )
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
                          decoration: BoxDecoration(
                              color: ColorResources.white,
                              border: Border.all(color: ColorResources.primary500),
                              borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(FeatherIcons.sliders, color: ColorResources.black, size: 20,).paddingOnly(right: 10),
                              Text('Filter',style: latoRegular,)
                            ],
                          )
                      ),
                    ).paddingAll(20),
                    Text(selectedYear.toString(),style: latoRegular)
                  ],
                ),
                listExpand?
                    Container(
                      child:  controller.compOffListLoading.value?Container():
                      dataList.isEmpty?
                      Center(child: Text('There is no data.')).paddingOnly(top: 30):
                      ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (context,index){
                          CompOffResponse data = dataList[index];
                          return Material(
                            elevation: 1,
                            color: ColorResources.white,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('Attendance Date', style: latoSemibold,).paddingOnly(right: 10).paddingOnly(right: 10),
                                      Text(DateTime.parse(data.attDat!).dMY().toString(),)
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Text('Request Date', style: latoSemibold,).paddingOnly(right: 10).paddingOnly(right: 10),
                                      Text(DateTime.parse(data.requestedTime!).dMY().toString(),)
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Text('Duration', style: latoSemibold,).paddingOnly(right: 10).paddingOnly(right: 10),
                                      Text(data.duration.toString(),)
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
                            ).paddingOnly(left: 10, right: 10, top: 10, bottom: 10),
                          ).paddingOnly(bottom: 9);
                        },
                      ).paddingOnly(left: 20, right: 20),
                    ):Container()
              ],
            ).paddingOnly(top: 15, bottom: 15),
          ),
        ));
  }
}
