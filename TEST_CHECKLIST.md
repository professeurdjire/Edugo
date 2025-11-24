# ✅ Checklist de Test - OneSignal et Soumissions

## 🔔 Configuration OneSignal

### ⚠️ Action Requise
1. **Remplacer l'App ID OneSignal** dans `lib/services/onesignal_service.dart` :
   - Ligne 22 : Remplacer `'YOUR_ONESIGNAL_APP_ID'` par votre vrai App ID OneSignal
   - Vous pouvez le trouver dans votre dashboard OneSignal : https://app.onesignal.com

### ✅ Déjà Configuré
- ✅ OneSignal initialisé dans `main.dart`
- ✅ Firebase configuré dans `build.gradle.kts`
- ✅ `google-services.json` présent dans `android/app/`
- ✅ Service OneSignal créé avec handlers de notifications
- ✅ Association du Player ID avec l'utilisateur (nécessite endpoint backend)

---

## 📝 Soumissions et Validations

### ✅ Quiz
- ✅ Service de soumission : `SubmissionService.submitQuiz()`
- ✅ Validation : Vérifie que toutes les questions sont répondues
- ✅ Écran de résultats : `QuizResultScreen`
- ✅ Gestion des erreurs avec messages utilisateur

### ✅ Exercices
- ✅ Service de soumission : `ExerciseService.submitExerciceAnswers()`
- ✅ Endpoint : `POST /api/eleve/exercices/soumettre/{eleveId}/{exerciceId}`
- ✅ Validation côté backend
- ✅ Historique des exercices disponible

### ✅ Challenges
- ✅ Service de soumission : `ChallengeService.submitChallengeAnswers()`
- ✅ Participation : `ChallengeService.participerChallenge()`
- ✅ Leaderboard : `ChallengeService.getChallengeLeaderboard()`
- ✅ Validation des réponses

---

## 🧪 Tests à Effectuer

### 1. Test OneSignal
```
1. Ouvrir l'application
2. Vérifier dans les logs : "[OneSignalService] Player ID: ..."
3. Vérifier : "[OneSignalService] OneSignal initialized successfully"
4. Envoyer une notification de test depuis le dashboard OneSignal
5. Vérifier que la notification est reçue
6. Cliquer sur la notification et vérifier la navigation
```

### 2. Test Quiz
```
1. Ouvrir un livre avec un quiz associé
2. Cliquer sur "Faire le quiz"
3. Répondre à toutes les questions
4. Cliquer sur "Soumettre"
5. Vérifier :
   - Validation : Toutes les questions doivent être répondues
   - Soumission : Les réponses sont envoyées au backend
   - Résultats : L'écran de résultats s'affiche avec le score
   - Points : Les points sont ajoutés au total (vérifier sur l'écran d'accueil)
```

### 3. Test Exercices
```
1. Aller dans la section "Exercices"
2. Sélectionner une matière
3. Choisir un exercice
4. Répondre aux questions
5. Soumettre l'exercice
6. Vérifier :
   - Validation des réponses
   - Affichage de la note
   - Mise à jour de l'historique
   - Ajout des points/expérience
```

### 4. Test Challenges
```
1. Aller dans la section "Challenges"
2. Voir les challenges disponibles
3. Participer à un challenge
4. Répondre aux questions
5. Soumettre les réponses
6. Vérifier :
   - Validation des réponses
   - Affichage du score
   - Mise à jour du leaderboard
   - Ajout des points
```

### 5. Test Validations
```
1. Tester les formulaires :
   - Email : Format invalide
   - Mot de passe : Longueur minimale
   - Champs requis : Vérifier les messages d'erreur
   
2. Tester les soumissions :
   - Quiz : Soumettre sans répondre à toutes les questions
   - Exercice : Soumettre avec des réponses vides
   - Challenge : Vérifier la validation avant soumission
```

---

## 🔧 Configuration Backend Requise

### Endpoints Nécessaires
1. **OneSignal Player ID** :
   - `POST /api/eleve/{eleveId}/onesignal-player-id`
   - Body : `{ "playerId": "string" }`

2. **Quiz Submission** :
   - `POST /api/quizzes/{quizId}/submit`
   - Retourne : `SubmitResultResponse` avec score et points

3. **Exercise Submission** :
   - `POST /api/eleve/exercices/soumettre/{eleveId}/{exerciceId}`
   - Retourne : `FaireExerciceResponse` avec note et points

4. **Challenge Submission** :
   - `POST /api/challenges/{challengeId}/submit`
   - Retourne : Résultat avec score et classement

---

## 📊 Points à Vérifier

### Après Chaque Soumission
1. ✅ Les points sont ajoutés au total sur l'écran d'accueil
2. ✅ L'expérience est mise à jour
3. ✅ Les badges sont débloqués si les conditions sont remplies
4. ✅ L'historique est mis à jour
5. ✅ Les statistiques sont recalculées

### Messages d'Erreur
- ✅ Connexion perdue : Message clair pour l'utilisateur
- ✅ Validation échouée : Message spécifique
- ✅ Token expiré : Redirection vers login
- ✅ Erreur serveur : Message d'erreur générique

---

## 🐛 Problèmes Potentiels

### OneSignal
- ❌ Si Player ID est null : Vérifier les permissions de notification
- ❌ Si notifications ne sont pas reçues : Vérifier l'App ID
- ❌ Si association échoue : Vérifier l'endpoint backend

### Soumissions
- ❌ Erreur 403 : Vérifier le token d'authentification
- ❌ Erreur 400 : Vérifier le format des réponses
- ❌ Erreur 500 : Vérifier les logs backend

---

## ✅ Statut Actuel

- ✅ **Configuration Firebase** : Complète
- ✅ **Service OneSignal** : Prêt (nécessite App ID)
- ✅ **Services de soumission** : Implémentés
- ✅ **Validations** : Implémentées
- ✅ **Gestion d'erreurs** : Implémentée
- ⚠️ **App ID OneSignal** : À configurer
- ⚠️ **Endpoint Player ID** : À créer côté backend

---

## 🚀 Prochaines Étapes

1. **Configurer OneSignal** :
   - Obtenir l'App ID depuis le dashboard
   - Remplacer dans `onesignal_service.dart`
   - Tester la réception de notifications

2. **Tester les Soumissions** :
   - Commencer par un quiz simple
   - Vérifier les points ajoutés
   - Tester les exercices et challenges

3. **Vérifier les Validations** :
   - Tester tous les cas limites
   - Vérifier les messages d'erreur
   - S'assurer que les validations sont claires

