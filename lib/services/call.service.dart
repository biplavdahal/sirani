abstract class CallService {
  /// Get agora token
  Future<String> getCallToken(String? channel);

  /// Emits call notification to other user
  Future<void> sendCallNotification({
    required String callToken,
    required int userId,
  });
}
