import 'package:edugo/screens/connexion%20et%20inscriptions/inscription.dart';
import 'package:edugo/screens/principales/mainScreen.dart';
import 'package:edugo/screens/profil/reenitialiserMotDePasse/reenitialisationA.dart';
import 'package:flutter/material.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/auth_models.dart';
import 'package:edugo/services/theme_service.dart';

class LoginScreen extends StatefulWidget {
  final ThemeService? themeService;

  const LoginScreen({super.key, this.themeService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  late ThemeService _themeService;
  bool _obscurePassword = true; // Variable pour gérer la visibilité du mot de passe

  final String _fontFamily = 'Roboto';

  @override
  void initState() {
    super.initState();
    _themeService = widget.themeService ?? ThemeService();
  }

  // Fonction pour basculer la visibilité du mot de passe
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        // Couleurs dynamiques basées sur le thème
        final Color purpleLogoAndButton = primaryColor;
        final Color borderColor = primaryColor.withOpacity(0.5);
        final Color fillColor = const Color(0xFFF5F5F5);
        final Color iconColor = primaryColor.withOpacity(0.7);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.12),

                  // 1. Logo et Nom de l'Application
                  _buildLogoSection(context, primaryColor),

                  const SizedBox(height: 60),

                  // 2. Champs de Saisie (Adresse Email)
                  _buildEmailField(primaryColor, borderColor, fillColor, iconColor),

                  const SizedBox(height: 25),

                  // 3. Champs de Saisie (Mot de passe)
                  _buildPasswordField(primaryColor, borderColor, fillColor, iconColor),

                  const SizedBox(height: 10),

                  // Affichage des erreurs
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),

                  // 4. Lien "Mot de passe oublié?"
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MotPasseOublieA()),
                        );
                        debugPrint('Mot de passe oublié cliqué.');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Mot de passe oublié?',
                        style: TextStyle(
                          color: primaryColor.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 5. Bouton "Se Connecter"
                  _buildLoginButton(context, primaryColor),

                  const SizedBox(height: 20),

                  // 6. Lien "Pas de compte ? Inscrivez Vous"
                  TextButton(
                    onPressed: () {
                      debugPrint('Inscription cliquée.');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistrationStepperScreen(themeService: widget.themeService),),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Pas de compte ? Inscrivez Vous',
                      style: TextStyle(
                        color: primaryColor.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: _fontFamily,
                        decoration: TextDecoration.underline,
                        decorationColor: primaryColor.withOpacity(0.8),
                      ),
                    ),
                  ),

                  // Espace pour la barre de navigation du système
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget pour la section du logo
  Widget _buildLogoSection(BuildContext context, Color primaryColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 120,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  // Widget pour le champ email
  Widget _buildEmailField(Color primaryColor, Color borderColor, Color fillColor, Color iconColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adresse Email',
          style: TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre email';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Veuillez entrer un email valide';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Entré Votre Email',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: Icon(Icons.email_outlined, color: iconColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: primaryColor,
                width: 1.5,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor,
                width: 1.0,
              ),
            ),
          ),
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Widget pour le champ mot de passe avec icône œil dynamique
  Widget _buildPasswordField(Color primaryColor, Color borderColor, Color fillColor, Color iconColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mot De Passe',
          style: TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword, // Utilise la variable d'état
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre mot de passe';
            }
            if (value.length < 6) {
              return 'Le mot de passe doit contenir au moins 6 caractères';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Entré Votre Mot de Passe',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: IconButton(
              icon: Icon(
                // Change l'icône en fonction de l'état
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: iconColor,
              ),
              onPressed: _togglePasswordVisibility, // Appelle la fonction de bascule
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: primaryColor,
                width: 1.5,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor,
                width: 1.0,
              ),
            ),
          ),
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Widget pour le bouton de connexion
  Widget _buildLoginButton(BuildContext context, Color primaryColor) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });

            try {
              final response = await _authService.login(
                _emailController.text.trim(),
                _passwordController.text,
              );

              if (response != null && response.token != null) {
                _authService.setAuthToken(response.token!);
                final userId = _authService.currentUserId;

                if (userId != null) {
                  print('✅ Utilisateur connecté avec ID: $userId');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen(
                      eleveId: userId,
                      themeService: _themeService,
                    )),
                  );
                } else {
                  print('⚠️ ID utilisateur non disponible, navigation sans ID');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen(
                      themeService: _themeService,
                    )),
                  );
                }
              } else {
                setState(() {
                  _errorMessage = 'Identifiants incorrects. Veuillez réessayer.';
                });
              }
            } catch (e) {
              print('❌ Erreur de connexion: $e');
              setState(() {
                _errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
              });
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Se Connecter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: _fontFamily,
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}