// dashboard/controllers/dashboard_controller.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardController extends GetxController {
  final client = Supabase.instance.client;

  late final String adminUuid;

  var isAdmin = false.obs;
  var userEmail = RxnString();

  @override
  void onInit() {
    super.onInit();
    adminUuid = dotenv.env['ADMIN_ID'] ?? "";
    _updateAuthState();
    client.auth.onAuthStateChange.listen((_) => _updateAuthState());
  }

  void _updateAuthState() {
    final user = client.auth.currentUser;
    isAdmin.value = user?.id == adminUuid;
    userEmail.value = user?.email;
  }
}
