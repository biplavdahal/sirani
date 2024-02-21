import 'package:bestfriend/ui/view.model.dart';
import 'package:mysirani/data_model/resource.data.dart';
import 'package:mysirani/views/resource/resource.argument.dart';

class ResourceModel extends ViewModel {
  // Data
  late ResourceData _resource;
  ResourceData get resource => _resource;

  // Action
  void init(ResourceArgument argument) {
    _resource = argument.resource;
    setIdle();
  }
}
