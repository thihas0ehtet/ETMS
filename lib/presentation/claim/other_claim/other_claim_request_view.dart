import 'package:etms/app/route/route_name.dart';
import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/claim/claim_request.dart';
import 'package:etms/presentation/controllers/claim_controller.dart';
import 'package:etms/presentation/widgets/custom_button.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../app/config/config.dart';
import '../../../data/datasources/shared_preference_helper.dart';
import '../../apply_leave/widgets/photo_attachement.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/simple_text_form.dart';

class OtherClaimRequestView extends StatefulWidget {
  const OtherClaimRequestView({super.key});

  @override
  State<OtherClaimRequestView> createState() => _OtherClaimRequestViewState();
}

class _OtherClaimRequestViewState extends State<OtherClaimRequestView> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _remarkController = TextEditingController();
  ClaimController controller = Get.find();
  String selectedClaimGroup = '';
  String selectedClaimName = '';
  List<String> groupList = [''];
  List<String> nameList = [''];
  var attachmentStateKey = GlobalKey<PhotoAttachmentViewState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClaimGroup();
  }

  @override
  void dispose(){
    super.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _remarkController.dispose();
  }

  getClaimGroup() async{
    await controller.getClaimGroups();
    setState(() {
      groupList.addAll(controller.claimGroups.map((element) => element.claimGroupName.toString()).toList());
    });
  }

  getClaimName() async{
    int id = getClaimGroupId(selectedClaimGroup);
    await controller.getClaimNames(groupId: id);
    setState(() {
      selectedClaimName='';
      nameList = [''];
      nameList.addAll(controller.claimNames.map((element) => element.claimName.toString()).toList());
    });
  }

  int getClaimGroupId(String name){
    int? id;
    for (var item in controller.claimGroups) {
      // Check if the name matches
      if(name == item.claimGroupName){
        id = item.claimGroupID!;
      }
    }
    return id!;
  }

  int getClaimNameId(String name){
    int? id;
    for (var item in controller.claimNames) {
      // Check if the name matches
      if(name == item.claimName){
        id = item.claimNameID!;
      }
    }
    return id!;
  }

  resetData(){
    _amountController.clear();
    _dateController.clear();
    _remarkController.clear();
    attachmentStateKey.currentState!.clearImageFile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorResources.white,
          appBar: MyAppBar(title: 'Other Claim',
            widget:  GestureDetector(
              onTap: (){
                Get.toNamed(RouteName.other_claim_history);
              },
              child: Row(
                children: [
                  Text('History',style: latoRegular.copyWith(color: ColorResources.white,
                      decoration: TextDecoration.underline,decorationColor: ColorResources.white),).paddingOnly(right: 10),
                  SvgPicture.asset('assets/images/history.svg',width: 16,height: 16,
                    color: ColorResources.white,)
                ],
              ),
            ),),
          body: Obx(()=>
          controller.claimGroupsLoading.value || groupList.isEmpty?Container():
              Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Claim Group"),
                        SizedBox(height: 5,),
                        Container(
                          // padding: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                              color: ColorResources.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Color(0xff475772))
                          ),
                          child: DropdownButton(
                              dropdownColor: ColorResources.white,
                              isExpanded: true,
                              value: selectedClaimGroup,
                              underline: Container(),
                              icon: Icon(FeatherIcons.chevronDown, color: ColorResources.black,),
                              items: groupList.map((groupName) {
                                return DropdownMenuItem<String>(
                                  value: groupName,
                                  child:
                                  Text(
                                    // groupName, style: latoRegular,
                                    groupName.toString()==''?'Select Claim Type':groupName.toString(),
                                    style: latoRegular.copyWith(color: groupName==''
                                        ? ColorResources.text300
                                        : ColorResources.text500),
                                  ).paddingOnly(left: 14),
                                );
                              }).toList(),
                              onChanged: (dynamic value) {
                                if (value != selectedClaimGroup) {
                                  setState(() {
                                    selectedClaimGroup = value!;
                                  });
                                  getClaimName();
                                }
                              }),
                        ),
                        SizedBox(height: 20,),
                        Text("Claim Name"),
                        SizedBox(height: 5,),
                        Container(
                          // padding: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                              color: ColorResources.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Color(0xff475772))
                          ),
                          child: DropdownButton(
                              dropdownColor: ColorResources.white,
                              isExpanded: true,
                              value: selectedClaimName,
                              underline: Container(),
                              icon: Icon(FeatherIcons.chevronDown, color: ColorResources.black,),
                              items: nameList.map((name) {
                                return DropdownMenuItem<String>(
                                  value: name,
                                  child:
                                  Text(
                                    // groupName, style: latoRegular,
                                    name.toString()==''?'Select Claim Name':name.toString(),
                                    style: latoRegular.copyWith(color: name==''
                                        ? ColorResources.text300
                                        : ColorResources.text500),
                                  ).paddingOnly(left: 14),
                                );
                              }).toList(),
                              onChanged: (dynamic value) {
                                if (value != selectedClaimName) {
                                  setState(() {
                                    selectedClaimName = value!;
                                  });
                                }
                              }),
                        ),
                        SizedBox(height: 20,),
                        Text('Amount').paddingOnly(bottom: 5),
                        SizedBox(height: 5,),
                        SimpleTextFormField(
                          controller: _amountController,
                          hintText: '\$',
                          // isLate!?'Why are you late?':'Why are you too early?',
                          maxLine: 1,
                          isNumber: true,
                        ),
                        SizedBox(height: 20,),
                        Text('Receipt Date').paddingOnly(bottom: 5),
                        TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          style:  latoRegular.copyWith(color: ColorResources.text500, fontSize: 15),
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
                              hintText: _dateController.text==''?'dd-mm-yyyy':_dateController.text,
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
                              builder: (BuildContext context) {
                                return  AlertDialog(
                                    shadowColor: ColorResources.white,
                                    backgroundColor: ColorResources.white,
                                    surfaceTintColor: ColorResources.white,
                                    content:  Wrap(
                                      children: [
                                        SfDateRangePicker(
                                          backgroundColor: ColorResources.white,
                                          initialDisplayDate: DateTime.parse(DateTime.now().toString()),
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
                                              setState((){
                                                _dateController.text=value.dMY()!;
                                              });
                                            }
                                            Navigator.pop(context);
                                          },
                                          selectionMode: DateRangePickerSelectionMode.single,
                                        ),
                                      ],
                                    )
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 20,),
                        Text('Remark').paddingOnly(bottom: 5),
                        SimpleTextFormField(
                          controller: _remarkController,
                          hintText: 'Remark',
                          // isLate!?'Why are you late?':'Why are you too early?',
                          maxLine: 3,
                        ),
                        PhotoAttachmentView(key: attachmentStateKey,),
                      ],
                    ).paddingOnly(bottom: 70),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      text: 'Submit',
                      onTap: () async {
                        // resetData();
                        if(selectedClaimGroup==''){
                          'Please select claim group'.error();
                        }else if(selectedClaimName==''){
                          'Please select claim name'.error();
                        }else if(_amountController.text.isEmpty){
                          'Please type amount'.error();
                        }else if(_dateController.text.isEmpty){
                          'Please select receipt date'.error();
                        }else{
                          SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
                          String sysId= await _sharedPrefs.getEmpSysId;
                          ClaimRequest request = ClaimRequest(
                              claimNameId: getClaimNameId(selectedClaimName),
                              groupId: getClaimGroupId(selectedClaimGroup),
                              amount: double.parse(_amountController.text),
                              sysId: int.parse(sysId),
                              receiptDate: _dateController.text,
                              notifyTo: 0,
                              claimStatus: 0,
                              payStatus: false,
                              dateCreated: DateTime.now().toString(),
                              fileUpload: attachmentStateKey.currentState!.getImageFile()==null?false:true,
                              remark: _remarkController.text
                          );

                          if(attachmentStateKey.currentState!.getImageFile()==null){
                            bool success = await controller.saveClaim(data: request);
                            if(success) resetData();
                          } else{
                            bool success = await controller.saveClaim(data: request, image: attachmentStateKey.currentState!.getImageFile());
                            if(success) resetData();
                          }
                        }
                      },
                    ),
                  )
                ],
              ).paddingAll(20))
        ));
  }
}
