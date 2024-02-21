import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/services/app_data.service.dart';
import 'package:mysirani/views/start_up/start_up.view.dart';

class OnboardingModel extends ViewModel {
  // Service
  final AppDataService _appDataService = locator<AppDataService>();

  // Data
  List<Map<String, dynamic>> get walthrough => [
        {
          'title': 'Connect with a professional mental health counselor',
          'description':
              'Connecting with a trained professional to share your inner world is the safest way to get a steady and reliable support in your journey.',
          'image': 'assets/images/illustration1.jpg',
        },
        {
          'title': 'Chat buddies / First aid through text messages',
          'description':
              'Chat anonymously with an expert of your choice anytime, anywhere.',
          'image': 'assets/images/illustration2.jpg',
        },
        {
          'title':
              'Online group sessions and discussions - private and confidential',
          'description':
              'Sometimes it means the world to know that there are others who share our pain and have gone through similar journeys.',
          'image': 'assets/images/illustration3.jpg',
        },
      ];

  // Actions
  Future<void> completeOnboarding() async {
    await _appDataService.completeOnboarding();
    gotoAndClear(StartUpView.tag);
  }
}
