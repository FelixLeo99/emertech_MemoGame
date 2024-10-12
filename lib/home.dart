import 'package:flutter/material.dart';
import 'package:project_uts/highscore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class Home extends StatefulWidget {
  Home({super.key});
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  String _user_id = "";

  @override
  void initState() {
    super.initState();
    checkUser().then((value) {
      setState(() {
        _user_id = value;
      });
    });
  }

  Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") ?? '';
    return user_id;
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home"),
      ),
      drawer: Drawer(
        elevation: 16.0,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_user_id),
              accountEmail: Text("$_user_id@gmail.com"),
              currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
              ),
            ),
            ListTile(
              title: const Text("High Score"),
              leading: const Icon(Icons.leaderboard),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/highscore");
              },
            ),
            ListTile(
              title: const Text("LOGOUT"),
              leading: const Icon(Icons.logout),
              onTap: () {
                doLogout();
              },
            ),
          ],
        ),
      ),
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

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    setState(() {
      _user_id = ""; 
    });
    Navigator.pushReplacementNamed(context, '/login');
  }
}
