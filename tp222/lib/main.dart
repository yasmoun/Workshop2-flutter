import 'package:flutter/material.dart';
import 'package:number_to_word_arabic/number_to_word_arabic.dart';
import 'package:number_to_words_english/number_to_words_english.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Convertisseur de Nombre',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Convertisseur de Nombre'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _resultText = '';
  String _inputNumber = ''; // Variable pour afficher le nombre entré

  void _convertToArabic() {
    String input = _controller.text.trim();
    if (input.isNotEmpty) {
      double? number = _parseAndFormatNumber(input);
      if (number != null) {
        List<String> parts = number.toStringAsFixed(3).split('.');
        String dinars = Tafqeet.convert(parts[0]);
        String millimes = Tafqeet.convert(parts[1]);

        setState(() {
          _resultText = '$dinars دينار و $millimes مليم';
          _inputNumber = input; // Afficher le nombre saisi
          _controller.clear(); // Vider le champ après conversion
        });
      } else {
        setState(() {
          _resultText = 'Veuillez entrer un nombre valide';
        });
      }
    } else {
      setState(() {
        _resultText = 'Veuillez entrer un nombre';
      });
    }
  }

  void _convertToEnglish() {
    String input = _controller.text.trim();
    if (input.isNotEmpty) {
      double? number = _parseAndFormatNumber(input);
      if (number != null) {
        List<String> parts = number.toStringAsFixed(3).split('.');
        String integerPart = NumberToWordsEnglish.convert(int.parse(parts[0]));
        String decimalPart = NumberToWordsEnglish.convert(int.parse(parts[1]));

        setState(() {
          _resultText = '$integerPart dinars and $decimalPart millimes';
          _inputNumber = input; // Afficher le nombre saisi
          _controller.clear(); // Vider le champ après conversion
        });
      } else {
        setState(() {
          _resultText = 'Please enter a valid number';
        });
      }
    } else {
      setState(() {
        _resultText = 'Please enter a number';
      });
    }
  }

  double? _parseAndFormatNumber(String input) {
    // Remplacer la virgule par un point pour le traitement
    input = input.replaceAll(',', '.');

    // Essayer de convertir en double
    double? number = double.tryParse(input);
    if (number != null) {
      // Arrondir à trois chiffres après la virgule
      String formatted = number.toStringAsFixed(3);
      return double.tryParse(formatted);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Champ de texte pour la saisie
            TextField(
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Entrez un nombre ',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Champ affichant le nombre entré
            Text(
              _inputNumber.isEmpty ? '' : 'Nombre entré : $_inputNumber',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _convertToArabic,
                  child: Text('Convertir en Arabe'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // Couleur jaune
                  ),
                ),
                SizedBox(height: 16), // Espacement entre les boutons
                ElevatedButton(
                  onPressed: _convertToEnglish,
                  child: Text('Convertir en Anglais'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Couleur violette
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              _resultText.isEmpty ? '' : _resultText,
              style: TextStyle(fontSize: 24),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
