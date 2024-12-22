import 'package:flutter/material.dart';
import '../screens/home.dart';



class GetStartPage extends StatelessWidget {
  const GetStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/homebackground.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 32),
                child: Text(
                  "ស្វែងរករូបមន្តម្ហូបខ្មែរ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Koulen',
                  ),
                ),
              ),
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ចាប់ផ្តើមធ្វើម្ហូប",
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Koulen',
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "វិធីសាស្រ្តសាមញ្ញសម្រាប់ស្វែងរករូបមន្តម្ហូបខ្មែរដ៏ឆ្ងាញ់",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Koulen', 
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32, left: 32, right: 32),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "ចាប់ផ្តើមធ្វើម្ហូប",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white, 
                          fontFamily: 'Koulen',
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
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
