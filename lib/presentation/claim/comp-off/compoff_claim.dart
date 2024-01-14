import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/claim/compoff_request_data.dart';
import 'package:etms/presentation/controllers/claim_controller.dart';
import 'package:etms/presentation/widgets/custom_button.dart';
import 'package:etms/presentation/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../app/helpers/shared_preference_helper.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _workedDateController.text=DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
  }
  Widget showDatePickAlert(){
    String pickedDate=_workedDateController.text;
    return AlertDialog(
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
                  showActionButtons: true,
                  selectionMode: DateRangePickerSelectionMode.single,
                  confirmText: 'OK',
                  cancelText: 'Cancel',
                  onSubmit: (value){
                    if(value is DateTime){
                      setState(() {
                        _workedDateController.text=DateFormat('dd/MM/yyyy').format(value).toString();
                      });
                    }
                    Navigator.pop(context);
                  },
                  onCancel: (){
                    Navigator.pop(context);
                  },
                ),
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
          appBar: MyAppBar(title: 'Comp-Off'),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Comp Off Request Form', style: latoMedium.copyWith(fontSize: 17),),
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
                      // Icon(Icons.calendar_month, color: ColorResources.black,)
                    ),
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (context) {
                          return showDatePickAlert();
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
                  // isLate!?'Why are you late?':'Why are you too early?',
                  maxLine: 3,
                ),
                SizedBox(height: 20,),
                CustomButton(
                    onTap: () async{
                      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
                      String sysId= await _sharedPrefs.getEmpSysId;
                      String attendance = DateTime.parse(DateFormat('dd/MM/yyyy').parse(_workedDateController.text).toString()).dMY().toString();
                      CompOffRequestData requestData = CompOffRequestData(
                        empSysId: sysId,
                        attDate: attendance,
                        remark: remarkController.text,
                        duration: "0.5"
                      );
                      await controller.requestCompOff(data: requestData);
                    }, text: 'Submit')
              ],
            ).paddingOnly(left: 20, right: 20 ,top: 15, bottom: 15),
          ),
        ));
  }
}
