import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScore extends StatefulWidget {
  const HighScore({super.key});

  @override
  _HighScoreState createState() => _HighScoreState();
}

class _HighScoreState extends State<HighScore> {
  List<List<String>> _highScores = [];

  @override
  void initState() {
    super.initState();
    _getHighScores();
  }

  // Ambil high score dari SharedPreferences
  void _getHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? scores = prefs.getStringList('high_scores'); // Ambil data dari Shared Preferences

    // Jika tidak ada data, inisialisasi dengan list kosong
    if (scores == null) {
      _highScores = [];
    } else {
      _highScores = scores.map((score) {
        final parts = score.split(','); // Misalnya: "player1,100"
        return [parts[0], parts[1]]; // Membagi menjadi nama dan skor
      }).toList();
    }

    // Pastikan hanya menyimpan 3 skor teratas
    _highScores.sort((a, b) => int.parse(b[1]).compareTo(int.parse(a[1]))); // Urutkan berdasarkan skor
    _highScores = _highScores.take(3).toList(); // Ambil 3 skor teratas

    setState(() {}); // Refresh tampilan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Scores'),
        backgroundColor: Colors.teal,
      ),
      body: _highScores.isEmpty
          ? Center(child: const Text('No High Scores available.'))
          : ListView.builder(
              itemCount: _highScores.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    leading: Image.asset(
                      'assets/ranking${index + 1}.png', // Gambar ranking sesuai dengan urutan
                      width: 50,
                      height: 50,
                    ),
                    title: Text(_highScores[index][0]), // Nama pemain
                    subtitle: Text('Score: ${_highScores[index][1]}'), // Skor
                  ),
                );
              },
            ),
    );
  }
}
