class User {
  // attributs

  int _id;
  String _email;
  List<String> _roles;
  String _nom;
  String _prenom;

  // constructeur

  User(this._id, this._email, this._roles, this._nom, this._prenom);

  // getters

  int getId() {
    return this._id;
  }

  String getEmail() {
    return this._email;
  }

  List<String> getRoles() {
    return this._roles;
  }

  String getNom() {
    return this._nom;
  }

  String getPrenom() {
    return this._prenom;
  }

  // setters

  void setId(int id) {
    this._id = id;
  }

  void setEmail(String email) {
    this._email = email;
  }

  void setRoles(List<String> roles) {
    this._roles = roles;
  }

  void setNom(String nom) {
    this._nom = nom;
  }

  void setPrenom(String prenom) {
    this._prenom = prenom;
  }

  // fonctions
}
