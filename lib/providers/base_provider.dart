import 'package:ai_score/enum/view_state.dart';
import 'package:ai_score/locator.dart';
import 'package:ai_score/service/api.dart';
import 'package:flutter/widgets.dart';

class BaseProvider extends ChangeNotifier {
  ViewState _state = ViewState.Idle;
  bool _isDisposed = false;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    if (!_isDisposed) {
      notifyListeners();
    }
  }


  Api api = locator<Api>();

  void customNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
