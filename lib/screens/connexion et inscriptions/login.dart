import 'package:edugo/core/widgets/widgets.dart';
import 'package:edugo/core/constants/constant.dart';
import 'package:edugo/screens/connexion%20et%20inscriptions/inscription.dart';
import 'package:edugo/screens/main_navigation.dart';
import 'package:edugo/screens/profil/reenitialiserMotDePasse/reenitialisationA.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer votre adresse email';
    }
    final RegExp emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Adresse email invalide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre mot de passe';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: remplacer par une vraie authentification backend (services/api)
    // avant toute mise en production — la navigation ci-dessous est un
    // placeholder tant que l'API n'existe pas.
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Ne rien remplacer si l'utilisateur a navigué ailleurs entre-temps
    if (ModalRoute.of(context)?.isCurrent != true) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildLogoSection(),

                    const SizedBox(height: 32),

                    // Titre de bienvenue
                    const Text(
                      'Bon retour !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppConst.textDark,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConst.fontFamily,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connectez-vous pour continuer votre aventure',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppConst.textGrey,
                        fontSize: 15,
                        fontFamily: AppConst.fontFamily,
                      ),
                    ),

                    const SizedBox(height: 36),

                    const AppFieldLabel('Adresse Email'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: _validateEmail,
                      style: const TextStyle(
                        fontFamily: AppConst.fontFamily,
                        fontSize: 16,
                        color: AppConst.textDark,
                      ),
                      decoration: appInputDecoration(
                        hint: 'Entrez votre email',
                        prefixIcon: Icons.mail_outline_rounded,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const AppFieldLabel('Mot De Passe'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      validator: _validatePassword,
                      onFieldSubmitted: (_) => _handleLogin(),
                      style: const TextStyle(
                        fontFamily: AppConst.fontFamily,
                        fontSize: 16,
                        color: AppConst.textDark,
                      ),
                      decoration: appInputDecoration(
                        hint: 'Entrez votre mot de passe',
                        prefixIcon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppConst.textGrey,
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Lien "Mot de passe oublié ?"
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MotPasseOublieA(),
                                  ),
                                );
                              },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(
                            color: AppConst.purpleDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppConst.fontFamily,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    AppPrimaryButton(
                      text: 'Se Connecter',
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                    ),

                    const SizedBox(height: 24),

                    _buildSignUpLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Image.asset(
      'assets/images/logo.png',
      height: 110,
      fit: BoxFit.contain,
    );
  }




  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Pas de compte ? ',
          style: TextStyle(
            color: AppConst.textGrey,
            fontSize: 15,
            fontFamily: AppConst.fontFamily,
          ),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationStepperScreen(),
                    ),
                  );
                },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Inscrivez-vous',
            style: TextStyle(
              color: AppConst.purpleDark,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: AppConst.fontFamily,
              decoration: TextDecoration.underline,
              decorationColor: AppConst.purpleDark,
            ),
          ),
        ),
      ],
    );
  }
}
