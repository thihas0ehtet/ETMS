import 'dart:io';
import 'dart:typed_data';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/profile/emp_master_data.dart';
import 'package:etms/presentation/controllers/profile_controller.dart';
import 'package:etms/presentation/profile/widget/profile_text_field.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../app/config/config.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../../app/utils/app_utils.dart';
import '../../data/datasources/response/profile/emp_master_response.dart';
import '../widgets/custom_button.dart';
import '../widgets/my_app_bar.dart';
import 'package:path/path.dart' as path;

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  // EmpMasterResponse data = Get.arguments[0];
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
  List<String> mStringList=[];
  List mIdList=[];
  String selectedMStatus = '';
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    EmpMasterResponse data = controller.empMaster.value;
    setState(() {
      _firstNameController.text = data.empFirstName.toString();
      _lastNameController.text = data.empLastName.toString();
      _contactNoController.text = data.empContactNo.toString();
      _permanentAddrController.text = data.empPermanentAddr??'';
      _currentAddrController.text = data.empCurrentAddr??'';
      _emailController.text = data.empEmail.toString();
      _passportExpController.text = data.empPassportExpDate==null?'':DateTime.parse(data.empPassportExpDate).dMY().toString();
      photoBytes = controller.imageBytes.value;
    });
    getMaritalStatus();
  }

  getMaritalStatus() async{
    await controller.getMaritalStatus();
    setState(() {
      // mStatusList=controller.mStatusList;
      mIdList.addAll(controller.mStatusList.map((element) => element.maritalStatusID).toList());
      mStringList.addAll(controller.mStatusList.map((element) => element.maritalStatusName.toString()).toList());
    });

    if(!(controller.empMaster.value.empMaritalStatusID.toString()=='' || controller.empMaster.value.empMaritalStatusID.toString()=='null')){
      int index = mIdList.indexOf(controller.empMaster.value.empMaritalStatusID!);
      setState(() {
        selectedMStatus = mStringList[index];
        _maritalStatusController.text = mStringList[index];
      });
    } else {
      selectedMStatus = mStringList[0];
      _maritalStatusController.text = mStringList[0];
    }
  }

  Future<void> pickImageFromCamera() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if(image!=null){
      setState(() {
        imageFile=File(image.path);
      });
    }
  }

  Future<void> _onImageButtonPressed({
    required BuildContext context,
  }) async {
    _picker.pickImage(source: ImageSource.gallery, imageQuality: 80).then((value) {
      setState(() {
        imageFile=File(value!.path);
      });
    }).catchError((e) {
      if (e.toString().contains('photo_access_denied')) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  "You need to accept permission to select image",
                  style: TextStyle(
                    color: Colors.indigo,
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.black, backgroundColor: Colors.grey.shade300),
                  ),
                  TextButton(
                    child: Text("Accept"),
                    onPressed: () {
                      AppUtils.checkImagePermission(context).then((value) {
                        if (value) {
                          Navigator.of(context).pop();
                          // AppUtils.showSnackChek("You accept permission");
                        } else {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.white, backgroundColor: Colors.indigo),
                  ),
                ],
              );
            });
      }
    });
  }

  showPhotoOptions(){
    showModalBottomSheet(
        backgroundColor: ColorResources.white,
        context: context,
        elevation: 10,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),)
        ),
        builder: (BuildContext context){
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20,),
                Text(
                  "Choose an action",
                  style: latoSemibold.copyWith(fontSize: 16),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        pickImageFromCamera();
                      },
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt_outlined,size: 30),
                          Text('Camera')
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        await _onImageButtonPressed(context: context);
                      },
                      child: Column(
                        children: [
                          Icon(Icons.image,size: 30,),
                          Text('Gallery')
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30,),
              ],
            ),
          );
        });
  }

  saveProfile() async {
    EmpMasterData empMasterData = EmpMasterData(
      code: controller.empMaster.value.empCode,
      contactNo: _contactNoController.text,
      email: _emailController.text,
      maritalStatus: mIdList[mStringList.indexWhere((element) => element == selectedMStatus)],
      passportExp: _passportExpController.text,
      permanentAddr: _permanentAddrController.text,
      currentAddr: _currentAddrController.text
    );

    if(imageFile!=null){
      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
          imageFile!.path,
          format: CompressFormat.jpeg
      );

      // Write the compressed bytes to the output file
      String fileType = path.basename(imageFile!.path).split('.')[1];
      String outputFile = imageFile!.path.replaceAll(fileType, 'jpeg');
      File file = await File(outputFile).writeAsBytes(compressedBytes!);

      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;
      FormData formData= FormData(
          {
            'file': MultipartFile(file.path, filename: file.path.split('/').last),
            'id': sysId
          }
      );
      await controller.saveEmpMaster(empMasterData,formData);
      if(controller.updateProfileSuccess.value==true){
        Navigator.pop(context);
      }
    } else{
      await controller.saveEmpMaster(empMasterData,null);
      if(controller.updateProfileSuccess.value==true){
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: MyAppBar(title: 'Personal Information'),
          body: mStringList.isNotEmpty?
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
                            GestureDetector(
                              onTap: ()=>showPhotoOptions(),
                              child: Row(
                                children: [
                                  imageFile!=null?
                                  Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: ColorResources.secondary700),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(imageFile!)
                                          )
                                      )
                                  ):
                                  photoBytes!.isEmpty?
                                  Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: ColorResources.secondary700)),
                                    child: Icon(Icons.camera_alt),
                                  ):
                                  Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: ColorResources.secondary700),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: MemoryImage(photoBytes!)))
                                  )
                                      .paddingOnly(right: 15),
                                  Expanded(child: ProfileTextField(controller: _firstNameController, label: 'First Name', isReadOnly: true,)),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),

                            ProfileTextField(controller: _lastNameController, label: 'Last Name', isReadOnly: true),
                            SizedBox(height: 10,),

                            ProfileTextField(controller: _contactNoController, label: 'Contact No.', isNumber: true),
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
                                        backgroundColor: ColorResources.white,
                                        surfaceTintColor: ColorResources.white,
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
                                  color: ColorResources.white,
                                  surfaceTintColor: ColorResources.white,
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
                                            child: Text(type, style: latoRegular.copyWith(color: ColorResources.text400),))
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
                  child: CustomButton(onTap: (){
                    saveProfile();
                  }, text: 'Submit',).paddingOnly(bottom: 20)
              )
            ],
          ).paddingOnly(left: 20, right: 20):
          Container(),
        ));
  }
}
