import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Movieflix(),
    );
  }
}

class Movieflix extends StatelessWidget {
  const Movieflix({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}

class ApiService {
  final String popular = "https://movies-api.nomadcoders.workers.dev/popular";
  final String nowPlaying =
      "https://movies-api.nomadcoders.workers.dev/now-playing";
  final String comingSoon =
      "https://movies-api.nomadcoders.workers.dev/coming-soon";
  final String detail = "https://movies-api.nomadcoders.workers.dev/movie";
  final String img = "https://image.tmdb.org/t/p/w500/";

  void getPopular() async {
    final url = Uri.parse(popular);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return;
    }
    throw Error();
  }

  void getNowPlaying() async {
    final url = Uri.parse(nowPlaying);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return;
    }
    throw Error();
  }

  void getComingSoon() async {
    final url = Uri.parse(comingSoon);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return;
    }
    throw Error();
  }

  void getDetail(int id) async {
    final url = Uri.parse('$detail?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return;
    }
    throw Error();
  }
}
