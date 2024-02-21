import 'package:flutter/material.dart';
import 'package:mysirani/data_model/chat_plan.data.dart';
import 'package:mysirani/helpers/format_currenecy.helper.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';

class ChatPlanItem extends StatelessWidget {
  final ChatPlanData plan;
  final ValueSetter<int>? onBuyPressed;

  const ChatPlanItem({Key? key, required this.plan, this.onBuyPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final planRate = plan.discountRate == null && plan.discountPercent == null
        ? plan.rate
        : plan.discountPercent != null
            ? plan.rate - (plan.rate * (plan.discountPercent! / 100))
            : plan.rate - plan.discountRate!;

    return Container(
      margin: onBuyPressed == null
          ? EdgeInsets.zero
          : const EdgeInsets.only(left: 16, right: 16, top: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColor.primary.withOpacity(0.03),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                color: AppColor.primary.withOpacity(0.1),
                child: Text(
                  "Rs. ${formatCurrency(planRate)}",
                  style: const TextStyle(
                    color: AppColor.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                bottom: -16,
                right: 90,
                left: 90,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  child: Text(
                    plan.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (plan.discountPercent != null || plan.discountRate != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.blue[400],
                    child: Text(
                      plan.discountPercent != null
                          ? "${plan.discountPercent}% Off"
                          : "Rs.${plan.discountRate} Discount",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "👉🏼 ${plan.time} ${plan.timeUnit}",
                  style: const TextStyle(color: AppColor.primary),
                ),
                const SizedBox(height: 8),
                Text(
                  "👉🏼 ${plan.sessions} Sessions",
                  style: const TextStyle(color: AppColor.primary),
                ),
                if (plan.support.isNotEmpty) const SizedBox(height: 8),
                if (plan.support.isNotEmpty)
                  Text(
                    "👉🏼 ${plan.support} Support",
                    style: const TextStyle(color: AppColor.primary),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (onBuyPressed != null)
            PrimaryButton(
              label: "Buy Plan",
              onPressed: () {
                if (onBuyPressed != null) onBuyPressed!(planRate.toInt());
              },
            )
        ],
      ),
    );
  }
}
