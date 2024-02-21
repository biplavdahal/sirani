import 'package:bestfriend/bestfriend.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/program/program.argument.dart';

class ProgramView extends StatelessWidget {
  final Arguments? arguments;
  static String tag = 'program-view';

  const ProgramView(this.arguments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _program = (arguments as ProgramArgument).program;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_program.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 200.h,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: auImageBaseUrl + _program.image,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
                    _program.duration,
                    style: const TextStyle(
                      color: AppColor.secondaryTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(_program.fullDetail),
            ],
          ),
        ),
      ),
    );
  }
}
