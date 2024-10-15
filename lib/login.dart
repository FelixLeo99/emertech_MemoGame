import 'package:flutter/material.dart';
import 'package:project_uts/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  String _user_id = "";  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        height: 300,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1),
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 5)]),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter valid email id as abc@gmail.com'),
              onChanged: (v) {
                setState(() {
                  _user_id = v;  // Perbarui nilai _user_id saat teks berubah
                });
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter secure password'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () {
                  doLogin();  
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
  void doLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", _user_id);  
    main();
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => MyApp()), 
    //   (route) => false
    // );
  }
}
