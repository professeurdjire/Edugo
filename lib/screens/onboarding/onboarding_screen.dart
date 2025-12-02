//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             if (_currentIndex < _pages.length - 1)
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: _finishOnboarding,
//                   child: const Text(
//                     'Passer',
//                     style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               )
//             else
//               const SizedBox(height: 48),
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 physics: const BouncingScrollPhysics(),
//                 onPageChanged: (index) {
//                   setState(() => _currentIndex = index);
//                 },
//                 itemCount: _pages.length,
//                 itemBuilder: (context, index) {
//                   return _OnboardingPage(pageData: _pages[index]);
//                 },
//               ),
//             ),
//             _buildIndicators(),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _handlePrimaryAction,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _pages[_currentIndex].accentColor,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                   ),
//                   child: Text(
//                     _currentIndex == _pages.length - 1 ? 'Se connecter' : 'Continuer',
//                     style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildIndicators() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//         _pages.length,
//         (index) => AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           margin: const EdgeInsets.symmetric(horizontal: 6),
//           height: 8,
//           width: _currentIndex == index ? 32 : 10,
//           decoration: BoxDecoration(
//             color: _currentIndex == index ? _pages[index].accentColor : Colors.grey.shade300,
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//       ),
//     );
//   }

//   void _handlePrimaryAction() {
//     if (_currentIndex == _pages.length - 1) {
//       _finishOnboarding();
//     } else {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 400), 
//         curve: Curves.easeInOut
//       );
//     }
//   }

//   Future<void> _finishOnboarding() async {
//     // Appeler onFinished s'il existe (pour sauvegarder l'état onboarding)
//     if (widget.onFinished != null) {
//       await widget.onFinished!();
//     }

//     // Toujours rediriger vers la page de login
//     if (!mounted) return;
    
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (_) => LoginScreen(themeService: widget.themeService),
//       ),
//     );
//   }
// }

// class _OnboardingPageData {
//   final String title;
//   final String description;
//   final String asset;
//   final Color accentColor;

//   const _OnboardingPageData({
//     required this.title,
//     required this.description,
//     required this.asset,
//     required this.accentColor,
//   });
// }

// class _OnboardingPage extends StatelessWidget {
//   final _OnboardingPageData pageData;

//   const _OnboardingPage({required this.pageData});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 24),
//               decoration: BoxDecoration(
//                 color: pageData.accentColor.withOpacity(0.08),
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               child: Center(
//                 child: Image.asset(
//                   pageData.asset,
//                   fit: BoxFit.contain,
//                   width: MediaQuery.of(context).size.width * 0.7,
//                 ),
//               ),
//             ),
//           ),
//           Text(
//             pageData.title,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             pageData.description,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey.shade600,
//               height: 1.5,
//             ),
//           ),
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
// }

import 'package:edugo/screens/auth/login.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  final Future<void> Function()? onFinished;
  final ThemeService themeService;

  const OnboardingScreen({
    super.key,
    required this.themeService,
    this.onFinished,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<_OnboardingPageData> _pages = [
    const _OnboardingPageData(
      title: 'Découvre ta bibliothèque',
      description: 'Parcours des centaines de livres adaptés à ton niveau et à tes matières scolaires.',
      asset: 'assets/images/bib.png',
    ),
    const _OnboardingPageData(
      title: 'Lis ou écoute',
      description: 'Active la lecture audio, ajuste la vitesse et suit ta progression en temps réel.',
      asset: 'assets/images/ecoute.png',
    ),
    const _OnboardingPageData(
      title: 'Gagne avec les quiz',
      description: 'Teste ta compréhension après chaque lecture et débloque des récompenses.',
      asset: 'assets/images/for.png',
    ),
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: widget.themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Header avec bouton skip
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo ou espace vide
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
                      ),
                      
                      if (_currentIndex < _pages.length - 1)
                        _buildSkipButton(),
                    ],
                  ),
                ),
                
                // Contenu principal
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                      _animationController.reset();
                      _animationController.forward();
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Transform.scale(
                              scale: _scaleAnimation.value,
                              child: child,
                            ),
                          );
                        },
                        child: _OnboardingPage(
                          pageData: _pages[index],
                          primaryColor: primaryColor,
                        ),
                      );
                    },
                  ),
                ),
                
                // Indicateurs et bouton
                _buildBottomSection(primaryColor),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: _finishOnboarding,
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        'Passer',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildBottomSection(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        children: [
          // Indicateurs modernes
          _buildModernIndicators(primaryColor),
          const SizedBox(height: 32),
          
          // Bouton principal
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handlePrimaryAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                _currentIndex == _pages.length - 1 ? 'Commencer' : 'Continuer',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          
          // Indicateur de progression pour la dernière page
          if (_currentIndex == _pages.length - 1) ...[
            const SizedBox(height: 16),
            Text(
              '${_currentIndex + 1}/${_pages.length}',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModernIndicators(Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: _currentIndex == index ? 24 : 6,
          decoration: BoxDecoration(
            color: _currentIndex == index ? primaryColor : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _currentIndex == index ? [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
        ),
      ),
    );
  }

  void _handlePrimaryAction() {
    if (_currentIndex == _pages.length - 1) {
      _finishOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    if (widget.onFinished != null) {
      await widget.onFinished!();
    }

    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginScreen(themeService: widget.themeService),
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String description;
  final String asset;

  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.asset,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData pageData;
  final Color primaryColor;

  const _OnboardingPage({
    required this.pageData,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration avec effet de profondeur
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryColor.withOpacity(0.05),
                    primaryColor.withOpacity(0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  // Effet de fond décoratif
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  
                  // Image principale
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          pageData.asset,
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Contenu texte
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  pageData.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    pageData.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}