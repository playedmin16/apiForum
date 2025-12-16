import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../objects/UserClass.dart';

class UserApi {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  Future<List<User>> fetchUsers() async {
    final url = "$baseUrl/users";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> members = data['member'] ?? [];
      return members.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Erreur HTTP ${response.statusCode}');
    }
  }

  /*

  / Récupère l'URL de base depuis le fichier .env.local
  / Le "!" signifie que la valeur ne peut pas être nulle.
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  / Méthode asynchrone qui renvoie une liste d'objets UserModel
  Future<List<UserModel>> fetchUsers() async {

  / Construit l'URL complète vers l'endpoint (la route) /Users
  final url = "$baseUrl/Users";

  / Envoie une requête HTTP GET vers l'API et attend la réponse
  final response = await http.get(Uri.parse(url));

  / Vérifie si la réponse HTTP est correcte (code 200)
  if (response.statusCode == 200) {

  / Convertit le JSON brut (string) en Map (objet clé/valeur)
  final Map<String, dynamic> data = json.decode(response.body);

  / Récupère le tableau de Users dans la clé "member"
  / Si "member" n’existe pas, retourne une liste vide
  final List<dynamic> members = data['member'] ?? [];

  / Transforme chaque élément JSON en un objet UserModel
  / puis renvoie la liste complète
  return members.map((item) => UserModel.fromJson(item)).toList();

  */

  Future<int> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final String baseUrl = dotenv.env['API_BASE_URL']!;
    final uri = Uri.parse("$baseUrl/users");
    final headers = {
      'Content-Type': 'application/ld+json',
      'Accept': 'application/ld+json',
    };
    final body = json.encode({
      'prenom': firstName,
      'nom': lastName,
      'email': email,
      'password': password,
    });
    try {
      final response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode == 201) {
        return 201;
      } else {
        print("Échec : ${response.statusCode}\nRéponse : ${response.body}");
        return response.statusCode;
      }
    } catch (e) {
      print("Exception lors de la requête : $e");
      return 0;
    }
  }
}

/*

Cette fonction retourne un Future<int> indiquant que le résultat sera disponible dans le futur, et il
s'agira d'un entier.

/ Configuration de la requête HTTP :

var headers = {'Content-Type': 'application/ld+json'}; // Définition des entêtes de la requête HTTP,
spécifiant que le contenu sera du JSON.
var body = json.encode({...}); // Encodage des données de l'utilisateur en format JSON. Les
données incluent le prénom, le nom, l'email, le mot de passe, et les rôles.

/ Envoi de la requête HTTP :

La requête est envoyée en utilisant la méthode POST de la bibliothèque « http ».
await http.post(url, headers: headers, body: body); // L'utilisation de await indique que le code
attendra ici jusqu'à ce que la réponse du serveur soit reçue.

/ Gestion de la réponse :

Si le code de statut est 201, le compte est créé. Les autres codes indiquent qu’il y a un problème.
(400 pour une mauvaise requête, 401 pour accès interdit, 500 pour une erreur serveur, ...)

/ Gestion des exceptions :

Un bloc try-catch est utilisé pour gérer les erreurs potentielles lors de l'envoi de la requête (par
exemple, problème de réseau ou de configuration). Si une exception est capturée, un message
d'erreur est affiché et la fonction retourne 0.

*/

Future<http.Response> login(String email, String password) async {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final url = "$baseUrl/users";
  final urlFull = Uri.parse(url);
  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };
  final body = jsonEncode({'email': email, 'password': password});
  final response = await http.post(urlFull, headers: headers, body: body);
  /*
  La requête POST est envoyée à l'URL spécifiée avec les en-têtes et le corps définis.
  La méthode await est utilisée pour attendre la réponse de l'API.
  */
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to login: ${response.reasonPhrase}');
  }
}

/*

Future<http.Response> login(String email, String password) async {

La méthode est déclarée avec un retour de type Future<http.Response>, ce qui signifie qu'elle
renverra un objet http.Response à un moment futur après l'exécution asynchrone de la méthode.
Elle prend deux paramètres : email et password, qui sont les informations d'identification de
l'utilisateur.

'accept': 'application/json' // indique que la réponse attendue doit être en format JSON.
'Content-Type': 'application/json' //indique que le corps de la requête sera au format JSON.
*/
