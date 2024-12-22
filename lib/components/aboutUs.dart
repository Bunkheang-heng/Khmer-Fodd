import 'package:flutter/material.dart';
import 'AboutDeveloper.dart';

const mainGreen = Color(0xFF2E7D32); // Dark green color

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainGreen,
        title: const Text(
          'អំពីពួកយើង',
          style: TextStyle(
            fontFamily: 'Fasthand',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              mainGreen.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/image.png',
                      height: 120,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: mainGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'គោលបំណង',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontFamily: 'Koulen',
                          fontWeight: FontWeight.bold,
                          color: mainGreen,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'កម្មវិធីនេះត្រូវបានបង្កើតឡើងដើម្បីជួយអ្នកស្រលាញ់ការធ្វើម្ហូប និងចង់រៀនធ្វើម្ហូបខ្មែរ។ យើងមានគោលបំណងក្នុងការថែរក្សា និងផ្សព្វផ្សាយវប្បធម៌ម្ហូបអាហារខ្មែរដល់មនុស្សជំនាន់ក្រោយ។',
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'Chenla', height: 1.5),
                ),
                const SizedBox(height: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: mainGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'មុខងារសំខាន់ៗ',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontFamily: 'Koulen',
                          fontWeight: FontWeight.bold,
                          color: mainGreen,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                const FeatureItem(
                  icon: Icons.restaurant_menu,
                  title: 'មុខម្ហូបច្រើនប្រភេទ',
                  description:
                      'មានមុខម្ហូបខ្មែរជាច្រើនប្រភេទ ដែលមានរូបភាព និងវិធីធ្វើច្បាស់លាស់',
                ),
                const FeatureItem(
                  icon: Icons.smart_toy,
                  title: 'AI ជំនួយការ',
                  description:
                      'អាចសួរសំណួរផ្សេងៗអំពីការធ្វើម្ហូប ហើយ AI នឹងជួយឆ្លើយតប',
                ),
                const FeatureItem(
                  icon: Icons.search,
                  title: 'ងាយស្រួលស្វែងរក',
                  description: 'អាចស្វែងរកមុខម្ហូបដែលចង់ធ្វើបានយ៉ាងងាយស្រួល',
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutDeveloperPage()),
                      );
                    },
                    icon: const Icon(Icons.person, color: Colors.white),
                    label: const Text(
                      'អំពីអ្នកអភិវឌ្ឍន៍',
                      style: TextStyle(
                        fontFamily: 'Koulen',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainGreen,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      elevation: 4,
                      shadowColor: mainGreen.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: mainGreen.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: mainGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: mainGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Fasthand',
                    color: mainGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Koulen',
                    color: Colors.black87,
                    height: 1.4,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
