import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retociclo4/domain/models/user_status.dart';
import 'package:retociclo4/domain/use_cases/controllers/auth_controller.dart';
import 'package:retociclo4/domain/use_cases/controllers/conectivity_controller.dart';
import 'package:retociclo4/domain/use_cases/controllers/status_controller.dart';
import 'package:retociclo4/ui/pages/content/states/widgets/publish_state.dart';
import 'widgets/state_card.dart';

class StatesScreen extends StatefulWidget {
  // StatesScreen empty constructor
  const StatesScreen({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<StatesScreen> {
  final ConnectivityController connectivityController = Get.find<ConnectivityController>();
  final StatusController statusController = Get.find<StatusController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    statusController.suscribeUpdates();
  }

  @override
  void dispose() {
    statusController.unsuscribeUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.only(bottom: 16.0),
          child: Center(
            child: ElevatedButton(
              child: const Text("Agregar"),
              onPressed: () {
                // We don't allow to trigger the action if we don't have connectivity
                if (connectivityController.connected) {
                  Get.dialog(
                    PublishState(),
                  );
                } else {
                  Get.snackbar(
                    "Error de conectividad",
                    "No se encuentra conectado a internet.",
                  );
                }
              },
            ),
          ),
          ),
        Expanded(
          child: Obx( () {
            return ListView.builder(
              itemCount: statusController.entries.length,
              itemBuilder: (context, index) {
                UserStatus status = statusController.entries[index];
                User user = authController.currentUser!;
                return StateCard(
                  title: status.name,
                  content: status.message,
                  picUrl: status.picUrl,
                  displayIcon: user.email! == status.email ? "delete" : "",
                  onAction: () {
                    if (user.email! == status.email) {
                      statusController.removeStatus(status);
                    }
                  },
                );
              }, 
            );
          }),
        ),
      ],
    );
  }
}
