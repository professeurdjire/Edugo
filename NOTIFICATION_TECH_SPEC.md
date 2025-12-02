# 📱 Spécification Technique des Notifications - Frontend (EDUGO Mobile)

Ce document technique détaille l'implémentation requise pour le système de notifications dans l'application mobile EDUGO, en se basant sur les exigences fonctionnelles définies.

## 📋 Table des matières

1. [Vue d'ensemble](#vue-densemble)
2. [Types de notifications à implémenter](#types-de-notifications-à-implémenter)
3. [Structure des données](#structure-des-données)
4. [Implémentation OneSignal](#implémentation-onesignal)
5. [Routage et navigation](#routage-et-navigation)
6. [Services requis](#services-requis)
7. [Composants UI/UX](#composants-uiux)
8. [Scénarios d'utilisation](#scénarios-dutilisation)

---

## 🎯 Vue d'ensemble

L'application EDUGO doit supporter un système de notifications push complet qui informe les élèves de divers événements liés à leur activité académique. Les notifications doivent être reçues via OneSignal et permettre une navigation contextuelle vers les écrans appropriés.

---

## 📨 Types de notifications à implémenter

### 1. QUIZ_TERMINE
- **Déclenchement** : Après soumission d'un quiz
- **Données** :
  ```json
  {
    "type": "QUIZ_TERMINE",
    "quizId": 123,
    "score": 18,
    "totalPoints": 20,
    "pointsGagnes": 10
  }
  ```
- **Navigation** : `/quizzes/{quizId}/result`

### 2. CHALLENGE_TERMINE
- **Déclenchement** : Après achèvement d'un challenge
- **Données** :
  ```json
  {
    "type": "CHALLENGE_TERMINE",
    "challengeId": 45,
    "score": 85,
    "totalPoints": 100,
    "rang": 2,
    "badgeObtenu": true,
    "pointsGagnes": 24
  }
  ```
- **Navigation** : `/challenges/{challengeId}/result`

### 3. DEFI_TERMINE
- **Déclenchement** : Après achèvement d'un défi
- **Données** :
  ```json
  {
    "type": "DEFI_TERMINE",
    "defiId": 67,
    "score": 15,
    "totalPoints": 20,
    "pointsGagnes": 8
  }
  ```
- **Navigation** : `/defis/{defiId}/result`

### 4. EXERCICE_CORRIGE
- **Déclenchement** : Quand un admin corrige un exercice
- **Données** :
  ```json
  {
    "type": "EXERCICE_CORRIGE",
    "exerciceId": 89,
    "note": 18,
    "pointsGagnes": 5
  }
  ```
- **Navigation** : `/exercices/{exerciceId}`

### 5. NOUVEAU_CHALLENGE
- **Déclenchement** : Création d'un nouveau challenge
- **Données** :
  ```json
  {
    "type": "NOUVEAU_CHALLENGE",
    "challengeId": 12,
    "titre": "Challenge de Mathématiques"
  }
  ```
- **Navigation** : `/challenges/{challengeId}`

### 6. NOUVEAU_DEFI
- **Déclenchement** : Création d'un nouveau défi
- **Données** :
  ```json
  {
    "type": "NOUVEAU_DEFI",
    "defiId": 34,
    "titre": "Défi du jour",
    "pointDefi": 15
  }
  ```
- **Navigation** : `/defis/{defiId}`

### 7. RAPPEL_DEADLINE
- **Déclenchement** : Rappel avant fin d'un challenge/défi
- **Données** :
  ```json
  {
    "type": "RAPPEL_DEADLINE",
    "entityType": "CHALLENGE",
    "entityId": 12,
    "titre": "Challenge de Mathématiques",
    "joursRestants": 2
  }
  ```
- **Navigation** : `/challenges/{entityId}` ou `/defis/{entityId}`

### 8. BADGE_OBTENU
- **Déclenchement** : Obtention d'un badge
- **Données** :
  ```json
  {
    "type": "BADGE_OBTENU",
    "badgeId": 5,
    "badgeNom": "Expert en Mathématiques",
    "badgeDescription": "Vous avez réussi 10 quiz de mathématiques",
    "badgeIcone": "📐"
  }
  ```
- **Navigation** : `/profile/badges`

### 9. NOUVEAU_LIVRE
- **Déclenchement** : Ajout d'un nouveau livre
- **Données** :
  ```json
  {
    "type": "NOUVEAU_LIVRE",
    "livreId": 78,
    "titre": "Algèbre 5ème",
    "auteur": "Jean Dupont",
    "matiere": "Mathématiques"
  }
  ```
- **Navigation** : `/livres/{livreId}`

### 10. OBJECTIF_ATTEINT
- **Déclenchement** : Atteinte d'un objectif de lecture
- **Données** :
  ```json
  {
    "type": "OBJECTIF_ATTEINT",
    "objectifId": 3,
    "typeObjectif": "HEBDOMADAIRE",
    "nbreLivre": 5,
    "progression": 100.0
  }
  ```
- **Navigation** : `/objectifs`

### 11. MESSAGE_ADMIN
- **Déclenchement** : Message de l'administration
- **Données** :
  ```json
  {
    "type": "MESSAGE_ADMIN",
    "messageId": 123,
    "titre": "Maintenance prévue",
    "important": true
  }
  ```
- **Navigation** : Modal ou `/annonces`

### 12. CLASSEMENT_AMELIORE
- **Déclenchement** : Amélioration du classement
- **Données** :
  ```json
  {
    "type": "CLASSEMENT_AMELIORE",
    "challengeId": 12,
    "ancienRang": 10,
    "nouveauRang": 5,
    "challengeTitre": "Challenge de Mathématiques"
  }
  ```
- **Navigation** : `/challenges/{challengeId}/leaderboard`

### 13. NOUVEAU_QUIZ
- **Déclenchement** : Création d'un nouveau quiz
- **Données** :
  ```json
  {
    "type": "NOUVEAU_QUIZ",
    "quizId": 56,
    "titre": "Quiz sur Algèbre 5ème",
    "livreId": 78,
    "livreTitre": "Algèbre 5ème"
  }
  ```
- **Navigation** : `/quizzes/{quizId}`

### 14. REPONSE_SUGGESTION
- **Déclenchement** : Réponse à une suggestion
- **Données** :
  ```json
  {
    "type": "REPONSE_SUGGESTION",
    "suggestionId": 23,
    "reponse": "Merci pour votre suggestion. Nous l'avons prise en compte."
  }
  ```
- **Navigation** : `/suggestions/{suggestionId}`

---

## 📊 Structure des données

### Modèle de notification côté API
```typescript
interface NotificationResponse {
  id: number;
  titre: string;
  message: string;
  dateEnvoi: string; // ISO 8601
  utilisateurId: number;
  lu: boolean;
  // Note: Le champ "type" et les données supplémentaires sont dans les données OneSignal
}
```

### Charge utile OneSignal
```typescript
interface OneSignalNotificationData {
  type: NotificationType;
  // Autres champs selon le type
  [key: string]: any;
}
```

### Types de notifications
```typescript
type NotificationType =
  | 'QUIZ_TERMINE'
  | 'CHALLENGE_TERMINE'
  | 'DEFI_TERMINE'
  | 'EXERCICE_CORRIGE'
  | 'NOUVEAU_CHALLENGE'
  | 'NOUVEAU_DEFI'
  | 'RAPPEL_DEADLINE'
  | 'BADGE_OBTENU'
  | 'NOUVEAU_LIVRE'
  | 'OBJECTIF_ATTEINT'
  | 'MESSAGE_ADMIN'
  | 'CLASSEMENT_AMELIORE'
  | 'NOUVEAU_QUIZ'
  | 'REPONSE_SUGGESTION';
```

---

## 🔔 Implémentation OneSignal

### Réception des notifications push

```dart
class NotificationService {
  void initializeOneSignal() {
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      final data = result.notification.payload.additionalData;
      handleNotification(data);
    });
  }

  void handleNotification(Map<String, dynamic> data) {
    final type = data['type'] as String;
    
    switch (type) {
      case 'QUIZ_TERMINE':
        Navigator.pushNamed(context, '/quizzes/${data['quizId']}/result');
        break;
      case 'CHALLENGE_TERMINE':
        Navigator.pushNamed(context, '/challenges/${data['challengeId']}/result');
        break;
      // ... autres cas
    }
  }
}
```

---

## 🧭 Routage et navigation

### Mapping des types vers les routes

```dart
const notificationRoutes = {
  'QUIZ_TERMINE': (data) => '/quizzes/${data['quizId']}/result',
  'CHALLENGE_TERMINE': (data) => '/challenges/${data['challengeId']}/result',
  'DEFI_TERMINE': (data) => '/defis/${data['defiId']}/result',
  'EXERCICE_CORRIGE': (data) => '/exercices/${data['exerciceId']}',
  'NOUVEAU_CHALLENGE': (data) => '/challenges/${data['challengeId']}',
  'NOUVEAU_DEFI': (data) => '/defis/${data['defiId']}',
  'RAPPEL_DEADLINE': (data) {
    final entityType = data['entityType'];
    final entityId = data['entityId'];
    return entityType == 'CHALLENGE' 
      ? '/challenges/$entityId' 
      : '/defis/$entityId';
  },
  'BADGE_OBTENU': (data) => '/profile/badges',
  'NOUVEAU_LIVRE': (data) => '/livres/${data['livreId']}',
  'OBJECTIF_ATTEINT': (data) => '/objectifs',
  'MESSAGE_ADMIN': (data) => '/annonces', // Ou afficher modal
  'CLASSEMENT_AMELIORE': (data) => '/challenges/${data['challengeId']}/leaderboard',
  'NOUVEAU_QUIZ': (data) => '/quizzes/${data['quizId']}',
  'REPONSE_SUGGESTION': (data) => '/suggestions/${data['suggestionId']}',
};
```

### Implémentation du handler de navigation

```dart
void handleNotificationNavigation(Map<String, dynamic> data) {
  final type = data['type'] as String?;
  if (type == null) return;
  
  final routeBuilder = notificationRoutes[type];
  if (routeBuilder != null) {
    final route = routeBuilder(data);
    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }
}
```

---

## ⚙️ Services requis

### NotificationRoutingService

Service dédié à la gestion du routage des notifications :

```dart
class NotificationRoutingService {
  static void navigateToNotificationTarget(
    BuildContext context,
    Map<String, dynamic> notificationData
  ) {
    final type = notificationData['type'] as String?;
    if (type == null) return;

    switch (type) {
      case 'QUIZ_TERMINE':
        _navigateToQuizResult(context, notificationData);
        break;
      case 'CHALLENGE_TERMINE':
        _navigateToChallengeResult(context, notificationData);
        break;
      case 'DEFI_TERMINE':
        _navigateToDefiResult(context, notificationData);
        break;
      // ... autres cas
    }
  }

  static void _navigateToQuizResult(
    BuildContext context, 
    Map<String, dynamic> data
  ) {
    final quizId = data['quizId'] as int?;
    if (quizId != null) {
      // Implémenter la navigation vers l'écran de résultat du quiz
      // Navigator.push(...) ou Navigator.pushNamed(...)
    }
  }

  // ... autres méthodes de navigation
}
```

---

## 🎨 Composants UI/UX

### Écran de liste des notifications

Fonctionnalités requises :
- Affichage chronologique des notifications
- Indicateur visuel pour les notifications non lues
- Action de marquage comme lu
- Rafraîchissement par pull-to-refresh
- Navigation contextuelle au tap

### Carte de notification individuelle

Éléments visuels :
- Icône spécifique au type
- Titre et corps du message
- Horodatage
- Indicateur de statut (lu/non lu)
- Animation de feedback tactile

---

## 🔄 Scénarios d'utilisation

### Scénario 1 : Réception d'une notification de résultat de quiz

1. L'élève termine un quiz
2. Le backend envoie une notification via OneSignal
3. L'application reçoit la notification en arrière-plan
4. L'élève clique sur la notification
5. L'application ouvre l'écran de résultat du quiz

### Scénario 2 : Consultation de la liste des notifications

1. L'élève accède à l'écran des notifications
2. L'application charge les notifications depuis l'API
3. Les notifications non lues sont mises en évidence
4. L'élève tape sur une notification
5. La notification est marquée comme lue
6. L'élève est redirigé vers l'écran correspondant

### Scénario 3 : Notification de rappel de deadline

1. Un cron job déclenche l'envoi de rappels
2. OneSignal diffuse la notification aux élèves concernés
3. L'élève reçoit la notification sur son appareil
4. En cliquant, il est dirigé vers le challenge/défi concerné
5. L'élève peut alors participer avant la deadline

---

## ✅ Points de vérification

Avant déploiement, vérifier :
- [ ] Tous les types de notifications sont correctement gérés
- [ ] Le routage vers les bons écrans fonctionne
- [ ] Les permissions de notification sont demandées
- [ ] L'association Player ID / utilisateur fonctionne
- [ ] Le compteur de notifications non lues est mis à jour
- [ ] L'expérience utilisateur est fluide et intuitive
- [ ] La gestion des erreurs est robuste
- [ ] Les tests couvrent tous les scénarios critiques

---

## 📞 Support et maintenance

Pour toute question technique sur l'implémentation des notifications, référez-vous à cette documentation et contactez l'équipe de développement EDUGO.