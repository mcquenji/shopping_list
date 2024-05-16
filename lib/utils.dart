import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

extension L10nContextExt on BuildContext {
  AppLocalizations get t => AppLocalizations.of(this)!;
}

extension L10nStateExt on State {
  AppLocalizations get t => context.t;
}

extension ThemeContextExt on BuildContext {
  CupertinoThemeData get theme => CupertinoTheme.of(this);
}

extension ThemeStateExt on State {
  CupertinoThemeData get theme => context.theme;
}

extension ColorExt on Color {
  String get hex => "#${value.toRadixString(16).substring(2)}";
}

extension TextStyleExt on TextStyle? {
  TextStyle? get bold => this?.copyWith(fontWeight: FontWeight.bold);
}

extension MediaQueryContextExt on BuildContext {
  Size get screen => MediaQuery.of(this).size;
}

extension CupertinoAcitivityIndicatorExt on CupertinoActivityIndicator {
  CupertinoActivityIndicator large(BuildContext context) =>
      CupertinoActivityIndicator(
        radius: context.screen.width * 0.05,
        animating: animating,
        color: color,
        key: key,
      );
}
