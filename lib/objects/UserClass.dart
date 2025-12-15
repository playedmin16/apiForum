class User {
  // attributs

  final int id;
  final String email;
  final List<String> roles;
  final String nom;
  final String prenom;

  // constructeur

  User({
    required this.id,
    required this.email,
    required this.roles,
    required this.nom,
    required this.prenom,
  });

  // getters

  int getId() {
    return this.id;
  }

  String getEmail() {
    return this.email;
  }

  List<String> getRoles() {
    return this.roles;
  }

  String getNom() {
    return this.nom;
  }

  String getPrenom() {
    return this.prenom;
  }

  // fonctions

  // Méthode usine (factory) permettant de créer un User
  // à partir d’une structure JSON reçue depuis l’API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? 'emal',
      roles: (json['roles'] as List<dynamic>? ?? ["user"]).cast<String>(),
      nom: json['nom'] ?? 'nom',
      prenom: json['prenom'] ?? 'prenom',
    );
  }

  String afficheRoles() {
    String str = "";
    for (String unRole in this.roles) {
      str = str + unRole + " ";
    }
    return str;
  }
}
