import 'package:ai_score/providers/base_provider.dart';

class HomeProvider extends BaseProvider {
  int _selectedTabPosition = 0;

  int get selectedTabPosition => _selectedTabPosition;

  void updateSelectedTabPosition(int position) {
    _selectedTabPosition = position;
    customNotify();
  }
}
