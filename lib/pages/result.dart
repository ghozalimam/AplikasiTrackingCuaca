import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Result extends StatefulWidget {
  final String place;

  const Result({super.key, required this.place});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  Future<Map<String, dynamic>> getDataFromAPI() async {
    final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=${widget.place}&appid=6a65f067e7ef964254347c1d3744a268&units=metric"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Hasil Tracking',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 70, right: 70),
          child: FutureBuilder(
            future: getDataFromAPI(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                final data = snapshot.data!;
                final weatherIconCode = data['weather'][0]['icon'];
                final weatherIconUrl =
                    'https://openweathermap.org/img/wn/$weatherIconCode@2x.png';
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(weatherIconUrl),
                        Text(
                          'Cuaca: ${data['weather'][0]['main']}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Suhu: ${data['main']['feels_like']} °C',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Lokasi: ${data['name']}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Negara: ${data['sys']['country']}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Image.network(
                            'https://flagsapi.com/${data["sys"]["country"]}/shiny/24.png'),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text('No Data'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
