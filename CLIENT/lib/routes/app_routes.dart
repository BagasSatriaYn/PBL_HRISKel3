import 'package:go_router/go_router.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/login/screens/login_screen.dart';
import '../features/superior/screens/superior_screen.dart';
import '../features/dashboard/screens/admin_dashboard_screen.dart';
import '../features/dashboard/screens/employee_dashboard_screen.dart';
import '../features/login/screens/forgot_password_page.dart';
import '../features/dashboard/screens/landing_screen.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Landing Page Route - Halaman pertama yang dibuka
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingScreen(),
      ),
      
      // Login Route
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      
      // Admin Dashboard Route
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) => const AdminDashboard(),
      ),
      
      // Employee Dashboard Route
      GoRoute(
        path: '/employee-dashboard',
        builder: (context, state) => const EmployeeDashboard(),
      ),
      
      // Forgot Password Route
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      
      // Home Route
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Superior Route
      GoRoute(
        path: '/superior',
        builder: (context, state) => const SuperiorScreen(),
      ),
    ],
  ); // GoRouter
}