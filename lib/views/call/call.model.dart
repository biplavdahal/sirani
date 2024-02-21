import 'dart:async';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/constants/keys.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/date.helper.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/managers/dialog/dialog.mixin.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/services/appointment.service.dart';
import 'package:mysirani/views/call/call.argument.dart';
import 'package:wakelock/wakelock.dart';

class CallModel extends ViewModel with DialogMixin, SnackbarMixin {
  // Services
  final AppointmentService _appointmentService = locator<AppointmentService>();

  // Data

  late String _token;
  String get token => _token;

  late AgoraClient _client;
  AgoraClient get client => _client;

  late String _secondPartyName;
  String get secondPartyName => _secondPartyName;

  final bool _remoteAudioMuted = false;
  bool get remoteAudioMuted => _remoteAudioMuted;
  final bool _remoteVideoDisabled = false;
  bool get remoteVideoDisabled => _remoteVideoDisabled;

  final Map<String, Duration> _extendDurations = {
    "15 minutes": const Duration(minutes: 15),
    "30 minutes": const Duration(minutes: 30),
    "45 minutes": const Duration(minutes: 45),
    "1 hour": const Duration(minutes: 60),
  };

  late Timer? _sessionTimeTracker;

  late Duration _remainingDuration;
  late String _endTime;
  late int _callerId;

  Future<void> init(CallArgument arguments) async {
    _remainingDuration = arguments.remainingDuration.remainingDuration;
    _endTime = arguments.remainingDuration.endTime;
    _callerId = arguments.callerId;
    _token = arguments.token;
    _secondPartyName = arguments.secondPartyName;
    _client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: agoraAppId,
        channelName: arguments.channelName,
        tempToken: _token,
        uid: 0,
      ),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
      agoraEventHandlers: AgoraEventHandlers(
        joinChannelSuccess: (channel, uid, elapsed) {},
        leaveChannel: (stats) {
          debugPrint("Session ended");
          _sessionTimeTracker?.cancel();
        },
        userJoined: (uid, elapsed) {
          Fluttertoast.showToast(msg: "$_secondPartyName joined!");
        },
        activeSpeaker: (uid) {},
        userOffline: (uid, elapsed) {
          Fluttertoast.showToast(
            msg: "$_secondPartyName left!",
          );
        },
        localAudioStateChanged: (state, error) {},
        localVideoStateChanged: (localVideoState, error) {},
        onError: (errorCode) {},
        remoteAudioStateChanged: (uid, state, reason, elapsed) {
          // _remoteAudioMuted = state == AudioRemoteState.Stopped;
          // setIdle();
        },
        remoteVideoStateChanged: (uid, state, reason, elapsed) {
          // _remoteVideoDisabled = state == VideoRemoteState.Stopped;
          // setIdle();
        },
        tokenPrivilegeWillExpire: (token) {},
      ),
    );

    _sessionTimeTracker = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingDuration = _remainingDuration - const Duration(seconds: 1);
      debugPrint("Remaining time: ${_remainingDuration.inSeconds}");
      if (_remainingDuration.inSeconds == 600) {
        Fluttertoast.showToast(
          msg: "Session time will be over in 10 minutes",
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          fontSize: 18,
        );
      }
    });

    Wakelock.enable();
    setIdle();
  }

  void onEndCall() {
    Wakelock.disable();
    debugPrint("Session Ended");
    _sessionTimeTracker?.cancel();
    _client.sessionController.endCall();
    goBack();
  }

  Future<void> onExtendPressed() async {
    try {
      final selected = await dialog.showDialog(
        DialogRequest(
          type: DialogType.selection,
          title: "Extend Session Time",
          payload: _extendDurations.keys.toList(),
          dismissable: true,
        ),
      );

      _endTime = addDurationToTimeStr(
          time: _endTime, toBeAdded: _extendDurations[selected!.result]!);

      dialog.showDialog(
        DialogRequest(
            type: DialogType.progressDialog, title: "Extending session!"),
      );

      await _appointmentService.extendSession(id: _callerId, time: _endTime);

      _remainingDuration =
          _remainingDuration + _extendDurations[selected.result]!;

      dialog.hideDialog();

      setIdle();

      Fluttertoast.showToast(msg: "Session extended by ${selected.result}!");
    } on ErrorData catch (e) {
      dialog.hideDialog();

      errorHandler(snackbar, e: e);
    }
  }
}
