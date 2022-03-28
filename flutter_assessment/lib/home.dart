import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Person.dart';

late List<Person> favourites = [];


//Sync data from API

Future<List<Person>> fetchPerson() async {
  final response =
      await http.get(Uri.parse('https://reqres.in/api/users?page=1'));

  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> jsonResponse = map["data"];
    return jsonResponse.map((data) => Person.fromJson(data)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load');
  }
}


//Delete data
deletePerson(String name) async {
  final response = await http.post(Uri.parse('https://reqres.in/api/users/2'),
      body: {'first_name': name});

  if (response.statusCode == 200) {
    print("Returned message: " + response.body.toString());
  } else {
    throw Exception('Unexpected error occurred!');
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _home createState() => _home();
}

class _home extends State<Home> {
  late Future<List<Person>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FutureBuilder<List<Person>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Person>? data = snapshot.data;

                  return ListView.builder(
                      itemCount: data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = data![index];
                        final name = data[index].firstName;

                        return Dismissible(
                            key: Key(name),
                            background: swipeToDelete(),
                            onDismissed: (direction) {
                                  data.removeAt(index);
                            },
                            child: PersonCard(
                                image: item.image,
                                firstName: item.firstName,
                                lastName: item.lastName,
                                email: item.email));
                      });
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }


  Widget swipeToEdit() => Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.green,
      child: Icon(Icons.edit, color: Colors.white, size: 25));

  Widget swipeToDelete() => Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: Icon(Icons.delete, color: Colors.white, size: 25));
}

// A card view that displays the information of a person

class PersonCard extends StatelessWidget {
  const PersonCard(
      {Key? key,
      required this.image,
      required this.firstName,
      required this.lastName,
      required this.email})
      : super(key: key);

  final String image;
  final String firstName;
  final String lastName;
  final String email;

  @override
  Widget build(BuildContext context) {

    Person p = Person(image, firstName, lastName, email);

    return Container(
      padding: const EdgeInsets.all(2),
      height: 110,
      child: Card(
          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'detail',
                    arguments: p);
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(image)),
                                        Column(
                                          children: [
                                            Text(firstName + " " + lastName,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            // Text(this.description),
                                            Text(email),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            StarButton(
                                              isStarred: false,
                                              valueChanged: (_isStarred){

                                                favourites.add(p);

                                              },


                                            )
                                          ],
                                        )
                                      ])
                                ])))
                  ]))),
    );
  }
}

// Favourites page

class Favourite extends StatefulWidget{
  const Favourite({Key? key}) : super(key: key);


  @override
  _favourite createState() => _favourite();

}

class _favourite extends State<Favourite>{



  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: favourites.length,
        itemBuilder: (BuildContext context, int index) {
          final item = favourites[index];
          final name = favourites[index].firstName;

          return PersonCard(
                  image: item.image,
                  firstName: item.firstName,
                  lastName: item.lastName,
                  email: item.email);
        });



  }


}
