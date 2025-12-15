import 'package:flutter/material.dart';
import 'api/userApi.dart';
import 'objects/UserClass.dart';

class ListeUsersPage extends StatefulWidget {
  const ListeUsersPage({super.key});
  @override
  State<ListeUsersPage> createState() => _ListeUsersPageState();
}

class _ListeUsersPageState extends State<ListeUsersPage> {
  // Future contenant la liste des Users (chargés depuis l’API)
  late Future<List<User>> futureUsers;
  @override
  void initState() {
    super.initState();
    // Appel de l'API dès l'ouverture de l'écran
    futureUsers = UserApi().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre supérieure de la page
      appBar: AppBar(title: const Text('Users')),
      // FutureBuilder permet d’afficher du contenu une fois la Future terminée
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        // builder = fonction appelée à chaque changement d’état du Future
        builder: (context, snapshot) {
          // 1. Affichage d’un loader pendant le chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Affichage d’un User d’erreur si l'API échoue
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          // 3. Cas où aucune donnée n'est retournée
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun User trouvé.'));
          }
          // Liste des Users une fois chargés
          final Users = snapshot.data!;
          // 4. Affichage de la liste sous forme de ListView
          return ListView.builder(
            itemCount: Users.length, // nombre de Users
            itemBuilder: (context, index) {
              final u = Users[index]; // User courant
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
                      const SizedBox(height: 10),
                      Text(
                        "${u.nom} ${u.prenom}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        u.email,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        u.afficheRoles(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
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
