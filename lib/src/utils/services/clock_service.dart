import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_storyboard/src/utils/datetime_extension.dart';
import 'package:injectable/injectable.dart';

class MockDelay {
  final DateTime completionSchedule;
  final FutureOr<void> Function(Timer timer) callback;
  final bool periodic;
  final Duration duration;
  bool cancelled = false;

  MockDelay(
      this.completionSchedule, this.callback, this.periodic, this.duration);

  Timer get timer => FlitTimer(this);

  void cancel() {
    cancelled = true;
  }

  MockDelay next() {
    assert(periodic == true);
    final delay = MockDelay(
      this.completionSchedule.add(duration),
      callback,
      true,
      this.duration,
    );
    return delay;
  }
}

class FlitTimer implements Timer {
  final MockDelay mockDelay;
  FlitTimer(this.mockDelay);

  void cancel() {
    mockDelay.cancel();
  }

  @override
  bool get isActive => throw UnimplementedError();

  @override
  int get tick => throw UnimplementedError();
}

@lazySingleton
class ClockService {
  bool _mockMode = false;

  final List<MockDelay> _delays = [];
  late DateTime _nowMocked;
  DateTime now() {
    return _mockMode ? _nowMocked : clock.now();
  }

  void setMockMode(DateTime initialTimestamp) {
    assert(_mockMode == false);
    _nowMocked = initialTimestamp;
    _mockMode = true;
  }

  Future<void> elapse(Duration duration) async {
    assert(_mockMode == true);
    final targetTime = _nowMocked.add(duration);
    await _emptyQueue(targetTime);
    _nowMocked = targetTime;
  }

  Future<void> _emptyQueue(DateTime targetTime) async {
    int i = 0;
    while (i < _delays.length) {
      await Future.value();
      final delay = _delays[i];
      i++;

      if (delay.cancelled) {
        continue;
      }
      if (targetTime.isSameOrAfter(delay.completionSchedule)) {
        _nowMocked = delay.completionSchedule;
        delay.callback(delay.timer);
        delay.cancel();
        if (delay.periodic) {
          _scheduleDelay(delay.next());
        }
      }
    }
    _cleanList();
  }

  void _cleanList() {
    _delays.removeWhere((delay) => delay.cancelled);
  }

  String get logTraceTwo => StackTrace.current
      .toString()
      .split("\n")
      .toList()[2]
      .split("      ")
      .last
      .split(" ")
      .last;

  Future<T> runFuture<T>(
    Future<T> future, {
    String? logTag,
    Duration? timeout,
  }) async {
    final trace = logTraceTwo;
    final start = DateTime.now();
    if (logTag != null) {
      print("[FUTURE] "
          "$logTag $trace awaiting... "
          "${timeout != null ? "(with timeout $timeout)" : ""}");
    }
    Completer<T> completer = Completer();
    Timer? timerTimeout;
    if (timeout != null) {
      timerTimeout = timer(timeout, (timer) {
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException(
            "Future ${logTag ?? ""} $trace not completed withing $timeout",
            timeout,
          ));
        }
      });
    }
    final _ = future.then((value) {
      if (completer.isCompleted) return;
      timerTimeout?.cancel();
      if (logTag != null) {
        print("[FUTURE] $logTag $trace completed!"
            " Took ${DateTime.now().difference(start)}");
      }
      completer.complete(value);
    }).catchError((error) {
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<void> futureDelayed(Duration delay) async {
    if (!_mockMode) return Future.delayed(delay);
    final completer = Completer();
    timer(delay, (Timer timer) {
      completer.complete();
      print("Completer completed");
    }, false);
    return completer.future;
  }

  Timer timerPeriodic(Duration duration, void Function(Timer timer) callback) {
    if (!_mockMode) return Timer.periodic(duration, callback);
    return timer(duration, callback, true);
  }

  Stream streamPeriodic(Duration duration) {
    if (!_mockMode) return Stream.periodic(duration);
    final streamCtrl = StreamController();
    timer(duration, (Timer timer) {
      streamCtrl.add(timer.isActive);
    }, true);
    return streamCtrl.stream;
  }

  Timer timer(Duration duration, FutureOr<void> Function(Timer timer) callback,
      [bool period = false]) {
    final delay = MockDelay(now().add(duration), callback, period, duration);
    _scheduleDelay(delay);
    // _emptyQueue(_nowMocked);
    return delay.timer;
  }

  void _scheduleDelay(MockDelay delay) {
    print(
        "New delay scheduled at ${delay.completionSchedule.toIso8601String()}");
    _delays.add(delay);
    _delays.sort((a, b) {
      return a.completionSchedule.compareTo(b.completionSchedule);
    });
  }
}

// https://github.com/dart-lang/fake_async/issues/34
// @Deprecated() use clock.now() directly
// It is safe to say that it will return a new object everytime
DateTime now() {
  return DateTime.fromMillisecondsSinceEpoch(
    clock.now().millisecondsSinceEpoch,
  );
}
