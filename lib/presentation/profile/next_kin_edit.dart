import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/profile/next_of_kin_data.dart';
import 'package:etms/data/datasources/response/profile/next_kin_response.dart';
import 'package:etms/presentation/controllers/profile_controller.dart';
import 'package:etms/presentation/profile/widget/profile_text_field.dart';
import 'package:etms/presentation/widgets/my_app_bar.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../app/config/color_resources.dart';
import '../../app/config/font_family.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../widgets/custom_button.dart';

class NextOfKinEditView extends StatefulWidget {
  const NextOfKinEditView({super.key});

  @override
  State<NextOfKinEditView> createState() => _NextOfKinEditViewState();
}

class _NextOfKinEditViewState extends State<NextOfKinEditView> {
  ProfileController controller = Get.find();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _contactNoController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _relationController = TextEditingController();
  TextEditingController _genderController = TextEditingController();

  NextKinResponse? data;
  String selectedCountry = '';
  List<String> countriesList = [];
  List<int> countriesIdList = [];
  String selectedRelation = '';
  List<String> relationList = [];
  List<int> relationIdList = [];
  String selectedGender = '';
  List<String> genderList = ['Male', 'Female'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async{
    await controller.getNextKin();
    if(controller.nextKin.value.toString()!='null' && controller.nextKin.value.toString()!=''){
      setState(() {
        data=controller.nextKin.value;
        _firstNameController.text = data!.nKFirstName!;
        _lastNameController.text = data!.nKLastName!;
        _contactNoController.text = data!.nKContactNo!;
        _addressController.text = data!.nKAddress!;
        _emailController.text = data!.nKEmail!;
        _dobController.text = data!.nKBirthDate==null?'':DateTime.parse(data!.nKBirthDate.toString()).dMY()!;
        _genderController.text = data!.nKGender=='M'?'Male':'Female';
      });
    }

    await controller.getCountries();
    setState(() {
      countriesList.addAll(controller.countriesList.map((element) => element.countryName.toString()).toList());
      countriesIdList.addAll(controller.countriesList.map((element) => element.countryID!).toList());
      // selectedCountry = countriesList[data!.nKNationality!];
      // _countryController.text = countriesList[data!.nKNationality!];
    });
    int index = countriesIdList.indexOf(data!.nKNationality!);
    setState(() {
      selectedCountry =countriesList[index];
      _countryController.text = countriesList[index];
    });

    await controller.getRelationType();
    setState(() {
      relationList.addAll(controller.reTypeList.map((element) => element.relationName.toString()).toList());
      relationIdList.addAll(controller.reTypeList.map((element) => element.relationID!).toList());
      // selectedRelation = relationList[data!.nKRelationID!];
      // _relationController.text = relationList[data!.nKRelationID!];
    });
    index = relationIdList.indexOf(data!.nKRelationID!);
    setState(() {
      selectedRelation = relationList[index];
      _relationController.text = relationList[index];
    });
  }

  saveNextOfKin() async{
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;

    NextOfKinData data = NextOfKinData(
      empSysId: sysId,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      birthDate: _dobController.text,
      gender: _genderController.text=='Male'?'M':'F',
      contactNo: _contactNoController.text,
      email: _emailController.text,
      nationality: countriesIdList[countriesList.indexWhere((element) => element == selectedCountry)],
      relationId: relationIdList[relationList.indexWhere((element) => element == selectedRelation)],
      address: _addressController.text
    );
    await controller.saveNextKin(data);
    if(controller.updateNextKinSuccess.value){
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: 'Next of Kin'),
        body: controller.getNextOfKinLoading.value?
        Container():
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

                          ProfileTextField(controller: _firstNameController, label: 'First Name'),
                          SizedBox(height: 10,),

                          ProfileTextField(controller: _lastNameController, label: 'Last Name'),
                          SizedBox(height: 10,),

                          ProfileTextField(controller: _contactNoController, label: 'Contact No.', isNumber: true),
                          SizedBox(height: 10,),

                          ProfileTextField(controller: _addressController, label: 'Address'),
                          SizedBox(height: 10,),

                          ProfileTextField(controller: _emailController, label: 'Email'),
                          SizedBox(height: 20,),

                          TextFormField(
                            readOnly: true,
                            controller: _dobController,
                            style:  latoRegular.copyWith(color: ColorResources.text500, fontSize: 15),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
                                labelText: 'Date of Birth',
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
                                            initialDisplayDate: DateTime.parse(data!.nKBirthDate.toString()),
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
                                                  _dobController.text=value.dMY()!;
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
                            controller: _genderController,
                            style:  latoRegular.copyWith(color: ColorResources.text500, fontSize: 15),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
                                labelText: 'Gender',
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
                                color: ColorResources.white,
                                surfaceTintColor: ColorResources.white,
                                position: RelativeRect.fromLTRB(
                                  offset.dx,
                                  offset.dy + renderBox.size.height,
                                  offset.dx + renderBox.size.width,
                                  offset.dy + renderBox.size.height + 10.0, // Adjust the offset as needed
                                ),
                                items: genderList.map((String gender) {
                                  return PopupMenuItem<String>(
                                      value: gender,
                                      child:  SizedBox(
                                          width: context.width,
                                          child: Text(gender, style: latoRegular.copyWith(color: ColorResources.text500),))
                                  );
                                }).toList(),
                              ).then((String? value) {
                                if (value != null) {
                                  setState(() {
                                    selectedGender = value;
                                    _genderController.text = value;
                                  });
                                }
                              });
                            },
                          ),
                          SizedBox(height: 20,),

