import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ecrans/ecran_accueil.dart';
import 'ecrans/ecran_publication.dart';
import 'ecrans/ecran_tableau_de_bord.dart';
import 'ecrans/ecran_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ApplicationSunuMarche());
}

class ApplicationSunuMarche extends StatelessWidget {
  const ApplicationSunuMarche({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SunuMarché',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PagePrincipale(),
    );
  }
}

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({super.key});

  @override
  State<PagePrincipale> createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> {
  int _indexSelectionne = 0;

  final List<Widget> _ecrans = const [
    EcranAccueil(),
    EcranPublication(),
    EcranTableauDeBord(),
    EcranAuth(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ecrans[_indexSelectionne],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexSelectionne,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _indexSelectionne = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Publier'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Mes Annonces'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}