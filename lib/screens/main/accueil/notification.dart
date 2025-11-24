import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/services/notification_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/notification.dart' as NotificationModel;

// --- CONSTANTES DE STYLES ---
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorChallenge = Color(0xFFFFA500); // Orange pour "Nouveau Challenge"
const Color _colorQuiz = Color(0xFF32C832); // Vert pour "Quiz"
const Color _colorDefi = Color(0xFF2196F3); // Bleu pour "Nouveau défi"
const Color _colorData = Color(0xFFFFCC00); // Jaune pour "Data internet"
const String _fontFamily = 'Roboto'; // Police principale

class NotificationScreen extends StatefulWidget {
  final ThemeService? themeService;
  final int? eleveId; // ID de l'élève pour charger les notifications

  const NotificationScreen({super.key, this.themeService, this.eleveId});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late ThemeService _themeService;
  final NotificationService _notificationService = NotificationService();
  final AuthService _authService = AuthService();
  
  List<NotificationModel.NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;
  int? _currentEleveId;

  @override
  void initState() {
    super.initState();
    _themeService = widget.themeService ?? ThemeService();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Récupérer l'ID de l'élève
      int? eleveId = widget.eleveId;
      if (eleveId == null) {
        eleveId = _authService.currentUserId;
      }

      if (eleveId == null) {
        setState(() {
          _errorMessage = 'Impossible de récupérer l\'ID de l\'élève';
          _isLoading = false;
        });
        return;
      }

      _currentEleveId = eleveId;

      // Charger les notifications depuis le backend
      final notifications = await _notificationService.getAllNotifications(eleveId);
      
      // Marquer toutes les notifications comme lues
      await _notificationService.markAllAsRead(eleveId);

      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('[NotificationScreen] Erreur lors du chargement des notifications: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Erreur lors du chargement des notifications';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Notifications',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _loadNotifications,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Affichage conditionnel selon l'état
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    )
                  else if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadNotifications,
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    )
                  else if (_notifications.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          Icon(Icons.notifications_none, size: 64, color: primaryColor.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text(
                            'Aucune notification',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Vous n\'avez pas encore de notifications',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    // Liste des Notifications
                    _buildNotificationList(primaryColor),

                  const SizedBox(height: 80), // Espace final pour la barre de navigation
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

  Widget _buildNotificationList(Color primaryColor) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        final notificationData = _mapNotificationToDisplay(notification, primaryColor);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _NotificationCard(
            title: notificationData['title'] as String,
            body: notificationData['body'] as String,
            icon: notificationData['icon'] as IconData,
            color: notificationData['color'] as Color,
            primaryColor: primaryColor,
            isRead: notification.lu ?? false,
            onTap: () {
              // Marquer comme lue si ce n'est pas déjà fait
              if (notification.id != null && !(notification.lu ?? false)) {
                _notificationService.markAsRead(notification.id!);
                // Mettre à jour la liste des notifications
                setState(() {
                  final index = _notifications.indexOf(notification);
                  if (index != -1) {
                    _notifications[index] = NotificationModel.NotificationModel(
                      id: notification.id,
                      titre: notification.titre,
                      contenu: notification.contenu,
                      type: notification.type,
                      lu: true, // Marquer comme lue
                      dateCreation: notification.dateCreation,
                      eleveId: notification.eleveId,
                      metadata: notification.metadata,
                    );
                  }
                });
              }
            },
          ),
        );
      },
    );
  }

  /// Mapper une notification du backend vers les données d'affichage
  Map<String, dynamic> _mapNotificationToDisplay(NotificationModel.NotificationModel notification, Color primaryColor) {
    final type = (notification.type ?? '').toUpperCase();
    final titre = notification.titre ?? 'Notification';
    final contenu = notification.contenu ?? '';

    // Déterminer l'icône et la couleur selon le type
    IconData icon;
    Color color;

    if (type.contains('SIGNAL') || type.contains('SIGNALEMENT')) {
      // Notifications de signalement
      icon = Icons.report;
      color = Colors.redAccent;
    } else if (type.contains('CHALLENGE')) {
      icon = Icons.emoji_events;
      color = _colorChallenge;
    } else if (type.contains('QUIZ')) {
      icon = Icons.question_answer;
      color = primaryColor; // Quiz utilise la couleur du thème
    } else if (type.contains('DEFI') || type.contains('DÉFI')) {
      icon = Icons.volume_up;
      color = _colorDefi;
    } else if (type.contains('DATA') || type.contains('CONVERSION')) {
      icon = Icons.public;
      color = _colorData;
    } else if (type.contains('BADGE') || type.contains('BADGE')) {
      icon = Icons.stars;
      color = _colorQuiz;
    } else if (type.contains('EXERCICE') || type.contains('EXERCICE')) {
      icon = Icons.assignment;
      color = primaryColor;
    } else {
      // Type par défaut
      icon = Icons.notifications;
      color = primaryColor;
    }

    return {
      'title': titre,
      'body': contenu,
      'icon': icon,
      'color': color,
    };
  }
}

// -------------------------------------------------------------------
// --- WIDGETS DE COMPOSANTS ---
// -------------------------------------------------------------------

class _NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final Color color;
  final Color primaryColor;
  final bool isRead;
  final VoidCallback? onTap;

  const _NotificationCard({
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
    required this.primaryColor,
    this.isRead = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : primaryColor.withOpacity(0.05), // Fond légèrement coloré si non lue
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1), // Ombre adaptée au thème
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: isRead 
                ? primaryColor.withOpacity(0.1) 
                : primaryColor.withOpacity(0.3), // Bordure plus visible si non lue
            width: isRead ? 1 : 1.5,
          ),
        ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône de la notification
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),

          const SizedBox(width: 15),

          // Contenu du texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    color: primaryColor.withOpacity(0.7), // Texte du corps adapté au thème
                    fontSize: 14,
                    fontFamily: _fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color primaryColor;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.primaryColor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? primaryColor : _colorBlack.withOpacity(0.6),
          size: 24,
        ),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryColor : _colorBlack.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }
}