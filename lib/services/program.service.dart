import 'package:mysirani/data_model/program.data.dart';

abstract class ProgramService {
  // Getter for all programs list
  List<ProgramData> get programs;

  // Returns [true] if there are more programs to load.
  bool get hasMore;

  // Fetch programs
  Future<void> fetchPrograms();
}
