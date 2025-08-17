import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  }

  String? currentUid() => client.auth.currentUser?.id;
  String? currentEmail() => client.auth.currentUser?.email;
}
