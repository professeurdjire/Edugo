import 'package:edugo/core/widgets/widgets.dart';
import 'package:edugo/core/constants/constant.dart';
import 'package:edugo/screens/profil/reenitialiserMotDePasse/nouveauMotDePasse.dart';
import 'package:edugo/services/api/api.dart';
import 'package:flutter/material.dart';

class MotPasseOublieA extends StatefulWidget {
  const MotPasseOublieA({super.key});

  @override
  State<MotPasseOublieA> createState() => _MotPasseOublieAState();
}

class _MotPasseOublieAState extends State<MotPasseOublieA> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  // Passe à true une fois le code de réinitialisation envoyé
  bool _emailSent = false;
  bool _isSending = false;

  // Couleurs du message de succès
  static const Color _successBackground = Color(0xFFE6FAE7);
  static const Color _successForeground = Color(0xFF1E8C23);

  @override
  void dispose() {
    _emailController.dispose();
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

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();
    if (!_emailSent) {
      if (!_formKey.currentState!.validate()) return;
      setState(() => _isSending = true);
      try {
        // En mode démo l'envoi est simulé ; sinon l'API envoie le code.
        await AuthService.instance.requestPasswordReset(
          email: _emailController.text.trim(),
        );
      } on ApiException catch (e) {
        if (!mounted) return;
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.message), backgroundColor: Colors.redAccent),
        );
        return;
      }
      if (!mounted) return;
      setState(() {
        _isSending = false;
        _emailSent = true;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              NouveauMotPasse(email: _emailController.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: AppConst.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mot De Passe Oublié',
          style: TextStyle(
            color: AppConst.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: AppConst.fontFamily,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Bannière de succès après l'envoi du lien
              if (_emailSent)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(top: 16.0),
                  decoration: BoxDecoration(
                    color: _successBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: _successForeground, size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'E-mail envoyé !',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _successForeground,
                                fontFamily: AppConst.fontFamily,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Un code à 6 chiffres vous a été envoyé pour réinitialiser votre mot de passe. Pensez à vérifier votre dossier de spams.',
                              style: TextStyle(
                                fontSize: 14,
                                color: _successForeground,
                                height: 1.4,
                                fontFamily: AppConst.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Icône du cadenas
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: AppConst.purpleInputFill,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock_reset,
                      size: 70,
                      color: AppConst.purpleDark,
                    ),
                  ),
                ),
              ),

              const Text(
                'Réinitialiser votre mot de passe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConst.textDark,
                  fontFamily: AppConst.fontFamily,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Veuillez entrer votre adresse e-mail pour recevoir un code de réinitialisation à 6 chiffres.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppConst.textGrey,
                  fontFamily: AppConst.fontFamily,
                ),
              ),
              const SizedBox(height: 40),

              const AppFieldLabel('Adresse Email'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                enabled: !_emailSent,
                onFieldSubmitted: (_) => _handleSubmit(),
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
              const SizedBox(height: 50),

              AppPrimaryButton(
                text: _emailSent
                    ? 'Continuer'
                    : 'Envoyer le code de réinitialisation',
                onPressed: _handleSubmit,
                isLoading: _isSending,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
