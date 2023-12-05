import 'dart:convert';
import 'dart:typed_data';
import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/attendance_report_data.dart';
import 'package:etms/data/datasources/response/attendance_report/attendance_report_response.dart';
import 'package:etms/presentation/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/helpers/shared_preference_helper.dart';
import '../../../app/route/route_name.dart';
import '../../controllers/attendance_controller.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  AttendanceController controller = Get.find();
  ProfileController profileController = Get.find();
  AttReportSummaryResponse attSummary = AttReportSummaryResponse();
  bool isEmpty=true;
  // String photo='';
  Uint8List? photoBytes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    attSummary=controller.attSummary.value;
    if(attSummary.empFirstName.toString()!='null'){
      setState(() {
        isEmpty=false;
      });
    }
    print("GET PHOTO");
    getAttReportSummary(DateFormat('MMM yyy').format(DateTime.now()));

  }

  getAttReportSummary(String inputDate) async {
    DateTime parsedMonth = DateFormat('MMM yyyy').parse(inputDate);
    DateTime startOfMonth = DateTime(parsedMonth.year, parsedMonth.month, 1);
    DateTime endOfMonth = DateTime(parsedMonth.year, parsedMonth.month + 1, 0);
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;

    AttendanceReportData data = AttendanceReportData(
      unitId: 0,
      empSysId: sysId,
      active: 'All',
      sDate: startOfMonth.dMY(),
      eDate: endOfMonth.dMY(),
      uid: 1
    );
    await controller.getAttReportSummary(data: data);
    if(controller.attSummary.value.empFirstName.toString()!='null'){
      setState(() {
        isEmpty=false;
        attSummary=controller.attSummary.value;
      });
    }
    if(profileController.photo.isEmpty){
      getPhoto();
    } else{
      setProfilePhoto();
    }
  }

  // getPhoto() async{
  //   await profileController.getMyPhoto();
  //   Uint8List bytes = base64.decode(profileController.photo.value.split(',').last);
  //   // var bytes = base64.decode(cop2);
  //   print("Byesss is $bytes");
  //   setState(() {
  //     photoBytes=bytes;
  //   });
  //
  //   // setState(() {
  //   //   // photo=profileController.photo.value;
  //   //   photoBytes = base64.decode(profileController.photo.value);
  //   // });
  // }

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


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height,
      child: Stack(
        alignment: Alignment.center,
        //textDirection: TextDirection.ltr,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 200,
              color: ColorResources.primary800,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  photoBytes!=null?
                    Container(
                        height:50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(photoBytes!)))
                    ):Container(
                      height:50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        color: ColorResources.white
                      )),
                      // Container(
                      //   width: 50,
                      //   height: 50,
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       shape: BoxShape.circle
                      //   ),
                      //   child: Image.memory(Uint8List.fromList(photoBytes),cacheHeight: 400,fit: BoxFit.cover,),
                      // )
                      // if(photoBytes.isNotEmpty)
                      // ClipOval(
                      //   child:
                        // CachedNetworkImage(
                        //   width: 50,
                        //   height: 50,
                        //   fit: BoxFit.cover,
                        //   imageUrl:  p,
                        //   progressIndicatorBuilder:
                        //       (context, url, downloadProgress) =>
                        //       Center(
                        //         child: SizedBox(
                        //           width: 30,
                        //           height: 30,
                        //           child: CircularProgressIndicator(
                        //               value: downloadProgress.progress),
                        //         ),
                        //       ),
                        //   errorWidget: (context, url, error) =>
                        //   const Icon(Icons.error),
                        // ),
                      // )
                         SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isEmpty?'':"${attSummary.empFirstName} ${attSummary.empLastName}",style: latoBold.copyWith(fontSize: 18,color: ColorResources.text50),),
                          Text(isEmpty?'':"${attSummary.jobName}",style: latoRegular.copyWith(fontSize: 14,color: ColorResources.text50),),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // AuthController authController = Get.find();
                      // SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
                      // authController.companyCode.value="";
                      // _sharedPrefs.saveCompanyCode("");
                      Get.toNamed(RouteName.login);
                      // getAttReportSummary(DateFormat('MMM yyy').format(DateTime.now()));
                      // debugPrint("THis is ${attSummary.empFirstName}");
                    },
                    child: SvgPicture.asset('assets/images/bell.svg',color: ColorResources.text50,width: 22,),
                  )

                ],
              ).paddingOnly(top: 40,left: 20,right: 20),
            ),
          ),
          Positioned(
            top: 100,
            child: SizedBox(
              width: context.width,
              child: Card(
                  elevation: 2,
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                        color: ColorResources.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Hello, Morning",style: latoRegular,),
                            Text(DateFormat('hh:mm a').format(DateTime.now()),style: latoBold.copyWith(color: ColorResources.primary700),)
                          ],
                        ),
                        Text(
                          // "Saturday 23 September 2023",
                            DateFormat('EEEE dd MMMM yyyy').format(DateTime.now()),
                          style: latoRegular.copyWith(fontSize: 16),).paddingOnly(top: 22,bottom: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(isEmpty?'-':attSummary.workedDays.toString()),
                                Text("Present")
                              ],
                            ),
                            Column(
                              children: [
                                Text(isEmpty?'-':attSummary.absDays.toString()),
                                Text("Leave")
                              ],
                            ),
                            Column(
                              children: [
                                Text(isEmpty?'-':
                                (attSummary.pDays!+attSummary.nDays!).toString()
                                ),
                                Text("Absent")
                              ],
                            )
                          ],
                        )
                      ],
                    ).paddingAll(22),
                  )
              ).paddingOnly(left: 20,right: 20),
            ),
          )
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(color: Colors.amber,),
          // )
          //Container(color: Colors.amber,)
        ],
      ),
    );
  }
}
