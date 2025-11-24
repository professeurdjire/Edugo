import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/services/password_reset_service.dart';
import 'package:edugo/screens/profil/reenitialiserMotDePasse/succesReenitialisation.dart';

// Vous pouvez nommer ce fichier 'nouveauMotDePasse.dart'

class NouveauMotPasse extends StatefulWidget {
  final String? token; // Token reçu depuis l'email ou deep link
  
  const NouveauMotPasse({super.key, this.token});

  @override
  State<NouveauMotPasse> createState() => _NouveauMotPasseState();
}

class _NouveauMotPasseState extends State<NouveauMotPasse> {
  // Variables d'état pour masquer/afficher les mots de passe
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isTokenValid = false;
  bool _isTokenVerified = false;
  String? _errorMessage;
  String? _token;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PasswordResetService _passwordResetService = PasswordResetService();
  final ThemeService _themeService = ThemeService();
  final String _fontFamily = 'Roboto';
  static const Color _colorBlack = Colors.black12;
  
  @override
  void initState() {
    super.initState();
    _token = widget.token;
    if (_token != null && _token!.isNotEmpty) {
      _verifyToken();
    }
  }
  
  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  Future<void> _verifyToken() async {
    if (_token == null || _token!.isEmpty) {
      setState(() {
        _errorMessage = 'Token manquant';
        _isTokenValid = false;
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final response = await _passwordResetService.verifyToken(_token!);
      if (response.success) {
        setState(() {
          _isTokenValid = true;
          _isTokenVerified = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isTokenValid = false;
          _errorMessage = 'Token invalide ou expiré';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isTokenValid = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }
  
  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_isLoading) return;
    
    if (_token == null || _token!.isEmpty) {
      setState(() {
        _errorMessage = 'Token manquant. Veuillez utiliser le lien reçu par email.';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final response = await _passwordResetService.resetPassword(
        token: _token!,
        nouveauMotDePasse: _newPasswordController.text,
        confirmationMotDePasse: _confirmPasswordController.text,
      );
      
      if (response.success) {
        // Naviguer vers l'écran de succès
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SuccesReenitialisation(),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  // Fonction de construction des champs de mot de passe - STYLE MODIFIÉ
  Widget _buildPasswordField({
    required String hintText,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    required Color primaryColor,
    required Color iconColor,
    required Color borderColor,
  }) {
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: borderColor,
        width: 1.0,
      ),
    );

    final OutlineInputBorder focusedBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: primaryColor,
        width: 2.0,
      ),
    );

    return TextField(
      obscureText: !isVisible,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontFamily: 'Roboto',
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: iconColor,
          ),
          onPressed: onVisibilityToggle,
        ),
        enabledBorder: borderStyle,
        focusedBorder: focusedBorderStyle,
        border: borderStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        // Couleurs dynamiques basées sur le thème
        final Color lightPurple = primaryColor.withOpacity(0.1);
        final Color iconColor = primaryColor;
        final Color borderColor = primaryColor.withOpacity(0.3);
        const Color fillColor = Color(0xFFF5F5F5);

        return Scaffold(
          backgroundColor: Colors.white,
          // App Bar
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: _colorBlack),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Nouveau mot de passe',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),
            centerTitle: true,
          ),

          // Corps de la page
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Icône du cadenas
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 40),
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: lightPurple,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.lock_reset,
                        size: 70,
                        color: iconColor,
                      ),
                    ),
                  ),
                ),

                // Vérification du token
                if (!_isTokenVerified && _token != null) ...[
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Vérification du token en cours...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ] else if (_token == null || _token!.isEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Token manquant. Veuillez utiliser le lien reçu par email.',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontSize: 14,
                              fontFamily: _fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (!_isTokenValid) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Token invalide ou expiré',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: _fontFamily,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _errorMessage ?? 'Le lien de réinitialisation a expiré ou est invalide. Veuillez demander un nouveau lien.',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 14,
                                  fontFamily: _fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Champ : Nouveau mot de passe
                  const Text(
                    'Nouveau mot de passe',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: !_isNewPasswordVisible,
                          enabled: !_isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre nouveau mot de passe';
                            }
                            if (value.length < 6) {
                              return 'Le mot de passe doit contenir au moins 6 caractères';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'Roboto',
                          ),
                          decoration: InputDecoration(
                            hintText: 'Entrer votre nouveau mot de passe',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: fillColor,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isNewPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: iconColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isNewPasswordVisible = !_isNewPasswordVisible;
                                });
                              },
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
                                width: 2.0,
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
                        ),
                        const SizedBox(height: 25),

                        // Champ : Confirmer le mot de passe
                        const Text(
                          'Confirmer le mot de passe',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          enabled: !_isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez confirmer votre mot de passe';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Les mots de passe ne correspondent pas';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'Roboto',
                          ),
                          decoration: InputDecoration(
                            hintText: 'Confirmer votre nouveau mot de passe',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: fillColor,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: iconColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
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
                                width: 2.0,
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
                        ),
                      ],
                    ),
                  ),
                  
                  // Affichage des erreurs
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                                fontFamily: _fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),

                  // Bouton : Réinitialiser mot de passe
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        disabledBackgroundColor: primaryColor.withOpacity(0.6),
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
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Réinitialiser mot de passe',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}