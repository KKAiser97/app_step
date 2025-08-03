import 'dart:async';

import 'package:app_steps/src/home/presentation/cubit/step_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeCubit extends Cubit<HomeState> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  int _lastCount = 0;

  HomeCubit() : super(HomeState.initial());

  // void onPedestrianStatusChanged(PedestrianStatus event) {
  //   print(event);
  //   setState(() {
  //     _status = event.status;
  //   });
  // }

  // void onPedestrianStatusError(error) {
  //   print('onPedestrianStatusError: $error');
  //   setState(() {
  //     _status = 'Pedestrian Status not available';
  //   });
  //   print(_status);
  // }
  //
  // void onStepCountError(error) {
  //   print('onStepCountError: $error');
  //   setState(() {
  //     _steps = 'Step Count not available';
  //   });
  // }

  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() == PermissionStatus.granted;
    }

    return granted;
  }

  Future<void> initPlatformState() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      // tell user, the app will not work
    }

    // _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    // (await _pedestrianStatusStream.listen(onPedestrianStatusChanged))
    //     .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount);
    // _stepCountStream.listen(_onStepCount).onError(onStepCountError);

    // if (!mounted) return;
  }

  // void startCounting() {
  //   // _stepCountStream.cancel();
  //   // Listen to the pedometer step count stream
  //   _stepCountStream = Pedometer.stepCountStream.listen(_onStepCount);
  // }

  void _onStepCount(StepCount event) {
    // event.steps is the total count since boot, so compute delta
    final current = event.steps;
    final delta = current - _lastCount;
    if (delta > 0) {
      emit(state.copyWith(steps: state.steps + delta));
    }
    _lastCount = current;
  }

  // void stopCounting() {
  //   _stepCountStream?.cancel();
  //   _stepCountStream = null;
  // }

  void setGoal(int newGoal) {
    emit(state.copyWith(goal: newGoal));
  }

  @override
  Future<void> close() {
    // _stepCountStream?.cancel();
    return super.close();
  }
}
