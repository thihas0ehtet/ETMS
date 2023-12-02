import 'dart:convert';
import 'dart:typed_data';
import 'package:etms/app/config/config.dart';
import 'package:etms/app/route/route_name.dart';
import 'package:etms/data/datasources/response/profile/emp_master_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileController profileController = Get.find();
  EmpMasterResponse? data;
  Uint8List? photoBytes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

    // getEmpMaster();
  }

  getData() async{
    await profileController.getEmpMaster();
    setState(() {
      data=profileController.empMaster.value;
    });
    if(profileController.photo.isEmpty){
      getPhoto();
    } else{
      setProfilePhoto();
    }
  }

  getPhoto() async{
    await profileController.getMyPhoto();
    setProfilePhoto();
  }

  setProfilePhoto(){
    Uint8List bytes = base64.decode(profileController.photo.value.split(',').last);
    setState(() {
      photoBytes=bytes;
    });
  }

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
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: widget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          // backgroundColor: ColorResources.background,
          backgroundColor: ColorResources.white,
          body:
          data!=null?
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
                            // Container(
                            //     height:50,
                            //     width: 50,
                            //     decoration: BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         color: Colors.yellow
                            //     )
                            // ).paddingOnly(right: 15),
                            if(photoBytes!=null)
                              Container(
                                  height:50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: MemoryImage(photoBytes!)))
                              ).paddingOnly(right: 15),
                            Text('${data!.empFirstName} ${data!.empLastName}', style: latoSemibold.copyWith(fontSize: 18),)
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            Get.toNamed(RouteName.profile_edit,arguments: [data,photoBytes]);
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
                    widgetInfo('Contact No.', data!.empContactNo.toString()),
                    widgetInfo('Email', data!.empEmail.toString()),
                    widgetInfo('Address', data!.empCurrentAddr.toString()),
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
                      Icon(Icons.arrow_forward_ios, size: 17,)
                    ],
                  )
                ),
              ),
              cardView(
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fingerprint'),
                      Icon(Icons.toggle_off, size: 25)
                    ],
                  )
              ),
              cardView(
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Password'),
                      Icon(Icons.key_sharp, size: 25)
                    ],
                  )
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Log Out ', style: latoLight.copyWith(decoration: TextDecoration.underline)),
                  Icon(Icons.lock_open, size: 17,)
                ],
              )
            ],
          ).paddingOnly(left: 20, right: 20):Container(),
        ));
  }
}
