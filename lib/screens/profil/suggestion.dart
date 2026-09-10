import 'package:edugo/core/constants/constant.dart';
import 'package:edugo/services/api/api.dart';
import 'package:flutter/material.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final String message = _messageController.text.trim();
    if (message.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    try {
      // En mode démo l'envoi est simulé ; sinon l'API reçoit la suggestion.
      await AuthService.instance.sendSuggestion(message);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isSending = false);
    _messageController.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Merci pour votre suggestion !'),
        backgroundColor: AppConst.purpleDark,
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
          'Suggestion',
          style: TextStyle(
            color: AppConst.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: AppConst.fontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          color: AppConst.purpleInputFill,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 60,
                          color: AppConst.purpleDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Vos suggestions sont les bienvenues !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppConst.textDark,
                          fontFamily: AppConst.fontFamily,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Aidez-nous à améliorer EDUGO en partageant vos idées.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppConst.textGrey,
                          fontFamily: AppConst.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Champ de saisie du message
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSend(),
                style: const TextStyle(
                  fontFamily: AppConst.fontFamily,
                  fontSize: 16,
                  color: AppConst.textDark,
                ),
                decoration: InputDecoration(
                  hintText: 'Écrivez votre suggestion...',
                  hintStyle: const TextStyle(
                    color: AppConst.textGrey,
                    fontFamily: AppConst.fontFamily,
                  ),
                  filled: true,
                  fillColor: AppConst.purpleInputFill,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                        color: AppConst.purpleButton, width: 1.5),
                  ),
                  suffixIcon: _isSending
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppConst.purpleDark,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send,
                              color: AppConst.purpleDark),
                          onPressed: _handleSend,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
