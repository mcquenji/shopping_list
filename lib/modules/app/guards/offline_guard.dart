import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';

class OfflineGuard extends RouteGuard {
  OfflineGuard() : super(redirectTo: "/offline");

  @override
  Future<bool> canActivate(String path, ParallelRoute route) async {
    final connectivity = Modular.get<ConnectivityService>();

    return connectivity.isConnected;
  }
}
