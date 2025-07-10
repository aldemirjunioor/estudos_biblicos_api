import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/bible_service.dart';
import '../model/book_model.dart';
import 'chapter_screen.dart';
import 'studies_library_screen.dart'; // Importando a nova tela

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BibleService _bibleService = BibleService();
  late Future<List<Book>> _books;

  @override
  void initState() {
    super.initState();
    _books = _bibleService.getBooks();
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  void _goToStudiesLibrary(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudiesLibraryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bíblia'),
        actions: [
          IconButton(
            onPressed: () => _goToStudiesLibrary(context),
            icon: const Icon(Icons.library_books),
            tooltip: 'Meus Estudos',
          ),
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: FutureBuilder<List<Book>>(
        future: _books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                return ListTile(
                  title: Text(book.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChapterScreen(book: book),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Nenhum livro encontrado.'));
          }
        },
      ),
    );
  }
}
