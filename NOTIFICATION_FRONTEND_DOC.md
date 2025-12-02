# 📱 Documentation des Notifications - Frontend (EDUGO Mobile)

Ce document décrit l'implémentation complète du système de notifications dans l'application mobile EDUGO.

## 📋 Table des matières

1. [Architecture du système](#architecture-du-système)
2. [Types de notifications supportés](#types-de-notifications-supportés)
3. [Structure des données](#structure-des-données)
4. [Services implémentés](#services-implémentés)
5. [Implémentation OneSignal](#implémentation-onesignal)
6. [Interface utilisateur](#interface-utilisateur)
7. [Routage et navigation](#routage-et-navigation)
8. [Exemples d'utilisation](#exemples-dutilisation)

---

## 🏗️ Architecture du système

Le système de notifications suit une architecture en couches :

```
┌─────────────────────┐
│   UI Components     │  ← Interface utilisateur
├─────────────────────┤
│ NotificationScreen  │  ← Écran de liste des notifications
│ NotificationCard    │  ← Composant individuel
├─────────────────────┤
│ NotificationService │  ← Service de gestion des notifications
│ OneSignalService    │  ← Service d'intégration push
├─────────────────────┤
│ NotificationModel   │  ← Modèle de données
└─────────────────────┘
```

---

## 🎯 Types de notifications supportés

Actuellement, l'application prend en charge les types de notifications suivants :

| Type | Icône | Couleur | Contexte |
|------|-------|---------|----------|
| CHALLENGE | 🏆 | Orange (#FFA500) | Notifications liées aux challenges |
| QUIZ | ❓ | Thème primaire | Notifications liées aux quiz |
| DEFI | 🎯 | Bleu (#2196F3) | Notifications liées aux défis |
| EXERCICE | 📝 | Thème primaire | Notifications de correction d'exercices |
| DATA | 🌐 | Jaune (#FFCC00) | Notifications liées à la conversion de données |
| BADGE | ⭐ | Vert (#32C832) | Notifications d'obtention de badges |
| SIGNALEMENT | ⚠️ | Rouge accentué | Notifications de signalement |

---

## 📊 Structure des données

### Modèle de notification (`NotificationModel`)

```dart
class NotificationModel {
  final int? id;
  final String? titre;
  final String? contenu;
  final String? type; // 'CHALLENGE', 'QUIZ', 'DEFI', 'DATA', etc.
  final bool? lu;
  final DateTime? dateCreation;
  final int? eleveId;
  final Map<String, dynamic>? metadata; // Données supplémentaires
}
```

### Propriétés du modèle

| Propriété | Type | Description |
|-----------|------|-------------|
| `id` | `int?` | Identifiant unique de la notification |
| `titre` | `String?` | Titre de la notification |
| `contenu` | `String?` | Corps/message de la notification |
| `type` | `String?` | Type de notification (détermine l'icône et la couleur) |
| `lu` | `bool?` | Indique si la notification a été lue |
| `dateCreation` | `DateTime?` | Date de création de la notification |
| `eleveId` | `int?` | ID de l'élève destinataire |
| `metadata` | `Map<String, dynamic>?` | Données supplémentaires spécifiques au type |

---

## ⚙️ Services implémentés

### NotificationService

Service principal pour gérer les opérations liées aux notifications.

#### Méthodes principales :

```dart
/// Récupérer le nombre de notifications non lues
Future<int> getUnreadNotificationCount(int eleveId)

/// Marquer une notification comme lue
Future<bool> markAsRead(int notificationId)

/// Marquer toutes les notifications comme lues
Future<bool> markAllAsRead(int eleveId)

/// Récupérer toutes les notifications d'un élève
Future<List<NotificationModel>> getAllNotifications(int eleveId)
```

### OneSignalService

Service d'intégration avec OneSignal pour les notifications push.

#### Méthodes principales :

```dart
/// Initialiser OneSignal
Future<void> initialize()

/// Obtenir le Player ID
String? get playerId

/// Vérifier si OneSignal est initialisé
bool get isInitialized
```

---

## 🔔 Implémentation OneSignal

### Initialisation

Dans [lib/services/onesignal_service.dart](file:///c%3A/Users/PC/Desktop/EdugoMobile/edugo/lib/services/onesignal_service.dart) :

```dart
Future<void> initialize() async {
  if (_isInitialized) return;

  try {
    // ⚠️ IMPORTANT: Remplacer par votre App ID OneSignal
    const String oneSignalAppId = 'YOUR_ONESIGNAL_APP_ID';

    // Initialiser OneSignal
    OneSignal.initialize(oneSignalAppId);

    // Demander la permission pour les notifications
    OneSignal.Notifications.requestPermission(true);

    // Obtenir le Player ID
    _playerId = await OneSignal.User.pushSubscription.id;

    // Configurer les handlers
    _setupNotificationHandlers();

    // Associer le Player ID à l'utilisateur
    await _associatePlayerIdWithUser();

    _isInitialized = true;
  } catch (e) {
    print('[OneSignalService] Error initializing OneSignal: $e');
  }
}
```

### Handlers de notification

```dart
void _setupNotificationHandlers() {
  // Handler pour les notifications reçues en arrière-plan
  OneSignal.Notifications.addClickListener((event) {
    print('[OneSignalService] Notification clicked: ${event.notification.body}');
    // Navigation personnalisée à implémenter ici
  });

  // Handler pour les notifications reçues en premier plan
  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    print('[OneSignalService] Notification received in foreground: ${event.notification.body}');
    // Personnalisation de l'affichage
  });
}
```

---

## 🖼️ Interface utilisateur

### Écran des notifications

Implémenté dans [lib/screens/main/accueil/notification.dart](file:///c%3A/Users/PC/Desktop/EdugoMobile/edugo/lib/screens/main/accueil/notification.dart)

#### Fonctionnalités :
- Affichage paginé des notifications
- Marquage automatique comme lu lors de l'ouverture
- Rafraîchissement par glisser-bas
- Indicateur visuel pour les notifications non lues

#### Structure :
```dart
class NotificationScreen extends StatefulWidget {
  final ThemeService? themeService;
  final int? eleveId;
}
```

### Composant de notification individuelle

```dart
class _NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final Color color;
  final bool isRead;
  final VoidCallback? onTap;
}
```

### Badge de notification

Dans [lib/widgets/notification_badge.dart](file:///c%3A/Users/PC/Desktop/EdugoMobile/edugo/lib/widgets/notification_badge.dart) :

```dart
class NotificationBadge extends StatelessWidget {
  final Widget child;
  final int count;
  final Color badgeColor;
  final Color textColor;
}
```

---

## 🧭 Routage et navigation

### Navigation vers l'écran des notifications

Depuis l'écran d'accueil ([lib/screens/main/accueil/accueille.dart](file:///c%3A/Users/PC/Desktop/EdugoMobile/edugo/lib/screens/main/accueil/accueille.dart)) :

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NotificationScreen(
      themeService: widget.themeService,
      eleveId: _currentEleveId,
    ),
  ),
).then((_) {
  // Rafraîchir le compteur après retour
  _loadUnreadNotificationCount();
});
```

### Navigation depuis une notification (à implémenter)

Le routage basé sur le type de notification doit être implémenté dans le handler de clic :

```dart
// À ajouter dans le OneSignal click handler
void _handleNotificationNavigation(Map<String, dynamic> data) {
  final type = data['type'] as String?;
  
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
```

---

## 💻 Exemples d'utilisation

### Initialisation des services

Dans le point d'entrée de l'application :

```dart
// Initialiser OneSignal
final oneSignalService = OneSignalService();
await oneSignalService.initialize();

// Vérifier les permissions
final permissionService = PermissionService();
await permissionService.requestNotificationPermission();
```

### Chargement des notifications

```dart
final notificationService = NotificationService();
final notifications = await notificationService.getAllNotifications(eleveId);

// Marquer toutes comme lues
await notificationService.markAllAsRead(eleveId);
```

### Mise à jour du compteur de notifications non lues

```dart
Future<void> _loadUnreadNotificationCount() async {
  if (_currentEleveId == null) return;
  
  try {
    final count = await _notificationService.getUnreadNotificationCount(_currentEleveId!);
    setState(() {
      _unreadNotificationCount = count;
    });
  } catch (e) {
    print('Erreur lors du chargement du compteur: $e');
  }
}
```

---

## 🛠️ Améliorations recommandées

1. **Implémenter le routage complet** : Ajouter la navigation vers les écrans spécifiques selon le type de notification
2. **Améliorer l'expérience utilisateur** : Ajouter des animations et transitions fluides
3. **Gestion des erreurs** : Ajouter une gestion plus robuste des erreurs réseau
4. **Cache local** : Implémenter un cache pour améliorer les performances
5. **Notifications silencieuses** : Gérer les notifications qui ne doivent pas s'afficher à l'utilisateur

---

## 📞 Support

Pour toute question sur l'implémentation des notifications, contactez l'équipe de développement EDUGO.