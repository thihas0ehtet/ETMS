import 'dart:convert';
import 'dart:typed_data';
import 'package:etms/app/config/config.dart';
import 'package:etms/app/route/route_name.dart';
import 'package:etms/data/datasources/response/profile/emp_master_response.dart';
import 'package:etms/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileController profileController = Get.find();
  AuthController authController = Get.find();
  EmpMasterResponse? data;
  // Uint8List? photoBytes;
  bool enableFingerprint = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("HELLO TIS I S ${profileController.empMaster.value.empFirstName}");
    if(profileController.empMaster.value.empFirstName==null){
      getData();
    } else{
      setState(() {
        data=profileController.empMaster.value;
      });
    }
    if(profileController.imageBytes.value.isEmpty){
      getPhoto();
    }

    // getEmpMaster();
  }

  getData() async{
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    bool enable = await _sharedPrefs.getFingerprint;
    if(mounted){
      setState(() {
        enableFingerprint = enable;
      });
    }

    await profileController.getEmpMaster();
    if(mounted){
      setState(() {
        data=profileController.empMaster.value;
      });
    }
    if(profileController.imageBytes.value.isEmpty){
      getPhoto();
      // await profileController.getMyPhoto();
      // getPhoto();
    }
    // else{
    //   setProfilePhoto();
    // }
  }

  getPhoto() async{
    await profileController.getMyPhoto();
  }

  // getPhoto() async{
  //   await profileController.getMyPhoto();
  //   // setProfilePhoto();
  // }

  // setProfilePhoto(){
  //   Uint8List bytes = base64.decode(profileController.photo.value.split(',').last);
  //   setState(() {
  //     photoBytes=bytes;
  //   });
  // }

  Widget widgetInfo(String title, String info){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: context.width*0.25,
            child: Text(title, style: latoRegular.copyWith(color: ColorResources.text300),)),
        Flexible(child: Text(info,style: latoRegular.copyWith(color: ColorResources.text500),))
      ],
    ).paddingOnly(bottom: 15);
  }

  Widget cardView({required Widget widget}){
    return  Card(
      elevation: 1,
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
        decoration: BoxDecoration(
            border: Border.all(color: ColorResources.border),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          color: ColorResources.white
        ),
        child: widget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ProfileController controller = Get.find();
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorResources.white,
          body:
          data!=null?
              Obx(()=>
                  Column(
                    children: [
                      SizedBox(height: 10,),
                      cardView(
                        widget: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    if(profileController.imageBytes.value.isNotEmpty)
                                      Container(
                                          height:50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: ColorResources.secondary700),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: MemoryImage(profileController.imageBytes.value)))
                                      ).paddingOnly(right: 15),
                                    Text('${profileController.empMaster.value.empFirstName} ${profileController.empMaster.value.empLastName}', style: latoSemibold.copyWith(fontSize: 18),)
                                  ],
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Get.toNamed(RouteName.profile_edit);
                                  },
                                  child: Row(
                                    children: [
                                      Text('Edit ', style: latoSemibold.copyWith(color: ColorResources.primary500, decoration: TextDecoration.underline)),
                                      Icon(Icons.edit_note, color: ColorResources.primary500,size: 25,)
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10,),
                            widgetInfo('Contact No.', profileController.empMaster.value.empContactNo.toString()),
                            widgetInfo('Email', profileController.empMaster.value.empEmail.toString()),
                            widgetInfo('Address', profileController.empMaster.value.empCurrentAddr.toString()),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: ()=> Get.toNamed(RouteName.next_kin_edit),
                        child: cardView(
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Next of Kin'),
                                SizedBox(
                                  height: 20,
                                    child: Icon(Icons.arrow_forward_ios, size: 17,)).paddingOnly(right: 10)
                              ],
                            )
                        ),
                      ),
                      cardView(
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Fingerprint'),
                              Container(
                                height: 20,
                                child: Switch(
                                  value: enableFingerprint,
                                  activeColor: ColorResources.primary700,
                                  activeTrackColor: ColorResources.primary700.withOpacity(0.3),
                                  inactiveThumbColor: ColorResources.secondary700.withOpacity(0.8),
                                  inactiveTrackColor: ColorResources.secondary600,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  // inactiveThumbColor: ColorResources.secondary700,
                                  // inactiveTrackColor: Colors.grey[200],
                                  // trackOutlineColor: MaterialStateProperty.all<Color>(enableFingerprint?Colors.transparent:ColorResources.secondary800),
                                  // thumbIcon:MaterialStateProperty.resolveWith<Icon?>((Set<MaterialState> states) {
                                  //   if (states.contains(MaterialState.disabled)) {
                                  //     return const Icon(Icons.close);
                                  //   }
                                  //   return null; // All other states will use the default thumbIcon.
                                  // }),
                                  onChanged: (bool value) {
                                    SharedPreferenceHelper _sharedPrefs = Get.find<SharedPreferenceHelper>();
                                    setState(() {
                                      enableFingerprint = !enableFingerprint;
                                    });
                                    _sharedPrefs.saveEnableFingerprint(enableFingerprint);
                                  },
                                ),
                              ),
                              // Icon(Icons.toggle_off, size: 25)
                            ],
                          )
                      ),
                      GestureDetector(
                        onTap: ()=> Get.toNamed(RouteName.reset_password),
                        child: cardView(
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Password'),
                                Icon(Icons.key_sharp, size: 25).paddingOnly(right: 10)
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: ()=> Get.offNamed(RouteName.login),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Log Out ', style: latoLight.copyWith(decoration: TextDecoration.underline)),
                            Icon(Icons.lock_open, size: 17,)
                          ],
                        ),
                      )
                    ],
                  ).paddingOnly(left: 20, right: 20)
              ) :Container(),
        ));
  }
}
