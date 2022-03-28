import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


import 'Person.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  _Detail createState() => _Detail();
}

class _Detail extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    final person = ModalRoute.of(context)!.settings.arguments as Person;

    return Scaffold(
        appBar: AppBar(title: Text("Person's detail")),
        body: Center(
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(person.image)),
                    Padding(padding: EdgeInsets.all(16.0),
                        child: Text(
                          person.firstName + person.lastName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                    )
                    ,
                    Text(person.email, style: const TextStyle(fontSize: 20)),
                    StarButton(
                      isStarred: false,
                      valueChanged: (_isStarred){

                      },

                    ),
                    ElevatedButton(onPressed: () async {
                      final Uri params = Uri(
                        scheme: 'mailto',
                        path: "'" + person.email + "'",
                      );

                      var url = params.toString();
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }
                        , child: Text('Send Email'))
                  ],
                )));
  }
}
