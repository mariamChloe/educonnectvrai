import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/listclasse.dart';

class ListeClasseScreen extends StatefulWidget {
  @override
  _ListeClasseScreenState createState() => _ListeClasseScreenState();
}

class _ListeClasseScreenState extends State<ListeClasseScreen> {
  List<Map<String, dynamic>> eleves = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<listeClasse>> fetchEleves() async {

      final classeUri = 'http://localhost:3000/listeClasse';
      print('Fetching data from: $classeUri');
      final response = await http.get(Uri.parse(classeUri));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonReponse = json.decode(response.body);
              if(jsonReponse["length"] != null ){
                List<dynamic > data = jsonReponse["data"];
                return data.map((e) => listeClasse.fromJson(e)).toList();
              }
            else {
              print('Erreur lors de la récupération des élèves. Statut ${response.statusCode}');
              print('Response body: ${response.body}');
              return [];
              }
         }else {
        print('Erreur lors de la récupération des élèves:');
        throw Exception('Failed to load Commande from API');
       }
  }

  Widget buildStudentRow(double width, String? nom, String? presence, String? matiere) {
  nom = nom ?? ''; // Provide a default value or handle null
  presence = presence ?? '';
  matiere = matiere ?? '';


    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/eleve.jpeg'),
              radius: 20,
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nom,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                'Présence: $presence, Matière: $matiere',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
      width: width,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(236, 237, 255, 1),
      body: SafeArea(
        child: Container(
          height: height,
          padding: EdgeInsets.all(10.0),
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.supervised_user_circle_outlined,
                          size: 35, color: Color.fromRGBO(236, 237, 255, 1)),
                    ),
                    Text("Tle D1",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(46, 49, 146, 1))),
                    Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(217, 14, 27, 1),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Text(
                          "Salle A3",
                          style: TextStyle(color: Colors.white),
                        )),
                    Container(
                      alignment: Alignment.center,
                      height: 60,
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(67, 180, 253, 1),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "9H15",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                WidgetSpan(
                                  child: Icon(
                                    Icons.schedule_outlined,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                width: width,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),

              Container(
                 height: 800,
                child: FutureBuilder<List<listeClasse>>(
            future: fetchEleves(),
            builder: (context, snapshot) {
              if(snapshot.hasData ) {
                print("length");
              List<listeClasse>? datas = snapshot.data;
                return ListView.builder(
                scrollDirection: Axis.vertical,  // Ajoutez cette ligne
                  itemCount: datas!.length,
                  itemBuilder:(context,index) {
                      return buildStudentRow(
                      width,
                      datas[index].nom ?? '',
                       datas[index].presence ?? '',
                       datas[index].matiere ?? '',

                    );
                  }
                );
        }else {
      // Return a loading indicator or another widget for different states
      return CircularProgressIndicator();
    }
      }
    )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
