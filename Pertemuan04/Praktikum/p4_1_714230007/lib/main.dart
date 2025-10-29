import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempat Wisata Bandung',
      theme: ThemeData(),
      home: const DetailScreen(),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin : const EdgeInsets.only(top: 16.0),
            child: const Text('Ranca Upas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,)
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
                  children: const <Widget>[
                    Icon( Icons.calendar_today),
                    Text('Open Everyday'),
                  ]),
                ],
              ),
                Row(
                  children: [
                  Column(
                  children: const <Widget>[
                    Icon( Icons.access_time),
                    Text('09:00 - 20:00'),
                  ]),
                ],
              ),
                Row(
                  children: [
                  Column(
                  children: const <Widget>[
                    Icon( Icons.monetization_on),
                    Text('Rp 20.000'),
                  ]),
                ],
              ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Ranca Upas merupakan sebuah tempat wisata alam yang terletak di daerah Ciwidey, Bandung, Jawa Barat. Tempat ini terkenal dengan pemandian air panas alami yang berasal dari mata air panas bawah tanah. Selain itu, Ranca Upas juga menawarkan berbagai aktivitas menarik seperti berkemah, bersepeda, dan berinteraksi dengan rusa-rusa yang berkeliaran bebas di area tersebut. Tempat ini sangat cocok untuk dikunjungi oleh keluarga dan pecinta alam yang ingin menikmati suasana pegunungan yang sejuk dan asri.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),) 
    );
  }
}