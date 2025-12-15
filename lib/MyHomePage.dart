import 'package:api_forum/InscriptionPage.dart';
import 'package:api_forum/ListeUsersPage.dart';
import 'package:flutter/material.dart';
import 'api/messageApi.dart';
import 'objects/MessageClass.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Future contenant la liste des messages (chargés depuis l’API)
  late Future<List<Message>> futureMessages;
  @override
  void initState() {
    super.initState();
    // Appel de l'API dès l'ouverture de l'écran
    futureMessages = MessageApi().fetchMessages();
  }

  void goPageListeUsers() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListeUsersPage()),
    );
  }

  void goPageInscription() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InscriptionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre supérieure de la page
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          TextButton(
            onPressed: goPageListeUsers,
            child: Text("Liste des users"),
          ),
          TextButton(onPressed: goPageInscription, child: Text("Inscription")),
        ],
      ),
      // FutureBuilder permet d’afficher du contenu une fois la Future terminée
      body: FutureBuilder<List<Message>>(
        future: futureMessages,
        // builder = fonction appelée à chaque changement d’état du Future
        builder: (context, snapshot) {
          // 1. Affichage d’un loader pendant le chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Affichage d’un message d’erreur si l'API échoue
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          // 3. Cas où aucune donnée n'est retournée
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun message trouvé.'));
          }
          // Liste des messages une fois chargés
          final messages = snapshot.data!;
          // 4. Affichage de la liste sous forme de ListView
          return ListView.builder(
            itemCount: messages.length, // nombre de messages
            itemBuilder: (context, index) {
              final m = messages[index]; // message courant
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Affichage de la date formatée manuellement
                      // padLeft permet de compléter une chaîne de caractères
                      //à gauche avec un caractère choisi. (ici un 0 pour rester sur 2 caractères)
                      Text(
                        "${m.postedAt.day.toString().padLeft(2, '0')}/"
                        "${m.postedAt.month.toString().padLeft(2, '0')}/"
                        "${m.postedAt.year} "
                        "à "
                        "${m.postedAt.hour.toString().padLeft(2, '0')}:"
                        "${m.postedAt.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        m.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        m.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${m.userFirstName} ${m.userLastName}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
