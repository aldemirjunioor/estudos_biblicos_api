import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/book_model.dart';
import '../model/verse_model.dart';

class BibleService {
  // Usando um proxy para contornar a restrição de segurança (CORS) do navegador.
  // Esta é a solução definitiva para fazer a bible-api.com funcionar.
  final String proxyAuthority = 'api.allorigins.win';
  final String bibleApiUrl = 'https://bible-api.com/';

  Future<List<Book>> getBooks() async {
    return Future.value(_hardcodedBooks);
  }

  Future<List<Verse>> getVerses(String bookApiName, int chapter) async {
    // Construindo a URL final que será enviada através do proxy.
    final targetUrl = '$bibleApiUrl$bookApiName $chapter';
    final proxyUri = Uri.https(proxyAuthority, '/raw', {'url': targetUrl});

    final response = await http.get(proxyUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> versesData = data['verses'];
      return versesData.map((json) => Verse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load verses for $bookApiName $chapter. Status code: ${response.statusCode}');
    }
  }

  final List<Book> _hardcodedBooks = [
    Book(name: "Gênesis", apiName: "Genesis", chapters: 50),
    Book(name: "Êxodo", apiName: "Exodus", chapters: 40),
    Book(name: "Levítico", apiName: "Leviticus", chapters: 27),
    Book(name: "Números", apiName: "Numbers", chapters: 36),
    Book(name: "Deuteronômio", apiName: "Deuteronomy", chapters: 34),
    Book(name: "Josué", apiName: "Joshua", chapters: 24),
    Book(name: "Juízes", apiName: "Judges", chapters: 21),
    Book(name: "Rute", apiName: "Ruth", chapters: 4),
    Book(name: "1º Samuel", apiName: "1 Samuel", chapters: 31),
    Book(name: "2º Samuel", apiName: "2 Samuel", chapters: 24),
    Book(name: "1º Reis", apiName: "1 Kings", chapters: 22),
    Book(name: "2º Reis", apiName: "2 Kings", chapters: 25),
    Book(name: "1º Crônicas", apiName: "1 Chronicles", chapters: 29),
    Book(name: "2º Crônicas", apiName: "2 Chronicles", chapters: 36),
    Book(name: "Esdras", apiName: "Ezra", chapters: 10),
    Book(name: "Neemias", apiName: "Nehemiah", chapters: 13),
    Book(name: "Ester", apiName: "Esther", chapters: 10),
    Book(name: "Jó", apiName: "Job", chapters: 42),
    Book(name: "Salmos", apiName: "Psalm", chapters: 150),
    Book(name: "Provérbios", apiName: "Proverbs", chapters: 31),
    Book(name: "Eclesiastes", apiName: "Ecclesiastes", chapters: 12),
    Book(name: "Cânticos", apiName: "Song of Solomon", chapters: 8),
    Book(name: "Isaías", apiName: "Isaiah", chapters: 66),
    Book(name: "Jeremias", apiName: "Jeremiah", chapters: 52),
    Book(name: "Lamentações", apiName: "Lamentations", chapters: 5),
    Book(name: "Ezequiel", apiName: "Ezekiel", chapters: 48),
    Book(name: "Daniel", apiName: "Daniel", chapters: 12),
    Book(name: "Oséias", apiName: "Hosea", chapters: 14),
    Book(name: "Joel", apiName: "Joel", chapters: 3),
    Book(name: "Amós", apiName: "Amos", chapters: 9),
    Book(name: "Obadias", apiName: "Obadiah", chapters: 1),
    Book(name: "Jonas", apiName: "Jonah", chapters: 4),
    Book(name: "Miquéias", apiName: "Micah", chapters: 7),
    Book(name: "Naum", apiName: "Nahum", chapters: 3),
    Book(name: "Habacuque", apiName: "Habakkuk", chapters: 3),
    Book(name: "Sofonias", apiName: "Zephaniah", chapters: 3),
    Book(name: "Ageu", apiName: "Haggai", chapters: 2),
    Book(name: "Zacarias", apiName: "Zechariah", chapters: 14),
    Book(name: "Malaquias", apiName: "Malachi", chapters: 4),
    Book(name: "Mateus", apiName: "Matthew", chapters: 28),
    Book(name: "Marcos", apiName: "Mark", chapters: 16),
    Book(name: "Lucas", apiName: "Luke", chapters: 24),
    Book(name: "João", apiName: "John", chapters: 21),
    Book(name: "Atos", apiName: "Acts", chapters: 28),
    Book(name: "Romanos", apiName: "Romans", chapters: 16),
    Book(name: "1ª Coríntios", apiName: "1 Corinthians", chapters: 16),
    Book(name: "2ª Coríntios", apiName: "2 Corinthians", chapters: 13),
    Book(name: "Gálatas", apiName: "Galatians", chapters: 6),
    Book(name: "Efésios", apiName: "Ephesians", chapters: 6),
    Book(name: "Filipenses", apiName: "Philippians", chapters: 4),
    Book(name: "Colossenses", apiName: "Colossians", chapters: 4),
    Book(name: "1ª Tessalonicenses", apiName: "1 Thessalonians", chapters: 5),
    Book(name: "2ª Tessalonicenses", apiName: "2 Thessalonians", chapters: 3),
    Book(name: "1ª Timóteo", apiName: "1 Timothy", chapters: 6),
    Book(name: "2ª Timóteo", apiName: "2 Timothy", chapters: 4),
    Book(name: "Tito", apiName: "Titus", chapters: 3),
    Book(name: "Filemom", apiName: "Philemon", chapters: 1),
    Book(name: "Hebreus", apiName: "Hebrews", chapters: 13),
    Book(name: "Tiago", apiName: "James", chapters: 5),
    Book(name: "1ª Pedro", apiName: "1 Peter", chapters: 5),
    Book(name: "2ª Pedro", apiName: "2 Peter", chapters: 3),
    Book(name: "1ª João", apiName: "1 John", chapters: 5),
    Book(name: "2ª João", apiName: "2 John", chapters: 1),
    Book(name: "3ª João", apiName: "3 John", chapters: 1),
    Book(name: "Judas", apiName: "Jude", chapters: 1),
    Book(name: "Apocalipse", apiName: "Revelation", chapters: 22)
  ];
}
