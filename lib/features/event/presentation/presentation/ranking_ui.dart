import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankingScreen extends StatelessWidget {

  final String eventId;
  final String eventName;

  const RankingScreen({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  Stream<QuerySnapshot> rankingStream() {
    return FirebaseFirestore.instance
        .collection("registrations")
        .where("eventId", isEqualTo: eventId)
        .orderBy("rank")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF9F9FB),
      appBar: AppBar(
        title: Text("$eventName Ranking"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: rankingStream(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text("No Rankings Yet"),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(20.w),
            itemCount: docs.length,
            itemBuilder: (context, index) {

              final reg =
              docs[index].data() as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.only(bottom: 15.h),
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor:
                      const Color(0xffC86DD7),
                      child: Text(
                        "${reg['rank'] ?? "-"}",
                        style: const TextStyle(
                            color: Colors.white),
                      ),
                    ),

                    SizedBox(width: 15.w),

                    Expanded(
                      child: Text(
                        reg['teamName'] ?? "Individual",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    Text(
                      "Score: ${reg['score'] ?? 0}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}