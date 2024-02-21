import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/data_model/session_time.data.dart';

class CallArgument extends Arguments {
  final String token;
  final String channelName;
  final String secondPartyName;
  final int callerId;
  final SessionTimeData remainingDuration;

  CallArgument(
    this.token,
    this.channelName, {
    required this.secondPartyName,
    required this.callerId,
    required this.remainingDuration,
  });
}
