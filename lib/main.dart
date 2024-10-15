import 'package:flutter/material.dart';
import 'package:project_uts/game.dart';
import 'package:project_uts/highscore.dart';
import 'package:project_uts/home.dart';
import 'package:project_uts/login.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });

}
String active_user = "";

Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") ?? '';
    return user_id;
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'game': (context) => MemoryGame(),
        'highscore': (context) =>const HighScore(),
        },
      title: 'Website Hangker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hello World'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _currentIndex = 0;
  final List<Widget> _screens = [Home()];
  final List<String> _title = ['Home'];

  String _user_id = "";

@override
  void initState() {
    super.initState();
    checkUser().then((value) => setState(
          () {
            _user_id = value;
          },
        ));
  }
void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("user_id");
  main();
}
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_title[_currentIndex]),
      ),
      drawer:  Drawer(
        elevation: 16.0,
        child: Column(
          children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Welcome !"),
                accountEmail: Text(_user_id),
                currentAccountPicture: CircleAvatar(
                    backgroundImage:
                        NetworkImage("https://i.pravatar.cc/150"))),
              ListTile(
              title: const Text("High Score"),
              leading: const Icon(Icons.leaderboard),
              onTap: () {
                	Navigator.pushNamed(context, "highscore");
              }),
              ListTile(
              title: const Text("LOGOUT"),
              leading: const Icon(Icons.logout),
              onTap: () {
                	doLogout();
              }),
          ],
        ),
      ),
      body: _screens[_currentIndex],
    );
  }
}

