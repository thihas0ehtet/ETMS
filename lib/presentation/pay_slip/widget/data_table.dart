import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/config.dart';

Widget DataTableWidget({
  TableBorder? border, horizontalMargin=4,
  int? columnSpacing,
  MaterialStateColor? headingRowColor,
  List<DataColumn>? columns,
  List<DataRow>? rows,
  required List<dynamic> dataList,
  required BuildContext context,
  required bool isAllowance,
  required String total
}
    ){
  return  DataTable(
    // border: TableBorder.all(),
    horizontalMargin: 4,
    columnSpacing: 30,
    headingRowColor:   MaterialStateColor.resolveWith((states) => ColorResources.primary200),
    columns: <DataColumn>[
      DataColumn(
        label: Expanded(
          child: Text(
            'Description',
            textAlign: TextAlign.center,
            style: latoRegular,
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Amount',
            textAlign: TextAlign.center,
            style: latoRegular,
          ),
        ),
      ),
    ],
    rows:
    List.generate(
        dataList.length+1,
            (index) =>
            index==dataList.length?
            DataRow(
              color: MaterialStateProperty.all<Color>(ColorResources.white),
              cells: <DataCell>[
                DataCell(
                    SizedBox(
                        width: context.width*0.6-40,
                        child: Text(isAllowance?'Total Additions':'Total Deductions',
                          textAlign: TextAlign.right,))),
                DataCell(
                    SizedBox(
                        width: context.width*0.4-40,
                        child: Text(total, textAlign: TextAlign.right))),
              ],
            ):
            DataRow(
              color: MaterialStateProperty.all<Color>(index%2==0?ColorResources.white:ColorResources.primary50),
              cells: <DataCell>[
                DataCell(
                    SizedBox(
                        width: context.width*0.6-40,
                        child: Text(isAllowance?dataList[index].allowanceName.toString():dataList[index].deductionName.toString()))),
                DataCell(
                    SizedBox(
                        width: context.width*0.4-40,
                        child: Text(isAllowance?dataList[index].allowanceAmount.toString():dataList[index].deductionAmount.toString(), textAlign: TextAlign.right))),
              ],
            )
    ),
  );
}