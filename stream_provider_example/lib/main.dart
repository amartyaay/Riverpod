import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

const names = [
  'Tya',
  'Nali',
  'Pin',
  'Anju',
  'Rai',
  'Bob',
  'Alice',
  'Youtube',
  'Beast',
  'Pwe',
];
final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(
    const Duration(seconds: 1),
    (i) => i + 1,
  ),
);

final namesProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.stream).map(
        (count) => names.getRange(0, count),
      ),
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream Provider'),
        centerTitle: true,
      ),
      body: names.when(
        data: (names) {
          return ListView.builder(
            itemCount: names.length,
            itemBuilder: ((context, index) {
              return ListTile(
                title: Text(names.elementAt(index)),
              );
            }),
          );
        },
        error: ((error, stackTrace) => Center(
              child: Text(
                error.toString(),
              ),
            )),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
