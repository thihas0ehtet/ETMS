import 'package:etms/data/repositories/claim_repo_impl.dart';
import 'package:etms/presentation/controllers/claim_controller.dart';
import 'package:etms/presentation/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/config.dart';
import '../../app/route/route_name.dart';

class ClaimScreen extends StatefulWidget {
  const ClaimScreen({super.key});

  @override
  State<ClaimScreen> createState() => _ClaimScreenState();
}

class _ClaimScreenState extends State<ClaimScreen> {
  ClaimController controller = Get.find();
  bool otVisible = false;
  bool leaveCompOffVisible = false;
  bool otherVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async{
    bool otSuccess = await controller.checkClaimVisible(type: ClaimType.ot);
    setState(() {otVisible = otSuccess;});

    bool leaveCompOffSuccess = await controller.checkClaimVisible(type: ClaimType.leave);
    setState(() {leaveCompOffVisible = leaveCompOffSuccess;});

    bool otherSuccess = await controller.checkClaimVisible(type: ClaimType.other);
    setState(() { otherVisible = otherSuccess;});
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
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorResources.white,
          appBar: MyAppBar(title: 'Claim'),
          body: Column(
            children: [
              if(otVisible)
              GestureDetector(
                onTap: ()=> Get.toNamed(RouteName.otClaimList),
                child: cardView(
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('OT Claim'),
                        SizedBox(
                            height: 20,
                            child: Icon(Icons.arrow_forward_ios, size: 17, color: ColorResources.primary800)).paddingOnly(right: 10)
                      ],
                    )
                ),
              ),
              if(leaveCompOffVisible)
              GestureDetector(
                onTap: ()=> Get.toNamed(RouteName.compOffClaim),
                child: cardView(
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Comp-Off Claim'),
                        SizedBox(
                            height: 20,
                            child: Icon(Icons.arrow_forward_ios, size: 17, color: ColorResources.primary800)).paddingOnly(right: 10)
                      ],
                    )
                ),
              ),
              if(otherVisible)
              GestureDetector(
                onTap: ()=> Get.toNamed(RouteName.other_claim),
                child: cardView(
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Other Claim'),
                        SizedBox(
                            height: 20,
                            child: Icon(Icons.arrow_forward_ios, size: 17, color: ColorResources.primary800)).paddingOnly(right: 10)
                      ],
                    )
                ),
              ),
            ],
          ).paddingOnly(left: 20, right: 20, top: 15,bottom: 15),
        ));
  }
}
