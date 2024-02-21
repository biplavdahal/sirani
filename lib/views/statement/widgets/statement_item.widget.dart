import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/data_model/statement.data.dart';
import 'package:mysirani/helpers/date_time_format.helper.dart';

class StatementItem extends StatelessWidget {
  final StatementData statement;

  const StatementItem(this.statement, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Balance ${statement.type == "Cr" ? "Credited" : "Debited"}",
        maxLines: 2,
      ),
      subtitle: Text(
        formattedDateTime(statement.dateTime),
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          MdiIcons.cog,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Rs. ${statement.amount}"),
          const SizedBox(
            width: 4,
          ),
          Icon(
            statement.type == "Cr"
                ? MdiIcons.chevronUpCircle
                : MdiIcons.chevronDownCircle,
            color: statement.type == "Cr" ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
