import 'package:edugo/core/constants/constant.dart';
import 'package:edugo/screens/connexion%20et%20inscriptions/login.dart';
import 'package:flutter/material.dart';

class SuccesReenitialisation extends StatelessWidget {
  const SuccesReenitialisation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    color: AppConst.purpleInputFill,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 100,
                      color: AppConst.purpleDark,
                    ),
                  ),
                ),
              ),

              const Text(
                'Mot de passe réinitialisé',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppConst.textDark,
                  fontFamily: AppConst.fontFamily,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Votre mot de passe a été réinitialisé avec succès. Vous pouvez maintenant vous connecter avec votre nouveau mot de passe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppConst.textGrey,
                  height: 1.5,
                  fontFamily: AppConst.fontFamily,
                ),
              ),
              const SizedBox(height: 80),

              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConst.purpleButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Se connecter maintenant',
                    style: TextStyle(
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
