import 'api/export.dart';
import 'universal/export.dart';
export 'api/export.dart';
export 'data/export.dart';
export 'universal/export.dart';

class GrowthAuth0 {
  static final api = Auth0Api();
  static final universal = Auth0Universal();
}
