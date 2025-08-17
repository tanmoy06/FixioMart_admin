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
    // We still need LoginController for the logout function.
    final auth = Get.put(LoginController(), permanent: true);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 240,
            color: Colors.grey[200],
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DrawerHeader(
                    child: Text(
                      'Admin Panel',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Manage Headings'),
                    onTap: () => Get.rootDelegate.toNamed(Routes.HEADING),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    // This Obx now correctly listens to changes from DashboardController
                    child: Obx(() {
                      // 1. Get the email from the DashboardController's reactive variable.
                      final email = controller.userEmail.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 2. Display the email. It will update automatically.
                          Text(email == null ? 'Not signed in' : email),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  email == null
                                      ? () =>
                                          Get.rootDelegate.toNamed(Routes.LOGIN)
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
            ),
          ),

          // Main content area (nested routes)
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
