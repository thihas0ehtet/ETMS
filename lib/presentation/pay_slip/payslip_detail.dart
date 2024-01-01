import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/payroll_detail_data.dart';
import 'package:etms/data/datasources/response/payslip/payslip_allowance_response.dart';
import 'package:etms/data/datasources/response/payslip/payslip_deduciton_response.dart';
import 'package:etms/presentation/pay_slip/widget/data_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../app/config/config.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../../data/datasources/response/payslip/payroll_detail_response.dart';
import '../controllers/payslip_controller.dart';
import '../test/save_file_mobile.dart';
import '../widgets/my_app_bar.dart';

class PaySlipDetail extends StatefulWidget {
  const PaySlipDetail({super.key});

  @override
  State<PaySlipDetail> createState() => _PaySlipDetailState();
}

class _PaySlipDetailState extends State<PaySlipDetail> {
  PaySlipController controller = Get.find();
  PayrollDetailResponse? detail;
  List<PayslipAllowanceResponse> allowanceList = [];
  List<PayslipDeductionResponse> deductionList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData()async{
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;
    PayrollDetailData data = PayrollDetailData(
        empSysId: sysId,
        unitId: '0',
        id: Get.arguments.toString()
    );
    await controller.getPayDetail(data);
    setState(() {
      detail=controller.payDetail.value;
    });

    await controller.getPayslipAllowance(data);
    setState(() {
      allowanceList=controller.payslipAllowList;
    });

    await controller.getPayslipDeduction(data);
    setState(() {
      deductionList=controller.payslipDedList;
    });
  }


