import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SuggestionScreen(),
    );
  }
}

class SuggestionScreen extends StatelessWidget {
  const SuggestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // --- AppBar ---
      appBar: AppBar(
        // Fond de la barre d'application assorti à l'image (mauve/violet clair)
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0, // Enlève l'ombre de l'AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Suggestion',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // --- Corps de l'écran ---
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Espace principal pour le message de bienvenue
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'Vos Suggestion sont les bienvenues !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.85),
                  ),
                ),
              ),
            ),
          ),

          // Champ de saisie de message (Input field)
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'message',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  border: InputBorder.none, // Enlève la bordure par défaut
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: const Color(0xFF9370DB), // Couleur mauve pour l'icône
                    ),
                    onPressed: () {
                      // Logique pour envoyer le message
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}