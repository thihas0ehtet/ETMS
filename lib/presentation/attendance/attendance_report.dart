import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/attendance_report_data.dart';
import 'package:etms/presentation/attendance/widget/check_inout_status.dart';
import 'package:etms/presentation/attendance/widget/check_inout_widget.dart';
import 'package:etms/presentation/controllers/attendance_controller.dart';
import 'package:etms/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../../data/datasources/response/attendance_report/att_report_response.dart';
import '../test/save_file_mobile.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReportScreen> {
  DateTime filteredDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  AttendanceController controller = Get.find();
  List<AttReportResponse> attReportList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAttendanceReport(DateFormat('MMM yyy').format(DateTime.now()));
  }

  getAttendanceReport(String inputDate) async {
    // String inputMonth = 'Jan 2023';
    DateTime parsedMonth = DateFormat('MMM yyyy').parse(inputDate);

    // Get the start and end dates of the month
    DateTime startOfMonth = DateTime(parsedMonth.year, parsedMonth.month, 1);
    DateTime endOfMonth = DateTime(parsedMonth.year, parsedMonth.month + 1, 0);
    debugPrint("Start of month is $startOfMonth");
    debugPrint("And end is $endOfMonth");
    debugPrint(DateFormat('dd MMM yyyy').format(startOfMonth));
    debugPrint(DateFormat('dd MMM yyyy').format(endOfMonth));


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
    await controller.getAttendanceReport(data: data);
    setState(() {
      attReportList=controller.attendanceReportList;
    });
  }

  Widget statusCard(String text, String count){
    return Card(
      elevation: 1,
      color: Colors.white,
      child: Container(
          padding: EdgeInsets.only(left: 17,right: 17, top: 12, bottom: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(text=='null'||text==''?'-':text).paddingOnly(bottom: 10),
              Text(count=='null'||count==''?'-':count)
            ],
          )
        // .paddingOnly(left: 10,right: 10,top: 5,bottom: 5),
      ),
    );
  }

  Future<void> generateInvoice() async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219)));
    //Generate PDF grid.
    // List list = [
    //   {
    //     'checkin':'5:04 AM',
    //     'checkout':'6:AM',
    //     'status':'Late',
    //     'lat': 4.9,
    //     'ute': 4.7,
    //     'ot': 5.0
    //   },
    //   {
    //     'checkin':'5:10 AM',
    //     'checkout':'6:20 AM',
    //     'status':'onTime',
    //     'lat': 4.3,
    //     'ute': 1.2,
    //     'ot': 3.0
    //   },
    //   {
    //     'checkin':'5:30 AM',
    //     'checkout':'6:20 AM',
    //     'status':'onTime',
    //     'lat': 4.9,
    //     'ute': 4.7,
    //     'ot': 5.0
    //   }
    // ];
    final PdfGrid grid = getGrid();
    final PdfLayoutResult result = drawHeader(page, pageSize);
    drawGrid(page, grid, result);
    final List<int> bytes = document.saveSync();
    document.dispose();
    await saveAndLaunchFile(bytes, 'attendance-report.pdf');
  }

  PdfGrid getGrid() {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 7);
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Date';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Check In';
    headerRow.cells[2].value = 'Check Out';
    headerRow.cells[3].value = 'Status';
    headerRow.cells[4].value = 'LAT';
    headerRow.cells[5].value = 'UTE';
    headerRow.cells[6].value = 'OT';
    //Add rows
    for(var i =0;i<attReportList.length;i++){
      addData(date: DateTime.parse(attReportList[i].dte!).dMY().toString(), checkIN: attReportList[i].sTIME??'-', checkOut: attReportList[i].eTIME??'-',
          status:!((attReportList[i].lATMIN!>0.0)|| (attReportList[i].eRYOFF!>0.0))?'On Time':'Late',
          lat: attReportList[i].lATMINTIM??'-',ute:attReportList[i].eRYOFFTIM??'-', ot:attReportList[i].otHours??'-',
          grid: grid);
    }
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable2Accent1);
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Draws the invoice header
  PdfLayoutResult drawHeader(PdfPage page, Size pageSize) {

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    final PdfFont contentFontTitle = PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);

    final String etms =
        'ETMS';
    final Size etmsSize = contentFontTitle.measureString(etms);

    final String payslip =
        'Attendance Report (${DateFormat('MMMM yyyy').format(filteredDate)})';
    final Size attReportSize = contentFontTitle.measureString(payslip);

    final double maxTitleWidth = [
      'Department:'.length,
      'Pay Period:'.length,
      'Payment Date:'.length,
    ].map((e) => e * 8.0).reduce((value, element) => value > element ? value : element);

    PdfTextElement(text: etms, font: contentFontTitle, brush: PdfBrushes.darkRed).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (etmsSize.width + 30), 30,
            etmsSize.width + 30, pageSize.height - 120)
    );

    return PdfTextElement(text: payslip, font: contentFontTitle,
        brush: PdfBrushes.darkBlue).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 30,
            0, pageSize.height - 120)
    )!;

  }

  //Draws the grid
  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;

    //Draw grand total.
    // page.graphics.drawString('Grand Total',
    //     PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
    //     bounds: Rect.fromLTWH(
    //         quantityCellBounds!.left,
    //         result.bounds.bottom + 10,
    //         quantityCellBounds!.width,
    //         quantityCellBounds!.height));
    // page.graphics.drawString(getTotalAmount(grid).toString(),
    //     PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
    //     bounds: Rect.fromLTWH(
    //         totalPriceCellBounds!.left,
    //         result.bounds.bottom + 10,
    //         totalPriceCellBounds!.width,
    //         totalPriceCellBounds!.height));
  }

  void addData({required String date, required String checkIN, required String checkOut,
    required String status, required String lat, required String ute, required String ot, required PdfGrid grid}) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = date;
    row.cells[1].value = checkIN;
    row.cells[2].value = checkOut;
    row.cells[3].value = status;
    row.cells[4].value = lat.toString()==''?'-':lat.toString();
    row.cells[5].value = ute.toString()==''?'-':ute.toString();
    row.cells[6].value = ot.toString()==''?'-':ot.toString();
  }

  bool isWeekEnd(String date){
    DateTime dateTime=DateTime.parse(date);
    return dateTime.weekday == DateTime.saturday || dateTime.weekday == DateTime.sunday;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorResources.background,
          appBar: MyAppBar(title: 'Attendance Report',
              widget: InkWell(
                onTap: (){
                  // PdfGeneratorView();
                  generateInvoice();
                },
                child: Icon(Icons.download),
              )
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FilterWidget(
                    onDateTimeChanged: (DateTime newDate){
                      setState(() {
                        _selectedDate = newDate;
                      });
                    },
                    onFilterConfirm: (){
                      setState(() {
                        filteredDate=_selectedDate;
                      });
                      Navigator.pop(context);
                      getAttendanceReport(DateFormat('MMM yyyy').format(filteredDate).toString());
                    },
                    filteredDateWidget: Text(DateFormat('yyyy / MMMM').format(filteredDate),style: latoRegular,)
                ),
                if(attReportList.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemCount: attReportList.length,
                      itemBuilder: (context,index){
                        bool checkInLate = attReportList[index].lATMIN!>0.0;
                        bool checkOutLate = attReportList[index].eRYOFF!>0.0;
                        return GestureDetector(
                          onTap: (){
                            if(!(attReportList[index].sTIME==null || attReportList[index].eTIME==null)) {
                              showDialog(
                              // barrierColor: ColorResources.background,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: ColorResources.background,
                                    content: Container(
                                      // height: 300,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(DateFormat('MMMM dd, yyyy').format(DateTime.parse(attReportList[index].dte.toString())).toString(),style: latoBold,),
                                                CheckInOutStatus(isOnTime: !((attReportList[index].lATMIN!>0.0)|| (attReportList[index].eRYOFF!>0.0)))
                                              ],
                                            ).paddingOnly(bottom: 20),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start  ,
                                              children: [
                                                Expanded(
                                                  child: CheckInOutWidget(
                                                      isCheckIn: true,
                                                      isOnTime: !(attReportList[index].lATMIN!>0.0),
                                                      checkInOutTime:
                                                      attReportList[0].sTIME==null?'-':
                                                      DateFormat('hh:mm a').format(DateTime.parse(attReportList[index].sTIME.toString())).toString()
                                                  ).paddingOnly(right: 10),
                                                ),
                                                Expanded(child:
                                                CheckInOutWidget(
                                                    isCheckIn: false,
                                                    isOnTime: !(attReportList[index].eRYOFF!>0.0),
                                                    checkInOutTime:
                                                    attReportList[0].eTIME==null?'-':
                                                    DateFormat('hh:mm a').format(DateTime.parse(attReportList[index].eTIME.toString())).toString()
                                                )),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                statusCard('LAT', attReportList[0].lATMINTIM.toString()),
                                                statusCard('UTE', attReportList[0].eRYOFFTIM.toString()),
                                                statusCard('OT ', attReportList[0].otHours.toString())
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  );
                                });
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: Container(
                              color: ColorResources.white,
                              constraints: BoxConstraints(
                                  maxHeight: 100
                              ),
                              child:Stack(
                                children: [
                                  if(attReportList[index].remarks!=null)
                                  Align(
                                    alignment: Alignment.topRight,
                                    child:
                                    SvgPicture.asset('assets/images/remark.svg',width: 25,height: 25,
                                                color: ColorResources.primary500,).paddingOnly(right: 25),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          width: 20,
                                          height: 100,
                                          // height: context.height,
                                          decoration: BoxDecoration(
                                            color: isWeekEnd(attReportList[index].dte!)?ColorResources.secondary700:!checkInLate&&!checkOutLate?ColorResources.green:ColorResources.red,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                          ),
                                          child:

                                          RotatedBox(
                                              quarterTurns: 3,
                                              child: new Text(isWeekEnd(attReportList[index].dte!)?'':!checkInLate&&!checkOutLate?'OnTime':'Late', textAlign: TextAlign.center,
                                                  style: latoRegular.copyWith(color: ColorResources.white))
                                          )

                                        // Expanded(child:
                                        // Text(!checkInLate&&!checkOutLate?'OnTime':'Late',
                                        // style: latoRegular.copyWith(color: ColorResources.white),)
                                        // ),
                                      ).paddingOnly(right: 20),
                                      SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(DateFormat('MMMM dd, yyyy').format(DateTime.parse(attReportList[index].dte.toString())).toString(),style: latoBold,)
                                                .paddingOnly(bottom: 20),

                                            Row(
                                              children: [
                                                SvgPicture.asset('assets/images/check-in.svg',width: 22,height: 22,
                                                  color: ColorResources.black,).paddingOnly(right: 10),
                                                // Icon(Icons.login, color: ColorResources.black,).paddingOnly(right: 10),
                                                Text(
                                                    attReportList[index].sTIME==null?'-':
                                                    DateFormat('hh:mm a').format(DateTime.parse(attReportList[index].sTIME.toString())).toString()).paddingOnly(right: 20),
                                                SvgPicture.asset('assets/images/check-out.svg',width: 22,height: 22,
                                                  color: ColorResources.black,).paddingOnly(right: 10),
                                                Text(
                                                    attReportList[index].eTIME==null?'-':
                                                    DateFormat('hh:mm a').format(DateTime.parse(attReportList[index].eTIME.toString())).toString()).paddingOnly(right: 20),

                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ),
                          ).paddingOnly(bottom: 10),
                        );
                      }
                  ),
                )
                    .paddingOnly(top: 20),
              ],
            ).paddingAll(19),
          )
              // .paddingOnly(left: 10, right: 10, top:15, bottom: 15),
        )
    );
  }
}
