import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/fullscreen.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int page = 1;
  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              '23TIOtEDyctgNuVzly4RigtpOSKdtcjAELTWM2IU1F053JpcGyHTgLLK'
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      print(images[0]);
    });
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url = 'https://api.pexels.com/v1/curated?per_page=80&page=$page';
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '23TIOtEDyctgNuVzly4RigtpOSKdtcjAELTWM2IU1F053JpcGyHTgLLK'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
      print(images[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
            child: SizedBox(
          height: 60,
          width: double.infinity,
          child: GridView.builder(
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Fullscreen(
                            imageUrl: images[index]['src']['large2x']),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.white24,
                    child: Image.network(
                      images[index]['src']['tiny'],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
        )),
        // ignore: avoid_unnecessary_containers
        InkWell(
          onTap: () {
            loadmore();
          },
          child: Container(
            child: const Text(
              'Load More..',
              style: TextStyle(fontSize: 20, color: Colors.amber),
            ),
          ),
        )
      ]),
    );
  }
}
