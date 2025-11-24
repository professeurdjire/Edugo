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

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<_OnboardingPageData> _pages = [
    const _OnboardingPageData(
      title: 'Découvre ta bibliothèque',
      description: 'Parcours des centaines de livres adaptés à ton niveau et à tes matières scolaires.',
      asset: 'assets/images/enfantlu.png',
      accentColor: Color(0xFFA885D8),
    ),
    const _OnboardingPageData(
      title: 'Lis ou écoute',
      description: 'Active la lecture audio, ajuste la vitesse et suit ta progression en temps réel.',
      asset: 'assets/images/lectureEnfant.png',
      accentColor: Color(0xFF4C7CF3),
    ),
    const _OnboardingPageData(
      title: 'Gagne avec les quiz',
      description: 'Teste ta compréhension après chaque lecture et débloque des récompenses.',
      asset: 'assets/images/book1.png',
      accentColor: Color(0xFF4CAF50),
    ),
  ];

  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (_currentIndex < _pages.length - 1)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text(
                    'Passer',
                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            else
              const SizedBox(height: 48),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(pageData: _pages[index]);
                },
              ),
            ),
            _buildIndicators(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handlePrimaryAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _pages[_currentIndex].accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _currentIndex == _pages.length - 1 ? 'Se connecter' : 'Continuer',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 8,
          width: _currentIndex == index ? 32 : 10,
          decoration: BoxDecoration(
            color: _currentIndex == index ? _pages[index].accentColor : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
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
        duration: const Duration(milliseconds: 400), 
        curve: Curves.easeInOut
      );
    }
  }

  Future<void> _finishOnboarding() async {
    // Appeler onFinished s'il existe (pour sauvegarder l'état onboarding)
    if (widget.onFinished != null) {
      await widget.onFinished!();
    }

    // Toujours rediriger vers la page de login
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
  final Color accentColor;

  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.asset,
    required this.accentColor,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData pageData;

  const _OnboardingPage({required this.pageData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: pageData.accentColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Image.asset(
                  pageData.asset,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
            ),
          ),
          Text(
            pageData.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pageData.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}