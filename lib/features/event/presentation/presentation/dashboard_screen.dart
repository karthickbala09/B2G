import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackthon_app/features/event/presentation/presentation/ranking_ui.dart';
import '../../../../core/Service/gemini_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  bool isEvaluating = false;

  Future<void> evaluateEvent(String eventId) async {

    setState(() => isEvaluating = true);

    final snapshot = await FirebaseFirestore.instance
        .collection("registrations")
        .where("eventId", isEqualTo: eventId)
        .get();

    if (snapshot.docs.isEmpty) {
      setState(() => isEvaluating = false);
      return;
    }

    List<Map<String, dynamic>> scoredList = [];

    for (var doc in snapshot.docs) {

      final abstract = doc['abstract'] ?? "";

      if (abstract.isEmpty) continue;

      try {

        final result =
        await GeminiService.evaluateAbstract(abstract);

        final score = result['score'] ?? 0;

        scoredList.add({
          "doc": doc,
          "score": score,
        });

      } catch (e) {
        print("GEMINI ERROR: $e");
      }
    }

    scoredList.sort((a, b) =>
        b['score'].compareTo(a['score']));

    int rank = 1;

    for (var item in scoredList) {
      await item['doc'].reference.update({
        "score": item['score'],
        "rank": rank,
      });
      rank++;
    }

    setState(() => isEvaluating = false);
  }

  Future<int> getSubmissionCount(String eventId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("registrations")
        .where("eventId", isEqualTo: eventId)
        .get();

    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {

    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xffF9F9FB),
      appBar: AppBar(
        title: const Text("My Events Dashboard"),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("events")
            .where("organizerId", isEqualTo: uid)
            .get(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data!.docs;

          if (events.isEmpty) {
            return const Center(
              child: Text("You haven't created any events"),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(20.w),
            itemCount: events.length,
            itemBuilder: (context, index) {

              final e = events[index];
              final eventId = e.id;
              final eventName = e['name'] ?? "";
              final eventDate = e['eventDate'] ?? "";

              return FutureBuilder<int>(
                future: getSubmissionCount(eventId),
                builder: (context, snapshot) {

                  final submissionCount = snapshot.data ?? 0;

                  return Container(
                    margin: EdgeInsets.only(bottom: 15.h),
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          eventName,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5.h),

                        Text("Date: $eventDate"),
                        Text("Submissions: $submissionCount"),

                        SizedBox(height: 15.h),

                        SizedBox(
                          width: double.infinity,
                          height: 45.h,
                          child: ElevatedButton(
                            onPressed: submissionCount == 0 || isEvaluating
                                ? null
                                : () async {

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );

                              await evaluateEvent(eventId);

                              Navigator.pop(context);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RankingScreen(
                                    eventId: eventId,
                                    eventName: eventName,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xff3023AE),
                            ),
                            child: Text(
                              isEvaluating
                                  ? "Evaluating..."
                                  : "Evaluate & View Ranking",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}