  Widget widgetInfo(String title, String info){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: latoRegular.copyWith(color: ColorResources.text300),),
        Text(info,style: latoRegular.copyWith(color: ColorResources.text500),)
      ],
    ).paddingOnly(bottom: 15);
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
    final PdfGrid additionGrid = getGrid(page: page, isAddition: true);
    final PdfGrid deductionGrid = getGrid(page: page, isAddition: false);

    final PdfLayoutResult result = drawHeader(page, pageSize);
    final PdfLayoutResult result1 = drawGrid('ADDITIONS',page, additionGrid, result);
    final PdfLayoutResult result2  = drawGrid('DEDUCTIONS',page, deductionGrid, result1);
    drawSummary(page, result2);


    //Save the PDF document
    final List<int> bytes = document.saveSync();
    //Dispose the document.
    document.dispose();
    //Save and launch the file.
    await saveAndLaunchFile(bytes, 'payslip.pdf');
  }
  //Draws the invoice header
  PdfLayoutResult drawHeader(PdfPage page, Size pageSize) {

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    final PdfFont contentFontTitle = PdfStandardFont(PdfFontFamily.helvetica, 15, style: PdfFontStyle.bold);

    final String etms =
        'ETMS';
    final Size etmsSize = contentFontTitle.measureString(etms);

    final String payslip =
        'Payslip (Strictly Private & Confidential)';
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

    PdfTextElement(text: payslip, font: contentFontTitle,
        brush: PdfBrushes.darkBlue).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 30,
            0, pageSize.height - 120)
    );

    PdfTextElement(text: 'Department:', font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 80,
            maxTitleWidth, pageSize.height - 160)
    );
    PdfTextElement(text: detail!.unitPath.toString(), font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTRB(130, 80,
            0, pageSize.height - 160)
    );

    PdfTextElement(text: 'Payment Period:', font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 100,
            maxTitleWidth, pageSize.height - 140)
    );
    PdfTextElement(text: '${DateTime.parse(detail!.periodStart.toString()).dMY()} To ${DateTime.parse(detail!.periodEnd.toString()).dMY()}', font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTRB(130, 100,
            0, pageSize.height - 140)
    );
    PdfTextElement(text: 'Payment Date: ', font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            maxTitleWidth, pageSize.height - 120)
    );
    PdfTextElement(text: DateTime.parse(detail!.payDate.toString()).dMY().toString() , font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTRB(130, 120,
            0, pageSize.height - 120)
    );
    PdfTextElement(text: 'Staff Name:  ', font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 140,
            maxTitleWidth, pageSize.height - 100)
    );
    PdfTextElement(text: detail!.empName.toString(), font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTRB(130, 140,
            0, pageSize.height - 100)
    );
    PdfTextElement(text: 'NRIC/FIN: ', font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 160,
            maxTitleWidth, pageSize.height - 80)
    );
    return PdfTextElement(text: detail!.finNumber.toString()==''?'-':detail!.finNumber.toString(), font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTRB(130, 160,
            0, pageSize.height - 80)
    )!;

  }

  void drawSummary(PdfPage page, PdfLayoutResult result){
    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

    final double maxTitleWidth = [
      'Net Pay'.length,
      "Employee's cpf".length,
      'Total cpf'.length,
    ].map((e) => e * 8.0).reduce((value, element) => value > element ? value : element);

    page.graphics.drawString('Net Pay', PdfStandardFont(PdfFontFamily.helvetica, 9),
        bounds: Rect.fromLTWH(30, result.bounds.bottom + 25, 0, 0)
    );
    page.graphics.drawString(detail!.netAmount.toString(), PdfStandardFont(PdfFontFamily.helvetica, 9),
        bounds: Rect.fromLTWH(maxTitleWidth+30, result.bounds.bottom + 25, 0, 0)
    );

    page.graphics.drawString("Employee's cpf", PdfStandardFont(PdfFontFamily.helvetica, 9),
        bounds: Rect.fromLTWH(30, result.bounds.bottom + 40, 0, 0)
    );
    page.graphics.drawString(detail!.employerContribution??'-', PdfStandardFont(PdfFontFamily.helvetica, 9),
        bounds: Rect.fromLTWH(maxTitleWidth+30, result.bounds.bottom + 40, 0, 0)
    );

    page.graphics.drawString("Total cpf", PdfStandardFont(PdfFontFamily.helvetica, 9),
        bounds: Rect.fromLTWH(30, result.bounds.bottom + 55, 0, 0)
    );
    page.graphics.drawString(detail!.totalContribution??'-', PdfStandardFont(PdfFontFamily.helvetica, 9),
        bounds: Rect.fromLTWH(maxTitleWidth+30, result.bounds.bottom + 55, 0, 0)
    );

  }

  //Draws the grid
  PdfLayoutResult drawGrid(String title, PdfPage page, PdfGrid grid, PdfLayoutResult result) {
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
    page.graphics.drawString(title, PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(30, result.bounds.bottom + 25, 0, 0)
    );
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(30, result.bounds.bottom + 40, 0, 0))!;
    return result;
  }

  PdfGrid getGrid({required PdfPage page, required bool isAddition}) {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 2);
    grid.draw( page: page,
        bounds: Rect.fromLTRB(100, 160,
            0, 0));
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Description';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Amount';
    if(isAddition){
      for(var i =0;i<allowanceList.length;i++){
        addProducts(allowanceList[i].allowanceName.toString(),
            allowanceList[i].allowanceAmount.toString(), grid);
      }
      addProducts('Total Additions',
          detail!.totalAllowance.toString(), grid);
    } else{
      for(var i =0;i<deductionList.length;i++){
        addProducts(deductionList[i].deductionName.toString(),
            deductionList[i].deductionAmount.toString(), grid);
      }
      addProducts('Total Deductions',
          detail!.totalDeduction.toString(), grid);
    }

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable3Accent1);
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 15, right:15, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 15, right: 15, top: 5);
      }
    }
    return grid;
  }

  void addProducts(String description, String amount,PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    grid.columns[0].width=150;
    grid.columns[1].width=100;
    row.cells[0].value = description;
    row.cells[1].value = amount;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorResources.secondary500,
        appBar:  MyAppBar(
          title: 'Payroll Summary',
          widget: InkWell(
            onTap: (){
              // PdfGeneratorView();
              generateInvoice();
            },
            child: Icon(Icons.download),
          )
        ),
        body: SingleChildScrollView(
          child: detail!=null?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15,),
              Center(child: Text('Strictly Private & Confidential', style: latoBold.copyWith(fontSize: 15),)),
              const SizedBox(height: 25,),
              widgetInfo('Department', detail!.unitPath.toString()),
              widgetInfo('Pay Period', '${DateTime.parse(detail!.periodStart.toString()).dMY()} To ${DateTime.parse(detail!.periodEnd.toString()).dMY()}'),
              widgetInfo('Payment Date', DateTime.parse(detail!.payDate.toString()).dMY().toString()),
              widgetInfo('Staff Name', detail!.empName.toString()),
              widgetInfo('NRIC/FIN', detail!.finNumber.toString()==''?'-':detail!.finNumber.toString()),

              const SizedBox(height: 20,),

              if(allowanceList.isNotEmpty)
              Text('ADDITIONS',style: latoSemibold).paddingOnly(bottom: 5),
              if(allowanceList.isNotEmpty)
                DataTableWidget(
                    dataList: allowanceList,
                    context: context,
                    isAllowance: true,
                  total: detail!.totalAllowance.toString()
                ).paddingOnly(bottom: 25),

              if(deductionList.isNotEmpty)
                Text('DEDUCTIONS',style: latoSemibold).paddingOnly(bottom: 5),
              if(deductionList.isNotEmpty)
                DataTableWidget(
                    dataList: deductionList,
                    context: context,
                    isAllowance: false,
                    total: detail!.totalDeduction.toString()
                ).paddingOnly(bottom: 25),

              widgetInfo('Net Pay', detail!.netAmount.toString()),
              widgetInfo("Employee's cpf", detail!.employerContribution??'-'),
              widgetInfo("Total cpf", detail!.totalContribution??'-'),
            ],
          ).paddingOnly(left: 20, right: 20)
              :Container(),
        ),
      ),
    );
  }
}
