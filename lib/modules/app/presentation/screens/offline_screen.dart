import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/utils.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key, required this.from});

  final String? from;

  @override
  Widget build(BuildContext context) {
    final service = context.read<ConnectivityService>();

    return CupertinoPageScaffold(
      child: StreamBuilder<bool>(
        stream: service.onConnectivityChanged,
        builder: (context, snapshot) {
          if (from != null && (snapshot.data ?? false)) {
            Modular.to.navigate(from!);
          }

          return SafeArea(
            child: Center(
              child: Padding(
                padding: PaddingHorizontal(),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.wifi_exclamationmark,
                            color: CupertinoColors.systemBlue,
                            size: 150,
                          ),
                          50.vSpacing,
                          context.t.offline_title.text.styled(
                            context.theme.textTheme.navLargeTitleTextStyle,
                          ),
                          10.vSpacing,
                          context.t.offline_subtitle.text,
                        ],
                      ),
                    ),
                    CupertinoButton.filled(
                      onPressed: Modular.to.pop,
                      child: context.t.offline_button.text,
                    ).stretch(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
