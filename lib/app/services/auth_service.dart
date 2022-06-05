import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class AuthService extends GetxService {
  final _firebaseAuth = FirebaseAuth.instance;

  final Rxn<User> _firebaseUser = Rxn<User>(FirebaseAuth.instance.currentUser);

  // TODO: implement User Model
  // Rx<UserModel> _user = UserModel().obs;

  User? get firebaseUser => _firebaseUser.value;

  bool get isAuth => firebaseUser != null;

  // TODO: implement User Model
  // UserModel get user => _user.value;

  @override
  void onInit() {
    ever(_firebaseUser, _onAuthChanges);

    _firebaseUser.bindStream(_firebaseAuth.userChanges());
  }

  void _onAuthChanges(User? firebaseUser) {
    // TODO: implement User Model
    // if (firebaseUser != null) {
    //   if (_user.value.id == null) {
    //     _user.bindStream(UserProfileService(firebaseUser!.uid).stream());
    //   }
    // } else {
    //   _user.value = UserModel();
    // }
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
