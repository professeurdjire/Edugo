# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projet

EDUGO est une application mobile Flutter (français) : bibliothèque digitale pour élèves du primaire et du secondaire (livres, quiz, challenges, récompenses). Tout le texte visible par l'utilisateur est en français.

## Commandes

```bash
flutter pub get          # installer les dépendances
flutter run              # lancer l'application
flutter analyze          # analyse statique (flutter_lints, config par défaut)
flutter test             # lancer les tests
flutter test test/widget_test.dart   # un seul fichier de test
```

Aucune CI n'est configurée ; les revues de PR sont faites par CodeRabbit sur GitHub.

## Architecture

### Flux de navigation

`main.dart` démarre sur `WelcomeScreen` (presentations/presentation1.dart) → `LoginScreen` → `MainNavigation` (barre à 5 onglets : Accueil, Bibliothèque, Challenge, Exercice, Assistance). L'inscription (`RegistrationStepperScreen`, stepper 3 étapes) et le flux « mot de passe oublié » (reenitialisationA → nouveauMotDePasse → succesReenitialisation) débouchent aussi sur `MainNavigation` / `LoginScreen` en vidant la pile.

`MainNavigation.switchTab(context, index)` permet à un écran affiché dans un onglet de changer l'onglet actif (utilisé par l'accueil).

### Système de design centralisé

- `lib/core/constants/constant.dart` — `AppConst` : palette unique (violet `purpleButton` 0xFFA582E5, `purpleDark` 0xFF7042C9, fond des champs `purpleInputFill` 0xFFF1EFFE, `textGrey` 0xFF5F5F72 choisi pour un contraste WCAG ≥ 4.5:1, `successGreen`), police Roboto. Ne pas réintroduire de couleurs codées en dur dans les écrans : ajouter une constante ici.
- `lib/core/widgets/widgets.dart` — composants de formulaire partagés : `appInputDecoration()` (décoration commune des champs), `AppFieldLabel`, `AppPrimaryButton` (bouton violet pleine largeur, état `isLoading`). Tous les formulaires (connexion, inscription, profil, mots de passe) délèguent à ces composants.

### Authentification et backend

`lib/services/api/api.dart` (`AuthService`, `ApiConfig`, `ApiException`) et `lib/services/storage/secure_storage.dart` (`SecureStorageService`, jeton + profil via flutter_secure_storage) portent l'authentification. **Mode démo par défaut** : sans configuration, aucun appel réseau n'est fait et les opérations simulent une réussite. Pour brancher le vrai backend :

```bash
flutter run --dart-define=EDUGO_DEMO=false --dart-define=EDUGO_API_URL=https://votre-backend
```

Les endpoints attendus sont documentés en tête d'`AuthService` — à aligner avec l'API réelle (issue GitHub #3). Le démarrage passe par `StartupGate` (main.dart) : jeton présent → `MainNavigation`, sinon `WelcomeScreen`. La réinitialisation par lien e-mail (`nouveauMotDePasse`) attend le support des liens profonds. `lib/services/notifications/notification.dart` reste vide.

`lib/models/eleve.dart` (`Eleve`, fromJson/toJson) est aligné sur les champs du formulaire d'inscription.

### Pièges spécifiques

- Le dossier `lib/screens/connexion et inscriptions/` contient des espaces : les imports existants l'encodent en `connexion%20et%20inscriptions`. Conserver cette forme.
- Attention aux quasi-doublons de noms de fichiers (`nouveauMotDePasse.dart` définit la classe `NouveauMotPasse`, sans « De »).
- Les assets doivent vivre sous `assets/images/` (seul dossier déclaré dans pubspec.yaml).
- Historiquement, certains écrans embarquaient un `main()`/`MyApp` de test ou une fausse barre de statut recréée en widgets ; ils ont été supprimés — ne pas en réintroduire.
