import 'package:flutter/material.dart';
import 'package:mysirani/theme.dart';

class FeelingsOptions extends StatelessWidget {
  final Function(String) onSelected;

  const FeelingsOptions({Key? key, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            "How are you feeling today?",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  onSelected("better");
                },
                child: Column(
                  children: [
                    Image.asset(
                      "assets/feelings/better.png",
                      height: 42,
                    ),
                    const SizedBox(height: 8),
                    const Text("Better"),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  onSelected("frustuated");
                },
                child: Column(
                  children: [
                    Image.asset(
                      "assets/feelings/frustuated.png",
                      height: 42,
                    ),
                    const SizedBox(height: 8),
                    const Text("Frustuated"),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  onSelected("anxious");
                },
                child: Column(
                  children: [
                    Image.asset(
                      "assets/feelings/anxious.png",
                      height: 42,
                    ),
                    const SizedBox(height: 8),
                    const Text("Anxious"),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  onSelected("sad");
                },
                child: Column(
                  children: [
                    Image.asset(
                      "assets/feelings/sad.png",
                      height: 42,
                    ),
                    const SizedBox(height: 8),
                    const Text("Sad"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
