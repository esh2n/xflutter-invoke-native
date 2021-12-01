import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:routemaster/routemaster.dart';
import '../../00_common/ffl/platform_channel_provider.dart';

class PlatFormPage extends ConsumerWidget {
  const PlatFormPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final platform = ref.watch(platformChannelProvider);
    final networkStateStream = ref.watch(onNetworkStateChangeStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(Routemaster.of(context).currentRoute.fullPath),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Text('Platform', style: textTheme.headline2)),
              const Gap(16),
              Text('Reachable', style: textTheme.headline3),
              Text(platform.isReachable ? 'Reachable' : 'Not reachable'),
              const Gap(32),
              Text('Network state', style: textTheme.headline4),
              networkStateStream.when(data: (state) {
                print('Network state changed: $state');
                switch (state) {
                  case 1:
                    return const Text('Connected via Movile');
                  case 2:
                    return const Text('Connected via Wifi');
                  default:
                    return const Text('Not connected');
                }
              }, error: (err, stack) {
                return Text('Error: $err');
              }, loading: () {
                return const Center(child: CircularProgressIndicator());
              }),
              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }
}
