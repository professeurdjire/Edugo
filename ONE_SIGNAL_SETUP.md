# 🔧 Configuration de OneSignal pour EDUGO Mobile

## 📋 Étapes de Configuration

### 1. Créer un Compte OneSignal
1. Allez sur [https://onesignal.com](https://onesignal.com)
2. Créez un compte gratuit
3. Créez une nouvelle application

### 2. Obtenir votre App ID
1. Dans le dashboard OneSignal, sélectionnez votre application
2. Copiez l'**App ID** (un UUID comme `07b64c22-48ee-4981-9bf5-df3d231a5e45`)

### 3. Configurer l'App ID dans le Code
Remplacez le placeholder dans [lib/services/onesignal_service.dart](file:///c%3A/Users/PC/Desktop/EdugoMobile/edugo/lib/services/onesignal_service.dart) :

```dart
// ⚠️ IMPORTANT: Remplacez par votre App ID OneSignal
const String oneSignalAppId = 'VOTRE_APP_ID_ICI'; // TODO: Remplacer par votre App ID
```

### 4. Configuration Android (AndroidManifest.xml)
Ajoutez votre App ID dans `android/app/src/main/AndroidManifest.xml` :

```xml
<manifest>
  <application>
    <!-- OneSignal -->
    <meta-data android:name="onesignal_app_id" android:value="VOTRE_APP_ID_ICI" />
    <!-- ... autres configurations ... -->
  </application>
</manifest>
```

### 5. Configuration iOS (Info.plist)
Ajoutez votre App ID dans `ios/Runner/Info.plist` :

```xml
<dict>
  <!-- OneSignal -->
  <key>OneSignalAppId</key>
  <string>VOTRE_APP_ID_ICI</string>
  <!-- ... autres configurations ... -->
</dict>
```

## 🧪 Test de Fonctionnement

### Vérifier l'Initialisation
Dans les logs, vous devriez voir :
```
[OneSignalService] OneSignal initialized successfully
[OneSignalService] Player ID: [UUID_VALIDE]
```

### Envoyer une Notification de Test
1. Dans le dashboard OneSignal, allez dans "Messages"
2. Cliquez sur "New Push"
3. Sélectionnez votre application
4. Envoyez un message de test

## 🛠️ Dépannage

### Problème: Player ID est null
**Causes possibles :**
1. App ID incorrect
2. Problème de réseau
3. Permissions non accordées

**Solutions :**
1. Vérifiez que l'App ID est correct
2. Assurez-vous que l'appareil a accès à internet
3. Vérifiez les permissions dans les paramètres de l'app

### Problème: Notifications non reçues
**Causes possibles :**
1. L'application n'est pas correctement enregistrée
2. Problème de certificats (iOS)
3. Problème de clés API (Android)

**Solutions :**
1. Vérifiez la configuration dans le dashboard OneSignal
2. Suivez les guides de configuration spécifiques à chaque plateforme

## 📱 Permissions

L'application demande automatiquement la permission pour les notifications. Vous pouvez aussi vérifier manuellement :

```dart
final permission = await OneSignal.Notifications.requestPermission(true);
```

## 📊 Monitoring

Les logs importants à surveiller :
```
[OneSignalService] Player ID: [UUID]
[OneSignalService] Notification clicked: [message]
[OneSignalService] Notification data: [data]
```

## 🔐 Sécurité

N'oubliez pas de :
1. Garder votre App ID privé
2. Utiliser des clés API sécurisées
3. Ne pas commiter vos identifiants dans le code source