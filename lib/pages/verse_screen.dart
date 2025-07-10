import 'package:flutter/material.dart';
import '../services/bible_service.dart';
import '../model/verse_model.dart';
import 'study_screen.dart';

class VerseScreen extends StatefulWidget {
  final String bookApiName;
  final int chapter;
  final String bookName;

  const VerseScreen({
    super.key,
    required this.bookApiName,
    required this.chapter,
    required this.bookName,
  });

  @override
  _VerseScreenState createState() => _VerseScreenState();
}

class _VerseScreenState extends State<VerseScreen> {
  final BibleService _bibleService = BibleService();
  late Future<List<Verse>> _verses;

  @override
  void initState() {
    super.initState();
    _verses = _bibleService.getVerses(widget.bookApiName, widget.chapter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bookName} ${widget.chapter}'),
      ),
      body: FutureBuilder<List<Verse>>(
        future: _verses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final verse = snapshot.data![index];
                return ListTile(
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${verse.verse} ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: verse.text),
                      ],
                    ),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudyScreen(
                          verseText: verse.text,
                          bookName: widget.bookName,
                          chapter: widget.chapter,
                          verseNumber: verse.verse,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Nenhum versículo encontrado.'));
          }
        },
      ),
    );
  }
}
