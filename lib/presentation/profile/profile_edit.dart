import 'dart:typed_data';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/response/profile/marital_status_response.dart';
import 'package:etms/presentation/controllers/profile_controller.dart';
import 'package:etms/presentation/profile/widget/profile_text_field.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../app/config/config.dart';
import '../../data/datasources/response/profile/emp_master_response.dart';
import '../widgets/custom_button.dart';
import '../widgets/my_app_bar.dart';

class ProfileEditView extends StatefulWidget {
  // EmpMasterResponse data;
  // Uint8List photoBytes;
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  EmpMasterResponse data = Get.arguments[0];
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _contactNoController = TextEditingController();
  TextEditingController _permanentAddrController = TextEditingController();
  TextEditingController _currentAddrController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _maritalStatusController = TextEditingController();
  TextEditingController _passportExpController = TextEditingController();
  Uint8List? photoBytes;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  ProfileController controller = Get.find();
  List<MaritalStatusResponse> mStatusList = [];
  List<String> mStringList=[];
  List mIdList=[];
  String selectedMStatus = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _firstNameController.text = data.empFirstName.toString();
      _lastNameController.text = data.empLastName.toString();
      _contactNoController.text = data.empContactNo.toString();
      _permanentAddrController.text = data.empPermanentAddr.toString();
      _currentAddrController.text = data.empCurrentAddr.toString();
      photoBytes = Get.arguments[1];
    });
    getMaritalStatus();
  }

  getMaritalStatus() async{
    await controller.getMaritalStatus();
    setState(() {
      mStatusList=controller.mStatusList;
      mIdList.addAll(controller.mStatusList.map((element) => element.maritalStatusID).toList());
      mStringList.addAll(controller.mStatusList.map((element) => element.maritalStatusName.toString()).toList());
    });
    if(!(data.empMaritalStatusID.toString()=='' || data.empMaritalStatusID.toString()=='null')){
      setState(() {
        selectedMStatus = mStringList[data.empMaritalStatusID!];
        _maritalStatusController.text = mStringList[data.empMaritalStatusID!];
      });
    } else {
      selectedMStatus = mStringList[0];
      _maritalStatusController.text = mStringList[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: MyAppBar(title: 'Personal Information'),
          body: mStatusList.isNotEmpty?
          Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Form(
                        key: _key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text('Name'),

                            Row(
                              children: [
                                // Stack(
                                //   children: [
                                //     Container(
                                //         height:70,
                                //         width: 70,
                                //         decoration: BoxDecoration(
                                //             shape: BoxShape.circle,
                                //             image: DecorationImage(
                                //                 fit: BoxFit.cover,
                                //                 image: MemoryImage(photoBytes!)))
                                //     ),
                                //     InkWell(
                                //       onTap: (){
                                //         // pickImageFromGallary();
                                //       },
                                //       child: Container(
                                //         width: 25,
                                //         height: 25,
                                //         margin: EdgeInsets.only(left: 50, top: 45),
                                //         // margin: const EdgeInsets.fromLTRB(110,100, 0, 0),
                                //         decoration: BoxDecoration(
                                //             shape: BoxShape.circle,
                                //             color: Colors.white,
                                //             border: Border.all(color: Colors.black)
                                //         ),
                                //         child: const Icon(Icons.edit,color:Colors.black,size: 15,),
                                //       ),
                                //     ),
                                //   ],
                                // )
                                Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: MemoryImage(photoBytes!)))
                                )
                                    .paddingOnly(right: 15),
                                Expanded(child: ProfileTextField(controller: _firstNameController, label: 'First Name')),
                              ],
                            ),
                            SizedBox(height: 10,),

                            ProfileTextField(controller: _lastNameController, label: 'Last Name'),
                            SizedBox(height: 10,),

                            ProfileTextField(controller: _contactNoController, label: 'Contact No.'),
                            SizedBox(height: 10,),

                            ProfileTextField(controller: _permanentAddrController, label: 'Permanent Address / Overseas Address'),
                            SizedBox(height: 10,),

                            ProfileTextField(controller: _currentAddrController, label: 'Current Address / Local Address'),
                            SizedBox(height: 10,),

                            ProfileTextField(controller: _emailController, label: 'Email'),
                            SizedBox(height: 20,),

                            TextFormField(
                              readOnly: true,
                              controller: _passportExpController,
                              style:  latoRegular.copyWith(color: ColorResources.text500, fontSize: 15),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
                                  labelText: 'Passport Expiry Date',
                                  labelStyle:  latoRegular.copyWith(color: ColorResources.text400, fontSize: 15),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  suffixIcon: Icon(Icons.edit, size: 20)
                              ),
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return  AlertDialog(
                                      content:  Wrap(
                                        children: [
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
                                                setState((){
                                                  _passportExpController.text=value.dMY()!;
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

                            TextFormField(
                              readOnly: true,
                              controller: _maritalStatusController,
                              style:  latoRegular.copyWith(color: ColorResources.text500, fontSize: 15),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
                                  labelText: 'Marital Status',
                                  labelStyle:  latoRegular.copyWith(color: ColorResources.text400, fontSize: 15),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  suffixIcon: Icon(FeatherIcons.chevronDown, size: 20)
                              ),
                              onTap: (){
                                RenderBox renderBox = context.findRenderObject() as RenderBox;
                                var offset = renderBox.localToGlobal(Offset.zero);
                                showMenu<String>(
                                  context: context,
                                  // position: RelativeRect.fromLTRB(0, 150, 0, 0),
                                  // position: RelativeRect.fromLTRB(0, _maritalStatusController..toDouble(), 0, 0),
                                  position: RelativeRect.fromLTRB(
                                    offset.dx,
                                    offset.dy + renderBox.size.height,
                                    offset.dx + renderBox.size.width,
                                    offset.dy + renderBox.size.height + 10.0, // Adjust the offset as needed
                                  ),
                                  items: mStringList.map((String type) {
                                    return PopupMenuItem<String>(
                                        value: type,
                                        child:  SizedBox(
                                            width: context.width,
                                            child: Text(type, style: latoRegular,))
                                    );
                                  }).toList(),
                                ).then((String? value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedMStatus = value;
                                      _maritalStatusController.text = value;
                                    });
                                  }
                                });
                              },
                            ),
                            SizedBox(height: 20,),

                          ],
                        ))
                  ],
                ).paddingOnly(bottom: 70),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(onTap: (){}, text: 'Submit',).paddingOnly(bottom: 20)
              )
            ],
          ).paddingOnly(left: 20, right: 20):
          Container(),
        ));
  }
}
