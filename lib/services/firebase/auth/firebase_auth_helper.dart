// * import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petrol_n_gas/models/user_model.dart';
import 'package:petrol_n_gas/services/firebase/firestore/firestore_service.dart';

import 'auth_exceptions/auth_exception_handler.dart';
import 'auth_exceptions/auth_results_status.dart';

class FirebaseAuthHelper {
  final _auth = FirebaseAuth.instance;
  late AuthResultStatus _status;

  Future<AuthResultStatus> login({email, pass}) async {
    try {
      final authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);

      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future logout() async {
    await _auth.signOut();
  }

  final FirestoreService _firestoreService = FirestoreService();
  Future register({email, pass}) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);

      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }

    //* add user to firestore
    try {
      UserModel user = UserModel(email: email, role: "customer", name: "USER");
      _firestoreService.createUser(user);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<String> getCurrentUserEmail() async {
    try {
      User user = _auth.currentUser!;
      return user.email!;
    } catch (e) {
      return "";
    }
  }
}
