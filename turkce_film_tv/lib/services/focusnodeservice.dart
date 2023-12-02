import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LeftButtonIntent extends Intent {}

class RightButtonIntent extends Intent {}

class UpButtonIntent extends Intent {}

class DownButtonIntent extends Intent {}

class EnterButtonIntent extends Intent {}

class FocusService {
  static final FocusNode loginButtonNode = FocusNode();
  static final FocusNode registerButtonNode = FocusNode();
  static final FocusNode loginEpostaNode = FocusNode();
  static final FocusNode loginSifreNode = FocusNode();
  static final FocusNode loginLoginButtonNode = FocusNode();
  static final FocusNode loginForgotPasswordButtonNode = FocusNode();
  static final FocusNode registerKullaniciAdiNode = FocusNode();
  static final FocusNode registerEPostaNode = FocusNode();
  static final FocusNode registerPasswordNode = FocusNode();
  static final FocusNode registerPasswordAgainNode = FocusNode();
  static final FocusNode registerRegisterButtonNode = FocusNode();
  static final FocusNode forgotPasswordMailNode = FocusNode();
  static final FocusNode forgotPasswordSubmitNode = FocusNode();
  static final FocusNode homepageMenuAnasayfaNode = FocusNode();
  static final FocusNode homepageMenuWatchlistNode = FocusNode();
  static final FocusNode homepageMenuCategoriesNode = FocusNode();
  static final FocusNode homepageMenuSearchNode = FocusNode();
  static final FocusNode homepageMenuAvatarNode = FocusNode();
  static final FocusNode homepagePlayNode = FocusNode();
  static final FocusNode homepageAddToListNode = FocusNode();
  static final FocusNode homepageListNode = FocusNode();
  static final FocusNode listemWillWatchNode = FocusNode();
  static final FocusNode listemWillWatchDeleteNode = FocusNode();
  static final FocusNode listenWillWatchMakeWatchedNode = FocusNode();
  static final FocusNode listemWatchedNode = FocusNode();
  static final FocusNode listemWatchedDeleteNode = FocusNode();
  static final FocusNode listemWatchedRemoveNode = FocusNode();
  static final FocusNode avatarCurrentPasswordNode = FocusNode();
  static final FocusNode avatarNewPasswordNode = FocusNode();
  static final FocusNode avatarUpdateSubmitNode = FocusNode();
  static final FocusNode avatarLogOutNode = FocusNode();
  static final FocusNode avatarGridViewBuilderNode = FocusNode();
  static final FocusNode categoryMenuNode = FocusNode();

  static void disposeAll() {
    loginButtonNode.dispose();
    registerButtonNode.dispose();
    loginEpostaNode.dispose();
    loginSifreNode.dispose();
    loginLoginButtonNode.dispose();
    loginForgotPasswordButtonNode.dispose();
    registerKullaniciAdiNode.dispose();
    registerEPostaNode.dispose();
    registerPasswordNode.dispose();
    registerPasswordAgainNode.dispose();
    registerRegisterButtonNode.dispose();
    forgotPasswordMailNode.dispose();
    forgotPasswordSubmitNode.dispose();
    homepageMenuAnasayfaNode.dispose();
    homepageMenuWatchlistNode.dispose();
    homepageMenuCategoriesNode.dispose();
    homepageMenuSearchNode.dispose();
    homepageMenuAvatarNode.dispose();
    homepagePlayNode.dispose();
    homepageAddToListNode.dispose();
    homepageListNode.dispose();
    listemWillWatchNode.dispose();
    listemWillWatchDeleteNode.dispose();
    listenWillWatchMakeWatchedNode.dispose();
    listemWatchedNode.dispose();
    listemWatchedDeleteNode.dispose();
    listemWatchedRemoveNode.dispose();
    avatarCurrentPasswordNode.dispose();
    avatarNewPasswordNode.dispose();
    avatarUpdateSubmitNode.dispose();
    avatarLogOutNode.dispose();
    avatarGridViewBuilderNode.dispose();
    categoryMenuNode.dispose();
  }

  static final LogicalKeySet arrowLeftKeySet =
      LogicalKeySet(LogicalKeyboardKey.arrowLeft);
  static final LogicalKeySet arrowRightKeySet =
      LogicalKeySet(LogicalKeyboardKey.arrowRight);
  static final LogicalKeySet arrowUpKeySet =
      LogicalKeySet(LogicalKeyboardKey.arrowUp);
  static final LogicalKeySet arrowDownKeySet =
      LogicalKeySet(LogicalKeyboardKey.arrowDown);
  static final LogicalKeySet selectKeySet =
      LogicalKeySet(LogicalKeyboardKey.select);

  static final Map<LogicalKeySet, Intent> shortcuts = <LogicalKeySet, Intent>{
    arrowLeftKeySet: LeftButtonIntent(),
    arrowRightKeySet: RightButtonIntent(),
    arrowUpKeySet: UpButtonIntent(),
    arrowDownKeySet: DownButtonIntent(),
    selectKeySet: EnterButtonIntent(),
  };

  static void changeFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
    if (focusNode.hasFocus) {
      print('Focused node: ${focusNode.debugLabel}');
    } else {
      print('No node currently focused.');
    }
  }
}
