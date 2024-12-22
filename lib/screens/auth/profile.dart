import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  bool _isEditingName = false;

  Future<void> _updateName(String newName) async {
    if (newName.trim().isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({
        'name': newName,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ឈ្មោះត្រូវបានកែប្រែដោយជោគជ័យ'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        _isEditingName = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('មានបញ្ហាក្នងការកែប្រែឈមោះ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade800,
            Colors.green.shade500,
            Colors.green.shade300,
            Colors.white,
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            },
          ),
          title: const Text(
            'ទម្រង់',
            style: TextStyle(
              fontFamily: 'Chenla',
              fontSize: 32,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'ម��នបញ្ហាកើតឡើង',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.red[700],
                            fontFamily: 'Chenla',
                          ),
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                );
              }

              final userData = snapshot.data?.data() as Map<String, dynamic>?;
              final name = userData?['name'] as String? ?? 'មិនមាន';

              _nameController.text = name;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 120),
                    // Profile Image Section
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade400,
                                Colors.green.shade600,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.4),
                                spreadRadius: 4,
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 5),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/image.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Colors.white.withOpacity(0.9),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Info Card
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ColorFilter.mode(
                            Colors.white.withOpacity(0.8),
                            BlendMode.srcOver,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildEditableNameSection(),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Divider(thickness: 1),
                                ),
                                _buildInfoSection(
                                  context,
                                  'អ៊ីមែល',
                                  user?.email ?? 'មិនបានចូលគណនី',
                                  Icons.email_rounded,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Logout Button
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.shade400,
                            Colors.red.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          }
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          size: 28,
                        ),
                        label: const Text(
                          'ចាកចេញ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Chenla',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEditableNameSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.person_rounded,
              color: Colors.green.shade700,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _isEditingName
                ? TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'បញ្ចូលឈ្មោះរបស់អ្នក',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Chenla',
                    ),
                    autofocus: true,
                  )
                : Text(
                    _nameController.text,
                    style: const TextStyle(
                      fontFamily: 'Chenla',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              _isEditingName ? Icons.check_circle : Icons.edit,
              size: 28,
            ),
            color: _isEditingName ? Colors.green : Colors.blue,
            onPressed: () {
              if (_isEditingName) {
                _updateName(_nameController.text);
              } else {
                setState(() {
                  _isEditingName = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
      BuildContext context, String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: Colors.green.shade700,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Chenla',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Chenla',
                    color: Colors.green.shade900,
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
