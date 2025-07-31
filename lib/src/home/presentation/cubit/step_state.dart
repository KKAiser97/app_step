import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final int steps;
  final int goal;

  const HomeState({required this.steps, required this.goal});

  factory HomeState.initial() => const HomeState(steps: 0, goal: 10000);

  HomeState copyWith({int? steps, int? goal}) {
    return HomeState(
      steps: steps ?? this.steps,
      goal: goal ?? this.goal,
    );
  }

  @override
  List<Object> get props => [steps, goal];
}