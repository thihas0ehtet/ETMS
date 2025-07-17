import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/presentation/apply_leave/leave_calendar/event_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/datasources/shared_preference_helper.dart';
import '../../../data/datasources/request/leave/leave_status_data.dart';
import '../../../data/datasources/response/apply_leave/leave_list_response.dart';
import '../../../data/datasources/response/apply_leave/leave_status_response.dart';
import '../../controllers/leave_controller.dart';
import '../../widgets/my_app_bar.dart';
import 'utils.dart';
import 'table_calendar.dart';
import 'customization/calendar_style.dart';

class LeaveCalenderView extends StatefulWidget {
  const LeaveCalenderView({super.key});

  @override
  _LeaveCalenderViewState createState() => _LeaveCalenderViewState();
}

class _LeaveCalenderViewState extends State<LeaveCalenderView> {
  LeaveController controller = Get.find();
  late final ValueNotifier<List<LeaveStatusResponse>> _selectedEvents;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Map<dynamic, List<LeaveStatusResponse>> kEventsData = {};

  // LinkedHashMap<DateTime, List<Event>>? kEvents12;

  @override
  void initState() {
    super.initState();

    handleGetData();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Color generateColor(String text) {
    if (text.toLowerCase() == 'pending') {
      return ColorResources.yellow;
    } else if (text.toLowerCase().contains('reject')) {
      return ColorResources.red;
    }
    return ColorResources.green;
  }

  Color generateTextColor(String text) {
    if (text.toLowerCase() == 'pending') {
      return Colors.black;
    }
    return ColorResources.white;
  }

  // void addEventData(){
  //   final kEventSource = { for (var item in List.generate(50, (index) => index)) DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5) : List.generate(
  //           item % 4 + 1, (index) => Event('Event $item | ${index + 1}')) }
  //     ..addAll({
  //       kToday: [
  //         const Event('Today\'s Event 1'),
  //         const Event('Today\'s Event 2'),
  //       ],
  //     });
  // }

  List<LeaveStatusResponse> _getEventsForDay(DateTime day) {
    String startOfMonth = DateTime(day.year, day.month, 1).dMY().toString();
    String date = DateFormat('dd-MMM-yyyy').format(day);
    return kEventsData[date] ?? [];
  }

  // List<Event> _getEventsForRange(DateTime start, DateTime end) {
  //   // Implementation example
  //   final days = daysInRange(start, end);
  //
  //   return [
  //     for (final d in days) ..._getEventsForDay(d),
  //   ];
  // }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  getData(String inputDate) async {
    // DateTime parsedMonth = DateFormat('yyyy / MMMM').parse(inputDate);
    // DateTime startOfMonth = DateTime(parsedMonth.year, parsedMonth.month, 1);

    SharedPreferenceHelper sharedPrefs = Get.find<SharedPreferenceHelper>();
    String sysId = await sharedPrefs.getEmpSysId;
    LeaveStatusData leaveStatusData =
        LeaveStatusData(empSysId: sysId, selectDate: inputDate);

    await controller.getLeaveStatusList(data: leaveStatusData);
    setState(() {
      kEventsData = controller.kEvents;
    });
  }

  handleGetData() {
    String startOfMonth =
        DateTime(_focusedDay.year, _focusedDay.month, 1).dMY().toString();

    getData(startOfMonth);
  }

  // void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
  //   setState(() {
  //     _selectedDay = null;
  //     _focusedDay = focusedDay;
  //     _rangeStart = start;
  //     _rangeEnd = end;
  //     _rangeSelectionMode = RangeSelectionMode.toggledOn;
  //   });
  //
  //   // `start` or `end` could be null
  //   if (start != null && end != null) {
  //     _selectedEvents.value = _getEventsForRange(start, end);
  //   } else if (start != null) {
  //     _selectedEvents.value = _getEventsForDay(start);
  //   } else if (end != null) {
  //     _selectedEvents.value = _getEventsForDay(end);
  //   }
  // }

  Widget statusWiget(String text, Color color) {
    return Expanded(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.circle,
            color: color,
            size: 12,
          ).paddingOnly(right: 8),
          Expanded(child: Text(text))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      appBar: MyAppBar(title: 'Leave Calendar'),
      body: Column(
        children: [
          Material(
            elevation: 2,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5)),
            color: ColorResources.white,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  statusWiget('Pending', ColorResources.yellow),
                  statusWiget('Approved', ColorResources.green),
                  statusWiget('Reject', ColorResources.red),
                ],
              ).paddingAll(10),
            ).paddingOnly(left: 10, right: 10),
          ).paddingOnly(left: 20, right: 20),
          TableCalendar<LeaveStatusResponse>(
            // rowHeight: _getEventsForDay1.length.toDouble(),
            rowHeight: 45,
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                  color: ColorResources.secondary700, shape: BoxShape.circle),
              todayDecoration: BoxDecoration(
                  color: ColorResources.primary500, shape: BoxShape.circle),
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
              // markerDecoration: BoxDecoration(
              //   color: Colors.green,
              //   // color: ((_getEventsForDay as List<Event>).length%2)==0?Colors.green:Colors.red,
              //   shape: BoxShape.circle
              // )
            ),
            onDaySelected: _onDaySelected,
            // onRangeSelected: _onRangeSelected,
            // onFormatChanged: (format) {
            //   if (_calendarFormat != format) {
            //     setState(() {
            //       _calendarFormat = format;
            //     });
            //   }
            // },
            onPageChanged: (focusedDay) {
              // String parsedMonth = DateFormat('yyyy / MMMM').format(focusedDay);
              String startOfMonth =
                  DateTime(focusedDay.year, focusedDay.month, 1)
                      .dMY()
                      .toString();
              _focusedDay = focusedDay;
              getData(startOfMonth);
            },
          ),
          const SizedBox(height: 8.0),
          const Divider(
            thickness: 1,
          ),
          Expanded(
            child: ValueListenableBuilder<List<LeaveStatusResponse>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    LeaveStatusResponse data = value[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        // horizontal: 12.0,
                        vertical: 2.0,
                      ),
                      color: ColorResources.white,
                      // decoration: BoxDecoration(
                      //   border: Border.all(),
                      //   borderRadius: BorderRadius.circular(12.0),
                      // ),
                      child: GestureDetector(
                        onTap: () => debugPrint('${value[index]}'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.leaveTypeName.toString(),
                                    softWrap: true,
                                    // overflow: TextOverflow.ellipsis,
                                    style: latoSemibold.copyWith(fontSize: 15),
                                  ).paddingOnly(bottom: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          DateTime.parse(
                                                  data.leaveDate.toString())
                                              .dMYE()
                                              .toString(),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ).paddingOnly(bottom: 5),
                                  Text(
                                    '(${data.halfType})',
                                    style: latoRegular.copyWith(
                                        color: ColorResources.primary500),
                                  )
                                  // Text('(Evening-half)',
                                  //   style: latoRegular.copyWith(color: ColorResources.primary500),)
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 4, bottom: 4),
                              decoration: BoxDecoration(
                                  color: generateColor(data.status.toString()),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Text(
                                data.status.toString(),
                                style: latoRegular.copyWith(
                                    color: generateTextColor(
                                        data.status.toString())),
                              ),
                            ),
                          ],
                        ).paddingOnly(left: 20, right: 20, top: 5, bottom: 5),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
