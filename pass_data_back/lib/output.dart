import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pass_data_back/provider.dart';
import 'input.dart';

class OutputPage extends ConsumerWidget {
  const OutputPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(nameProvider.notifier).state;
    final age = ref.watch(ageProvider.notifier).state;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name),
          Text(age.toString()),
          GestureDetector(
            child: const Text('GO BACK'),
            onTap: () {
              if (age > 18) {
                ref.refresh(isAdult.notifier).state = true;
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
