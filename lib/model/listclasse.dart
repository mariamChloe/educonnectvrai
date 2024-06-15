class listeClasse{

  String? id;
  String? date;
  String? heure; //heure de cours
  String? matiere;
  String? presence;
  String? nom;


  listeClasse({this.id, this.date, this.heure, this.matiere, this.presence,this.nom});

  factory listeClasse.fromJson(Map<String, dynamic> json)
  =>  listeClasse(
    id: json['_id'],
    date: json['Date'],
    heure: json['Heure de cours'],
    matiere: json['Matiere'],
    presence: json['Presence'],
    nom: json['Nom'],
  );
}
