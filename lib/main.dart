import 'package:flutter/material.dart';
import 'package:projet_gares/ui/screens/favorites.dart';
import 'package:projet_gares/ui/screens/home.dart';
import 'package:projet_gares/ui/screens/train_station.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const Home(title: 'Home',),
        '/train_station': (context) => const TrainStation(),
        '/favorites': (context) => const Favorites(),
      },
        initialRoute: '/'
    );
  }
}


