import 'package:flutter/material.dart';
import 'package:mysirani/data_model/user.data.dart';

class CounsellorDetail extends StatelessWidget {
  final UserData counsellorProfile;

  const CounsellorDetail(this.counsellorProfile, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (counsellorProfile.summary != null) ...[
              const Text(
                "Introduction",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                counsellorProfile.summary!,
              ),
            ],
            if (counsellorProfile.experience != null) ...[
              const Divider(),
              const Text(
                "Experience",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                counsellorProfile.experience!,
              ),
            ],
            if (counsellorProfile.education != null) ...[
              const Divider(),
              const Text(
                "Education",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                counsellorProfile.education!,
              ),
            ],
            if (counsellorProfile.language != null) ...[
              const Divider(),
              const Text(
                "Language",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                counsellorProfile.language!,
              ),
            ],
            if (counsellorProfile.skills != null) ...[
              const Divider(),
              const Text(
                "Skills",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                counsellorProfile.skills!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
