import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/openai_service.dart';

class StudyScreen extends StatefulWidget {
  final String verseText;
  final String bookName;
  final int chapter;
  final int verseNumber;

  const StudyScreen({
    super.key,
    required this.verseText,
    required this.bookName,
    required this.chapter,
    required this.verseNumber,
  });

  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final OpenAIService _openAIService = OpenAIService();
  Future<String>? _studyFuture;
  String? _studyContent;

  @override
  void initState() {
    super.initState();
    _studyFuture = _openAIService.generateStudy(widget.verseText);
  }

  void _saveStudy() async {
    if (_studyContent == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final verseRef = '${widget.bookName} ${widget.chapter}:${widget.verseNumber}';

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('studies')
        .add({
      'verse': verseRef,
      'studyText': _studyContent,
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Estudo salvo com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bookName} ${widget.chapter}:${widget.verseNumber}'),
      ),
      body: FutureBuilder<String>(
        future: _studyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao gerar estudo: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            _studyContent = snapshot.data;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estudo sobre "${widget.verseText}"',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _studyContent!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _saveStudy,
                          child: const Text('Salvar Estudo'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('Não foi possível gerar o estudo.'));
          }
        },
      ),
    );
  }
}
