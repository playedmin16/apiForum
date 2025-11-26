class Message {
  // attributs

  int _idMessage;
  int _idUser;
  int? _idMessageParent;
  String _titre;
  DateTime _datePost;
  String _contenu;

  // constructeur

  Message(
    this._idMessage,
    this._idUser,
    this._idMessageParent,
    this._datePost,
    this._titre,
    this._contenu,
  );

  // getters

  int getIdMessage() {
    return this._idMessage;
  }

  int getIdUser() {
    return this._idUser;
  }

  int? getIdMessageParent() {
    return this._idMessageParent;
  }

  DateTime getDatePost() {
    return this._datePost;
  }

  String getTitre() {
    return this._titre;
  }

  String getContenu() {
    return this._contenu;
  }

  // setters

  void setIdMessage(int idMessage) {
    this._idMessage = idMessage;
  }

  void setIdUser(int idUser) {
    this._idUser = idUser;
  }

  void setIdMessageParent(int idMessageParent) {
    this._idMessageParent = idMessageParent;
  }

  void setDatePost(DateTime date) {
    this._datePost = date;
  }

  void setTitre(String titre) {
    this._titre = titre;
  }

  void setContenu(String contenu) {
    this._contenu = contenu;
  }

  // fonctions
}
