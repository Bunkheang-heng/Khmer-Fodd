import 'package:flutter/material.dart';

class AboutDeveloperPage extends StatelessWidget {
  const AboutDeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'អំពីអ្នកអភិវឌ្ឍន៍',
          style: TextStyle(
            fontFamily: 'Chenla',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ស្វែងយល់ពីអ្នកអភិវឌ្ឍន៍',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Chenla',
                    color: Colors.green[700],
                  ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.withOpacity(0.05),
                      Colors.white,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage('assets/Developer.png'),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: Colors.green,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade400,
                                Colors.green.shade700,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.9),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              'ហេង ប៊ុនឃាង',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Chenla',
                                fontSize: 28,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          '( HENG Bunkheang )',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'និស្សិតឆ្នាំទី២ ផ្នែកវិទ្យាសាស្ត្រកុំព្យូទ័រ',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.green[700],
                              fontFamily: 'Chenla',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInfoSection(
                        icon: Icons.school,
                        title: 'ការសិក្សា',
                        content:
                            'សាកលវិទ្យាល័យអាមេរិកាំងភ្នំពេញ (AUPP)\nផ្នែកវិទ្យាសាស្ត្រកុំព្យូទ័រ\nឆ្នាំទី២',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoSection(
                        icon: Icons.work,
                        title: 'បទពិសោធន៍',
                        content:
                            'អ្នកអភិវឌ្ឍន៍កម្មវិធីទូរស័ព្ទ\nអ្នកអភិវឌ្ឍន៍គេហទំព័រ\nអ្នករចនាក្រាហ្វិក',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoSection(
                        icon: Icons.code,
                        title: 'ជំនាញ',
                        content:
                            'Flutter & Dart\nPython\nJavaScript\nHTML & CSS\nFigma',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoSection(
                        icon: Icons.contact_mail,
                        title: 'ទំនាក់ទំនង',
                        content:
                            'អ៊ីមែល: bunkheangheng99@gmail.com\nទូរស័ព្ទ: 0973556059\nTelegram: @bunkheangheng',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green[700]),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Chenla',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontFamily: 'Chenla',
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
