abstract class AppDataService {
  /// Will return true if onboarding screen was shown already.
  Future<bool?> onboardingSeenAlready();

  /// Will complete the onboarding process.
  Future<void> completeOnboarding();
}
