import 'package:flutter/material.dart';
import 'package:project_uts/game.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://i.pinimg.com/564x/c4/8a/da/c48ada5ee56d733592ca14c1483efd16.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Text(
                  'Memo Pattern adalah permainan memori di mana pemain harus mengingat urutan atau pola dari beberapa persegi yang muncul di layar untuk waktu yang singkat. Setelah itu, pemain harus menebak lokasi persegi yang benar dengan menekan persegi putih yang ditampilkan di layar.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 250),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MemoryGame()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    'Play Game',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
