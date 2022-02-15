import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:user_response/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Model model = Model();
  List<UserResponse>? list = [];

  bool? isEmpty = true;
  Future getDataFromApi() async {
    final Uri uri = Uri.parse("https://jsonplaceholder.typicode.com/users");
    final url = await http.get(uri);
    model = Model.fromJson(jsonDecode(url.body));
    setState(() {
      list = model.results;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 24, 24),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: list == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: list!.length,
                itemBuilder: (context, i) {
                  final k = list![i];
                  print(k.email.toString());
                  return Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                        child: isEmpty!
                            ? Text(
                                '${k.name!.substring(0, 1).toUpperCase()}${k.surename!.substring(0, 1).toUpperCase()}',
                                style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue),
                              )
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Text(k.id!.toString()),
                      const SizedBox(height: 10),
                      Text(k.name!.toString() + k.surename!.toString()),
                      const SizedBox(height: 10),
                      Text(k.email!),
                      const SizedBox(height: 10),
                      Text(k.address!.city!),
                      const SizedBox(height: 10),
                      Text(k.phone!),
                      const SizedBox(height: 10),
                      Text(k.website!),
                      const SizedBox(height: 10),
                      Text(k.company!.toString()),
                    ],
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.update),
          onPressed: () {
            getDataFromApi();
          }),
    );
  }
}
