import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

const unknownWeatherEmoji = "🤷‍♂️";

enum City {
  london,
  paris,
  tokyo,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 2),
    () => {
      City.paris: '⛄',
      City.london: '🌧️☂️',
      City.tokyo: '🌞🌻',
    }[city]!,
  );
}

//StateProvider hold STATE which can be changed from OUTSIDE WORLD
//UI write to this and Reead from This
final currentCityProvider = StateProvider<City?>((ref) {
  return null;
});

//Depending on other PROVIDER
//UI only read this
final weatherProvider = FutureProvider<WeatherEmoji>((ref) async {
  //listening to changes to Current City CHnages.
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWeather(city);
  } else {
    return unknownWeatherEmoji;
  }
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Weather"),
      ),
      //ListView inside Column must be inside Expanded
      body: Column(
        children: [
          currentWeather.when(
            data: (data) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                data,
                style: emojiStyle,
              ),
            ),
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (context, index) {
                final city = City.values[index];
                final isSelected = city == ref.watch(currentCityProvider);
                return ListTile(
                  title: Text(city.toString()),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  //provider doesnt have a STATE, its NOTIFIER does, so to change state, we use NOTIFIER.
                  onTap: () => ref.read(currentCityProvider.notifier).state = city,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
