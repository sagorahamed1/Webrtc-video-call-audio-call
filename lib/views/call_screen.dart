import 'package:flutter/material.dart';
import 'package:calling_practice/controllers/call_controller.dart';
import 'package:calling_practice/utils/utils.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallController controller = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(() {
            return Positioned.fill(
              child: RTCVideoView(controller.remoteStream.value),
            );
          }),


          GetBuilder<CallController>(builder: (controller) {
            return Positioned(
              top: 40, // Position from the top
              left: (MediaQuery.of(context).size.width - 120) /
                  2, // Center horizontally
              width: 120, // Width of local video
              height: 200, // Height of local video
              child: Text("roomID: ${Utils.roomId.toString()}", style: TextStyle(color: Colors.red)),
            );
          }),



          Positioned(
            top: 20,
            right: 20,
            child: Obx(() {
              return Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: RTCVideoView(controller.localStream.value, mirror: true),
              );
            }),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Utils.signaling.hangUp(Utils.localRenderer);
                    Get.back();
                  },
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    controller.isVideoEnable.value =
                    !controller.isVideoEnable.value;
                    controller.toggleVideo();
                  },
                  child: Icon(
                    controller.isVideoEnable.value
                        ? Icons.videocam
                        : Icons.videocam_off,
                    color: Colors.white,
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    controller.isAudioEnable.value =
                    !controller.isAudioEnable.value;
                    controller.toggleAudio();
                  },
                  child: Icon(
                    controller.isAudioEnable.value ? Icons.mic : Icons.mic_off,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
