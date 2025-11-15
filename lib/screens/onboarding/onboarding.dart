import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/screens/presentations/presentation1.dart';

class OnboardingScreen extends StatefulWidget {
  final ThemeService themeService;
  const OnboardingScreen({super.key, required this.themeService});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_OnboardPageModel> _pages = const [
    _OnboardPageModel(
      title: 'Découvre, lis, progresse',
      description: 'Accède à une bibliothèque riche et adaptée à ton niveau scolaire pour développer tes compétences.',
      imageAsset: 'book1.png',
    ),
    _OnboardPageModel(
      title: 'Suis tes objectifs',
      description: 'Fixe des objectifs de lecture et suis tes progrès avec des statistiques simples et motivantes.',
      imageAsset: 'book1.png',
    ),
    _OnboardPageModel(
      title: 'Apprends en t’amusant',
      description: 'Profite d’activités, quiz et recommandations personnalisées dans l’univers EduGo.',
      imageAsset: 'book1.png',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const WelcomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = widget.themeService.primaryColorNotifier.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 260,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/' + p.imageAsset,
                            fit: BoxFit.contain,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.menu_book_rounded, color: primary, size: 96);
                            },
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          p.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final active = _index == i;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? primary : primary.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _finish,
                    child: const Text('Passer'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (_index == _pages.length - 1) {
                        _finish();
                        return;
                      }
                      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                    },
                    child: Text(_index == _pages.length - 1 ? 'Commencer' : 'Suivant'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPageModel {
  final String title;
  final String description;
  final String imageAsset;
  const _OnboardPageModel({required this.title, required this.description, required this.imageAsset});
}
