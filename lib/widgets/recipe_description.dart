import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../models/recipe.dart';

class RecipeDescription extends StatefulWidget {
  final Recipe recipe;

  const RecipeDescription({super.key, required this.recipe});

  @override
  State<RecipeDescription> createState() => _RecipeDescriptionState();
}

class _RecipeDescriptionState extends State<RecipeDescription> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await flutterTts.setLanguage('km-KH');
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);

      // Add engine configuration
      await flutterTts.setEngine('com.google.android.tts');

      // Check available engines
      final engines = await flutterTts.getEngines;
      debugPrint('Available engines: $engines');

      // Check available languages
      final languages = await flutterTts.getLanguages;
      final isKhmerSupported = languages.contains('km-KH');

      if (!isKhmerSupported) {
        debugPrint('Khmer language is not supported on this device');
        // Show a snackbar to inform the user
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Khmer language is not supported on this device'),
            ),
          );
        }
      }

      flutterTts.setCompletionHandler(() {
        setState(() {
          isSpeaking = false;
        });
      });
    } catch (e) {
      debugPrint('TTS initialization failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize TTS: $e'),
          ),
        );
      }
    }
  }

  Future<void> _speak(String text) async {
    try {
      if (isSpeaking) {
        await flutterTts.stop();
        setState(() {
          isSpeaking = false;
        });
      } else {
        setState(() {
          isSpeaking = true;
        });
        final result = await flutterTts.speak(text);
        if (result == 1) {
          // Speaking started successfully
        } else {
          setState(() {
            isSpeaking = false;
          });
        }
      }
    } catch (e) {
      debugPrint('TTS speak failed: $e');
      setState(() {
        isSpeaking = false;
      });
      // Optionally show an error message to the user
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade700, Colors.green.shade500],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.description, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      'ការពិពណ៌នា:',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Koulen',
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        isSpeaking ? Icons.stop_circle : Icons.play_circle,
                        color: Colors.white,
                      ),
                      onPressed: () => _speak(
                          widget.recipe.description ?? 'គ្មានការពិពណ៌នា'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Text(
                  widget.recipe.description ?? 'គ្មានការពិពណ៌នា',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Koulen',
                    height: 1.5,
                    color: Colors.green.shade900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
