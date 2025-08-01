import 'package:etms/app/app_binding.dart';
import 'package:etms/app/route/route_name.dart';
import 'package:etms/presentation/apply_leave/apply_leave_page.dart';
import 'package:etms/presentation/apply_leave/leave_calendar/leave_calendar_view.dart';
import 'package:etms/presentation/approval/leave_approval/leave_proposal_detail.dart';
import 'package:etms/presentation/approval/approval_page.dart';
import 'package:etms/presentation/attendance/attendance_report.dart';
import 'package:etms/presentation/attendance/attendance_screen.dart';
import 'package:etms/presentation/attendance/widget/scan_qr.dart';
import 'package:etms/presentation/claim/claim.dart';
import 'package:etms/presentation/claim/comp-off/compoff_claim.dart';
import 'package:etms/presentation/claim/ot/ot_claim_list.dart';
import 'package:etms/presentation/claim/ot/ot_history.dart';
import 'package:etms/presentation/claim/other_claim/other_claim_history.dart';
import 'package:etms/presentation/claim/other_claim/other_claim_request_view.dart';
import 'package:etms/presentation/pay_slip/payslip_detail.dart';
import 'package:etms/presentation/pay_slip/payslip_period_screen.dart';
import 'package:etms/presentation/profile/next_kin_edit.dart';
import 'package:etms/presentation/profile/profile_edit.dart';
import 'package:etms/presentation/auth/login.dart';
import 'package:etms/presentation/auth/reset_password.dart';
import 'package:etms/presentation/dashboard.dart';
import 'package:etms/presentation/menu/menu.dart';
import 'package:etms/presentation/splash_screen.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class AppPages {
  static const initial = RouteName.splash;

  static final routes = [
    GetPage(
      name: RouteName.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
        name: RouteName.login,
        page: () => const LoginScreen()
    ),
    GetPage(
        name: RouteName.dashboard,
        page: () => const DashboardScreen()
    ),
    GetPage(
        name: RouteName.menu,
        page: () => const MenuScreen()
    ),
    GetPage(
        name: RouteName.attendanceScreen,
        page: () => const AttendanceScreen()
    ),
    GetPage(
        name: RouteName.attendanceReport,
        page: () => const AttendanceReportScreen()
    ),
    GetPage(
        name: RouteName.applyLeave,
        page: () => const ApplyLeavePage()
    ),
    GetPage(
        name: RouteName.payslip_period,
        page: () => const PaySlipPeriodScreen()
    ),
    GetPage(
        name: RouteName.payslip_detail,
        page: () => const PaySlipDetail()
    ),
    GetPage(
        name: RouteName.profile_edit,
        page: () => const ProfileEditView()
    ),
    GetPage(
        name: RouteName.next_kin_edit,
        page: () => const NextOfKinEditView()
    ),
    GetPage(
        name: RouteName.leave_calendar,
        page: () => LeaveCalenderView()
    ),
    GetPage(
        name: RouteName.reset_password,
        page: () => ResetPasswordView()
    ),
    GetPage(
        name: RouteName.qrScan,
        page: () => ScanQRView()
    ),
    GetPage(
        name: RouteName.claim,
        page: () => ClaimScreen()
    ),
    GetPage(
        name: RouteName.otClaimList,
        page: () => OtClaimListView()
    ),
    GetPage(
        name: RouteName.compOffClaim,
        page: () => CompOffClaimView()
    ),
    GetPage(
        name: RouteName.otHistory,
        page: () => OTHistoryView()
    ),
    // GetPage(
    //     name: RouteName.leaveProposalDetail,
    //     page: () => LeaveProposalDetailView()
    // ),
    GetPage(
        name: RouteName.approval,
        page: () => ApprovalPage()
    ),
    GetPage(
        name: RouteName.other_claim,
        page: () => OtherClaimRequestView()
    ),
    GetPage(
        name: RouteName.other_claim_history,
        page: () => OtherClaimHistoryView()
    ),
  ];
}