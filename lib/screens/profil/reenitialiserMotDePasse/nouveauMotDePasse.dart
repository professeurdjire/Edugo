import 'package:edugo/core/widgets/widgets.dart';
import 'package:edugo/core/constants/constant.dart';
import 'package:edugo/screens/profil/reenitialiserMotDePasse/succesReenitialisation.dart';
import 'package:flutter/material.dart';

class NouveauMotPasse extends StatefulWidget {
  const NouveauMotPasse({super.key});

  @override
  State<NouveauMotPasse> createState() => _NouveauMotPasseState();
}

class _NouveauMotPasseState extends State<NouveauMotPasse> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer le mot de passe';
    }
    if (value != _newPasswordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SuccesReenitialisation()),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      style: const TextStyle(
        fontFamily: AppConst.fontFamily,
        fontSize: 16,
        color: AppConst.textDark,
      ),
      decoration: appInputDecoration(
        hint: hintText,
        prefixIcon: Icons.lock_outline_rounded,
        suffixIcon: IconButton(
          icon: Icon(
            isVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppConst.textGrey,
            size: 22,
          ),
          onPressed: onVisibilityToggle,
        ),
      ),
    );
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
          'Nouveau mot de passe',
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

              const AppFieldLabel('Nouveau mot de passe'),
              const SizedBox(height: 8),
              _buildPasswordField(
                controller: _newPasswordController,
                hintText: 'Entrez le nouveau mot de passe',
                isVisible: _isNewPasswordVisible,
                validator: _validateNewPassword,
                onVisibilityToggle: () {
                  setState(
                      () => _isNewPasswordVisible = !_isNewPasswordVisible);
                },
              ),
              const SizedBox(height: 25),

              const AppFieldLabel('Confirmer le mot de passe'),
              const SizedBox(height: 8),
              _buildPasswordField(
                controller: _confirmPasswordController,
                hintText: 'Confirmez le mot de passe',
                isVisible: _isConfirmPasswordVisible,
                validator: _validateConfirmPassword,
                onVisibilityToggle: () {
                  setState(() =>
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                },
              ),
              const SizedBox(height: 60),

              AppPrimaryButton(
                text: 'Réinitialiser mot de passe',
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
