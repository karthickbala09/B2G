import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../widget/custom_textfield.dart';
import '../widget/gradient_button.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {

  // ---------------- CONTROLLERS ----------------
  final name = TextEditingController();
  String eventType = 'Hackathon';
  final org = TextEditingController();
  final organizer = TextEditingController();
  final desc = TextEditingController();
  final posterUrl = TextEditingController();

  final regStart = TextEditingController();
  final regEnd = TextEditingController();
  final date = TextEditingController();
  final submissionDeadline = TextEditingController();

  String eventMode = 'Offline';
  final venue = TextEditingController();
  final city = TextEditingController();

  final maxTeamSize = TextEditingController();
  final maxParticipants = TextEditingController();
  final eligibility = TextEditingController();

  bool abstractRequired = false;
  final abstractDesc = TextEditingController();
  bool pdfRequired = false;
  bool pptRequired = false;
  final pptTemplate = TextEditingController();
  final rulebookLink = TextEditingController();

  bool isPaid = false;
  final entryFee = TextEditingController();
  final paymentInstructions = TextEditingController();

  bool aiJudging = false;
  final evaluationCriteria = TextEditingController();
  final topNWinners = TextEditingController();

  final prizeDetails = TextEditingController();
  bool certificates = false;
  final internship = TextEditingController();

  final contactEmail = TextEditingController();
  final contactPhone = TextEditingController();
  final whatsappLink = TextEditingController();
  final websiteLink = TextEditingController();
  final form = TextEditingController();

  // ---------------- DATE PICKER ----------------
  Future<void> pickDate(TextEditingController c) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      c.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  // ---------------- VALIDATION + SUBMIT ----------------
  void _submit() {

    if (name.text.trim().isEmpty ||
        org.text.trim().isEmpty ||
        organizer.text.trim().isEmpty ||
        desc.text.trim().isEmpty ||
        date.text.trim().isEmpty ||
        regStart.text.trim().isEmpty ||
        regEnd.text.trim().isEmpty ||
        contactEmail.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all mandatory fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!contactEmail.text.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter valid email"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final eventData = {
      "name": name.text.trim(),
      "eventType": eventType,
      "org": org.text.trim(),
      "organizer": organizer.text.trim(),
      "desc": desc.text.trim(),
      "posterUrl": posterUrl.text.trim(),
      "regStart": regStart.text.trim(),
      "regEnd": regEnd.text.trim(),
      "eventDate": date.text.trim(),
      "submissionDeadline": submissionDeadline.text.trim(),
      "mode": eventMode,
      "venue": venue.text.trim(),
      "city": city.text.trim(),
      "maxTeamSize": maxTeamSize.text.trim(),
      "maxParticipants": maxParticipants.text.trim(),
      "eligibility": eligibility.text.trim(),
      "abstractRequired": abstractRequired,
      "abstractDesc": abstractDesc.text.trim(),
      "pdfRequired": pdfRequired,
      "pptRequired": pptRequired,
      "pptTemplate": pptTemplate.text.trim(),
      "rulebookLink": rulebookLink.text.trim(),
      "isPaid": isPaid,
      "entryFee": isPaid ? entryFee.text.trim() : null,
      "paymentInstructions": paymentInstructions.text.trim(),
      "aiJudging": aiJudging,
      "evaluationCriteria": evaluationCriteria.text.trim(),
      "topNWinners": topNWinners.text.trim(),
      "prizeDetails": prizeDetails.text.trim(),
      "certificates": certificates,
      "internship": internship.text.trim(),
      "contactEmail": contactEmail.text.trim(),
      "contactPhone": contactPhone.text.trim(),
      "whatsappLink": whatsappLink.text.trim(),
      "websiteLink": websiteLink.text.trim(),
      "formLink": form.text.trim(),
      "organizerId": FirebaseAuth.instance.currentUser!.uid,
    };

    context.read<EventBloc>().add(CreateEvent(eventData));
  }

  // ---------------- SECTION HEADER ----------------
  Widget _section(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff3023AE))),
          Divider(thickness: 1, color: const Color(0xffC86DD7)),
        ],
      ),
    );
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    return BlocListener<EventBloc, EventState>(
      listener: (context, state) {
        if (state is EventSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Event Created Successfully"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }

        if (state is EventFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Create Event")),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 1️⃣ BASIC INFO
              _section("1. Basic Event Information"),
              CustomTextField(label: "Event Title", controller: name),
              CustomTextField(label: "Organization Name", controller: org),
              CustomTextField(label: "Organizer Name", controller: organizer),
              CustomTextField(label: "Description", controller: desc, maxLines: 3),
              CustomTextField(label: "Poster URL", controller: posterUrl),

// 2️⃣ DATE INFO
              _section("2. Date Information"),
              CustomTextField(
                label: "Registration Start",
                controller: regStart,
                readOnly: true,
                onTap: () => pickDate(regStart),
              ),
              CustomTextField(
                label: "Registration End",
                controller: regEnd,
                readOnly: true,
                onTap: () => pickDate(regEnd),
              ),
              CustomTextField(
                label: "Event Date",
                controller: date,
                readOnly: true,
                onTap: () => pickDate(date),
              ),
              CustomTextField(
                label: "Submission Deadline",
                controller: submissionDeadline,
                readOnly: true,
                onTap: () => pickDate(submissionDeadline),
              ),

// 3️⃣ LOCATION & MODE
              _section("3. Location & Mode"),
              CustomTextField(label: "Venue", controller: venue),
              CustomTextField(label: "City", controller: city),

// 4️⃣ PARTICIPATION
              _section("4. Participation Details"),
              CustomTextField(label: "Max Team Size", controller: maxTeamSize),
              CustomTextField(label: "Max Participants", controller: maxParticipants),
              CustomTextField(label: "Eligibility Criteria", controller: eligibility),

// 5️⃣ SUBMISSION
              _section("5. Submission Requirements"),
              SwitchListTile(
                title: const Text("Abstract Required"),
                value: abstractRequired,
                onChanged: (v) => setState(() => abstractRequired = v),
              ),
              if (abstractRequired)
                CustomTextField(label: "Abstract Description", controller: abstractDesc),

              SwitchListTile(
                title: const Text("PDF Required"),
                value: pdfRequired,
                onChanged: (v) => setState(() => pdfRequired = v),
              ),

              SwitchListTile(
                title: const Text("PPT Required"),
                value: pptRequired,
                onChanged: (v) => setState(() => pptRequired = v),
              ),

              if (pptRequired)
                CustomTextField(label: "PPT Template Link", controller: pptTemplate),

              CustomTextField(label: "Rulebook Link", controller: rulebookLink),

// 6️⃣ PAYMENT
              _section("6. Payment Details"),
              SwitchListTile(
                title: const Text("Is Paid Event"),
                value: isPaid,
                onChanged: (v) => setState(() => isPaid = v),
              ),
              if (isPaid)
                CustomTextField(label: "Entry Fee", controller: entryFee),
              if (isPaid)
                CustomTextField(label: "Payment Instructions", controller: paymentInstructions),

// 7️⃣ EVALUATION
              _section("7. Evaluation Details"),
              SwitchListTile(
                title: const Text("AI Judging Enabled"),
                value: aiJudging,
                onChanged: (v) => setState(() => aiJudging = v),
              ),
              CustomTextField(label: "Evaluation Criteria", controller: evaluationCriteria),
              CustomTextField(label: "Top N Winners", controller: topNWinners),

// 8️⃣ REWARDS
              _section("8. Rewards & Recognition"),
              CustomTextField(label: "Prize Details", controller: prizeDetails),
              SwitchListTile(
                title: const Text("Certificates Provided"),
                value: certificates,
                onChanged: (v) => setState(() => certificates = v),
              ),
              CustomTextField(label: "Internship Opportunity", controller: internship),

// 9️⃣ COMMUNICATION
              _section("9. Communication & Support"),
              CustomTextField(label: "Contact Email", controller: contactEmail),
              CustomTextField(label: "Contact Phone", controller: contactPhone),
              CustomTextField(label: "WhatsApp Group Link", controller: whatsappLink),
              CustomTextField(label: "Website Link", controller: websiteLink),
              CustomTextField(label: "Google Form Link (Backup)", controller: form),


              SizedBox(height: 30.h),

              BlocBuilder<EventBloc, EventState>(
                builder: (context, state) {
                  if (state is EventLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GradientButton(
                    text: "Create Event",
                    onTap: _submit,
                  );
                },
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
