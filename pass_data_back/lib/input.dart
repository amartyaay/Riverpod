import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pass_data_back/output.dart';
import 'package:pass_data_back/provider.dart';

final ageProvider = StateProvider<int>((ref) {
  return 0;
});

final nameProvider = StateProvider<String>((ref) {
  return "";
});

class InputPage extends ConsumerWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController name = TextEditingController();
    TextEditingController age = TextEditingController();
    // final nameProvider = Provider((ref) => name.text);
    // final ageProvider = Provider((ref) => age.text);
    final adult = ref.watch(isAdult.notifier).state;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            child: TextField(
              controller: name,
              onChanged: (value) {
                ref.read(nameProvider.notifier).state = value;
              },
            ),
          ),
          SizedBox(
            width: 50,
            child: TextField(
              controller: age,
              onChanged: (value) {
                ref.read(ageProvider.notifier).update((state) => int.tryParse(age.text) ?? 0);
              },
            ),
          ),
          Text(adult.toString()),
          GestureDetector(
            child: const Text('GO NEXT'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OutputPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
