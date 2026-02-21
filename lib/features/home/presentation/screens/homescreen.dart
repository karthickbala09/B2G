import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/screens/login_screen.dart';

import '../../../event/presentation/bloc/event_bloc.dart';
import '../../../event/presentation/presentation/event_screen.dart';
import '../../../event/presentation/presentation/participate_screen.dart';
import '../../../event/presentation/presentation/dashboard_screen.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9FB),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {

            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeError) {
              return Center(child: Text(state.message));
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ================= HEADER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back,👋",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "Opportunity Engine",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff2D3142),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          context.read<AuthBloc>().add(LogoutEvent());

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                                (route) => false,
                          );
                        },
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Icon(Icons.logout,
                              size: 20.sp, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  /// ================= EXACT ORIGINAL BANNER =================
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(25.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffC86DD7),
                          Color(0xff3023AE)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff3023AE)
                              .withOpacity(0.3),
                          blurRadius: 20.r,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius:
                                  BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  "New Update",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp),
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Text(
                                "Create & Manage\nEvents Easily",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "Host hackathons, workshops,\nand contests in one place.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 80.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 40.sp),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),

                  Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff2D3142),
                    ),
                  ),

                  SizedBox(height: 15.h),

                  /// ================= GRID =================
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.h,
                    childAspectRatio: 1.1,
                    children: [

                      _buildActionCard(
                        title: "Create Event",
                        icon: Icons.add_circle_outline,
                        color: const Color(0xffC86DD7),
                        cmd: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<EventBloc>(),
                                child: const CreateEventScreen(),
                              ),
                            ),
                          );
                        },
                      ),

                      _buildActionCard(
                        title: "Participate",
                        icon: Icons.event_available_outlined,
                        color: const Color(0xff3023AE),
                        cmd: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<EventBloc>(),
                                child: const ParticipateScreen(),
                              ),
                            ),
                          );
                        },
                      ),

                      _buildActionCard(
                        title: "Dashboard",
                        icon: Icons.dashboard_outlined,
                        color: Colors.orangeAccent,
                        cmd: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<EventBloc>(),
                                child: const DashboardScreen(),
                              ),
                            ),
                          );
                        },
                      ),

                      _buildActionCard(
                        title: "Profile",
                        icon: Icons.person_outline,
                        color: Colors.teal,
                        cmd: null,
                      ),
                    ],
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    VoidCallback? cmd,
  }) {
    return InkWell(
      onTap: cmd,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon,
                    color: color, size: 28.sp),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff2D3142),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
