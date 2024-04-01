import 'package:etms/app/config/config.dart';
import 'package:etms/app/route/route_name.dart';
import 'package:etms/data/datasources/response/profile/emp_master_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
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
  EmpMasterResponse? data;
  bool enableFingerprint = false;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    getFingerprint();
    if(profileController.empMaster.value.empFirstName==null){
      getData();
    } else{
      setState(() {
        data=profileController.empMaster.value;
      });
      if(profileController.imageBytes.value.isEmpty){
        getPhoto();
      }
    }
  }

  getFingerprint() async{
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    bool enable = await _sharedPrefs.getFingerprint;
    if(mounted){
      setState(() {
        enableFingerprint = enable;
      });
    }
  }

  getData() async{
    await profileController.getEmpMaster();
    setState(() {
      data=profileController.empMaster.value;
    });
    if(profileController.imageBytes.value.isEmpty){
      await getPhoto();
    }
    if(profileController.imageBytes.value.isEmpty){
      getPhoto();
    }
  }

  getPhoto() async{
    profileController.getPhotoLoading.value=true;
    await profileController.getMyPhoto();
  }

  Widget widgetInfo(String title, String info){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: context.width*0.25,
            child: Text(title, style: latoRegular.copyWith(color: ColorResources.text300),)),
        Flexible(child: Text(info.toString()=='null' || info.toString()==''? '-':info,style: latoRegular.copyWith(color: ColorResources.text500),))
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
          data!=null && profileController.empMaster.value.empFirstName.toString()!='null'?
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
                                      Text('Edit ', style: latoSemibold.copyWith(color: ColorResources.primary500, decoration: TextDecoration.underline)).paddingOnly(right: 5),
                                      SvgPicture.asset('assets/images/edit.svg',width: 16,height: 16,
                                        color: ColorResources.primary500,)
                                      // Icon(Icons.edit_note, color: ColorResources.primary500,size: 25,)
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
                                Text('Next of Kin', style: latoRegular.copyWith(color: ColorResources.text500),),
                                SizedBox(
                                  height: 20,
                                    child: Icon(Icons.arrow_forward_ios, size: 17, color: ColorResources.primary800)).paddingOnly(right: 10)
                              ],
                            )
                        ),
                      ),
                      cardView(
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Fingerprint', style: latoRegular.copyWith(color: ColorResources.text500)),
                              Switch(
                                value: enableFingerprint,
                                activeColor: ColorResources.primary700,
                                activeTrackColor: ColorResources.primary700.withOpacity(0.3),
                                inactiveThumbColor: ColorResources.secondary700.withOpacity(0.8),
                                inactiveTrackColor: ColorResources.secondary600,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                onChanged: (bool value) {
                                  SharedPreferenceHelper _sharedPrefs = Get.find<SharedPreferenceHelper>();
                                  setState(() {
                                    enableFingerprint = !enableFingerprint;
                                  });
                                  _sharedPrefs.saveEnableFingerprint(enableFingerprint);
                                },
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
                                Text('Password', style: latoRegular.copyWith(color: ColorResources.text500)),
                                SvgPicture.asset('assets/images/password.svg',width: 20,height: 20,
                                  color: ColorResources.primary800,)
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: () async {
                          await EasyLoading.show();
                          await Future.delayed(Duration(seconds: 1));
                          await EasyLoading.dismiss();
                          Get.offAllNamed(RouteName.login);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Log Out ', style: latoLight.copyWith(decoration: TextDecoration.underline,
                            color: ColorResources.text500)),
                            SvgPicture.asset('assets/images/Login.svg',width: 17,height: 17,
                              color: ColorResources.text300,)
                          ],
                        ),
                      )
                    ],
                  ).paddingOnly(left: 20, right: 20)
              )
              :Container(),
        ));
  }
}
