import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:async';
import 'dart:math';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  late ScrollController _scrollController;
  late AnimationController _typingIndicatorController;
  Timer? _debounceTimer;

  // Initialize Gemini API with Khmer prompt
  final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: 'AIzaSyBD1cbt5BJtncNgzUDvwJTp0HeRJ8_tqJA',
  );
  late final chat = model.startChat(history: [
    Content.text(
        '''ខ្ញុំជាចុងភៅពិសេសដែលអាចជួយឆ្លើយសំណួរអំពីការធ្វើម្ហូបខ្មែរ។
    ខ្ញុំនឹងឆ្លើយតបជាភាសាខ្មែរ។ សម្រាប់ការឆ្លើយតប៖

    ១. សម្រាប់គ្រឿងផ្សំ៖
    • រាយគ្រឿងផ្សំជាចំណុច
    • បញ្ជាក់បរិមាណច្បាស់លាស់

    ២. សម្រាប់វិធីធ្វើ៖
    • បែងចែកជាជំហានច្បាស់លាស់
    • ប្រើលេខសម្រាប់ជំហាននីមួយៗ
    
    ៣. ទម្រង់នៃការឆ្លើយតប៖
    • បែងចែកជាផ្នែក (គ្រឿងផ្សំ វិធីធ្វើ កំណត់សម្គាល់)
    • ប្រើការចុះបន្ទាត់ថ្មីសម្រាប់ភាពងាយស្រួលអាន
    • មិនប្រើសញ្ញា * ឬ **
    • ប្រើភាសាសាមញ្ញងាយយល់
    '''),
    Content.text('បាទ/ចាស ខ្ញុំជាចុងភៅពិសេសដែលនឹងជួយណែនាំអំពីការធ្វើម្ហូបខ្មែរ។'),
  ]);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _typingIndicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _typingIndicatorController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await chat.sendMessage(Content.text(userMessage));
      final botMessage = response.text;

      setState(() {
        _messages.add(ChatMessage(
          text: botMessage ?? 'គ្មានការឆ្លើយតប',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  void _scrollToBottom() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('កំហុស: $error'),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'ចុងភៅពិសេស',
          style: TextStyle(
            fontFamily: 'Moul',
            color: Colors.green,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildAIAssistantCard(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return MessageBubble(message: message);
                },
              ),
            ),
            if (_isLoading) _buildTypingIndicator(),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildAIAssistantCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.restaurant_menu,
                color: Colors.green, size: 30),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jong Pou Pises',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'សួរសំណួរអំពីការធ្វើម្ហូប',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Moul',
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _typingIndicatorController,
                  builder: (context, child) {
                    final animation = sin(
                        (_typingIndicatorController.value * 2 * 3.14159) +
                            (index * 1.0472));
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 8 + (animation * 4),
                      width: 8,
                      decoration: BoxDecoration(
                        color: Colors.green.shade300,
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'សួរសំណួរអំពីការធ្វើម្ហូប...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontFamily: 'Moul',
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _messageController.clear(),
                  color: Colors.grey.shade400,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Format the message text
    String formattedText = message.text
        .replaceAll('*', '') // Remove asterisks
        .replaceAll('- ', '• ') // Convert dashes to bullets
        .trim();

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: message.isUser
                ? [Colors.green.shade400, Colors.green.shade600]
                : [Colors.grey.shade200, Colors.grey.shade300],
          ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft:
                message.isUser ? const Radius.circular(20) : Radius.zero,
            bottomRight:
                message.isUser ? Radius.zero : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedText,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(message.timestamp),
              style: TextStyle(
                color: message.isUser ? Colors.white70 : Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
