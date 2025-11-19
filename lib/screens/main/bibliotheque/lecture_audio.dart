import 'package:flutter/material.dart';
import 'package:edugo/services/text_to_speech_service.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8);
const Color _colorBlack = Color(0xFF000000);
const Color _colorGrey = Color(0xFF757575);
const String _fontFamily = 'Roboto';

class AudioBookReaderScreen extends StatefulWidget {
  final String bookTitle;
  final String bookContent; // In a real app, this would be the actual book content
  final int? livreId;
  final int? eleveId;

  const AudioBookReaderScreen({
    super.key,
    required this.bookTitle,
    required this.bookContent,
    this.livreId,
    this.eleveId,
  });

  @override
  State<AudioBookReaderScreen> createState() => _AudioBookReaderScreenState();
}

class _AudioBookReaderScreenState extends State<AudioBookReaderScreen> {
  final TextToSpeechService _ttsService = TextToSpeechService();
  bool _isPlaying = false;
  bool _isInitialized = false;
  double _speechRate = 0.5;
  double _volume = 1.0;
  double _pitch = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    try {
      // Set initial TTS parameters
      await _ttsService.setSpeechRate(_speechRate);
      await _ttsService.setVolume(_volume);
      await _ttsService.setPitch(_pitch);
      
      setState(() {
        _isInitialized = _ttsService.isReady;
      });
      
      // Auto-start playback when screen loads
      if (_isInitialized) {
        _togglePlayPause();
      }
    } catch (e) {
      print('Error initializing TTS: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'initialisation de la lecture audio')),
        );
      }
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _stop();
      } else {
        _play();
      }
    });
  }

  void _play() {
    if (!_isInitialized) return;
    
    _ttsService.speak(widget.bookContent);
    setState(() {
      _isPlaying = true;
    });
  }

  void _stop() {
    _ttsService.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  void _pause() {
    _ttsService.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _updateSpeechRate(double rate) async {
    setState(() {
      _speechRate = rate;
    });
    await _ttsService.setSpeechRate(rate);
  }

  Future<void> _updateVolume(double volume) async {
    setState(() {
      _volume = volume;
    });
    await _ttsService.setVolume(volume);
  }

  Future<void> _updatePitch(double pitch) async {
    setState(() {
      _pitch = pitch;
    });
    await _ttsService.setPitch(pitch);
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Lecture audio',
          style: TextStyle(
            color: _colorBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _colorBlack),
          onPressed: () {
            _stop();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Book title header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: _purpleMain.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      color: _purpleMain,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bookTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _colorBlack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Lecture audio en cours',
                          style: TextStyle(
                            fontSize: 14,
                            color: _colorGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Main content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book content preview
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.bookContent,
                        style: const TextStyle(
                          fontSize: 16,
                          color: _colorGrey,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Playback controls
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Play/Pause button
                          Center(
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: _purpleMain,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 36,
                                ),
                                onPressed: _isInitialized ? _togglePlayPause : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Progress indicator (simplified)
                          LinearProgressIndicator(
                            value: _isPlaying ? 0.3 : 0.0, // Simulated progress
                            backgroundColor: Colors.grey[300],
                            color: _purpleMain,
                            minHeight: 4,
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('0:00', style: TextStyle(fontSize: 12, color: _colorGrey)),
                              Text('5:30', style: TextStyle(fontSize: 12, color: _colorGrey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // TTS Settings
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Paramètres audio',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _colorBlack,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Speech rate
                          _buildSettingSlider(
                            label: 'Vitesse',
                            value: _speechRate,
                            min: 0.1,
                            max: 1.0,
                            onChanged: _updateSpeechRate,
                          ),
                          
                          // Volume
                          _buildSettingSlider(
                            label: 'Volume',
                            value: _volume,
                            min: 0.0,
                            max: 1.0,
                            onChanged: _updateVolume,
                          ),
                          
                          // Pitch
                          _buildSettingSlider(
                            label: 'Tonalité',
                            value: _pitch,
                            min: 0.5,
                            max: 2.0,
                            onChanged: _updatePitch,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: _colorBlack,
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: const TextStyle(
                fontSize: 14,
                color: _colorGrey,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: _purpleMain,
          inactiveColor: Colors.grey[300],
          onChanged: onChanged,
        ),
      ],
    );
  }
}