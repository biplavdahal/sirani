import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/data_model/message.data.dart';
import 'package:mysirani/helpers/date_time_format.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';

class MessageItem extends StatelessWidget {
  final MessageData message;
  final bool showDateTime;
  final ValueSetter<int> onTap;

  const MessageItem(this.message,
      {Key? key, this.showDateTime = false, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelf =
        message.senderId == locator<AuthenticationService>().auth!.userId;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment:
            isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => onTap(message.id),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelf ? AppColor.primary : Colors.grey[200],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isSelf ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          if (showDateTime) const SizedBox(height: 5),
          if (showDateTime)
            Text(
              formattedDateTime(message.dateTime),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
