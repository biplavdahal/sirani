import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/onboarding/onboarding.model.dart';

class OnboardingView extends StatelessWidget {
  static String tag = 'onboarding-view';

  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<OnboardingModel>(
      builder: (ctx, model, child) {
        return IntroductionScreen(
          dotsContainerDecorator: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black12,
              ),
            ),
          ),
          curve: Curves.bounceInOut,
          controlsPadding: const EdgeInsets.all(8),
          dotsDecorator: DotsDecorator(
            spacing: const EdgeInsets.symmetric(horizontal: 1),
            activeColor: AppColor.primary,
            activeSize: const Size(18, 10),
            color: AppColor.primary.withOpacity(0.5),
            activeShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(100),
            )),
          ),
          isTopSafeArea: true,
          showDoneButton: true,
          showSkipButton: true,
          showNextButton: true,
          doneColor: AppColor.primary,
          skipColor: AppColor.secondaryTextColor,
          nextColor: AppColor.primary,
          onDone: model.completeOnboarding,
          onSkip: model.completeOnboarding,
          skip: const Text("Skip"),
          next: const Text("Next"),
          done: const Text("Get Started"),
          globalBackgroundColor: Colors.white,
          pages: model.walthrough
              .map(
                (intro) => PageViewModel(
                  title: intro["title"],
                  body: intro["description"],
                  image: Image.asset(intro["image"]),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
