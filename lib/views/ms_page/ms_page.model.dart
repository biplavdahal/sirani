import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/mixins/snack_bar.mixin.dart';
import 'package:bestfriend/ui/view.model.dart';
import 'package:mysirani/data_model/error.data.dart';
import 'package:mysirani/helpers/dio.helper.dart';
import 'package:mysirani/services/app.service.dart';
import 'package:mysirani/views/ms_page/ms_page.argument.dart';

class MSPageModel extends ViewModel with SnackbarMixin {
  // Service
  final AppService _appService = locator<AppService>();

  // Data
  late String _title;
  String get title => _title;
  late String _content;
  String get content => _content;

  // Action
  Future<void> init(MSPageArgument? argument) async {
    _title = argument?.title ?? 'Page';
    setIdle();

    try {
      setLoading();
      _content = await _appService.getContent(argument!.slug);
    } on ErrorData catch (e) {
      errorHandler(snackbar, e: e);
    }

    setIdle();
  }
}
