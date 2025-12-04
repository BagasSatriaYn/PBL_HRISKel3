import 'package:go_router/go_router.dart';

import '../features/splash/screens/splash_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/login/screens/login_screen.dart';
import '../features/login/screens/forgot_password_page.dart';

import '../features/superior/screens/superior_screen.dart';

import '../features/dashboard/screens/admin_dashboard_screen.dart';
import '../features/dashboard/screens/employee_dashboard_screen.dart';

// Tambahan halaman employee
import '../features/employee/screens/employee_salary_screen.dart';
import '../features/employee/screens/employee_attendance_screen.dart';
import '../features/employee/screens/employee_report_screen.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [

      // ======================
      // AUTH
      // ======================
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // ======================
      // DASHBOARD ADMIN
      // ======================
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) => const AdminDashboard(),
      ),

      // ======================
      // DASHBOARD EMPLOYEE
      // ======================
      GoRoute(
        path: '/employee-dashboard',
        builder: (context, state) => const EmployeeDashboard(),
      ),

      // ======================
      // EMPLOYEE FEATURES
      // ======================
      GoRoute(
        path: '/employee/salary',
        builder: (context, state) => const EmployeeSalaryScreen(),
      ),
      GoRoute(
        path: '/employee/attendance',
        builder: (context, state) => const EmployeeAttendanceScreen(),
      ),
      GoRoute(
        path: '/employee/report',
        builder: (context, state) => const EmployeeReportScreen(),
      ),

      // ======================
      // OTHER PAGES
      // ======================
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/superior',
        builder: (context, state) => const SuperiorScreen(),
      ),
    ],
  );
}