                          TextFormField(
                            readOnly: true,
                            controller: _countryController,
                            style:  latoRegular.copyWith(color: ColorResources.text500, fontSize: 15),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
                                labelText: 'Nationality',
                                labelStyle:  latoRegular.copyWith(color: ColorResources.text400, fontSize: 15),
                                filled: true,
                                fillColor: Colors.transparent,
                                suffixIcon: Icon(FeatherIcons.chevronDown, size: 20)
                            ),
                            onTap: (){
                              RenderBox renderBox = context.findRenderObject() as RenderBox;
                              var offset = renderBox.localToGlobal(Offset.zero);
                              showMenu<String>(
                                color: ColorResources.white,
                                surfaceTintColor: ColorResources.white,
                                context: context,
                                position: RelativeRect.fromLTRB(
                                  offset.dx,
                                  offset.dy + renderBox.size.height,
                                  offset.dx + renderBox.size.width,
                                  offset.dy + renderBox.size.height + 10.0, // Adjust the offset as needed
                                ),
                                items: countriesList.map((String country) {
                                  return PopupMenuItem<String>(
                                      value: country,
                                      child:  SizedBox(
                                          width: context.width,
                                          child: Text(country, style: latoRegular.copyWith(color: ColorResources.text500),))
                                  );
                                }).toList(),
                              ).then((String? value) {
                                if (value != null) {
                                  setState(() {
                                    selectedCountry = value;
                                    _countryController.text = value;
                                  });
                                }
                              });
                            },
                          ),
                          SizedBox(height: 20,),

                          TextFormField(
                            readOnly: true,
                            controller: _relationController,
                            style:  latoRegular.copyWith(color: ColorResources.text500, fontSize: 15),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
                                labelText: 'Relation Type',
                                labelStyle:  latoRegular.copyWith(color: ColorResources.text400, fontSize: 15),
                                filled: true,
                                fillColor: Colors.transparent,
                                suffixIcon: Icon(FeatherIcons.chevronDown, size: 20)
                            ),
                            onTap: (){
                              RenderBox renderBox = context.findRenderObject() as RenderBox;
                              var offset = renderBox.localToGlobal(Offset.zero);
                              showMenu<String>(
                                color: ColorResources.white,
                                surfaceTintColor: ColorResources.white,
                                context: context,
                                position: RelativeRect.fromLTRB(
                                  offset.dx,
                                  offset.dy + renderBox.size.height,
                                  offset.dx + renderBox.size.width,
                                  offset.dy + renderBox.size.height + 10.0, // Adjust the offset as needed
                                ),
                                items: relationList.map((String relation) {
                                  return PopupMenuItem<String>(
                                      value: relation,
                                      child:  SizedBox(
                                          width: context.width,
                                          child: Text(relation, style: latoRegular.copyWith(color: ColorResources.text500),))
                                  );
                                }).toList(),
                              ).then((String? value) {
                                if (value != null) {
                                  setState(() {
                                    selectedRelation = value;
                                    _relationController.text = value;
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
                child: CustomButton(onTap: (){saveNextOfKin();}, text: 'Submit',).paddingOnly(bottom: 20)
            )
          ],
        ).paddingOnly(left: 20, right: 20),
      ),
    );
  }
}
