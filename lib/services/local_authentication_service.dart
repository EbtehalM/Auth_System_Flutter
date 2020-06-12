import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

// local_auth plugin provides authentication methods that happen on the user device "locally".

class LocalAuthenticationService {
  final _auth = LocalAuthentication();

  // to keep track of authentication state
  bool isAuthenticated = false;

  Future<void> authenticate() async {
    try {
      isAuthenticated = await _auth.authenticateWithBiometrics(
        localizedReason: 'authenticate to access',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
