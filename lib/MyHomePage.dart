import 'package:flutter/material.dart';
import 'api/loadApi.dart';
import '../objects/MessageClass.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await LoadApi.instance.loadMessages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final messages = LoadApi.instance.tousLesMessages;

    // Messages racine = parent == null
    final rootMessages =
        messages.where((m) => m.getIdMessageParent() == null).toList()
          ..sort((a, b) => a.getDatePost().compareTo(b.getDatePost()));

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),

      body: messages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: rootMessages.length,
              itemBuilder: (context, index) {
                final msg = rootMessages[index];
                return buildMessageItem(msg, messages);
              },
            ),
    );
  }

  Widget buildMessageItem(Message message, List<Message> allMessages) {
    // Récupère les réponses du message
    final replies =
        allMessages
            .where((m) => m.getIdMessageParent() == message.getIdMessage())
            .toList()
          ..sort((a, b) => a.getDatePost().compareTo(b.getDatePost()));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.getTitre(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(message.getContenu(), style: const TextStyle(fontSize: 15)),

            const SizedBox(height: 8),

            Text(
              "Publié le : ${message.getDatePost()}",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),

            if (replies.isNotEmpty) ...[
              const Divider(height: 20),
              const Text("Réponses :", style: TextStyle(fontSize: 16)),
            ],

            for (var rep in replies) buildReply(rep),
          ],
        ),
      ),
    );
  }

  Widget buildReply(Message reply) {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(reply.getContenu(), style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            "Publié le : ${reply.getDatePost()}",
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
