import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
      ),
      body: const Center(
        child: Text('Favorites'),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, '/home');
          },
          child: const Icon(Icons.train_outlined),
        )
    );
  }
}
