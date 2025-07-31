import 'package:app_steps/src/home/presentation/cubit/step_cubit.dart';
import 'package:app_steps/src/home/presentation/cubit/step_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  late HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomeCubit>();
    _cubit.startCounting();
  }

  @override
  void dispose() {
    _cubit.stopCounting();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Today Steps')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final progress = state.steps / state.goal;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        strokeWidth: 12,
                      ),
                    ),
                    Text(
                      '${state.steps}/${state.goal}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _showSetGoalDialog(context, state.goal),
                  child: const Text('Set Goal'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showSetGoalDialog(BuildContext context, int currentGoal) {
    final controller = TextEditingController(text: currentGoal.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Set Daily Goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Steps'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newGoal = int.tryParse(controller.text) ?? currentGoal;
              context.read<HomeCubit>().setGoal(newGoal);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}