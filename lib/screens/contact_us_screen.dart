import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  static final Uri instagramUri = Uri.parse('https://instagram.com/');
  static final Uri telegramUri = Uri.parse('https://t.me/');

  Future<void> _launch(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Зв'язатися з нами"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ми завжди поруч. Ви можете написати нам у соцмережах:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  iconSize: 32,
                  onPressed: () => _launch(instagramUri),
                  tooltip: 'Instagram',
                ),
                IconButton(
                  icon: const Icon(Icons.send_outlined),
                  iconSize: 32,
                  onPressed: () => _launch(telegramUri),
                  tooltip: 'Telegram',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}