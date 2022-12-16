import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

const TextStyle emojiStyle = TextStyle(
  fontSize: 60,
  fontWeight: FontWeight.bold,
);

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

@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  Person({
    required this.name,
    required this.age,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  Person updated([String? name, int? age]) => Person(
        name: name ?? this.name,
        age: age ?? this.age,
        uuid: uuid,
      );
  String get displayName => '$name - $age yrs';

  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() => 'Person(name: $name,age: $age,uuid: $uuid)';
}

//Change Notifier
class DataModel extends ChangeNotifier {
  final List<Person> _person = [];
  int get count => _person.length;
  UnmodifiableListView<Person> get people => UnmodifiableListView(_person);

  //add people
  void add(Person person) {
    _person.add(person);
    notifyListeners();
  }

  void remove(Person person) {
    _person.remove(person);
    notifyListeners();
  }

  void update(Person updatedPerson) {
    //modified bool operator compare only uuid
    final index = _person.indexOf(updatedPerson);
    final oldPerson = _person[index];
    if (oldPerson.age != updatedPerson.age || oldPerson.name != updatedPerson.name) {
      _person[index] = oldPerson.updated(
        updatedPerson.name,
        updatedPerson.age,
      );
      notifyListeners();
    }
  }
}

final peopleProvider = ChangeNotifierProvider<DataModel>((ref) {
  return DataModel();
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
