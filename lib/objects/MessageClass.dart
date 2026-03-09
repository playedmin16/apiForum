class Message {
  final int id;
  final String title;
  final String content;
  final DateTime postedAt;
  final String userLastName;
  final String userFirstName;
  final int? parentId;

  Message({
    required this.id,
    required this.title,
    required this.content,
    required this.postedAt,
    required this.userLastName,
    required this.userFirstName,
    this.parentId,
  });

  // Méthode usine (factory) permettant de créer un Message
  // à partir d’une structure JSON reçue depuis l’API
  factory Message.fromJson(Map<String, dynamic> json) {
    // Récupère l’objet "user" dans le JSON, ou un objet vide si absent
    final user = json['user'] ?? {};
    return Message(
      id: json['id'] ?? 0,
      title: json['titre'] ?? '',
      content: json['contenu'] ?? '',
      postedAt: DateTime.parse(json['datePoste']),
      userLastName: user['nom'] ?? '',
      userFirstName: user['prenom'] ?? '',

      parentId: json['parent'] != null
          ? json['parent'] is String
                ? int.parse(json['parent'].split('/').last)
                : int.parse(
                    (json['parent'] as Map<String, dynamic>)['@id']
                        .split('/')
                        .last,
                  )
          : null,

      /*
      
      équivalent :

      if (parentId.json['parent] != null) {
        int.parse(json['parent']['@id'].split('/').last); -> Split sépares par le caractère spécifié et .last prend le dernier.
                                                             On récup donc l'id
      } else {
        null;
      }
      
      */
    );
  }
}
