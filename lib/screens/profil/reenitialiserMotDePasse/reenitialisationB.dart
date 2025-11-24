import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/services/password_reset_service.dart';

// Classe principale de l'écran (un StatefulWidget car l'état peut changer)
class MotPasseOublieB extends StatefulWidget {
  const MotPasseOublieB({super.key});

  @override
  State<MotPasseOublieB> createState() => _MotPasseOublieBState();
}

// Classe qui gère l'état et le comportement de l'écran
class _MotPasseOublieBState extends State<MotPasseOublieB> {
  // Variable booléenne qui indique si le message de succès doit être affiché
  bool _emailSentSuccessfully = false;
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PasswordResetService _passwordResetService = PasswordResetService();
  final ThemeService _themeService = ThemeService();
  final String _fontFamily = 'Roboto';
  static const Color _colorBlack = Colors.black12;
  final Color successGreen = const Color(0xFFE6FAE7);
  final Color successIconTextGreen = const Color(0xFF1E8C23);
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  Future<void> _requestPasswordReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _emailSentSuccessfully = false;
    });
    
    try {
      final response = await _passwordResetService.requestPasswordReset(
        _emailController.text.trim(),
      );
      
      if (response.success) {
        setState(() {
          _emailSentSuccessfully = true;
          _isLoading = false;
        });
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        // Couleurs dynamiques basées sur le thème
        final Color lightPurple = primaryColor.withOpacity(0.1);
        final Color iconColor = primaryColor;
        final Color _borderColor = primaryColor.withOpacity(0.3);
        final Color _fillColor = const Color(0xFFF5F5F5);

        return Scaffold(
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
              'Mot De Passe Oublié',
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // ---------- Message de succès (affiché seulement si _emailSentSuccessfully = true) ----------
            if (_emailSentSuccessfully) ...[
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 30.0),
                decoration: BoxDecoration(
                  color: successGreen,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.lightGreen.shade200, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, color: successIconTextGreen, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'E-mail envoyé !',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: successIconTextGreen,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Un lien pour réinitialiser votre mot de passe a été envoyé. Pensez à vérifier votre dossier de spams',
                            style: TextStyle(
                              fontSize: 14,
                              color: successIconTextGreen,
                              height: 1.4,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // ---------- Fin du message de succès ----------

            // ---------- Icône du cadenas au centre ----------
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

            // ---------- Titre principal ----------
            const Text(
              'Réinitialiser votre mot de passe',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 12),

            // ---------- Texte d'instructions ----------
            const Text(
              'Veuillez entrer votre adresse e-mail pour recevoir un code de vérification.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 40),

            // ---------- Champ de saisie pour l'adresse email - STYLE MODIFIÉ ----------
            const Text(
              'Adresse Email',
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
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
                decoration: InputDecoration(
                  hintText: 'Entrer votre email',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: _fillColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.email_outlined,
                      color: iconColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _borderColor,
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
                      color: _borderColor,
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            
            // Affichage des erreurs
            if (_errorMessage != null && !_emailSentSuccessfully) ...[
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

            // ---------- Bouton principal ----------
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _requestPasswordReset,
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
                        'Envoyer le lien de réinitialisation',
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
        ),
      ),
    );
      },
    );
  }
}