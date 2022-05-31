import 'package:flutter/material.dart';
import 'package:pokhara_app/core/notifiers/providers/app_flavour.dart';
import 'package:pokhara_app/core/notifiers/providers/auth_state.dart';
import 'package:pokhara_app/core/notifiers/providers/language_state.dart';
import 'package:pokhara_app/utils/utilities.dart';
import 'package:pokhara_app/view/pages/dashboard/dashboard.dart';
import 'package:pokhara_app/view/pages/login.dart';
import 'package:pokhara_app/view/pages/profile/profile_page.dart';
import 'package:provider/provider.dart';

class AuthService extends StatelessWidget {
  const AuthService({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget getView(AuthState state) {
      if (state.isAuthenticated) {
        if (state.credentials.user.name == null ||
            state.credentials.user.name.isEmpty) {
          Utilities.showInToast('Please Complete your profile',
              toastType: ToastType.INFO);
          return ProfilePage(
            editMode: true,
          );
        } else {
          return Dashboard();
        }
      }
      return LoginPage();
    }

    return Consumer<AppFlavour>(
      builder: (context, value, child) {
        return Consumer<LanguageState>(
          builder: (context, myType, child) {
            return Consumer<AuthState>(
              builder: (context, state, child) {
                return SafeArea(
                  child: getView(state),
                  // child: Banner(
                  //     message: Constants.isProduction ? 'Beta' : 'Test',
                  //     location: BannerLocation.topStart,
                  //     child: getView(state)),
                );
              },
            );
          },
        );
      },
    );
  }
}
