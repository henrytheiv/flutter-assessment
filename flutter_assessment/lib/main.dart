
import 'package:flutter/material.dart';
import 'home.dart';
import 'Person.dart';
import 'detail.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'home',
      routes: {'home': (context) => const MyHomePage(title: 'Listing'),
        'detail': (context) => const Detail(),

    }
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




  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: const Text('Home'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Favourites'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                Home(),
                Favourite(),
              ],


            )));




  }


}


