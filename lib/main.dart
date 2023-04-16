import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      debugShowCheckedModeBanner: false,
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
  bool isLoading = true;
  List<MovieInfo> populars = [];
  List<MovieInfo> playing = [];
  List<MovieInfo> coming = [];

  void fetchData() async {
    populars = await ApiService.getMovieInfos("popular");
    playing = await ApiService.getMovieInfos("playing");
    coming = await ApiService.getMovieInfos("coming");
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (isLoading)
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    child: Image.asset("assets/images/logo.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Opacity(
                      opacity: isLoading ? 0 : 1,
                      child: const Text(
                        'Popular Movies',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  makeListViewBuilder(
                    list: populars,
                    listIndex: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Opacity(
                      opacity: isLoading ? 0 : 1,
                      child: const Text(
                        'Now in Cinemas',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  makeListViewBuilder(
                    list: playing,
                    listIndex: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Opacity(
                      opacity: isLoading ? 0 : 1,
                      child: const Text(
                        'Coming soon',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  makeListViewBuilder(
                    list: coming,
                    listIndex: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox makeListViewBuilder({
    required List<MovieInfo> list,
    required int listIndex,
  }) {
    return SizedBox(
      height: listIndex == 0 ? 400 : 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          var item = list[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: listIndex == 0 ? 400 : 160,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          id: item.id,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        width: listIndex == 0 ? 200 : 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              offset: const Offset(5, 5),
                              color: Colors.black.withOpacity(0.5),
                            )
                          ],
                        ),
                        child: Image.network(
                          listIndex == 0
                              ? ApiService.imgUrl + item.posterPath
                              : ApiService.imgUrl + (item.backdropPath ?? ''),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: listIndex == 0 ? 230 : 160,
                        child: listIndex == 0
                            ? ListTile(
                                title: Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                trailing: Container(
                                  width: 55,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      if (item.voteAverage <= 2.5)
                                        const Text('🥚'),
                                      if (item.voteAverage > 2.5 &&
                                          item.voteAverage <= 5)
                                        const Text('🐣'),
                                      if (item.voteAverage > 5 &&
                                          item.voteAverage <= 7.5)
                                        const Text('🐤'),
                                      if (item.voteAverage > 7.5)
                                        const Text('🐥'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        item.voteAverage is int
                                            ? '${item.voteAverage}.0'
                                            : '${item.voteAverage}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ListView makeMoviesInfoList({
    required AsyncSnapshot<List<MovieInfo>> snapshot,
    required int listIndex,
  }) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        var item = snapshot.data![index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  id: item.id,
                ),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                width: listIndex == 0 ? 200 : 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      offset: const Offset(5, 5),
                      color: Colors.black.withOpacity(0.5),
                    )
                  ],
                ),
                child: Image.network(
                  listIndex == 0
                      ? ApiService.imgUrl + item.posterPath
                      : ApiService.imgUrl + (item.backdropPath ?? ''),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: listIndex == 0 ? 230 : 160,
                child: listIndex == 0
                    ? ListTile(
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        trailing: Container(
                          width: 55,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (item.voteAverage <= 2.5) const Text('🥚'),
                              if (item.voteAverage > 2.5 &&
                                  item.voteAverage <= 5)
                                const Text('🐣'),
                              if (item.voteAverage > 5 &&
                                  item.voteAverage <= 7.5)
                                const Text('🐤'),
                              if (item.voteAverage > 7.5) const Text('🐥'),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                item.voteAverage is int
                                    ? '${item.voteAverage}.0'
                                    : '${item.voteAverage}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          textAlign: TextAlign.center,
                          item.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
      itemCount: snapshot.data!.length,
    );
  }
}

class DetailScreen extends StatelessWidget {
  DetailScreen({
    super.key,
    required this.id,
  });

  final int id;

  late final Future<Detail> detail = ApiService.getDetail(id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: detail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return makeDetail(snapshot, context);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Stack makeDetail(AsyncSnapshot<Detail> snapshot, BuildContext context) {
    var item = snapshot.data!;
    return Stack(
      children: [
        Image.network(
          ApiService.imgUrl + item.posterPath,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.chevronLeft,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Back to list',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 200),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              makeRating(item.voteAverage),
              const SizedBox(height: 20),
              makeRuntimeAndGenres(item.runtime, item.genres),
              const SizedBox(height: 40),
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.overview,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber,
                    ),
                    child: const Text(
                      'Buy ticket',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row makeRating(dynamic voteAverage) {
    num count = voteAverage;
    num rating = count.ceil() / 2;
    int star = rating.toInt();
    num half = rating - star;
    num notStar = (5 - rating).floor();
    return Row(
      children: [
        for (var i = 0; i < star; i++)
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 30,
          ),
        if (half > 0)
          const Icon(
            Icons.star_half,
            color: Colors.amber,
            size: 30,
          ),
        for (var i = 0; i < notStar; i++)
          Icon(
            Icons.star,
            color: Colors.white.withOpacity(0.5),
            size: 30,
          ),
      ],
    );
  }

  Row makeRuntimeAndGenres(int runtime, List<dynamic> genres) {
    int hour = runtime ~/ 60;
    int minute = runtime % 60;
    List<String> genreList = [];
    for (var element in genres) {
      genreList.add(element['name']);
    }
    String genreStr = genreList.join(', ');
    return Row(
      children: [
        Text(
          '${hour}h ${minute}min',
          style: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 12,
          ),
        ),
        Text(
          ' | ',
          style: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 12,
          ),
        ),
        Text(
          genreStr,
          style: TextStyle(
            color: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}

class MovieInfo {
  final int id;
  final String posterPath, title, releaseDate;
  final dynamic voteAverage, backdropPath;

  MovieInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        posterPath = json['poster_path'],
        backdropPath = json['backdrop_path'],
        title = json['title'],
        releaseDate = json['release_date'],
        voteAverage = json['vote_average'];
}

class Detail {
  final int runtime;
  final String posterPath, title, releaseDate, overview;
  final dynamic voteAverage;
  final List<dynamic> genres;

  Detail.fromJson(Map<String, dynamic> json)
      : runtime = json['runtime'],
        posterPath = json['poster_path'],
        title = json['title'],
        releaseDate = json['release_date'],
        overview = json['overview'],
        voteAverage = json['vote_average'],
        genres = json['genres'];
}

class ApiService {
  static const String popularUrl =
      "https://movies-api.nomadcoders.workers.dev/popular";
  static const String nowPlayingUrl =
      "https://movies-api.nomadcoders.workers.dev/now-playing";
  static const String comingSoonUrl =
      "https://movies-api.nomadcoders.workers.dev/coming-soon";
  static const String detailUrl =
      "https://movies-api.nomadcoders.workers.dev/movie";
  static const String imgUrl = "https://image.tmdb.org/t/p/w500/";

  static Future<List<MovieInfo>> getMovieInfos(String whatInfo) async {
    String findUrl;

    switch (whatInfo) {
      case "popular":
        findUrl = popularUrl;
        break;
      case "playing":
        findUrl = nowPlayingUrl;
        break;
      case "coming":
        findUrl = comingSoonUrl;
        break;
      default:
        throw Error();
    }

    List<MovieInfo> movieInfos = [];
    final url = Uri.parse(findUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> movies = jsonDecode(response.body)['results'];
      for (var movie in movies) {
        movieInfos.add(MovieInfo.fromJson(movie));
      }
      return movieInfos;
    }
    throw Error();
  }

  static Future<Detail> getDetail(int id) async {
    final url = Uri.parse('$detailUrl?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Detail.fromJson(jsonDecode(response.body));
    }
    throw Error();
  }
}
