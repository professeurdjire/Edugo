import 'package:edugo/core/constants/constant.dart';
import 'package:flutter/material.dart';

/// Décoration commune des champs de saisie de l'application :
/// fond violet clair, coins arrondis, bordure violette au focus,
/// rouge en cas d'erreur.
InputDecoration appInputDecoration({
  required String hint,
  required IconData prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: AppConst.textGrey,
      fontSize: 15,
      fontFamily: AppConst.fontFamily,
    ),
    prefixIcon: Icon(prefixIcon, color: AppConst.purpleButton, size: 22),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: AppConst.purpleInputFill,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: AppConst.purpleButton, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
    ),
  );
}

/// Style commun du texte saisi dans les champs.
const TextStyle appInputTextStyle = TextStyle(
  fontFamily: AppConst.fontFamily,
  fontSize: 16,
  color: AppConst.textDark,
);

/// Libellé placé au-dessus d'un champ de formulaire.
class AppFieldLabel extends StatelessWidget {
  final String text;

  const AppFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppConst.textDark,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        fontFamily: AppConst.fontFamily,
      ),
    );
  }
}

/// Bouton principal violet pleine largeur, avec état de chargement optionnel.
class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AppPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConst.purpleButton,
          disabledBackgroundColor: AppConst.purpleButton.withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConst.fontFamily,
                ),
              ),
      ),
    );
  }
}
