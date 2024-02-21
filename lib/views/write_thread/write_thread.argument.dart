import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/data_model/forum_thread.data.dart';

class WriteThreadArgument extends Arguments {
  final ForumThreadData thread;

  WriteThreadArgument(this.thread);
}
