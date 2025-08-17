// dashboard/views/dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Get.put(LoginController(), permanent: true);
    final isMobile = MediaQuery.of(context).size.width < 600;

    final sidebar = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerHeader(
            child: Text(
              'Admin Panel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Manage Headings'),
            onTap: () {
              if (isMobile) Get.back(); // Close the drawer
              Get.rootDelegate.toNamed(Routes.HEADING);
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Obx(() {
              final email = controller.userEmail.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(email ?? 'Not signed in'),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          email == null
                              ? () => Get.rootDelegate.toNamed(Routes.LOGIN)
                              : auth.logout,
                      child: Text(email == null ? 'Login' : 'Logout'),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: isMobile ? AppBar(title: const Text('Admin Panel')) : null,
      drawer: isMobile ? Drawer(child: sidebar) : null,
      body: Row(
        children: [
          if (!isMobile)
            Container(width: 240, color: Colors.grey[200], child: sidebar),
          Expanded(
            child: GetRouterOutlet(
              initialRoute: Routes.HEADING,
              anchorRoute: Routes.DASHBOARD,
            ),
          ),
        ],
      ),
    );
  }
}
