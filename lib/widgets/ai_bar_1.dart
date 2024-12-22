import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIBar extends StatefulWidget {
  final String initialPrompt;
  final String context;
  final String systemMessage;

  const AIBar({
    super.key,
    required this.initialPrompt,
    required this.context,
    required this.systemMessage,
  });

  @override
  State<AIBar> createState() => _AIBarState();
}

class _AIBarState extends State<AIBar> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialPrompt;
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add({'role': 'user', 'content': userMessage});
      _isLoading = true;
    });
    _controller.clear();

    try {
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: 'AIzaSyBD1cbt5BJtncNgzUDvwJTp0HeRJ8_tqJA',
      );

      const warnning = '''
 ប្រសិនបើអ្នកប្រើប្រាស់សួរអ្វីក្រៅពីបរិបទ សូមប្រាប់ពួកគេថាអ្នកមិនអាចឆ្លើយសំណួរនោះបានទេ។
 if the user ask anything beside the context, please tell them that you are not able to answer that question.
''';

      final prompt = '''
${widget.systemMessage}

warnning:
$warnning

សំណួរ៖
${userMessage}

បរិបទ៖
${widget.context}
''';
      final content = [Content.text(prompt)];

      final response = await model.generateContent(content);
      final responseText = response.text;

      if (responseText == null || responseText.isEmpty) {
        throw Exception('គ្មានការឆ្លើយតបពី AI');
      }

      setState(() {
        _messages.add({'role': 'assistant', 'content': responseText});
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': 'បញ្ហាក្នុងការទទួលបានចម្លើយ។ សូមព្យាយាមម្តងទៀត។'
        });
        _isLoading = false;
      });
      print('កំហុស: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade50.withOpacity(0.9),
            Colors.white,
            Colors.green.shade50.withOpacity(0.7),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade800,
                  Colors.green.shade600,
                  Colors.green.shade500,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.psychology, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'ជំនួយការ AI',
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Koulen',
                    color: Colors.white,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black38,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    margin: EdgeInsets.only(
                      top: 12,
                      bottom: 12,
                      left: isUser ? 50 : 16,
                      right: isUser ? 16 : 50,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.green.shade100 : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(25),
                        topRight: const Radius.circular(25),
                        bottomLeft: isUser
                            ? const Radius.circular(25)
                            : const Radius.circular(5),
                        bottomRight: isUser
                            ? const Radius.circular(5)
                            : const Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.12),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      message['content']!,
                      style: TextStyle(
                        fontFamily: 'Koulen',
                        fontSize: 16,
                        height: 1.6,
                        color: isUser ? Colors.green.shade900 : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.green.shade700),
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'កំពុងគិត...',
                      style: TextStyle(
                        fontFamily: 'Koulen',
                        fontSize: 16,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.12),
                  blurRadius: 15,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'សរសេរសំណួររបស់អ្នកនៅទីនេះ...',
                        hintStyle: TextStyle(
                          fontFamily: 'Koulen',
                          color: Colors.green.shade300,
                        ),
                        filled: true,
                        fillColor: Colors.green.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 18,
                        ),
                        prefixIcon: Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.green.shade300,
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Koulen',
                        fontSize: 16,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.green.shade600,
                        Colors.green.shade500,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
