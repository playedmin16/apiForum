import 'package:flutter/material.dart';
import 'api/userApi.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});
  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final statusCode = await UserApi().registerUser(
        _prenomController.text,
        _nomController.text,
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inscription réussie !'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); // Retourne à la page précédente
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de l\'inscription (Code: $statusCode)'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Premier champ du formulaire (nom)
            Padding(
              padding: EdgeInsetsGeometry.all(10.0),
              child: TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(
                    color: Color.fromARGB(255, 196, 43, 160),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 196, 43, 160),
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 196, 43, 160),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Veuillez n\'utiliser que des lettres';
                  }
                  return null; // ce return doit être à l'intérieur du validator
                },
              ),
            ),
            // champ prénom
            Padding(
              padding: EdgeInsetsGeometry.all(10.0),
              child: TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(
                    color: Color.fromARGB(255, 196, 43, 160),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 196, 43, 160),
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 196, 43, 160),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Veuillez n\'utiliser que des lettres';
                  }
                  return null; // ce return doit être à l'intérieur du validator
                },
              ),
            ),
            // champ email
            Padding(
              padding: EdgeInsetsGeometry.all(10.0),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(
                    color: Color.fromARGB(255, 196, 43, 160),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 196, 43, 160),
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 196, 43, 160),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  } else if (!RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  ).hasMatch(value)) {
                    return 'Format obligatoire : exemple@exemple.exemple';
                  }
                  return null; // ce return doit être à l'intérieur du validator
                },
              ),
            ),
            // champ mot de passe
            Padding(
              padding: EdgeInsetsGeometry.all(10.0),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(
                    color: Color.fromARGB(255, 196, 43, 160),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 196, 43, 160),
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 196, 43, 160),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  if (value.length < 12) {
                    return '12 caractères minimum';
                  }
                  if (!value.contains(RegExp(r'[A-Z]'))) {
                    return 'Au moins une majuscule requise';
                  }
                  if (!value.contains(RegExp(r'[a-z]'))) {
                    return 'Au moins une minuscule requise';
                  }
                  if (!value.contains(RegExp(r'[0-9]'))) {
                    return 'Au moins un chiffre requis';
                  }
                  if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                    return 'Au moins un caractère spécial requis';
                  }
                  return null;
                },
              ),
            ),
            // Bouton submit
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Text("S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }
}
