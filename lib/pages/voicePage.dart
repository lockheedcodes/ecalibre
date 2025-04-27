import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:provider/provider.dart';
import 'package:ecalibre/provider/productProvider.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({Key? key}) : super(key: key);

  @override
  _VoicePageState createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';
  bool _isListening = false;
  final Map<String, double> _billItems = {};
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    bool available = await _speechToText.initialize();
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition unavailable')),
      );
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _appendBill(_lastWords);
    });
  }

  void _appendBill(String text) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final regex = RegExp(r'(\w+)\s+(\d+)');
    final matches = regex.allMatches(text.toLowerCase());

    for (final match in matches) {
      final name = match.group(1)!;
      final weight = double.tryParse(match.group(2)!) ?? 0;
      final product = productProvider.products.firstWhere(
        (p) => p.name.toLowerCase() == name,
        orElse: () => Product(id: 0, name: '', price: 0),
      );
      if (product.name != '') {
        final cost = (weight / 1000.0) * product.price;
        _billItems.update(name, (existing) => existing + cost,
            ifAbsent: () => cost);
        _totalPrice += cost;
      }
    }
  }

  Future<void> _handleMicPermissionAndListen() async {
    PermissionStatus status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    if (status.isGranted) {
      _toggleListening();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );
    }
  }

  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        await _speechToText.listen(
          onResult: _onSpeechResult,
          listenOptions: SpeechListenOptions(
            listenMode: ListenMode.dictation,
            partialResults: true,
          ),
        );
        setState(() {
          _isListening = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition unavailable')),
        );
      }
    } else {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Bill')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text('Recognized words:', style: TextStyle(fontSize: 18)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(_lastWords,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: _billItems.entries.map((e) {
                return Card(
                  color: Colors.lightBlue.shade50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text('${e.key.toUpperCase()}'),
                    subtitle: Text('₹${e.value.toStringAsFixed(2)}'),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.lightGreen.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('₹${_totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleMicPermissionAndListen,
        tooltip: 'Listen',
        backgroundColor: _isListening ? Colors.red : Colors.blue,
        child: Icon(_isListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
