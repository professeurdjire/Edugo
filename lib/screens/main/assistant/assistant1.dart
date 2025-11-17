import 'package:flutter/material.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/assistant_service.dart';
import 'package:edugo/services/storage/assistant_storage.dart';
import 'package:edugo/models/assistant_message.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur active)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const String _fontFamily = 'Roboto'; // Police principale

class AssistanceScreen extends StatefulWidget {
  final int? eleveId;

  const AssistanceScreen({super.key, this.eleveId});

  @override
  State<AssistanceScreen> createState() => _AssistanceScreenState();
}

class _AssistanceScreenState extends State<AssistanceScreen> {
  final AuthService _authService = AuthService();
  final AssistantService _assistantService = AssistantService();
  final TextEditingController _messageController = TextEditingController();
  
  bool _isLoading = true;
  bool _isSending = false;
  String _userName = '';
  String _userEmail = '';
  String _userPhoto = '';
  int? _currentEleveId;
  
  // Conversation history
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadConversationHistory();
  }

  Future<void> _loadUserData() async {
    try {
      // Try to get user data from AuthService
      final eleve = _authService.currentEleve;
      
      if (eleve != null) {
        setState(() {
          _userName = '${eleve.prenom ?? ''} ${eleve.nom ?? ''}'.trim();
          _userEmail = eleve.email ?? '';
          _userPhoto = eleve.photoProfil ?? '';
          _currentEleveId = eleve.id;
          _isLoading = false;
        });
      } else {
        // If no current user, try to fetch profile
        final profile = await _authService.getCurrentUserProfile();
        if (profile != null) {
          setState(() {
            _userName = '${profile.prenom ?? ''} ${profile.nom ?? ''}'.trim();
            _userEmail = profile.email ?? '';
            _userPhoto = profile.photoProfil ?? '';
            _currentEleveId = profile.id;
            _isLoading = false;
          });
        } else {
          setState(() {
            _userName = 'Utilisateur';
            _userEmail = '';
            _userPhoto = '';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Erreur lors du chargement des données utilisateur: $e');
      setState(() {
        _userName = 'Utilisateur';
        _userEmail = '';
        _userPhoto = '';
        _isLoading = false;
      });
    }
  }
  
  Future<void> _loadConversationHistory() async {
    if (_currentEleveId != null) {
      // First, try to load from local storage
      final storedMessages = await AssistantStorage.loadChatHistory(_currentEleveId!);
      if (storedMessages.isNotEmpty) {
        setState(() {
          _messages = storedMessages;
        });
      }
      
      // Then, try to load from API
      final assistantMessages = await _assistantService.getChatSessions(_currentEleveId!);
      // Extract messages from AssistantMessage objects
      final List<Message> extractedMessages = [];
      if (assistantMessages != null) {
        for (var assistantMessage in assistantMessages) {
          if (assistantMessage.messages != null) {
            extractedMessages.addAll(assistantMessage.messages!);
          }
        }
      }
      
      if (extractedMessages.isNotEmpty) {
        setState(() {
          _messages = extractedMessages;
        });
        
        // Save to local storage
        await AssistantStorage.saveChatHistory(_currentEleveId!, extractedMessages);
      }
    } else if (widget.eleveId != null) {
      // First, try to load from local storage
      final storedMessages = await AssistantStorage.loadChatHistory(widget.eleveId!);
      if (storedMessages.isNotEmpty) {
        setState(() {
          _messages = storedMessages;
        });
      }
      
      // Then, try to load from API
      final assistantMessages = await _assistantService.getChatSessions(widget.eleveId!);
      // Extract messages from AssistantMessage objects
      final List<Message> extractedMessages = [];
      if (assistantMessages != null) {
        for (var assistantMessage in assistantMessages) {
          if (assistantMessage.messages != null) {
            extractedMessages.addAll(assistantMessage.messages!);
          }
        }
      }
      
      if (extractedMessages.isNotEmpty) {
        setState(() {
          _messages = extractedMessages;
          _currentEleveId = widget.eleveId;
        });
        
        // Save to local storage
        await AssistantStorage.saveChatHistory(widget.eleveId!, extractedMessages);
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _currentEleveId == null) return;
    
    setState(() {
      _isSending = true;
    });
    
    try {
      final message = _messageController.text.trim();
      _messageController.clear();
      
      // Add user message to UI immediately
      final userMessage = Message((b) => b
        ..content = message
        ..role = 'USER'
        ..createdAt = DateTime.now().toIso8601String()
      );
      
      setState(() {
        _messages = [..._messages, userMessage];
      });
      
      // Send message to backend
      final response = await _assistantService.sendMessage(message, _currentEleveId!);
      
      if (response != null && response.messages != null) {
        // Add all messages from the response to the conversation
        setState(() {
          _messages = [..._messages, ...response.messages!];
        });
      }
    } catch (e) {
      print('Erreur lors de l\'envoi du message: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'envoi du message')),
        );
      }
    } finally {
      setState(() {
        _isSending = false;
      });
      
      // Save chat history
      if (_currentEleveId != null) {
        await AssistantStorage.saveChatHistory(_currentEleveId!, _messages);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. App Bar personnalisé (avec barre de statut et titre)
          _buildCustomAppBar(context),
          
          // 2. Informations utilisateur
          _buildUserInfoSection(),

          // 3. Conversation history
          _buildConversationHistory(),

          // 4. Champ de saisie du message
          _buildMessageInput(),
          
          const SizedBox(height: 10), // Espace avant la barre de navigation
        ],
      ),
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

  Widget _buildUserInfoSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // Avatar utilisateur
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _purpleMain.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: _purpleMain, width: 1),
            ),
            child: _userPhoto.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(_userPhoto),
                    radius: 25,
                  )
                : Icon(
                    Icons.person,
                    color: _purpleMain,
                    size: 30,
                  ),
          ),
          const SizedBox(width: 15),
          // Informations utilisateur
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isLoading ? 'Chargement...' : _userName,
                  style: TextStyle(
                    color: _colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _isLoading ? 'Chargement...' : _userEmail,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontFamily: _fontFamily,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Titre de la page
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
                  onPressed: () => Navigator.pop(context), 
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Aide',
                      style: TextStyle(
                        color: _colorBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: _colorBlack),
                  onPressed: _loadConversationHistory,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationHistory() {
    return Expanded(
      child: _messages.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 120.0),
                child: Text(
                  'Comment puis-je vous aider ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _colorBlack,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.role == 'USER';
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: _purpleMain.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.support_agent,
                            color: _colorBlack,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: isUser ? _purpleMain : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            message.content ?? '',
                            style: TextStyle(
                              color: isUser ? Colors.white : _colorBlack,
                              fontSize: 16,
                              fontFamily: _fontFamily,
                            ),
                          ),
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 10),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: _purpleMain.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: _colorBlack,
                            size: 18,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), 
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Tapez votre message...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            
            // Icône d'envoi (avion en papier)
            IconButton(
              onPressed: _isSending ? null : _sendMessage,
              icon: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(_colorBlack),
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: _colorBlack,
                      size: 20,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGET DE NAVIGATION (COMPOSANT) ---
// -------------------------------------------------------------------

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _NavBarItem({required this.icon, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? _purpleMain : _colorBlack,
          size: 24,
        ),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? _purpleMain : _colorBlack,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }
}