import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/constants/pref_keys.dart';
import 'package:mysirani/services/app_data.service.dart';

class AppDataServiceImplementation implements AppDataService {
  // Services
  final SharedPreferenceService _preferenceService =
      locator<SharedPreferenceService>();

  @override
  Future<void> completeOnboarding() async {
    await _preferenceService.set<bool>(spfOnboardingViewed, true);
  }

  @override
  Future<bool?> onboardingSeenAlready() async {
    final _pref = await _preferenceService.get<bool?>(spfOnboardingViewed);
    return _pref.value;
  }
}
