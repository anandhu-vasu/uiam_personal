import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uiam_personal/app/data/providers/person_provider.dart';

import '../data/models/person_model.dart';
import '../routes/app_pages.dart';

class AuthService extends GetxService {
  final _firebaseAuth = FirebaseAuth.instance;

  final Rxn<User> _firebaseUser = Rxn<User>(FirebaseAuth.instance.currentUser);
  final isLoaded = false.obs;

  // TODO: implement User Model
  PersonModel user = PersonModel();

  User? get firebaseUser => _firebaseUser.value;

  bool loading = true;

  bool get isAuth => firebaseUser != null;
  String get uid => firebaseUser!.uid;

  @override
  void onInit() {
    ever(_firebaseUser, _onAuthChanges);

    _firebaseUser.bindStream(_firebaseAuth.userChanges());
  }

  void _onAuthChanges(User? firebaseUser) async {
    // TODO: implement User Model
    if (isAuth) {
      if (user.id == null) {
        user = await PersonProvider(uid).fetch();
      }
    } else {
      user = PersonModel();
    }
    loading = false;
    if (Get.currentRoute != Routes.SPLASH) {
      redirect();
    }
  }

  redirect() {
    if (firebaseUser == null) {
      if (Get.currentRoute != Routes.LOGIN) Get.offAllNamed(Routes.LOGIN);
    } else {
      if (Get.currentRoute != Routes.HOME) Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
