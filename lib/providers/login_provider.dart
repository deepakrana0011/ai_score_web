import 'package:ai_score/constants/route_constants.dart';
import 'package:ai_score/enum/view_state.dart';
import 'package:ai_score/fetch_data_exception.dart';
import 'package:ai_score/helper/dialog_helper.dart';
import 'package:ai_score/helper/shared_pref.dart';
import 'package:ai_score/providers/base_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class LoginProvider extends BaseProvider{

  bool passwordVisible = false;

  bool data = false;

  updateData(bool val){
    data = val;
    notifyListeners();
  }

  Future<bool> login(
      BuildContext context, String email, String password) async {
    setState(ViewState.Busy);
    try {
      var model =  await api.login(email, password);
      if(model.success == true){
        SharedPref.prefs!.setString(SharedPref.userType, model.data.type.toString());
        SharedPref.prefs?.setString(SharedPref.token, model.data.token.toString()) ?? "";
        SharedPref.prefs!.setString(SharedPref.userId, model.data.id.toString());
        SharedPref.prefs?.setBool(SharedPref.isUserLogin, true);
        Navigator.pushNamed(context, RoutesConstants.home);
      } else{
        DialogHelper.showMessage(context, model.message);
      }
      setState(ViewState.Idle);
      return true;
    } on FetchDataException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

}