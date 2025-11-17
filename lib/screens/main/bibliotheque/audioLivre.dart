import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur active)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const String _fontFamily = 'Roboto'; // Police principale

class BookAudioReaderScreen extends StatelessWidget {
  final String bookTitle;

  // Le texte simulé du livre
  final String bookContent = """
Alfred se remémore ses souvenirs personnels, ces instants en apparence anodins, mais qui ont été des bascules dans sa vie. Un souvenir en entraînant un autre, il plonge dans sa tête, dans son cheminement, qu'il traduit en dessins.
Il se rappelle ce jour de mars 2021, à Naples, alors qu'il est avec sa fille. Il a rendez-vous sur le tournage de Come Prima, avec l'équipe du film pour les scènes de nuit. Mais dans le taxi, il est complètement perdu. Dans ce port, tout se ressemble. Il panique. Il n'arrive pas à joindre l'équipe de tournage. Le chauffeur s'agace et, à sa grande surprise, sa fille prend les devants. Ils sortent du taxi et elle part en tête. Lui est toujours perdu. Il la voit devant lui, sa petite fille, qui inverse les rôles et le prend sous son aile. Il se laisse guider et quelques centaines de mètres plus loin, elle réussit à atteindre leur objectif.
En novembre 2007, il est à Djibouti, seul, pour mener des ateliers de dessin dans des écoles isolées. C'est la première fois qu'il vient en Afrique. Il est très occupé et il n'a pas toujours le temps de donner de ses nouvelles, ni d'en recevoir de France, car la connexion n'est pas bonne partout. Ce jour-là, il peut accéder à un ordinateur connecté à Internet : le directeur d'une école lui laisse sa place. Au milieu de...
""";

  const BookAudioReaderScreen({super.key, this.bookTitle = "Le jardin Invisible"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. App Bar personnalisé 
          _buildCustomAppBar(context),

          // 2. Le corps de la page (Texte du livre défilant)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                bookContent,
                style: const TextStyle(
                  color: _colorBlack,
                  fontSize: 15,
                  height: 1.6, // Interlignage
                  fontFamily: _fontFamily,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          
          // 3. Le lecteur audio flottant/fixe
          _buildAudioPlayer(context),
        ],
      ),
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            // Titre de la page et Bouton de lecture (si l'audio n'est pas déjà lancé)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
                  onPressed: () => Navigator.pop(context), 
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      bookTitle, // Ex: "Le jardin Invisible"
                      style: const TextStyle(
                        color: _colorBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                ),
                // L'icône de lecture/pause est désormais dans le lecteur audio, 
                // mais si on voulait garder l'ancienne logique pour lancer l'audio depuis la barre supérieure:
                // const SizedBox(width: 48), 
                // Remplacé par une icône vide pour maintenir l'alignement du titre:
                const SizedBox(width: 48), 
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayer(BuildContext context) {
    // Simuler la position actuelle et la durée totale
    const int currentChapter = 13;
    const int totalChapters = 40;
    // Simuler la progression (ici 13/40) pour le slider
    double progressValue = currentChapter / totalChapters;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: _purpleMain.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _purpleMain.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton Play/Pause (basé sur l'image qui montre une icône Pause)
          Icon(Icons.pause, color: Colors.white, size: 28),
          
          const SizedBox(width: 10),
          
          // Barre de Progression
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 5.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayShape: SliderComponentShape.noOverlay,
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white.withOpacity(0.4),
                thumbColor: Colors.white,
              ),
              child: Slider(
                value: progressValue,
                onChanged: (double value) {
                  // Logique pour changer la position de lecture
                },
              ),
            ),
          ),
          
          const SizedBox(width: 10),

          // Compteur de Chapitres
          Text(
            '$currentChapter/$totalChapters',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

}
