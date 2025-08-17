import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final client = Supabase.instance.client;
  var loading = false.obs;
  var error = RxnString();

  Future<void> login(String email, String password) async {
    try {
      loading.value = true;
      error.value = null;
      final res = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      loading.value = false;
      if (res.session != null) {
        Get.offAllNamed('/dashboard');
      } else {
        error.value = 'Invalid credentials';
      }
    } catch (e) {
      loading.value = false;
      error.value = e.toString();
    }
  }

  Future<void> logout() async {
    await client.auth.signOut();
    Get.offAllNamed(Routes.LOGIN); // Redirect to login page
  }

  String? currentUid() => client.auth.currentUser?.id;
  String? currentEmail() => client.auth.currentUser?.email;
}
