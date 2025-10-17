// import 'package:flutter/material.dart';

// // --- CONSTANTES DE COULEURS ET STYLES ---

// // Couleurs principales basées sur le CSS/Design
// const Color _purpleHeader = Color(0xFFA885D8); // Header violet
// const Color _purpleMain = Color(0xFFA885D8); // Violet principal pour liens/icônes
// const Color _backgroundLight = Color(0xFFF5F5F5); // Fond clair pour les cartes
// const Color _colorGold = Color(0xFFFFD200); // Couleur dorée (étoile, notification)
// const Color _colorOrange = Color(0xFFFF7900); // Couleur orange (Défi, icône Challenge)
// const Color _colorGreen = Color(0xFF32C832); // Couleur verte (Quiz validé)
// const Color _colorBlack = Color(0xFF000000); // Texte noir
// const String _fontFamily = 'Roboto'; // Police principale (utilisée pour la majorité des textes)

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//      return Scaffold(
//       body: Stack(
//         children: [
//           // CONTENU PRINCIPAL AVEC HEADER FIXE
//           Column(
//             children: [
//               // Header fixe
//               _buildHeader(context),
              
//               // Espace pour le contenu scrollable (le header fait 174px)
//               Expanded(
//                 child: Container(
//                   // Fond blanc pour le contenu
//                   color: Colors.white,
//                   child: SingleChildScrollView(
//                     // Padding en haut = hauteur du header pour éviter que le contenu soit masqué
//                     padding: const EdgeInsets.only(top: 174.0, bottom: 90),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 23.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // --- SECTION 1: OBJECTIFS DE LECTURES ---
//                           _buildReadingGoalsSection(),
                          
//                           const SizedBox(height: 30),
                          
//                           // --- SECTION 2: SUCCÈS ET BADGES ---
//                           _buildBadgesSection(),
                   
//                           const SizedBox(height: 30),
                   
//                           // --- SECTION 3: ACTIVITÉ RÉCENTES ---
//                           _buildRecentActivitySection(),
                   
//                           const SizedBox(height: 30),
                   
//                           // --- SECTION 4: RECOMMANDATION POUR TOI (Défilement Horizontal) ---
//                           _buildRecommendationSection(),
                   
//                           const SizedBox(height: 30),
                          
//                           // --- SECTION 5: LECTURES (Barres de progression) ---
//                           _buildLecturesProgressSection(),
                   
//                           const SizedBox(height: 30),
                   
//                           // --- SECTION 6: NOS PARTENAIRES ÉDUCATIFS (Défilement Horizontal) ---
//                           _buildPartnersSection(),
                          
//                           // Espace supplémentaire en bas pour s'assurer que tout le contenu est visible
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
          
//           // Barre de navigation inférieure (Fixe)
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: _buildBottomNavBar(),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- WIDGETS DE STRUCTURE PRINCIPALE ---

//   Widget _buildHeader(BuildContext context) {
//     // Hauteur totale du Header: Rectangle 722 (115px) + Rectangle 2 (59px) = 174px
//     const double headerTotalHeight = 174.0;
    
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: headerTotalHeight,
//       decoration: const BoxDecoration(
//         color: _purpleHeader,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Stack(
//         children: [
//           // 1. Barre de Statut (20:20, Wifi, Batterie)
//           const Positioned(
//             top: 27, // top: 27px dans le CSS
//             left: 26,
//             child: Text(
//               '20 : 20',
//               style: TextStyle(
//                 color: _colorBlack,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//                 fontFamily: 'Inter', // Utilisation de 'Inter' comme dans le CSS
//               ),
//             ),
//           ),
//           const Positioned( // Position de l'Ellipse 1 pour simuler la caméra
//             top: 19,
//             left: 185,
//             child: Icon(Icons.circle, color: _colorBlack, size: 20),
//           ),
//           const Positioned(
//             top: 21,
//             right: 16, // Simule la position des icônes à droite
//             child: Row(
//               children: [
//                 Icon(Icons.wifi, color: _colorBlack, size: 24),
//                 SizedBox(width: 10),
//                 Icon(Icons.battery_full, color: _colorBlack, size: 24),
//               ],
//             ),
//           ),

