import 'dart:math';

import 'package:calling_practice/services/singnaling.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Utils{
  static String? roomId;
  static var localRenderer = RTCVideoRenderer();
  static var remoteRenderer = RTCVideoRenderer();
  static final signaling = Signaling();
  static int getRandomId(){
    final random = Random();
    int randomId = 10 + random.nextInt(90);

    return randomId;
  }

  Utils._();
}