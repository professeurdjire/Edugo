# 📋 Endpoints de Soumission - Documentation

## ✅ Endpoints Configurés dans Flutter

### 1. Quiz
- **Endpoint**: `POST /api/quizzes/{quizId}/submit`
- **Service**: `SubmissionService.submitQuiz()`
- **Fichier**: `lib/services/submission_service.dart:165`
- **Status**: ✅ Configuré correctement

### 2. Exercices
- **Endpoint**: `POST /api/exercices/{exerciceId}/submit`
- **Service**: `SubmissionService.submitExercise()`
- **Fichier**: `lib/services/submission_service.dart:330`
- **Status**: ✅ Configuré correctement

### 3. Challenges
- **Endpoint**: `POST /api/challenges/{challengeId}/submit`
- **Service**: `SubmissionService.submitChallenge()`
- **Fichier**: `lib/services/submission_service.dart:477`
- **Status**: ✅ Configuré correctement

### 4. Participation aux Challenges
- **Endpoint**: `POST /api/challenges/participer/{eleveId}/{challengeId}`
- **Alternative**: `POST /api/eleve/challenges/participer/{eleveId}/{challengeId}`
- **Service**: `ChallengeService.participerChallenge()`
- **Fichier**: `lib/services/challenge_service.dart:97`
- **Status**: ✅ Configuré correctement (tente les deux endpoints)

### 5. Participation aux Défis
- **Endpoint**: `POST /api/defis/participer/{eleveId}/{defiId}`
- **Alternative**: `POST /api/eleve/defis/participer/{eleveId}/{defiId}`
- **Service**: `DefiService.participerDefi()`
- **Fichier**: `lib/services/defi_service.dart:61`
- **Status**: ✅ Configuré correctement

## 🔐 Authentification

Tous les endpoints de soumission nécessitent :
- ✅ Un token JWT valide dans le header `Authorization: Bearer {token}`
- ✅ Le rôle `ELEVE` ou `ADMIN` dans le token JWT
- ✅ L'intercepteur `AuthService` ajoute automatiquement le token à toutes les requêtes

## 📝 Format des Payloads

### Format Standard (Quiz, Exercices, Challenges)
```json
{
  "eleveId": 7,
  "reponses": [
    {
      "questionId": 1,
      "reponseIds": [10, 11]  // Pour QCM/QCU/VRAI_FAUX
    },
    {
      "questionId": 2,
      "reponse": "Texte libre"  // Pour réponses courtes
    },
    {
      "questionId": 3,
      "appariements": [  // Pour appariement
        {"leftId": 1, "rightId": 2},
        {"leftId": 3, "rightId": 4}
      ]
    }
  ]
}
```

## 🐛 Débogage

### Logs Détaillés
Tous les services de soumission incluent des logs détaillés :
- ✅ URL complète de la requête
- ✅ Présence du token
- ✅ Payload envoyé
- ✅ Réponse du serveur
- ✅ Gestion des erreurs 403/401/400

### Vérification des Erreurs
En cas d'erreur 403 :
1. Vérifier que le token est présent dans les logs
2. Vérifier que le token contient le rôle `ELEVE`
3. Vérifier que l'endpoint correspond exactement à celui configuré dans `SecurityConfig.java`
4. Vérifier que les règles de sécurité sont dans le bon ordre (soumissions AVANT règles générales)

## 📅 Date de Mise à Jour
Novembre 2024 - Aligné avec les corrections backend

