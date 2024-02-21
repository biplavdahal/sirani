import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/data_model/program.data.dart';
import 'package:mysirani/theme.dart';

class ProgramItem extends StatelessWidget {
  final ProgramData program;

  const ProgramItem(this.program, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        MdiIcons.calendar,
                        color: AppColor.secondaryTextColor,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        program.duration,
                        style: const TextStyle(
                          color: AppColor.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    program.title,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    program.shortDetail,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                width: 124,
                height: 124,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(
                      auImageBaseUrl + program.image,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: 124,
                height: 124,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.center,
                      colors: [
                        Colors.white,
                        Colors.white10,
                      ]),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
