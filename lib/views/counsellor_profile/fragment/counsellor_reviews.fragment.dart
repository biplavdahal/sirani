import 'package:flutter/material.dart';
import 'package:mysirani/data_model/counsellor_review.data.dart';
import 'package:mysirani/helpers/date_time_format.helper.dart';
import 'package:mysirani/theme.dart';

class CounsellorReviews extends StatelessWidget {
  final List<CounsellorReviewData> reviews;

  const CounsellorReviews(this.reviews, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final _review = reviews[index];

        return ListTile(
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star,
                color: AppColor.accent,
              ),
              const SizedBox(
                width: 4,
              ),
              Text("${_review.rating}/5")
            ],
          ),
          title: Text(
            _review.name,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          leading: CircleAvatar(
            foregroundColor: AppColor.primary,
            child: Text(
              _review.name[0].toUpperCase(),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _review.review,
                style: const TextStyle(
                  color: AppColor.primaryTextColor,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                formattedDateTime(_review.dateTime),
                style: const TextStyle(fontSize: 11),
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: reviews.length,
    );
  }
}
