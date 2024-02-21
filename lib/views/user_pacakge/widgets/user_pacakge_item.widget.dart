import 'package:flutter/material.dart';
import 'package:mysirani/data_model/available_package.data.dart';
import 'package:mysirani/helpers/date_time_format.helper.dart';
import 'package:mysirani/helpers/date.helper.dart';
import 'package:mysirani/helpers/format_currenecy.helper.dart';
import 'package:mysirani/theme.dart';

class UserPackageItem extends StatelessWidget {
  final AvailablePackageData package;

  const UserPackageItem(this.package, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeStatus = date2Percentage(
      startingDate: DateTime.parse(package.orderDate),
      endingDate: DateTime.parse(package.validityDate),
    );

    return Opacity(
      opacity: activeStatus < 1 ? 1 : 0.4,
      child: Card(
        elevation: activeStatus < 1 ? 1 : 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    package.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColor.primary,
                    ),
                  ),
                  Text(
                    "Rs. ${formatCurrency(num.parse(package.amount))}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.only(
                bottom: 10,
                left: 10,
                right: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 64,
                    width: 64,
                    child: CircularProgressIndicator(
                      value: activeStatus,
                      backgroundColor: AppColor.primary.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        activeStatus < 1
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          "Issued",
                          style: TextStyle(
                            color: AppColor.secondaryTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          formattedDateTime(
                            package.orderDate,
                            showTime: false,
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          "Expiry",
                          style: TextStyle(
                            color: AppColor.secondaryTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          formattedDateTime(
                            package.validityDate,
                            showTime: false,
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
