import 'package:flutter/material.dart';
import 'model/tourism_place.dart';

var iniFontCustom = const TextStyle(fontFamily: 'Oswald');

class DetailScreen extends StatelessWidget {
    final TourismPlace place;
    const DetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(place.imageAsset),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: IconButton(icon: const Icon(Icons.arrow_back),
                  color:Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: const Text(
                'Ranca Upas',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30.0, fontFamily: 'Oswald'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: [
                      Column(
                        children: <Widget>[
                          Icon(Icons.calendar_today),
                          Text(place.openDays, style: iniFontCustom),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: <Widget>[
                          Icon(Icons.access_time),
                          Text(place.openTime, style: iniFontCustom),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: <Widget>[
                          Icon(Icons.monetization_on),
                          Text(place.ticketPrice, style: iniFontCustom),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                place.description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 84, 1, 133),
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: place.imageUrls.map((url) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(url, fit: BoxFit.cover),),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
