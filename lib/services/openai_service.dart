import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String _apiKey = dotenv.env['OPENAI_API_KEY']!;

  Future<String> generateStudy(String verseText) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };

    final prompt = """
    Analise o seguinte versículo bíblico: "$verseText"

    Por favor, forneça uma análise concisa (máximo de 500 tokens) com as seguintes seções, claramente separadas:

    1.  **Contexto Histórico:**
        *   (Descreva o cenário, o autor, a audiência original e o propósito do texto.)

    2.  **Aplicação Prática:**
        *   (Ofereça conselhos práticos e acionáveis sobre como aplicar os princípios deste versículo na vida diária hoje.)

    3.  **Referências Cruzadas:**
        *   (Liste 3-5 outros versículos que se conectam ou aprofundam o tema principal deste versículo.)
    """;

    final body = json.encode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': 'Você é um assistente teológico que fornece análises profundas e claras de versículos bíblicos.'},
        {'role': 'user', 'content': prompt},
      ],
      'max_tokens': 500,
      'temperature': 0.7,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        print('OpenAI API Error: ${response.body}');
        throw Exception('Falha ao gerar o estudo. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error calling OpenAI API: $e');
      throw Exception('Falha ao se comunicar com a API da OpenAI.');
    }
  }
}
