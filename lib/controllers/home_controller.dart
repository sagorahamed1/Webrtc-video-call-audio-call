import 'package:calling_practice/utils/utils.dart';
import 'package:calling_practice/views/voice_call_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../views/call_screen.dart';

class HomeController extends GetxController {
  RxInt roomIdLength = 2.obs;
  RxBool isButtonActive = false.obs;
  final TextEditingController roomCtrl = TextEditingController();

  void get getIsButtonActive {
    isButtonActive.value = roomCtrl.text.length != roomIdLength.value;
    update();
  }

  void createRoom() async {
    await Utils.signaling.openUserMedia(Utils.localRenderer, Utils.remoteRenderer).then((_) async {
      update();
    });
    Utils.roomId = await Utils.signaling.createRoom(Utils.remoteRenderer, Utils.getRandomId().toString());
    // Get.to(const CallScreen());
    Get.to(const VoiceCallScreen());
  }

  void joinRoom() async {
    await Utils.signaling
        .openUserMedia(Utils.localRenderer, Utils.remoteRenderer)
        .then((_) async {
      update();
    });
    Utils.signaling.joinRoom(
      roomCtrl.text.trim(),
      Utils.remoteRenderer,
    );
    Utils.roomId = roomCtrl.text.trim();
    // Get.to(const CallScreen());
    Get.to(const VoiceCallScreen());
  }
}
