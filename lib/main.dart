import 'package:flutter/material.dart';
import 'package:projet_gares/blocs/departures_cubit.dart';
import 'package:projet_gares/blocs/train_station_cubit.dart';
import 'package:projet_gares/repositories/arrivals_repository.dart';
import 'package:projet_gares/repositories/departures_repository.dart';
import 'package:projet_gares/repositories/train_station_repository.dart';
import 'package:projet_gares/ui/screens/favorites.dart';
import 'package:projet_gares/ui/screens/home.dart';
import 'package:projet_gares/ui/screens/train_station_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/arrivals_cubit.dart';

void main() async {
  await dotenv.load(fileName: "../.env");
  final TrainStationCubit trainStationCubit = TrainStationCubit(TrainStationRepository());

  runApp(
      BlocProvider<TrainStationCubit>(
      create: (_) => trainStationCubit,
      child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFF8B2635),
          primaryContainer: Color(0xFF8B2635),
          secondary: Color(0xFFEBEBD3),
          secondaryContainer: Color(0xFF8491A3),
          surface: Colors.white,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF083D77),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Colors.white70,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          displaySmall: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      routes: {
        '/':  (context) => const Home(title: 'Trains stations map',),
        '/train_station': (context) {
          final stationId = ModalRoute.of(context)?.settings.arguments as String;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => DeparturesCubit(DeparturesRepository(stationId)),
              ),
              BlocProvider(
                create: (context) => ArrivalsCubit(ArrivalsRepository(stationId)),
              ),
            ],
            child: TrainStation(stationId: stationId),
          );
        },
        '/favorites': (context) => const Favorites(),
      },
      initialRoute: '/',
    );
  }
}