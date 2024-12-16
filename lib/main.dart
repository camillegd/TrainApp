import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_gares/blocs/train_station_cubit.dart';
import 'package:projet_gares/repository/train_station_repository.dart';
import 'package:projet_gares/ui/screens/favorites.dart';
import 'package:projet_gares/ui/screens/home.dart';
import 'package:projet_gares/ui/screens/station_details.dart';

void main() {

  final TrainStationCubit trainStationCubit = TrainStationCubit(TrainStationRepository());
  runApp(
      BlocProvider<TrainStationCubit>(
          create: (_) => trainStationCubit,
          child: const MyApp())
      );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrainApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const Home(title: 'Trains stations map',),
        '/station_details': (context) => const StationDetails(),
        '/favorites': (context) => const Favorites(),
      },
        initialRoute: '/'
    );
  }
}


