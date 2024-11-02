import 'package:flutter/material.dart';
import 'package:calling_practice/controllers/home_controller.dart';
import 'package:calling_practice/utils/utils.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    Utils.localRenderer.initialize();
    Utils.remoteRenderer.initialize();

    homeController.roomCtrl.addListener(() {
      homeController.getIsButtonActive;
    });

    Utils.signaling.onAddRemoteStream = (stream) {
      Utils.remoteRenderer.srcObject = stream;
      setState(() {});
    };

    super.initState();
  }

  @override
  void dispose() {
    Utils.localRenderer.dispose();
    Utils.remoteRenderer.dispose();
    homeController.roomCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Call Connect',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final cameraPermission = await Permission.camera.request();
                final microphonePermission = await Permission.microphone.request();

                if (cameraPermission.isGranted && microphonePermission.isGranted) {
                  homeController.createRoom();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Camera and Microphone permissions are required.",
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Create Room"),
            ),
            const SizedBox(height: 30),
            GetBuilder<HomeController>(
              builder: (controller) {
                return TextFormField(
                  controller: homeController.roomCtrl,
                  maxLength: homeController.roomIdLength.value,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    hintText: 'Enter Room ID',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            GetBuilder<HomeController>(
              builder: (controller) {
                return ElevatedButton(
                  onPressed: controller.isButtonActive.value ? null : () {
                    controller.joinRoom();
                  },
                  style: controller.isButtonActive.value
                      ? ElevatedButton.styleFrom(backgroundColor: Colors.grey)
                      : ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Join Room'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
