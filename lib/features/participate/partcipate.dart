import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackthon_app/features/participate/presentation/bloc/register_bloc.dart';
import 'package:hackthon_app/features/participate/presentation/bloc/register_event.dart';
import 'package:hackthon_app/features/participate/presentation/bloc/register_state.dart';
import 'domain/entities/registration_entity.dart';

class RegisterEventScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const RegisterEventScreen({
    super.key,
    required this.eventData,
  });

  @override
  State<RegisterEventScreen> createState() =>
      _RegisterEventScreenState();
}

class _RegisterEventScreenState
    extends State<RegisterEventScreen> {

  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final teamName = TextEditingController();
  final teamSize = TextEditingController();
  final members = TextEditingController();
  final abstract = TextEditingController();

  String selectedCollege = "Sairam Engineering College";

  final List<String> colleges = [
    "Sairam Engineering College",
    "Sairam Institute of Technology",
    "Anna University",
    "SRM University",
    "VIT University",
    "Other",
  ];

  void _submit() {

    if (!_formKey.currentState!.validate()) return;

    final registration = RegistrationEntity(
      eventId: widget.eventData['id'] ?? "",
      participantId:
      FirebaseAuth.instance.currentUser!.uid,
      name: name.text.trim(),
      email: email.text.trim(),
      phone: phone.text.trim(),
      college: selectedCollege,
      teamName: teamName.text.trim(),
      teamSize: teamSize.text.trim(),
      members: members.text.trim(),
      abstractText: abstract.text.trim(),
      createdAt: DateTime.now(),
    );

    context.read<RegistrationBloc>().add(
      SubmitRegistration(registration),
    );
  }

  @override
  Widget build(BuildContext context) {

    final e = widget.eventData;

    return BlocListener<RegistrationBloc,
        RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registered Successfully"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }

        if (state is RegistrationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF9F9FB),
        appBar: AppBar(
          title: const Text("Event Registration"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              /// ================= EVENT DETAILS CARD =================

              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffC86DD7),
                      Color(0xff3023AE)
                    ],
                  ),
                  borderRadius:
                  BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      e['name'] ?? "",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      "Organized by ${e['org']}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white70,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Row(
                      children: [
                        Icon(Icons.calendar_month,
                            color: Colors.white,
                            size: 16.sp),
                        SizedBox(width: 5.w),
                        Text(
                          e['eventDate'] ?? "",
                          style: const TextStyle(
                              color: Colors.white),
                        ),
                        const Spacer(),
                        Text(
                          e['isPaid'] == true
                              ? "₹${e['entryFee']}"
                              : "Free",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    /// ⭐ HIGHLIGHT PRIZE
                    if (e['prizeDetails'] != null &&
                        e['prizeDetails'] != "")
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.2),
                          borderRadius:
                          BorderRadius.circular(
                              12.r),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                                Icons.emoji_events,
                                color: Colors.white),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                "Prize: ${e['prizeDetails']}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 12.h),

                    /// FULL DESCRIPTION
                    if (e['desc'] != null)
                      Text(
                        e['desc'],
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 25.h),

              /// ================= EXTRA EVENT DETAILS =================

              _eventInfoTile(
                  "Registration Start",
                  e['regStart']),
              _eventInfoTile(
                  "Registration End",
                  e['regEnd']),
              _eventInfoTile(
                  "Submission Deadline",
                  e['submissionDeadline']),
              _eventInfoTile(
                  "Venue", e['venue']),
              _eventInfoTile(
                  "City", e['city']),
              _eventInfoTile(
                  "Max Team Size",
                  e['maxTeamSize']),
              _eventInfoTile(
                  "Eligibility",
                  e['eligibility']),
              _eventInfoTile(
                  "Evaluation Criteria",
                  e['evaluationCriteria']),

              /// 📞 CONTACT INFO
              _eventInfoTile(
                  "Contact Email",
                  e['contactEmail']),
              _eventInfoTile(
                  "Contact Phone",
                  e['contactPhone']),

              SizedBox(height: 30.h),

              /// ================= PARTICIPANT FORM =================

              Text(
                "Participant Details",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20.h),

              Form(
                key: _formKey,
                child: Column(
                  children: [

                    _input("Full Name", name),
                    _input("Email", email,
                        keyboardType:
                        TextInputType.emailAddress),
                    _input("Phone", phone,
                        keyboardType:
                        TextInputType.phone),

                    DropdownButtonFormField<String>(
                      value: selectedCollege,
                      items: colleges
                          .map((e) =>
                          DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                          .toList(),
                      onChanged: (v) =>
                          setState(() =>
                          selectedCollege = v!),
                      decoration:
                      _decoration("Select College"),
                    ),

                    SizedBox(height: 15.h),

                    _input("Team Name", teamName),
                    _input("Team Size", teamSize,
                        keyboardType:
                        TextInputType.number),
                    _input(
                      "Team Members",
                      members,
                      maxLines: 3,
                    ),
                    _input(
                      "Project Abstract",
                      abstract,
                      maxLines: 4,
                    ),

                    SizedBox(height: 30.h),

                    BlocBuilder<RegistrationBloc,
                        RegistrationState>(
                      builder: (context, state) {

                        if (state
                        is RegistrationLoading) {
                          return const CircularProgressIndicator();
                        }

                        return SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.transparent,
                              shadowColor:
                              Colors.transparent,
                              padding: EdgeInsets.zero,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient:
                                const LinearGradient(
                                  colors: [
                                    Color(0xffC86DD7),
                                    Color(0xff3023AE)
                                  ],
                                ),
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    14.r),
                              ),
                              child: const Center(
                                child: Text(
                                  "Register Now",
                                  style: TextStyle(
                                    color:
                                    Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _eventInfoTile(String label, dynamic value) {
    if (value == null || value == "") {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value.toString()),
          ),
        ],
      ),
    );
  }

  Widget _input(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
        TextInputType keyboardType =
            TextInputType.text,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (v) =>
        v == null || v.isEmpty
            ? "Required"
            : null,
        decoration: _decoration(label),
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(14.r),
        borderSide:
        BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(14.r),
        borderSide:
        BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(14.r),
        borderSide: const BorderSide(
            color: Color(0xffC86DD7)),
      ),
    );
  }
}
