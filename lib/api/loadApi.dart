import '../objects/AppDetailsClass.dart';
import '../objects/SteamAppsClass.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class LoadApi {
  static final LoadApi instance = LoadApi._internal();
  LoadApi._internal();

  List<SteamApp> allApps = [];
  Map<int, AppDetails> toutesLesApps = {};
  bool appsLoaded = false;

  /// Liste de test de quelques AppIDs
  final List<int> testAppIds = [
    570, // Dota 2
    440, // Team Fortress 2
    730, // CS:GO
    578080, // PUBG
    105600, // Terraria
  ];

  /// Charge les jeux pour les AppIDs de test
  Future<void> loadTestApps() async {
    allApps.clear();

    for (var appId in testAppIds) {
      try {
        AppDetails? details = await getAppDetails(appId);
        if (details != null) {
          allApps.add(SteamApp(details.getAppid(), details.getName()));
        }
      } catch (e) {
        debugPrint('Erreur lors du chargement de l\'appid $appId : $e');
      }
    }

    appsLoaded = true;
    debugPrint('Apps chargées : ${allApps.length} jeux trouvés.');
  }

  /// Récupère les détails d'une app (cache)
  Future<AppDetails?> getAppDetails(int appId) async {
    if (toutesLesApps.containsKey(appId)) {
      return toutesLesApps[appId];
    }

    String url = "https://store.steampowered.com/api/appdetails?appids=$appId";

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> dataMap = jsonDecode(response.body);
        var appData = dataMap[appId.toString()]['data'];

        if (appData == null) return null;

        AppDetails details = AppDetails(
          appData['type'] ?? '',
          appData['name'] ?? '',
          appData['steam_appid'] ?? 0,
          appData['required_age'] ?? 0,
          appData['short_description'] ?? '',
          appData['header_image'] ?? '',
          appData['website'] ?? '',
          List<String>.from(appData['developers'] ?? []),
          List<String>.from(appData['publishers'] ?? []),
          appData['price_overview'] != null
              ? appData['price_overview']['currency'] ?? ''
              : '',
          appData['price_overview'] != null
              ? (appData['price_overview']['final'] ?? 0) / 100.0
              : 0.0,
          List<String>.from(
            appData['genres']?.map((g) => g['description']) ?? [],
          ),
          appData['release_date'] != null
              ? appData['release_date']['date'] ?? ''
              : '',
        );

        toutesLesApps[appId] = details;
        return details;
      } else {
        throw Exception('Erreur HTTP détails : ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(
        "Erreur lors de la récupération des détails pour l'appid $appId : $e",
      );
      return null;
    }
  }
}
