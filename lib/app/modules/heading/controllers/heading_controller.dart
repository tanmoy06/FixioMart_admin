import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../dashboard/controllers/dashboard_controller.dart';

class HeadingController extends GetxController {
  final supabase = Supabase.instance.client;

  var headings = <Map<String, dynamic>>[].obs;
  var loading = false.obs;
  var newHeading = ''.obs;

  late final DashboardController dashboard;

  @override
  void onInit() {
    super.onInit();
    dashboard = Get.find<DashboardController>();
    _fetchHeadings();
    _subscribeRealtime();
  }

  Future<void> _fetchHeadings() async {
    loading.value = true;
    final res = await supabase.from('headings').select().order('created_at');
    headings.assignAll(List<Map<String, dynamic>>.from(res));
    loading.value = false;
  }

  void _subscribeRealtime() {
    supabase
        .channel('realtime:headings')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'headings',
          callback: (payload) => _fetchHeadings(),
        )
        .subscribe();
  }

  Future<void> addHeading() async {
    if (!dashboard.isAdmin.value) return;
    final title = newHeading.value.trim();
    if (title.isEmpty) return;
    await supabase.from('headings').insert({'title': title});
    newHeading.value = '';
  }

  Future<void> deleteHeading(String id) async {
    if (!dashboard.isAdmin.value) return;
    await supabase.from('headings').delete().eq('id', id);
  }
}
