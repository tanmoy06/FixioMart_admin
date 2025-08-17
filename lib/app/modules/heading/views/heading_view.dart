import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/heading_controller.dart';

class HeadingView extends GetView<HeadingController> {
  const HeadingView({super.key});

  @override
  Widget build(BuildContext context) {
    // We remove Get.find from here
    final textCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Headings')),
      body: Obx(() {
        // And move it INSIDE the Obx closure
        final dashboard = Get.find<DashboardController>();

        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Now this will be reactive to changes in isAdmin
              if (dashboard.isAdmin.value)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textCtrl,
                        onChanged: (v) => controller.newHeading.value = v,
                        onSubmitted: (_) {
                          controller.addHeading();
                          textCtrl.clear();
                        },
                        decoration: const InputDecoration(
                          labelText: 'New Heading',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        controller.addHeading();
                        textCtrl.clear();
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              Expanded(
                child:
                    controller.headings.isEmpty
                        ? const Center(child: Text('No headings yet'))
                        : ListView.separated(
                          itemCount: controller.headings.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final h = controller.headings[i];
                            return ListTile(
                              title: Text(h['title']),
                              // This trailing icon will now also react to isAdmin changes
                              trailing:
                                  dashboard.isAdmin.value
                                      ? IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed:
                                            () => controller.deleteHeading(
                                              h['id'].toString(),
                                            ),
                                      )
                                      : null,
                            );
                          },
                        ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
