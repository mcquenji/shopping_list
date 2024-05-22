import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/utils.dart';

class UnexpectedErrorWidget extends StatelessWidget {
  const UnexpectedErrorWidget({
    super.key,
    required this.exception,
    required this.stackTrace,
  });

  final Object exception;
  final StackTrace? stackTrace;

  static Widget builder(
    BuildContext context,
    Object exception,
    StackTrace? stackTrace,
  ) {
    return UnexpectedErrorWidget(
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  static Widget handler(
    Object exception,
    StackTrace? stackTrace,
  ) {
    return UnexpectedErrorWidget(
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: PaddingHorizontal(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  size: 100,
                  color: CupertinoColors.systemRed,
                ),
                10.vSpacing,
                context.t.unexpected_error_title.text.centered.styled(
                  context.theme.textTheme.navTitleTextStyle,
                ),
                context.t.unexpected_error_message.text.centered,
              ],
            ),
            if (kDebugMode)
              CupertinoButton(
                child: const Text("Print error details"),
                onPressed: () {
                  // ignore: avoid_print
                  print(exception);
                  // ignore: avoid_print
                  print(stackTrace);
                },
              ),
            CupertinoButton(
              child: context.t.global_goBack.text,
              onPressed: () => Modular.to.navigate("/"),
            ).stretch(),
          ],
        ),
      ),
    );
  }
}
