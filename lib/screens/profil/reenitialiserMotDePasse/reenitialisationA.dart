import 'package:edugo/core/constants/constant.dart';
import 'package:edugo/screens/profil/reenitialiserMotDePasse/nouveauMotDePasse.dart';
import 'package:flutter/material.dart';

class MotPasseOublieA extends StatefulWidget {
  const MotPasseOublieA({super.key});

  @override
  State<MotPasseOublieA> createState() => _MotPasseOublieAState();
}

class _MotPasseOublieAState extends State<MotPasseOublieA> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  // Passe à true une fois le lien de réinitialisation « envoyé »
  bool _emailSent = false;

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

  void _handleSubmit() {
    FocusScope.of(context).unfocus();
    if (!_emailSent) {
      if (!_formKey.currentState!.validate()) return;
      // Simulation de l'envoi du lien en attendant le branchement de l'API
      setState(() => _emailSent = true);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NouveauMotPasse()),
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
                              'Un lien pour réinitialiser votre mot de passe a été envoyé. Pensez à vérifier votre dossier de spams.',
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
                'Veuillez entrer votre adresse e-mail pour recevoir un lien de réinitialisation.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppConst.textGrey,
                  fontFamily: AppConst.fontFamily,
                ),
              ),
              const SizedBox(height: 40),

              const Text(
                'Adresse Email',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppConst.textDark,
                  fontFamily: AppConst.fontFamily,
                ),
              ),
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
                decoration: InputDecoration(
                  hintText: 'Entrez votre email',
                  hintStyle: const TextStyle(
                    color: AppConst.textGrey,
                    fontSize: 15,
                    fontFamily: AppConst.fontFamily,
                  ),
                  prefixIcon: const Icon(Icons.mail_outline_rounded,
                      color: AppConst.purpleButton, size: 22),
                  filled: true,
                  fillColor: AppConst.purpleInputFill,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                        color: AppConst.purpleButton, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: Colors.redAccent, width: 1.2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: Colors.redAccent, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 50),

              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConst.purpleButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _emailSent
                        ? 'Continuer'
                        : 'Envoyer le lien de réinitialisation',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConst.fontFamily,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
