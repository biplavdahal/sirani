import 'package:mysirani/data_model/auth.data.dart';

abstract class AuthenticationService {
  /// Get all of logged in users data.
  ///
  /// Returns [null] if no user is logged in.
  AuthData? get auth;

  /// Returns [true] if the logged in user is a normal user.
  bool get isNormalUser;

  /// Returns [true] if user logged in using social auth
  bool get isSocialUser;

  /// Proceed sign in process with username and password.
  Future<void> signInWithUsernameAndPassword(String username, String password);

  /// Returns true if user is signned in.
  Future<bool> isSignnedIn();

  /// Signs out user
  Future<void> signOut();

  /// Returns the reponse of request.
  Future<String> requestResetPassword(String email);

  /// Register user with email, password, and username....
  Future<List<String>?> signUp({
    required String fullName,
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
    required String address,
  });

  /// Update user
  Future<void> updateUser(Map<String, dynamic> data);

  /// Update user balance
  Future<void> updateBalance([int? balance]);

  /// Login with google
  Future<void> signInWithGoogle();

  /// Login with facebook
  Future<void> signInWithFacebook();
}
