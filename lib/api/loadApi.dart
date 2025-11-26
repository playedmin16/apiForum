import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../objects/MessageClass.dart';
import '../objects/UserClass.dart';

class LoadApi {
  static final LoadApi instance = LoadApi._internal();
  LoadApi._internal();

  List<User> tousLesUsers = [];
  List<Message> tousLesMessages = [];

  bool usersLoaded = false;
  bool messagesLoaded = false;

  String apiBaseUrl = "http://s5-5738.nuage-peda.fr/forum/api";

  Future<void> loadUsers() async {
    final url = "$apiBaseUrl/users";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        tousLesUsers.clear();

        if (data["member"] != null) {
          for (var u in data["member"]) {
            User user = User(
              u["id"] ?? 0,
              u["email"] ?? "",
              [], // roles : non fournis
              u["nom"] ?? "",
              u["prenom"] ?? "",
            );

            tousLesUsers.add(user);
          }
        }

        usersLoaded = true;
        debugPrint("Users chargés : ${tousLesUsers.length}");
      }
    } catch (e) {
      debugPrint("Erreur loadUsers : $e");
    }
  }

  Future<void> loadMessages() async {
    final url = "$apiBaseUrl/messages";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        tousLesMessages.clear();

        if (data["member"] != null) {
          for (var m in data["member"]) {
            int idUser = 0;
            if (m["user"] != null && m["user"]["@id"] != null) {
              final uri = m["user"]["@id"];
              idUser = int.tryParse(uri.split("/").last) ?? 0;
            }

            int? parentId;
            if (m["parent"] != null && m["parent"]["@id"] != null) {
              final uri = m["parent"]["@id"];
              parentId = int.tryParse(uri.split("/").last);
            } else {
              parentId = null;
            }

            Message message = Message(
              m["id"] ?? 0,
              idUser,
              parentId,
              DateTime.parse(m["datePoste"]),
              m["titre"] ?? "",
              m["contenu"] ?? "",
            );

            tousLesMessages.add(message);
          }
        }

        messagesLoaded = true;
        debugPrint("Messages chargés : ${tousLesMessages.length}");
      }
    } catch (e) {
      debugPrint("Erreur loadMessages : $e");
    }
  }
}
