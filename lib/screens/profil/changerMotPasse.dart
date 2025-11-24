import 'package:flutter/material.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/eleveService.dart';
import 'package:edugo/services/theme_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Services
  final AuthService _authService = AuthService();
  final EleveService _eleveService = EleveService();
  final ThemeService _themeService = ThemeService();

  // Contrôleurs
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // États
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  // Validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentEleve = _authService.currentEleve;
      if (currentEleve == null) {
        throw Exception('Aucun utilisateur connecté');
      }

      final success = await _eleveService.changePassword(
        currentEleve.id!,
        _oldPasswordController.text,
        _newPasswordController.text,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Mot de passe changé avec succès'),
              backgroundColor: _themeService.currentPrimaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          // Vider les champs et retourner en arrière
          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();

          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.pop(context);
            }
          });
        }
      } else {
        throw Exception('Échec du changement de mot de passe');
      }
    } catch (e) {
      print(' Erreur changement mot de passe: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != _newPasswordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        final Color borderColor = primaryColor.withOpacity(0.3);
        final Color fillColor = const Color(0xFFF5F5F5);
        final Color lightPurpleBackground = primaryColor.withOpacity(0.1);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                if (!_isLoading) Navigator.pop(context);
              },
            ),
            title: const Text(
              'Changer le mot de passe',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),
            centerTitle: true,
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Icône de cadenas
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: lightPurpleBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock,
                        size: 60,
                        color: primaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- Ancien mot de passe ---
                  const Text(
                    'Ancien mot de passe',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    controller: _oldPasswordController,
                    hint: 'Entrer votre ancien mot de passe',
                    obscureText: !_oldPasswordVisible,
                    onToggleVisibility: () {
                      setState(() => _oldPasswordVisible = !_oldPasswordVisible);
                    },
                    isVisible: _oldPasswordVisible,
                    validator: _validatePassword,
                    borderColor: borderColor,
                    fillColor: fillColor,
                    primaryColor: primaryColor,
                  ),

                  const SizedBox(height: 25),

                  // --- Nouveau mot de passe ---
                  const Text(
                    'Nouveau mot de passe',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    controller: _newPasswordController,
                    hint: 'Entrer votre nouveau mot de passe',
                    obscureText: !_newPasswordVisible,
                    onToggleVisibility: () {
                      setState(() => _newPasswordVisible = !_newPasswordVisible);
                    },
                    isVisible: _newPasswordVisible,
                    validator: _validatePassword,
                    borderColor: borderColor,
                    fillColor: fillColor,
                    primaryColor: primaryColor,
                  ),

                  const SizedBox(height: 25),

                  // --- Confirmer le mot de passe ---
                  const Text(
                    'Confirmer le mot de passe',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    hint: 'Confirmer votre nouveau mot de passe',
                    obscureText: !_confirmPasswordVisible,
                    onToggleVisibility: () {
                      setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
                    },
                    isVisible: _confirmPasswordVisible,
                    validator: _validateConfirmPassword,
                    borderColor: borderColor,
                    fillColor: fillColor,
                    primaryColor: primaryColor,
                  ),

                  const SizedBox(height: 40),

                  // --- Bouton de validation ---
                  ElevatedButton(
                    onPressed: _isLoading ? null : _changePassword,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Changer le mot de passe',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required bool isVisible,
    required String? Function(String?) validator,
    required Color borderColor,
    required Color fillColor,
    required Color primaryColor,
  }) {
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: borderColor,
        width: 1.0,
      ),
    );

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontFamily: 'Roboto',
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: primaryColor,
          ),
          onPressed: onToggleVisibility,
        ),
        enabledBorder: borderStyle,
        focusedBorder: borderStyle.copyWith(
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        errorBorder: borderStyle.copyWith(
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: borderStyle.copyWith(
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        border: borderStyle,
      ),
    );
  }
}