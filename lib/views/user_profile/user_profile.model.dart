import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/views/change_password/change_password.view.dart';
import 'package:mysirani/views/edit_profile/edit_profile.view.dart';
import 'package:mysirani/views/statement/statement.view.dart';

class UserProfileModel extends ViewModel {
  // Actions
  Future<void> moreOptionActions(String action) async {
    switch (action) {
      case 'change_password':
        await goto(ChangePasswordView.tag);
        setIdle();
        break;
      case 'wallet_statement':
        await goto(StatementView.tag);
        setIdle();
        break;
      case 'update_profile':
        await goto(EditProfileView.tag);
        setIdle();
        break;
    }
  }
}
