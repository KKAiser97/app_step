import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'step_state.dart';

class HomeCubit extends Cubit<HomeState> {
  StreamSubscription? _accelSub;
  double _lastAccel = 0;
  final double _threshold = 1.2; // TODO: may variable to adjust sensitivity

  HomeCubit() : super(HomeState.initial());

  void startCounting() {
    _accelSub?.cancel();
    _accelSub = accelerometerEventStream().listen((event) {
      final accel = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      final delta = (accel - _lastAccel).abs();

      if (delta > _threshold) {
        emit(state.copyWith(steps: state.steps + 1));
      }
      _lastAccel = accel;
    });
  }

  void stopCounting() {
    _accelSub?.cancel();
    _accelSub = null;
  }

  void setGoal(int newGoal) {
    emit(state.copyWith(goal: newGoal));
  }

  @override
  Future<void> close() {
    _accelSub?.cancel();
    return super.close();
  }
}