//           // 2. Profil, Nom et Notifications
//           Positioned(
//             top: 67, // top: 67px dans le CSS
//             left: 19,
//             child: Row(
//               children: [
//                 // Avatar (Ellipse 172)
//                 CircleAvatar(
//                   radius: 25,
//                   backgroundColor: Colors.white,
//                   backgroundImage: AssetImage('assets/images/haoua_avatar.png'), // Assurez-vous d'avoir cet asset
//                 ),
//                 const SizedBox(width: 13),

//                 // Texte de Bienvenue
//                 const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Bienvenue',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                         fontFamily: 'Poppins',
//                       ),
//                     ),
//                     Text(
//                       'Haoua Haïdara',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                         fontFamily: 'Poppins',
//                       ),
//                     ),
//                   ],
//                 ),
                
//                 // Espacement pour pousser les icônes à droite
//                 SizedBox(width: MediaQuery.of(context).size.width - 250), 

//                 // Points (Rectangle 724)
//                 Container(
//                   width: 48,
//                   height: 24,
//                   padding: const EdgeInsets.symmetric(horizontal: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('1000', style: TextStyle(color: _colorOrange, fontSize: 10, fontWeight: FontWeight.w400)),
//                       Icon(Icons.star, color: _colorGold, size: 15),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 8),

//                 // Notification (Rectangle 725)
//                 Container(
//                   width: 31,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Center(
//                     child: Icon(Icons.notifications, color: _colorGold, size: 18),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // 3. Défi du Jour (Rectangle 723)
//           Positioned(
//             top: 143, // top: 143px dans le CSS
//             left: 30, // left: 30px dans le CSS
//             child: Container(
//               width: 332,
//               height: 57,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black26,
//                     offset: Offset(0, 4),
//                     blurRadius: 4,
//                   )
//                 ],
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: Row(
//                   children: [
//                     const Text(
//                       'Défi du jour',
//                       style: TextStyle(
//                         color: _colorBlack,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         fontFamily: _fontFamily,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     const Icon(Icons.edit_outlined, color: _colorOrange, size: 15), // lucide:edit
//                     const SizedBox(width: 8),
                    
//                     // Barre de progression (Rectangle 726)
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 20.0),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(50),
//                           child: LinearProgressIndicator(
//                             value: 0.53, // 160px / 290px ≈ 0.55, estimons 53%
//                             backgroundColor: const Color(0xFFD9D9D9),
//                             valueColor: const AlwaysStoppedAnimation<Color>(_purpleMain),
//                             minHeight: 10,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 15),
                    
//                     const Text(
//                       '5min',
//                       style: TextStyle(
//                         color: _colorBlack,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         fontFamily: _fontFamily,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNavBar() {
//     return Container(
//       height: 70, // 70px dans le CSS
//       decoration: const BoxDecoration(
//         color: _backgroundLight,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             offset: Offset(0, -2),
//             blurRadius: 5,
//           ),
//         ],
//       ),
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _NavBarItem(icon: Icons.home, label: 'Acceuil', isSelected: true),
//           _NavBarItem(icon: Icons.book_outlined, label: 'Bibliothèque'),
//           _NavBarItem(icon: Icons.emoji_events_outlined, label: 'Challenge'),
//           _NavBarItem(icon: Icons.checklist, label: 'Exercice'),
//           _NavBarItem(icon: Icons.chat_bubble_outline, label: 'Assistance'),
//         ],
//       ),
//     );
//   }

//   // --- WIDGETS DE CONTENU SCROLLABLE ---

