import 'dart:async';
import 'dart:isolate';

import 'package:e2e_test/e2e_worker_void_result.dart';
import 'package:worker_bee/worker_bee.dart';

Future<void> _run(SendPorts ports) async {
  final channel = IsolateChannel<Object?>.connectSend(ports.messagePort);
  final logsChannel = IsolateChannel<LogMessage>.connectSend(ports.logPort);
  final worker = E2EWorkerVoidResultImpl();
  await worker.connect(logsChannel: logsChannel);
  await worker.run(
    channel.stream.asBroadcastStream().cast(),
    channel.sink.cast(),
  );
// ignore: invalid_use_of_protected_member
  worker.logger.finest('Finished');
  unawaited(worker.close());
  Isolate.exit(ports.donePort);
}

/// The VM implementation of [E2EWorkerVoidResult].
class E2EWorkerVoidResultImpl extends E2EWorkerVoidResult {
  @override
  String get name => 'E2EWorkerVoidResult';
  @override
  VmEntrypoint get vmEntrypoint => _run;
}
