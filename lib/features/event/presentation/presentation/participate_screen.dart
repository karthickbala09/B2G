import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../participate/partcipate.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';


class ParticipateScreen extends StatefulWidget {
  const ParticipateScreen({super.key});

  @override
  State<ParticipateScreen> createState() => _ParticipateScreenState();
}

class _ParticipateScreenState extends State<ParticipateScreen> {

  @override
  void initState() {
    super.initState();
    context.read<EventBloc>().add(LoadAllEvents());
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xffF9F9FB),
      appBar: AppBar(
        title: const Text("Participate Events"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {

          if (state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EventLoaded) {

            if (state.events.isEmpty) {
              return Center(
                child: Text(
                  "No Events Available",
                  style: TextStyle(fontSize: 18.sp),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: state.events.length,
              itemBuilder: (context, index) {

                final e = state.events[index];
                final organizerId = e['organizerId'];

                return Container(
                  margin: EdgeInsets.only(bottom: 25.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 15.r,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Banner
                      Container(
                        height: 150.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24.r),
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xffC86DD7), Color(0xff3023AE)],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 40.sp,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// Title
                            Text(
                              e['name'] ?? "",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff2D3142),
                              ),
                            ),

                            SizedBox(height: 8.h),

                            /// Organization
                            Text(
                              "by ${e['org'] ?? ""}",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(height: 15.h),

                            /// Date + Fee
                            Row(
                              children: [
                                Icon(Icons.calendar_month, size: 16.sp),
                                SizedBox(width: 5.w),
                                Text(
                                  e['eventDate'] ?? "",
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                                const Spacer(),
                                Text(
                                  e['isPaid'] == true
                                      ? "₹${e['entryFee']}"
                                      : "Free",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: e['isPaid'] == true
                                        ? const Color(0xff3023AE)
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20.h),

                            /// Register Button
                            SizedBox(
                              width: double.infinity,
                              height: 50.h,
                              child: organizerId == currentUserId
                                  ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius:
                                  BorderRadius.circular(14.r),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Your Event",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              )
                                  : ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          RegisterEventScreen(
                                            eventData: e,
                                          ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xffC86DD7),
                                        Color(0xff3023AE),
                                      ],
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(14.r),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Register Now",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
