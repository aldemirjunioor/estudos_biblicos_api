import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StudyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> studyData;

  const StudyDetailScreen({super.key, required this.studyData});

  String? _extractUrl(String text) {
    final urlRegExp = RegExp(r'https?:\/\/[^\s\(\)]+');
    final match = urlRegExp.firstMatch(text);
    return match?.group(0);
  }

  @override
  Widget build(BuildContext context) {
    final String studyText = studyData['studyText'];
    final String verse = studyData['verse'];
    final String? url = _extractUrl(studyText);

    return Scaffold(
      appBar: AppBar(
        title: Text('Estudo de $verse'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(studyText, style: const TextStyle(fontSize: 16, height: 1.6)),
            const SizedBox(height: 20),
            if (url != null)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(url: url),
                      ),
                    );
                  },
                  child: const Text('Abrir Link de Referência'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class WebViewScreen extends StatelessWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Link de Referência'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
