import 'dart:collection';

import '../../../data/datasources/response/apply_leave/leave_status_response.dart';


/// Example event class.
// class Event {
//   final String title;
//
//   const Event(this.title);
//
//   @override
//   String toString() => title;
// }

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
// final kEvents = <DateTime, List<LeaveStatusResponse>>{}..addAll(_kEventSource);

// final _kEventSource = { for (var item in List.generate(50, (index) => index)) DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5) : List.generate(
//         item % 4 + 1, (index) => Event('Event $item | ${index + 1}')) }
//   ..addAll({
//     kToday: [
//       const Event('Today\'s Event 1'),
//       const Event('Today\'s Event 2'),
//     ],
//   })
// ;

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
// final kFirstDay = DateTime.now();
final kLastDay = DateTime.now();
final kFirstDay = DateTime(2008, 1,1);
// final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
