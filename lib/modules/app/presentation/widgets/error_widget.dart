import 'package:flutter/cupertino.dart';

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
    return Container();
  }
}