//   Widget _buildReadingGoalsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Objectifs de Lectures',
//               style: TextStyle(
//                 color: _colorBlack,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Poppins',
//               ),
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: const Text(
//                 'Définir un objectif',
//                 style: TextStyle(
//                   color: _purpleMain,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: _fontFamily,
//                 ),
//               ),
//             ),
//           ],
//         ),
        
//         const SizedBox(height: 10),
        
//         // La carte des objectifs (Rectangle 745)
//         Container(
//           width: double.infinity,
//           height: 117,
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: _backgroundLight,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Objectif hebdomadaire',
//                     style: TextStyle(
//                       color: _colorBlack,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: _fontFamily,
//                     ),
//                   ),
//                   Text(
//                     '3 jours restant',
//                     style: TextStyle(
//                       color: _purpleMain,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: _fontFamily,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
              
//               Row(
//                 children: [
//                   const Icon(Icons.menu_book, color: _purpleMain, size: 24), // tdesign:book-open
//                   const SizedBox(width: 7),
//                   const Text(
//                     '5 Livres',
//                     style: TextStyle(
//                       color: _purpleMain,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       fontFamily: _fontFamily,
//                     ),
//                   ),
//                   const Spacer(),
//                   const Text(
//                     '3/5 livres lus',
//                     style: TextStyle(
//                       color: _colorBlack,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: _fontFamily,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
              
//               // Barre de progression (Group 885)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(50),
//                 child: LinearProgressIndicator(
//                   value: 0.6, // 3/5 livres lus
//                   backgroundColor: const Color(0xFFD9D9D9),
//                   valueColor: const AlwaysStoppedAnimation<Color>(_purpleMain),
//                   minHeight: 10,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBadgesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Succès et Badges',
//               style: TextStyle(
//                 color: _colorBlack,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Poppins',
//               ),
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: const Text(
//                 'Voir tout',
//                 style: TextStyle(
//                   color: _purpleMain,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: _fontFamily,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
        
//         // Liste des Badges
//         const Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _BadgeItem(
//               title: 'Génie math',
//               iconColor: Color(0xFFFFCC00), // Or
//               icon: Icons.workspace_premium, 
//             ),
//             _BadgeItem(
//               title: '20 question/10min',
//               iconColor: Color(0xFFC0C0C0), // Argent
//               icon: Icons.workspace_premium,
//             ),
//             _BadgeItem(
//               title: 'Calcul mental',
//               iconColor: Color(0xFF8B4513), // Bronze (utilisé une couleur proche du CSS)
//               icon: Icons.workspace_premium,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildRecentActivitySection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Activité Récentes',
//               style: TextStyle(
//                 color: _colorBlack,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Poppins',
//               ),
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: const Text(
//                 'Voir tout',
//                 style: TextStyle(
//                   color: _purpleMain,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: _fontFamily,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 15),
        
//         // Liste des activités
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//           decoration: BoxDecoration(
//             color: _backgroundLight,
//             border: Border.all(color: Colors.black.withOpacity(0.2)),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black26,
//                 offset: Offset(0, 4),
//                 blurRadius: 4,
//               )
//             ],
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: const Column(
//             children: [
//               _ActivityItem(
//                 title: 'Quiz sur le livre Harry Potter à l’ecole',
//                 time: 'Il y a 2 jours',
//                 icon: Icons.check_circle,
//                 iconColor: _colorGreen,
//               ),
//               Divider(color: Colors.black12, height: 20),
//               _ActivityItem(
//                 title: 'Nouveau livre débuté',
//                 time: 'Il y a 4 jours',
//                 icon: Icons.menu_book,
//                 iconColor: _purpleMain,
//               ),
//               Divider(color: Colors.black12, height: 20),
//               _ActivityItem(
//                 title: 'Dernière challenge participé',
//                 time: 'Il y a 2 jours',
//                 icon: Icons.local_fire_department, // Simule icon-park-solid:trophy
//                 iconColor: _colorOrange,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRecommendationSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Recommendation pour toi',
//           style: TextStyle(
//             color: _colorBlack,
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             fontFamily: 'Poppins',
//           ),
//         ),
//         const SizedBox(height: 15),
        
//         // Liste de livres (Défilement Horizontal)
//         SizedBox(
//           height: 180, // Hauteur de Frame 10 (195px)
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: const [
//               _BookCard(
//                 title: 'Le jardin invisible',
//                 author: 'Auteur : C.S.Lewis',
//                 imagePath: 'assets/images/book1.jpg', // Asset simulé
//               ),
//               SizedBox(width: 15),
//               _BookCard(
//                 title: 'Le jardin invisible',
//                 author: 'Auteur : C.S.Lewis',
//                 imagePath: 'assets/images/book2.jpg', // Asset simulé
//               ),
//               SizedBox(width: 15),
//               _BookCard(
//                 title: 'Le jardin invisible',
//                 author: 'Auteur : C.S.Lewis',
//                 imagePath: 'assets/images/book3.jpg', // Asset simulé
//               ),
//               SizedBox(width: 15),
//               _BookCard(
//                 title: 'Le jardin invisible',
//                 author: 'Auteur : C.S.Lewis',
//                 imagePath: 'assets/images/book4.jpg', // Asset simulé
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
  
//   Widget _buildLecturesProgressSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Lectures',
//               style: TextStyle(
//                 color: _colorBlack,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Poppins',
//               ),
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: const Text(
//                 'Voir tout',
//                 style: TextStyle(
//                   color: _purpleMain,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: _fontFamily,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 15),

//         // Liste des lectures avec progression
//         const _ReadingProgressItem(
//           title: 'Le Petit Prince',
//           progressValue: 0.75, // 75%
//         ),
//         const SizedBox(height: 20),
//         const _ReadingProgressItem(
//           title: 'Le jardin invisible',
//           progressValue: 0.45, // 45%
//         ),
//         const SizedBox(height: 20),
//         const _ReadingProgressItem(
//           title: 'Le coeur se souvient',
//           progressValue: 0.25, // 25%
//         ),
//       ],
//     );
//   }

//   Widget _buildPartnersSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Nos partenaires educatifs',
//               style: TextStyle(
//                 color: _colorBlack,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Poppins',
//               ),
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: const Text(
//                 'Voir tout',
//                 style: TextStyle(
//                   color: _purpleMain,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: _fontFamily,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 15),
        
//         // Liste des partenaires (Défilement Horizontal)
//         SizedBox(
//           height: 170, // Hauteur de Frame 11 (190px)
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: const [
//               _PartnerCard(
//                 title: 'Khan Academy',
//                 description: 'Des milliers de leçons gratuites sur tous les sujets',
//                 imagePath: 'assets/images/partner1.jpg', // Asset simulé
//               ),
//               SizedBox(width: 20),
//               _PartnerCard(
//                 title: 'Duolinguo',
//                 description: 'Apprendre les langues tout en s’amusant !',
//                 imagePath: 'assets/images/partner2.jpg', // Asset simulé
//               ),
//               SizedBox(width: 20),
//               _PartnerCard(
//                 title: 'Busuu',
//                 description: 'Apprendre, pratiquer et progresser chaque jour.',
//                 imagePath: 'assets/images/partner3.jpg', // Asset simulé
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


// // --- WIDGETS DE COMPOSANTS RÉUTILISABLES ---

// class _NavBarItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isSelected;

//   const _NavBarItem({required this.icon, required this.label, this.isSelected = false});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           icon,
//           color: isSelected ? _purpleMain : _colorBlack,
//           size: 24,
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? _purpleMain : _colorBlack,
//             fontSize: 11,
//             fontWeight: FontWeight.w400,
//             fontFamily: _fontFamily,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _BadgeItem extends StatelessWidget {
//   final String title;
//   final Color iconColor;
//   final IconData icon;

//   const _BadgeItem({required this.title, required this.iconColor, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     // Utilisation des icônes de badge simulées par des images dans le design,
//     // mais ici on utilise une icône Material pour la simplicité, 
//     // en ajustant la couleur pour le rendu Or, Argent, Bronze.
//     return SizedBox(
//       width: 100,
//       child: Column(
//         children: [
//           Icon(
//             icon,
//             color: iconColor,
//             size: 60, // Ajusté pour ressembler à la taille des médailles
//           ),
//           const SizedBox(height: 5),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: _colorBlack,
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//               fontFamily: _fontFamily,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ActivityItem extends StatelessWidget {
//   final String title;
//   final String time;
//   final IconData icon;
//   final Color iconColor;

//   const _ActivityItem({required this.title, required this.time, required this.icon, required this.iconColor});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Icône entourée d'un cercle semi-transparent
//         Container(
//           width: 30,
//           height: 30,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: iconColor.withOpacity(0.3), // Ellipse 176, 177, 178
//           ),
//           child: Center(
//             child: Icon(icon, color: iconColor, size: 18),
//           ),
//         ),
//         const SizedBox(width: 15),
        
//         // Texte de l'activité
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: _colorBlack,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: _fontFamily,
//                 ),
//               ),
//               Text(
//                 time,
//                 style: const TextStyle(
//                   color: _colorBlack,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w300,
//                   fontFamily: _fontFamily,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _BookCard extends StatelessWidget {
//   final String title;
//   final String author;
//   final String imagePath;

//   const _BookCard({required this.title, required this.author, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 130, // Largeur Group 882
//       decoration: BoxDecoration(
//         color: _backgroundLight,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(5),
//               child: Image.asset(
//                 imagePath,
//                 width: 110,
//                 height: 123,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10.0),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 color: _colorBlack,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: _fontFamily,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10.0),
//             child: Text(
//               author,
//               style: const TextStyle(
//                 color: _colorBlack,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w300,
//                 fontFamily: _fontFamily,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ReadingProgressItem extends StatelessWidget {
//   final String title;
//   final double progressValue;

//   const _ReadingProgressItem({required this.title, required this.progressValue});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 color: _colorBlack,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: _fontFamily,
//               ),
//             ),
//             const SizedBox(height: 5),
//             // Barre de progression (Group 886)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(50),
//               child: LinearProgressIndicator(
//                 value: progressValue,
//                 backgroundColor: const Color(0xFFD9D9D9),
//                 valueColor: const AlwaysStoppedAnimation<Color>(_purpleMain),
//                 minHeight: 10,
//                 // Largeur de 300px dans le CSS, ici on utilise un SizedBox
//                 // pour contraindre la largeur dans un Row.
//               ),
//             ),
//           ],
//         ),
        
//         Text(
//           '${(progressValue * 100).round()}%',
//           style: const TextStyle(
//             color: _purpleMain,
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//             fontFamily: _fontFamily,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _PartnerCard extends StatelessWidget {
//   final String title;
//   final String description;
//   final String imagePath;

//   const _PartnerCard({required this.title, required this.description, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 200, // Largeur Group 889
//       decoration: BoxDecoration(
//         color: _backgroundLight,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image du partenaire (Rectangle 751)
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(30),
//               topRight: Radius.circular(30),
//             ),
//             child: Image.asset(
//               imagePath,
//               width: 200,
//               height: 90,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10, top: 10),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 color: _colorBlack,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: _fontFamily,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             child: Text(
//               description,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 color: _colorBlack,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w300,
//                 fontFamily: _fontFamily,
//                 height: 1.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ----------------------------------------------------
// // Point d'entrée pour le test :
// // ----------------------------------------------------
// /*
// void main() {
//   // Ajoutez le code d'initialisation de l'application ici
//   runApp(const MaterialApp(
//     home: HomeScreen(),
//     debugShowCheckedModeBanner: false,
//   ));
// }
// */