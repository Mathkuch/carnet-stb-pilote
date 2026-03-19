import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';


// ==========================================
// NOUVELLE PALETTE DE COULEURS PROFESSIONNELLE
// ==========================================
const Color primaryTeal = Color(0xFF7DBEA5); // Vert sauge doux
const Color darkNavy = Color(0xFF335061);    // Bleu marine profond
const Color bgColor = Color(0xFFF7F5F0);     // Blanc cassé / Crème chaleureux
const Color cardColor = Colors.white;

// ==========================================
// DONNÉES : CATALOGUE DES TRAITEMENTS
// ==========================================
const String csvTraitements = '''
Brivaracétam;Solution buvable;10;mg/mL;2
Brivaracétam;Comprimé;10;mg;2
Brivaracétam;Comprimé;25;mg;2
Brivaracétam;Comprimé;50;mg;2
Brivaracétam;Comprimé;75;mg;2
Brivaracétam;Comprimé;100;mg;2
Cannabidiol;Solution buvable;100;mg/mL;2
Carbamazépine;Suspension buvable;20;mg/mL;2-3
Carbamazépine;Comprimé;200;mg;2-3
Carbamazépine;Comprimé;400;mg;2
Cénobamate;Comprimé;25;mg;1
Cénobamate;Comprimé;50;mg;1
Cénobamate;Comprimé;100;mg;1
Cénobamate;Comprimé;200;mg;1
Clobazam;Comprimé;10;mg;2
Clobazam;Comprimé;20;mg;2
Clonazépam;Solution buvable;2.5;mg/mL;2
Clonazépam;Comprimé;2;mg;2
Diazépam;Intra-rectal;5;mg;Urgence
Diazépam;Intra-rectal;10;mg;Urgence
Éthosuximide;Sirop;50;mg/mL;2
Éthosuximide;Capsule;250;mg;2
Évérolimus;Comprimé;2.5;mg;1
Évérolimus;Comprimé;5;mg;1
Évérolimus;Comprimé;10;mg;1
Évérolimus;Comprimé dispersible;2;mg;1
Évérolimus;Comprimé dispersible;3;mg;1
Évérolimus;Comprimé dispersible;5;mg;1
Felbamate;Suspension buvable;120;mg/mL;3-4
Felbamate;Comprimé;400;mg;3-4
Felbamate;Comprimé;600;mg;3-4
Gabapentine;Gélule;100;mg;3
Gabapentine;Gélule;300;mg;3
Gabapentine;Gélule;400;mg;3
Lacosamide;Sirop;10;mg/mL;2
Lacosamide;Comprimé;50;mg;2
Lacosamide;Comprimé;100;mg;2
Lacosamide;Comprimé;150;mg;2
Lacosamide;Comprimé;200;mg;2
Lamotrigine;Comprimé dispersible;2;mg;1-2
Lamotrigine;Comprimé dispersible;5;mg;1-2
Lamotrigine;Comprimé dispersible;25;mg;1-2
Lamotrigine;Comprimé dispersible;50;mg;1-2
Lamotrigine;Comprimé dispersible;100;mg;1-2
Lamotrigine;Comprimé dispersible;200;mg;1-2
Lévétiracétam;Solution buvable;100;mg/mL;2
Lévétiracétam;Comprimé;250;mg;2
Lévétiracétam;Comprimé;500;mg;2
Lévétiracétam;Comprimé;750;mg;2
Lévétiracétam;Comprimé;1000;mg;2
Midazolam;Buccal;2.5;mg;Urgence
Midazolam;Buccal;5;mg;Urgence
Midazolam;Buccal;7.5;mg;Urgence
Midazolam;Buccal;10;mg;Urgence
Oxcarbazépine;Suspension buvable;60;mg/mL;2
Oxcarbazépine;Comprimé;150;mg;2
Oxcarbazépine;Comprimé;300;mg;2
Oxcarbazépine;Comprimé;600;mg;2
Pérampanel;Suspension buvable;0.5;mg/mL;1
Pérampanel;Comprimé;2;mg;1
Pérampanel;Comprimé;4;mg;1
Pérampanel;Comprimé;6;mg;1
Pérampanel;Comprimé;8;mg;1
Pérampanel;Comprimé;10;mg;1
Pérampanel;Comprimé;12;mg;1
Phénobarbital;Comprimé;15;mg;1
Phénobarbital;Comprimé;50;mg;1
Phénobarbital;Comprimé;100;mg;1
Phénytoïne;Comprimé;100;mg;1-2
Primidone;Comprimé;250;mg;2
Rufinamide;Suspension buvable;40;mg/mL;2
Rufinamide;Comprimé;200;mg;2
Rufinamide;Comprimé;400;mg;2
Stiripentol;Gélule;250;mg;2-3
Stiripentol;Gélule;500;mg;2-3
Stiripentol;Sachet;250;mg;2-3
Stiripentol;Sachet;500;mg;2-3
Topiramate;Gélule;15;mg;2
Topiramate;Gélule;25;mg;2
Topiramate;Gélule;50;mg;2
Topiramate;Comprimé;50;mg;2
Topiramate;Comprimé;100;mg;2
Topiramate;Comprimé;200;mg;2
Acide Valproïque;Solution buvable;200;mg/mL;2
Acide Valproïque;Comprimé;200;mg;2
Acide Valproïque;Comprimé;500;mg;2
Acide Valproïque;Granules;100;mg;2
Acide Valproïque;Granules;250;mg;2
Acide Valproïque;Granules;500;mg;2
Acide Valproïque;Granules;1000;mg;2
Vigabatrin;Sachet;500;mg;2
Vigabatrin;Comprimé;500;mg;2
Zonisamide;Gélule;25;mg;1-2
Zonisamide;Gélule;50;mg;1-2
Zonisamide;Gélule;100;mg;1-2
''';

List<Map<String, String>> parseCSV(String csv) {
  List<Map<String, String>> result = [];
  List<String> lines = csv.trim().split('\n');
  for (String line in lines) {
    List<String> values = line.split(';');
    if (values.length == 5) {
      result.add({
        'nom': values[0],
        'forme': values[1],
        'dosage': values[2],
        'unite': values[3],
        'prises': values[4],
      });
    }
  }
  return result;
}

final List<Map<String, String>> catalogueMedicaments = parseCSV(csvTraitements);

// ==========================================
// MODÈLES : PATIENT & TRAITEMENTS
// ==========================================
class Traitement {
  final String id;
  final String nom;
  final String forme;
  final String dosage;
  final String unite;
  final String prisesHabituelles;
  String posologiePersonnalisee;

  Traitement({required this.id, required this.nom, required this.forme, required this.dosage, required this.unite, required this.prisesHabituelles, this.posologiePersonnalisee = ""});
}

class PatientProfile {
  final String id;
  String prenom;
  String? sexe;
  DateTime? dateNaissance;
  String pays;
  String langue; // fr ou en
  List<Traitement> traitements = []; 

  PatientProfile({required this.id, required this.prenom, this.sexe, this.dateNaissance, this.pays = "France", this.langue = "fr"});

  int? get age {
    if (dateNaissance == null) return null;
    final now = DateTime.now();
    int a = now.year - dateNaissance!.year;
    if ((now.month < dateNaissance!.month) || (now.month == dateNaissance!.month && now.day < dateNaissance!.day)) a--;
    return a;
  }
}

class ProfileStore extends ChangeNotifier {
  final List<PatientProfile> _profiles = [];
  String? _activeId;

  List<PatientProfile> get profiles => List.unmodifiable(_profiles);

  PatientProfile get active {
    final id = _activeId;
    if (id == null || _profiles.isEmpty) {
      final p = PatientProfile(id: "p1", prenom: "Camille", sexe: "Féminin", dateNaissance: DateTime(DateTime.now().year - 8, 5, 12), langue: "fr");
      _profiles.add(p);
      _activeId = p.id;
      return p;
    }
    return _profiles.firstWhere((p) => p.id == id, orElse: () => _profiles.first);
  }

  void setActive(String id, BuildContext context) { 
    _activeId = id; 
    context.setLocale(Locale(active.langue));
    notifyListeners(); 
  }

  void addProfile(PatientProfile p, {bool makeActive = true, BuildContext? context}) { 
    _profiles.add(p); 
    if (makeActive) {
      _activeId = p.id;
      if (context != null) context.setLocale(Locale(p.langue));
    }
    notifyListeners(); 
  }

  void updateProfile(String id, {String? prenom, String? sexe, DateTime? dateNaissance, String? pays, String? langue}) {
    final p = _profiles.firstWhere((e) => e.id == id);
    if (prenom != null) p.prenom = prenom; 
    if (sexe != null) p.sexe = sexe; 
    if (dateNaissance != null) p.dateNaissance = dateNaissance; 
    if (pays != null) p.pays = pays;
    if (langue != null) p.langue = langue;
    notifyListeners();
  }

  void removeProfile(String id) { 
    if (_profiles.length <= 1) return; 
    _profiles.removeWhere((p) => p.id == id); 
    if (_activeId == id) _activeId = _profiles.first.id; 
    notifyListeners(); 
  }
  
  void ajouterTraitement(String profilId, Traitement t) {
    _profiles.firstWhere((e) => e.id == profilId).traitements.add(t);
    notifyListeners();
  }
  void supprimerTraitement(String profilId, String traitementId) {
    _profiles.firstWhere((e) => e.id == profilId).traitements.removeWhere((t) => t.id == traitementId);
    notifyListeners();
  }
}

final ProfileStore profileStore = ProfileStore();

// ==========================================
// POINT D'ENTRÉE & CONFIGURATION
// ==========================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('fr'), Locale('en')],
      path: 'assets/translations', 
      fallbackLocale: const Locale('fr'),
      child: const MonApplicationSTB(),
    ),
  );
}

class MonApplicationSTB extends StatelessWidget {
  const MonApplicationSTB({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Carnet STB', 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryTeal,
          primary: primaryTeal,
          secondary: darkNavy,
          background: bgColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bgColor,
          elevation: 0,
          iconTheme: IconThemeData(color: darkNavy),
          titleTextStyle: TextStyle(color: darkNavy, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        useMaterial3: true,
      ),
      home: AnimatedBuilder(animation: profileStore, builder: (context, _) => const EcranAccueil()),
    );
  }
}

// ==========================================
// PAGE D'ACCUEIL & NOUVEAU DRAWER
// ==========================================
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';

class EcranAccueil extends StatelessWidget {
  const EcranAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('menu.header'.tr()),
      ),
      drawer: const NouveauDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- ENCADRÉ DE BIENVENUE ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [primaryTeal, Color(0xFF5A9B82)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: primaryTeal.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.medical_services, color: Colors.white, size: 30),
                      const SizedBox(width: 10),
                      Expanded(child: Text('home.welcome_title'.tr(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text('home.welcome_text'.tr(), style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- AVERTISSEMENT BETA ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.shade200)),
              child: Row(
                children: [
                  const Icon(Icons.science, color: Colors.orange),
                  const SizedBox(width: 15),
                  Expanded(child: Text('home.beta_warning'.tr(), style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // --- SECTION PARTENAIRES (Avec textes sous les logos) ---
            Center(child: Text('home.partners'.tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey))),
            const SizedBox(height: 15),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 15, 
              runSpacing: 15,
              children: [
                _creerCartePartenaire('assets/logo_astb.jpg', 'ASTB France'),
                _creerCartePartenaire('assets/logo_defiscience.png', 'Filière DéfiScience'),
                _creerCartePartenaire('assets/logo_necker.jpg', 'Hôpital Necker-Enfants malades'),
                _creerCartePartenaire('assets/logo_CHRUNancy.png', 'CHRU Nancy'),
                _creerCartePartenaire('assets/logo_CReER.jpg', 'Réseau CReER'),
              ],
            )
          ],
        ),
      ),
    );
  }

  // NOUVEL OUTIL : Génère les cartes partenaires avec le logo ET le texte
  Widget _creerCartePartenaire(String cheminImage, String nom) {
    return SizedBox(
      width: 140, // Largeur fixe pour avoir des cartes uniformes
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                cheminImage,
                height: 50,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Text(
                nom,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF335061)),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// NOUVEAU MENU LATÉRAL (DRAWER)
// ==========================================
class NouveauDrawer extends StatelessWidget {
  const NouveauDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final profilActuel = profileStore.active;
    final String nomProfilActuel = profilActuel.prenom;
    final String sexeProfilActuel = profilActuel.sexe ?? 'Inconnu';
    final int ageProfilActuel = profilActuel.age ?? 0;

    return Drawer(
      backgroundColor: bgColor,
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                Container(height: 160, width: double.infinity, color: primaryTeal),
                Positioned(
                  top: 90, left: 16, right: 16,
                  child: GestureDetector(
                    onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => const PageAProposDeMoi())); },
                    child: Card(
                      elevation: 4, shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(radius: 25, backgroundColor: darkNavy.withOpacity(0.1), child: const Icon(Icons.person, color: darkNavy, size: 30)),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('ACTIVE PROFILE:', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                  Text("Patient : $nomProfilActuel", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: darkNavy)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildMenuItem(Icons.menu_book, 'menu.charter'.tr(), false, () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => const PageCharte())); }),
                _buildMenuItem(Icons.lightbulb_outline, 'menu.understand_tsc'.tr(), false, () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => const PageComprendreSTB())); }),
                _buildMenuItem(Icons.psychology_outlined, 'menu.tand'.tr(), false, () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => PageDepistageTAND(nomPatient: nomProfilActuel, sexePatient: sexeProfilActuel, agePatient: ageProfilActuel))); }),
                _buildMenuItem(Icons.calendar_month, 'menu.care_plan'.tr(), false, () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => PageMonSuivi(nomPatient: nomProfilActuel, agePatient: ageProfilActuel, sexePatient: sexeProfilActuel))); }),
                _buildMenuItem(Icons.medication, 'menu.treatments'.tr(), false, () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => const PagePlanTraitements())); }),
                _buildMenuItem(Icons.monitor_heart, 'menu.seizures'.tr(), false, () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => const PageMesCrises())); }),
                _buildMenuItem(Icons.medical_information, 'menu.visit'.tr(), false, () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => PagePreparerVisite(nomPatient: nomProfilActuel, agePatient: ageProfilActuel, sexePatient: sexeProfilActuel))); }),
                
                const Padding(padding: EdgeInsets.only(top: 20, bottom: 8, left: 16), child: Text("FUTURS MODULES", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey))),
                _buildMenuItem(Icons.handshake_outlined, 'menu.live_tsc'.tr(), false, () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => PageFonctionnalite(titreFocus: 'menu.live_tsc'.tr()))); }),
                _buildMenuItem(Icons.group, 'menu.care_team'.tr(), false, () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => PageFonctionnalite(titreFocus: 'menu.care_team'.tr()))); }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, bool isSelected, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: isSelected ? primaryTeal.withOpacity(0.15) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: darkNavy),
        title: Text(title, style: TextStyle(color: darkNavy, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ==========================================
// PAGE : PLAN DE TRAITEMENTS
// ==========================================
class PagePlanTraitements extends StatefulWidget {
  const PagePlanTraitements({super.key});
  @override
  State<PagePlanTraitements> createState() => _PagePlanTraitementsState();
}

class _PagePlanTraitementsState extends State<PagePlanTraitements> {
  void _afficherDialogueAjout(BuildContext context, String profilId) {
    showDialog(context: context, builder: (context) => _DialogAjoutTraitement(profilId: profilId));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: profileStore,
      builder: (context, _) {
        final profilActuel = profileStore.active;
        final traitements = profilActuel.traitements;

        return Scaffold(
          appBar: AppBar(title: Text('treatments.title'.tr())),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: primaryTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryTeal.withOpacity(0.3))),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: primaryTeal),
                      const SizedBox(width: 10),
                      Text('treatments.current_meds'.tr(args: [profilActuel.prenom]), style: const TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: traitements.isEmpty 
                    ? Center(child: Text('treatments.empty'.tr(), style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)))
                    : ListView.builder(
                        itemCount: traitements.length,
                        itemBuilder: (context, index) {
                          final t = traitements[index];
                          return Card(
                            elevation: 1, color: cardColor, margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: CircleAvatar(backgroundColor: primaryTeal.withOpacity(0.2), child: const Icon(Icons.medication, color: primaryTeal)),
                              title: Text('${t.nom} - ${t.dosage} ${t.unite}', style: const TextStyle(fontWeight: FontWeight.bold, color: darkNavy)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${'treatments.form'.tr()} : ${t.forme}', style: const TextStyle(fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text('${'treatments.posology'.tr()} : ${t.posologiePersonnalisee}', style: const TextStyle(fontWeight: FontWeight.bold, color: darkNavy)),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => profileStore.supprimerTraitement(profilActuel.id, t.id)),
                            ),
                          );
                        },
                      ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _afficherDialogueAjout(context, profilActuel.id), 
                  icon: const Icon(Icons.add), 
                  label: Text('treatments.add_med'.tr(), style: const TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: primaryTeal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))
                )
              ],
            ),
          ),
        );
      }
    );
  }
}

class _DialogAjoutTraitement extends StatefulWidget {
  final String profilId;
  const _DialogAjoutTraitement({required this.profilId});
  @override
  State<_DialogAjoutTraitement> createState() => _DialogAjoutTraitementState();
}

class _DialogAjoutTraitementState extends State<_DialogAjoutTraitement> {
  String? _nomSelectionne;
  Map<String, String>? _variationSelectionnee;
  final _posologieController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final nomsUniques = catalogueMedicaments.map((e) => e['nom']!).toSet().toList()..sort();
    final variations = _nomSelectionne == null ? <Map<String,String>>[] : catalogueMedicaments.where((e) => e['nom'] == _nomSelectionne).toList();

    return AlertDialog(
      backgroundColor: bgColor,
      title: Text('treatments.dialog_title'.tr(), style: const TextStyle(color: darkNavy, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _nomSelectionne, hint: Text('treatments.dialog_step1'.tr()), isExpanded: true,
              items: nomsUniques.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
              onChanged: (val) => setState(() { _nomSelectionne = val; _variationSelectionnee = null; }),
              decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<Map<String, String>>(
              initialValue: _variationSelectionnee, hint: Text('treatments.dialog_step2'.tr()), isExpanded: true,
              items: variations.map((v) => DropdownMenuItem(value: v, child: Text('${v['forme']} - ${v['dosage']} ${v['unite']}'))).toList(),
              onChanged: (val) {
                setState(() { 
                  _variationSelectionnee = val; 
                  if (val != null && _posologieController.text.isEmpty) _posologieController.text = "${val['prises']} prise(s)";
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _posologieController, maxLines: 2,
              decoration: InputDecoration(labelText: 'treatments.dialog_step3'.tr(), hintText: 'treatments.dialog_hint'.tr(), border: const OutlineInputBorder(), alignLabelWithHint: true),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('global.btn_cancel'.tr(), style: const TextStyle(color: Colors.grey))),
        ElevatedButton(
          onPressed: () {
            if (_variationSelectionnee != null && _posologieController.text.isNotEmpty) {
              final t = Traitement(id: DateTime.now().millisecondsSinceEpoch.toString(), nom: _variationSelectionnee!['nom']!, forme: _variationSelectionnee!['forme']!, dosage: _variationSelectionnee!['dosage']!, unite: _variationSelectionnee!['unite']!, prisesHabituelles: _variationSelectionnee!['prises']!, posologiePersonnalisee: _posologieController.text);
              profileStore.ajouterTraitement(widget.profilId, t);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: primaryTeal, foregroundColor: Colors.white),
          child: Text('global.btn_add'.tr())
        )
      ]
    );
  }
}

// ==========================================
// PAGE : À PROPOS DE MOI (GESTION DES PROFILS)
// ==========================================
class PageAProposDeMoi extends StatelessWidget {
  const PageAProposDeMoi({super.key});

  void _montrerDialogueAjout(BuildContext context) {
    String nouveauPrenom = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        title: const Text('Nouveau profil', style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold)),
        content: TextField(decoration: const InputDecoration(labelText: 'Prénom', border: OutlineInputBorder()), onChanged: (val) => nouveauPrenom = val),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('global.btn_cancel'.tr())),
          ElevatedButton(
            onPressed: () {
              if (nouveauPrenom.trim().isNotEmpty) {
                profileStore.addProfile(PatientProfile(id: DateTime.now().millisecondsSinceEpoch.toString(), prenom: nouveauPrenom.trim(), langue: context.locale.languageCode), makeActive: true, context: context);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryTeal, foregroundColor: Colors.white),
            child: Text('global.btn_add'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: profileStore,
      builder: (context, _) {
        final active = profileStore.active;
        return Scaffold(
          appBar: AppBar(title: const Text('Gestion des profils')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: primaryTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryTeal.withOpacity(0.3))),
                  child: Row(
                    children: [
                      const Icon(Icons.group, color: primaryTeal), const SizedBox(width: 10),
                      Expanded(child: DropdownButtonHideUnderline(child: DropdownButton<String>(isExpanded: true, value: active.id, items: profileStore.profiles.map((p) => DropdownMenuItem(value: p.id, child: Text(p.prenom, style: const TextStyle(fontWeight: FontWeight.bold, color: darkNavy)))).toList(), onChanged: (id) { if (id != null) profileStore.setActive(id, context); }))),
                      IconButton(icon: const Icon(Icons.person_add, color: primaryTeal), onPressed: () => _montrerDialogueAjout(context)),
                      if (profileStore.profiles.length > 1) IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => profileStore.removeProfile(active.id)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                FormulaireProfilEdition(key: ValueKey(active.id), profil: active),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FormulaireProfilEdition extends StatefulWidget {
  final PatientProfile profil;
  const FormulaireProfilEdition({super.key, required this.profil});
  @override
  State<FormulaireProfilEdition> createState() => _FormulaireProfilEditionState();
}

class _FormulaireProfilEditionState extends State<FormulaireProfilEdition> {
  late TextEditingController _prenomController;
  String? _sexeSelectionne;
  String _paysSelectionne = "France"; 
  String _langueSelectionnee = "fr";
  DateTime? _dateNaissance; 
  final List<String> _listePays = ['France', 'Belgique', 'Suisse', 'Canada', 'Luxembourg', 'Autre'];

  @override
  void initState() {
    super.initState();
    _prenomController = TextEditingController(text: widget.profil.prenom);
    _sexeSelectionne = widget.profil.sexe;
    _dateNaissance = widget.profil.dateNaissance;
    _paysSelectionne = widget.profil.pays;
    _langueSelectionnee = widget.profil.langue;
  }

  @override
  void dispose() { _prenomController.dispose(); super.dispose(); }

  Future<void> _selectionnerDate(BuildContext context) async {
    final DateTime? dateChoisie = await showDatePicker(context: context, initialDate: _dateNaissance ?? DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now(), initialDatePickerMode: DatePickerMode.year);
    if (dateChoisie != null && dateChoisie != _dateNaissance) setState(() { _dateNaissance = dateChoisie; });
  }

  void _sauvegarder() {
    profileStore.updateProfile(widget.profil.id, prenom: _prenomController.text, sexe: _sexeSelectionne, dateNaissance: _dateNaissance, pays: _paysSelectionne, langue: _langueSelectionnee);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${'global.btn_save'.tr()} !')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 50, backgroundColor: primaryTeal, foregroundColor: Colors.white, child: Text(_prenomController.text.isNotEmpty ? _prenomController.text[0].toUpperCase() : '?', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
        const SizedBox(height: 40),
        TextField(controller: _prenomController, decoration: const InputDecoration(labelText: 'Prénom / First Name', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)), onChanged: (v) => setState((){})),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Langue de l\'application / App Language', border: OutlineInputBorder(), prefixIcon: Icon(Icons.language)), 
          initialValue: _langueSelectionnee, 
          items: const [DropdownMenuItem(value: 'fr', child: Text('Français')), DropdownMenuItem(value: 'en', child: Text('English'))], 
          onChanged: (val) { if (val != null) { setState(() => _langueSelectionnee = val); context.setLocale(Locale(val)); } }
        ),
        const SizedBox(height: 20),
        InkWell(onTap: () => _selectionnerDate(context), child: InputDecorator(decoration: const InputDecoration(labelText: 'Date de naissance / Birth date', border: OutlineInputBorder(), prefixIcon: Icon(Icons.cake)), child: Text(_dateNaissance == null ? 'Sélectionner une date' : '${_dateNaissance!.day.toString().padLeft(2, '0')}/${_dateNaissance!.month.toString().padLeft(2, '0')}/${_dateNaissance!.year}', style: TextStyle(fontSize: 16, color: _dateNaissance == null ? Colors.grey.shade600 : Colors.black87)))),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(decoration: const InputDecoration(labelText: 'Sexe / Gender', border: OutlineInputBorder(), prefixIcon: Icon(Icons.wc)), initialValue: _sexeSelectionne, items: ['Féminin', 'Masculin', 'Autre', 'Je préfère ne pas le dire'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(), onChanged: (val) => setState(() => _sexeSelectionne = val)),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(decoration: const InputDecoration(labelText: 'Pays / Country', border: OutlineInputBorder(), prefixIcon: Icon(Icons.public)), initialValue: _paysSelectionne, items: _listePays.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(), onChanged: (val) { if (val != null) setState(() => _paysSelectionne = val); }),
        const SizedBox(height: 40),
        ElevatedButton.icon(onPressed: _sauvegarder, icon: const Icon(Icons.save), label: Text('global.btn_save'.tr()), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), backgroundColor: primaryTeal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))
      ],
    );
  }
}

// ==========================================
// PAGE : LA CHARTE (CONSENTEMENT)
// ==========================================
class PageCharte extends StatefulWidget {
  const PageCharte({super.key});
  @override
  State<PageCharte> createState() => _PageCharteState();
}

class _PageCharteState extends State<PageCharte> {
  bool _accepteConditions = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkNavy,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white, fontSize: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Consentement éclairé', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              const Text('En cliquant sur le bouton « J\'accepte les conditions », vous déclarez avoir pris connaissance des points ci-dessous :'),
              const SizedBox(height: 20),
              _creerPuce('Vos données seront stockées chez un hébergeur de données de santé agréé.'),
              _creerPuce('Vos données seront accessibles par les professionnels de santé qui vous suivent.'),
              _creerPuce('Vous pourrez à tout moment supprimer votre compte.'),
              _creerPuce('À des fins de recherche médicale, vos données seront rendues anonymes.'),
              const SizedBox(height: 40),
              Row(
                children: [
                  Checkbox(value: _accepteConditions, onChanged: (bool? nouvelleValeur) { setState(() { _accepteConditions = nouvelleValeur ?? false; }); }, side: const BorderSide(color: Colors.white, width: 2), activeColor: primaryTeal, checkColor: Colors.white),
                  const Text('J\'accepte les conditions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _creerPuce(String texte) { return Padding(padding: const EdgeInsets.only(bottom: 10.0, left: 10.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('•  ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Expanded(child: Text(texte))])); }
}

// ==========================================
// PAGE : DÉPISTAGE TAND (Étape par Étape Bilingue)
// ==========================================


class PageDepistageTAND extends StatefulWidget {
  final String nomPatient;
  final String sexePatient;
  final int agePatient; 

  const PageDepistageTAND({
    super.key, 
    required this.nomPatient, 
    required this.sexePatient,
    required this.agePatient,
  });

  @override
  State<PageDepistageTAND> createState() => _PageDepistageTANDState();
}

class _PageDepistageTANDState extends State<PageDepistageTAND> {
  Map<String, dynamic> reponses = {};
  int _etapeActuelle = 1;
  final int _nombreTotalEtapes = 12; 

  @override
  void initState() {
    super.initState();
    // Valeurs par défaut avec les clés
    reponses['tand.q1_a_pasEncore'] = false;
    reponses['tand.q1_a_age'] = '2';
    reponses['tand.q1_a_unite'] = 'tand.months';

    reponses['tand.q1_b_pasEncore'] = false;
    reponses['tand.q1_b_age'] = '7';
    reponses['tand.q1_b_unite'] = 'tand.months';

    reponses['tand.q1_c_pasEncore'] = false;
    reponses['tand.q1_c_age'] = '14';
    reponses['tand.q1_c_unite'] = 'tand.months';
  }

  // --- LOGIQUE MÉDICALE INTELLIGENTE ---
  bool _doitAfficherEtape(int etape) {
    if (etape == 6) {
      if (widget.agePatient < 5) return false;
      // "non verbal"
      if (reponses['tand.q2_lang'] == 'tand.q2_lang_opt1') return false; 
      // "Déficience intellectuelle sévère à profonde"
      if (reponses['tand.q5_opinion'] == 'tand.q5_c_opt3') return false; 
    }
    if (etape == 7) {
      if (reponses['tand.q5_opinion'] == 'tand.q5_c_opt3') return false;
    }
    return true; 
  }

  void _allerEtapeSuivante() {
    int prochaine = _etapeActuelle + 1;
    while (prochaine <= _nombreTotalEtapes && !_doitAfficherEtape(prochaine)) {
      prochaine++;
    }
    
    if (prochaine <= _nombreTotalEtapes) {
      setState(() { _etapeActuelle = prochaine; });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('tand.finished'.tr())));
      Navigator.pop(context);
    }
  }

  void _allerEtapePrecedente() {
    int precedente = _etapeActuelle - 1;
    while (precedente >= 1 && !_doitAfficherEtape(precedente)) {
      precedente--;
    }
    
    if (precedente >= 1) {
      setState(() { _etapeActuelle = precedente; });
    }
  }

  // --- LES LISTES DE CLÉS (Ne contiennent plus de français) ---
  final Map<String, String> q1Developpement = {
    'tand.q1_a': 'tand.q1_a_text',
    'tand.q1_b': 'tand.q1_b_text',
    'tand.q1_c': 'tand.q1_c_text',
    'tand.q1_d': 'tand.q1_d_text',
    'tand.q1_e': 'tand.q1_e_text',
    'tand.q1_f': 'tand.q1_f_text',
    'tand.q1_g': 'tand.q1_g_text',
  };

  final List<String> q2Langage = ['tand.q2_lang_opt1', 'tand.q2_lang_opt2', 'tand.q2_lang_opt3'];
  final List<String> q2Autonomie = ['tand.q2_auto_opt1', 'tand.q2_auto_opt2', 'tand.q2_auto_opt3'];
  final List<String> q2Mobilite = ['tand.q2_mob_opt1', 'tand.q2_mob_opt2', 'tand.q2_mob_opt3', 'tand.q2_mob_opt4'];
  
  final List<String> q3Comportements = List.generate(19, (i) => 'tand.q3_${i+1}');
  final List<String> q4Troubles = List.generate(6, (i) => 'tand.q4_${i+1}');
  
  final List<String> q5bResultats = ['tand.q5_b_opt1', 'tand.q5_b_opt2', 'tand.q5_b_opt3', 'tand.q5_b_opt4', 'tand.q5_b_opt5', 'tand.q5_b_opt6'];
  final List<String> q5cOptions = ['tand.q5_c_opt1', 'tand.q5_c_opt2', 'tand.q5_c_opt3'];

  // --- OUTIL DE TRADUCTION AVEC PRÉNOM ---
  String _t(String key) {
    String prenom = widget.nomPatient.isNotEmpty ? widget.nomPatient : 'tand.the_patient'.tr();
    String pronom = widget.sexePatient == 'Féminin' ? 'tand.she'.tr() : (widget.sexePatient == 'Masculin' ? 'tand.he'.tr() : 'tand.he_she'.tr());
    return key.tr().replaceAll('{prenom}', prenom).replaceAll('{pronom}', pronom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tand.appbar_title'.tr()), 
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('tand.draft_saved'.tr())));
              Navigator.pop(context); 
            },
            icon: const Icon(Icons.save, color: Colors.teal),
            label: Text('tand.btn_draft'.tr(), style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: _etapeActuelle / _nombreTotalEtapes, backgroundColor: Colors.grey[300], color: Theme.of(context).colorScheme.primary, minHeight: 8),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('tand.step_indicator'.tr().replaceAll('{etape}', '$_etapeActuelle').replaceAll('{total}', '$_nombreTotalEtapes')),
                    ),
                  ),
                  _buildContenuEtape(_etapeActuelle),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _etapeActuelle > 1
                    ? OutlinedButton.icon(onPressed: _allerEtapePrecedente, icon: const Icon(Icons.arrow_back), label: Text('global.btn_prev'.tr()))
                    : const SizedBox(width: 100), 
                ElevatedButton.icon(
                  onPressed: _allerEtapeSuivante,
                  icon: Icon(_etapeActuelle >= _nombreTotalEtapes ? Icons.check : Icons.arrow_forward),
                  label: Text(_etapeActuelle >= _nombreTotalEtapes ? 'global.btn_finish'.tr() : 'global.btn_next'.tr()),
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContenuEtape(int etape) {
    switch (etape) {
      case 1:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _titreSection('tand.step1_title'.tr()), 
          Card(
            color: Colors.green[50],
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.green.shade200)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.history, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(child: Text('tand.recovery_msg'.tr(), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Text(_t('tand.step1_intro'), style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic))), 
          ...q1Developpement.entries.map((entree) => _creerQuestionAge(entree.key, entree.value))
        ]);
      
      case 2:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _titreSection('tand.step2_title'.tr()), 
          Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Text(_t('tand.step2_intro'), style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic))), 
          _creerMenuDeroulant('tand.q2_lang', q2Langage), 
          _creerMenuDeroulant('tand.q2_auto', q2Autonomie), 
          _creerMenuDeroulant('tand.q2_mob', q2Mobilite)
        ]);
      
      case 3:
        bool afficherSuite3 = q3Comportements.any((q) => reponses[q] == 'tand.yes');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            _titreSection('tand.step3_title'.tr()), 
            Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Text(_t('tand.step3_intro'), style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic))), 
            ...q3Comportements.map((q) => _creerQuestionChoix(q)),
            if (afficherSuite3) ...[
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('tand.if_yes'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, fontSize: 16)),
                    const SizedBox(height: 10),
                    _creerQuestionChoix('tand.q3_help1'),
                    _creerQuestionChoix('tand.q3_help2'),
                  ],
                ),
              ),
            ]
          ]
        );
      
      case 4:
        bool afficherSuite4 = q4Troubles.any((q) => reponses[q] == 'tand.yes');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            _titreSection('tand.step4_title'.tr()), 
            Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Text(_t('tand.step4_intro'), style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic))), 
            ...q4Troubles.map((q) => _creerQuestionChoix(q)),
            if (afficherSuite4) ...[
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('tand.if_yes'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, fontSize: 16)),
                    const SizedBox(height: 10),
                    _creerQuestionChoix('tand.q4_help1'),
                    _creerQuestionChoix('tand.q4_help2'),
                  ],
                ),
              ),
            ]
          ]
        );
      
      case 5:
        bool afficherSuite5b = reponses['tand.q5_b'] == 'tand.yes';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            _titreSection('tand.step5_title'.tr()),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text('tand.step5_info'.tr(), style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            ), 
            _creerQuestionChoix('tand.q5_a'),
            _creerQuestionChoix('tand.q5_b'),
            
            if (afficherSuite5b) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: _creerMenuDeroulant('tand.q5_b_res', q5bResultats),
                ),
              ),
            ],
            const SizedBox(height: 15),
            Text(_t('tand.q5_c'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            _creerMenuDeroulant('tand.q5_opinion', q5cOptions),
            const SizedBox(height: 15),
            _creerQuestionChoix('tand.q5_d'),
          ]
        );

      case 6:
        bool afficherSuite6 = (reponses['tand.q6_a'] == 'tand.yes') || (reponses['tand.q6_b'] == 'tand.yes') || (reponses['tand.q6_c'] == 'tand.yes') || (reponses['tand.q6_d'] == 'tand.yes');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            _titreSection('tand.step6_title'.tr()), 
            Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Text('tand.step6_info'.tr(), style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic))),
            Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Text(_t('tand.step6_intro'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            
            _creerMenuDeroulant('tand.q6_a', ['tand.na', 'tand.no', 'tand.yes', 'tand.dont_know']),
            _creerMenuDeroulant('tand.q6_b', ['tand.na', 'tand.no', 'tand.yes', 'tand.dont_know']),
            _creerMenuDeroulant('tand.q6_c', ['tand.na', 'tand.no', 'tand.yes', 'tand.dont_know']),
            _creerMenuDeroulant('tand.q6_d', ['tand.na', 'tand.no', 'tand.yes', 'tand.dont_know']),

            if (afficherSuite6) ...[
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('tand.if_yes'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, fontSize: 16)),
                    const SizedBox(height: 10),
                    _creerQuestionChoix('tand.q6_help1'),
                    _creerQuestionChoix('tand.q6_help2'),
                    _creerQuestionChoix('tand.q6_help3'),
                  ],
                ),
              ),
            ]
          ]
        );

      case 7:
        List<String> q7Keys = List.generate(6, (i) => 'tand.q7_${i+1}');
        bool afficherSuite7 = q7Keys.any((q) => reponses[q] == 'tand.yes');
                              
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            _titreSection('tand.step7_title'.tr()), 
            Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Text(_t('tand.step7_intro'), style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic))),
            ...q7Keys.map((q) => _creerQuestionChoix(q)),
            
            if (afficherSuite7) ...[
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('tand.if_yes'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, fontSize: 16)),
                    const SizedBox(height: 10),
                    _creerQuestionChoix('tand.q7_help1'),
                    _creerQuestionChoix('tand.q7_help2'),
                  ],
                ),
              ),
            ]
          ]
        );
      
      case 8:
        List<String> q8Keys = List.generate(3, (i) => 'tand.q8_${i+1}');
        bool afficherSuite8 = q8Keys.any((q) => reponses[q] == 'tand.yes');
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            _titreSection('tand.step8_title'.tr()),
            Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Text(_t('tand.step8_intro'), style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic))), 
            ...q8Keys.map((q) => _creerQuestionChoix(q)),
            if (afficherSuite8) ...[
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('tand.if_yes'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, fontSize: 16)),
                    const SizedBox(height: 10),
                    _creerQuestionChoix('tand.q8_help1'),
                    _creerQuestionChoix('tand.q8_help2'),
                  ],
                ),
              ),
            ]
          ]
        );

      case 9:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_titreSection('tand.step9_title'.tr()), Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Text('tand.step9_intro'.tr(), style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic))), _creerCurseur('tand.q9_slider')]);
      case 10:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_titreSection('tand.step10_title'.tr()), Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Text('tand.step10_intro'.tr(), style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic))), _creerChampTexteMultiligne('tand.q10_text')]);
      case 11:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_titreSection('tand.step11_title'.tr()), Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Text('tand.step11_intro'.tr(), style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic))), _creerChampTexteMultiligne('tand.q11_text')]);
      case 12:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_titreSection('tand.step12_title'.tr()), Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Text('tand.step12_intro'.tr(), style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic))), _creerCurseur('tand.q12_slider')]);
      default:
        return const Text('Erreur : étape inconnue');
    }
  }

  // --- COMPOSANTS DE L'INTERFACE ADAPTÉS POUR LES CLÉS ---

  Widget _creerQuestionAge(String cleId, String cleQuestionTexte) {
    bool pasEncore = reponses['${cleId}_pasEncore'] ?? true;
    String unite = reponses['${cleId}_unite'] ?? 'tand.months';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_t(cleQuestionTexte), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          CheckboxListTile(
            title: Text('tand.not_yet'.tr(), style: const TextStyle(color: Colors.grey)),
            value: pasEncore, activeColor: Colors.grey, controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero,
            onChanged: (bool? valeur) { setState(() { reponses['${cleId}_pasEncore'] = valeur; if (valeur == true) reponses['${cleId}_age'] = null; }); },
          ),
          if (!pasEncore)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 10.0),
              child: Row(
                children: [
                  Expanded(flex: 1, child: TextField(controller: TextEditingController(text: reponses['${cleId}_age']), keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'tand.age'.tr(), border: const OutlineInputBorder(), contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0)), onChanged: (texte) { reponses['${cleId}_age'] = texte; })),
                  const SizedBox(width: 10),
                  Expanded(flex: 2, child: Row(children: [Radio<String>(value: 'tand.months', groupValue: unite, onChanged: (valeur) { setState(() { reponses['${cleId}_unite'] = valeur; }); }), Text('global.months'.tr()), Radio<String>(value: 'tand.years', groupValue: unite, onChanged: (valeur) { setState(() { reponses['${cleId}_unite'] = valeur; }); }), Text('global.years'.tr())])),
                ],
              ),
            ),
          const Divider(), 
        ],
      ),
    );
  }

  Widget _titreSection(String titre) { return Padding(padding: const EdgeInsets.only(top: 10, bottom: 10), child: Text(titre, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary))); }
  
  Widget _creerQuestionChoix(String cleQuestion) { 
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_t(cleQuestion), style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0)),
            value: reponses[cleQuestion],
            hint: Text('tand.select_answer'.tr(), style: const TextStyle(color: Colors.grey)),
            items: ['tand.yes', 'tand.no', 'tand.dont_know'].map((String cle) {
              return DropdownMenuItem<String>(value: cle, child: Text(cle.tr()));
            }).toList(),
            onChanged: (nouvelleValeur) { setState(() { reponses[cleQuestion] = nouvelleValeur; }); }
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
  
  Widget _creerMenuDeroulant(String cleLabel, List<String> clesOptions) { 
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), 
      child: DropdownButtonFormField<String>(
        isExpanded: true, 
        decoration: InputDecoration(labelText: _t(cleLabel), border: const OutlineInputBorder()), 
        value: reponses[cleLabel], 
        items: clesOptions.map((String cle) { 
          return DropdownMenuItem<String>(value: cle, child: Text(_t(cle), overflow: TextOverflow.ellipsis)); 
        }).toList(), 
        onChanged: (nouvelleValeur) { setState(() { reponses[cleLabel] = nouvelleValeur; }); }
      )
    ); 
  }
  
  Widget _creerCurseur(String cle) { 
    double valeurActuelle = reponses[cle] ?? 0.0; 
    return Column(children: [
      Slider(value: valeurActuelle, min: 0, max: 10, divisions: 10, label: valeurActuelle.round().toString(), onChanged: (double valeur) { setState(() { reponses[cle] = valeur; }); }), 
      Text('${'tand.score'.tr()} : ${valeurActuelle.round()} / 10', style: const TextStyle(fontWeight: FontWeight.bold))
    ]); 
  }
  
  Widget _creerChampTexteMultiligne(String cleLabel) { 
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), 
      child: TextField(
        maxLines: 4, 
        decoration: InputDecoration(labelText: _t(cleLabel), alignLabelWithHint: true, border: const OutlineInputBorder()), 
        onChanged: (texte) { reponses[cleLabel] = texte; }
      )
    ); 
  }
}
// ==========================================
// PAGE : MON SUIVI (SCORE TS-CARE INTERACTIF & PUBLIABLE)
// ==========================================

class PageMonSuivi extends StatefulWidget {
  final String nomPatient;
  final int agePatient;
  final String sexePatient;

  const PageMonSuivi({
    super.key,
    required this.nomPatient,
    required this.agePatient,
    required this.sexePatient,
  });

  @override
  State<PageMonSuivi> createState() => _PageMonSuiviState();
}

class _PageMonSuiviState extends State<PageMonSuivi> {
  Map<String, String> reponses = {};

  static const Map<String, int> poidsDomaine = {
    'neuro': 3, 'nephro': 3, 'pneumo': 3, 'tand': 2, 'cardio': 2, 'ophtalmo': 1, 'dermato': 1, 'dentaire': 1,
  };

  double scoreTsCare = -1.0;
  bool alertePrioritaire = false;
  List<Map<String, String>> avertissements = [];

  void _calculerScoreEtAlertes() {
    double scoreNeuro = 0; int nNeuro = 0;
    double scoreTand = 0; int nTand = 0;
    double scoreNephro = 0; int nNephro = 0;
    double scoreDermato = 0; int nDermato = 0;
    double scorePneumo = 0; int nPneumo = 0;
    double scoreOphtalmo = 0; int nOphtalmo = 0;
    double scoreCardio = 0; int nCardio = 0;
    double scoreDentaire = 0; int nDentaire = 0;

    avertissements.clear();
    alertePrioritaire = false;

    void ajouterPoint(String domaine, String? id) {
      if (id == null) return;
      double pt = (id == 'green') ? 1.0 : ((id == 'orange') ? 0.5 : 0.0);
      switch (domaine) {
        case 'neuro': scoreNeuro += pt; nNeuro++; break;
        case 'tand': scoreTand += pt; nTand++; break;
        case 'nephro': scoreNephro += pt; nNephro++; break;
        case 'dermato': scoreDermato += pt; nDermato++; break;
        case 'pneumo': scorePneumo += pt; nPneumo++; break;
        case 'ophtalmo': scoreOphtalmo += pt; nOphtalmo++; break;
        case 'cardio': scoreCardio += pt; nCardio++; break;
        case 'dentaire': scoreDentaire += pt; nDentaire++; break;
      }
    }

    // --- 1. NEUROLOGIE ---
    if (reponses['q1_1'] == 'yes') {
      ajouterPoint('neuro', reponses['q1_2']);
      if (reponses['q1_2'] == 'orange') avertissements.add({'couleur': 'orange', 'message': 'monitoring.warn_eeg'.tr()});
    }
    if (widget.agePatient <= 25) ajouterPoint('tand', reponses['q1_3']); else ajouterPoint('tand', reponses['q1_4']);
    ajouterPoint('neuro', reponses['q1_5']);
    if (reponses['q1_5'] == 'red') alertePrioritaire = true;

    // --- 2. NÉPHROLOGIE ---
    ajouterPoint('nephro', reponses['q2_2']);
    if (reponses['q2_2'] == 'red') alertePrioritaire = true;
    ajouterPoint('nephro', reponses['q2_3']);
    ajouterPoint('nephro', reponses['q2_4']);

    // --- 3. DERMATOLOGIE ---
    if (reponses['q3_1'] == 'yes') {
      ajouterPoint('dermato', 'orange');
      avertissements.add({'couleur': 'orange', 'message': 'monitoring.warn_dermato'.tr()});
    } else if (reponses['q3_1'] == 'no') {
      ajouterPoint('dermato', 'green');
    }

    // --- 4. PNEUMOLOGIE (>= 18 ans) ---
    if (widget.agePatient >= 18) {
      bool isFemme = widget.sexePatient.toLowerCase().contains('fem');
      if (isFemme) ajouterPoint('pneumo', reponses['q4_1']);
      else {
        ajouterPoint('pneumo', reponses['q4_2']);
        if (reponses['q4_2'] == 'orange') alertePrioritaire = true;
      }

      if (reponses['q4_3'] == 'yes') {
        ajouterPoint('pneumo', reponses['q4_4']);
        if (reponses['q4_4'] == 'red') alertePrioritaire = true;
        ajouterPoint('pneumo', reponses['q4_5']);
        ajouterPoint('pneumo', reponses['q4_6']);
      } else if (reponses['q4_3'] == 'no') {
        ajouterPoint('pneumo', reponses['q4_7']);
        if (reponses['q4_7'] == 'red') alertePrioritaire = true;
      } else if (reponses['q4_3'] == 'unknown') {
        avertissements.add({'couleur': 'orange', 'message': 'monitoring.warn_pneumo_doc'.tr()});
      }
    }

    // --- 5. OPHTALMOLOGIE ---
    if (reponses['q5_1'] == 'yes') ajouterPoint('ophtalmo', reponses['q5_2']);
    else if (reponses['q5_1'] == 'no') ajouterPoint('ophtalmo', 'green');

    // --- 6. CARDIOLOGIE (< 12 ans) ---
    if (widget.agePatient < 12) {
      if (reponses['q6_1'] == 'unknown') avertissements.add({'couleur': 'orange', 'message': 'monitoring.warn_cardio_init'.tr()});
      if (reponses['q6_1'] == 'yes') {
        if (reponses['q6_2'] == 'yes') {
          ajouterPoint('cardio', reponses['q6_3']); ajouterPoint('cardio', reponses['q6_4']);
        } else {
          ajouterPoint('cardio', reponses['q6_5']); ajouterPoint('cardio', reponses['q6_6']);
        }
      } else if (reponses['q6_1'] == 'no') ajouterPoint('cardio', 'green');
    }

    // --- 7. DENTAIRE ---
    if (widget.agePatient <= 6) ajouterPoint('dentaire', reponses['q7_1']);
    ajouterPoint('dentaire', reponses['q7_2']);

    double totalScore = 0; int totalPoids = 0;
    void appliquerPoids(String domaine, double score, int nItems) {
      if (nItems > 0) {
        totalScore += (score / nItems) * poidsDomaine[domaine]!;
        totalPoids += poidsDomaine[domaine]!;
      }
    }
    appliquerPoids('neuro', scoreNeuro, nNeuro); appliquerPoids('tand', scoreTand, nTand);
    appliquerPoids('nephro', scoreNephro, nNephro); appliquerPoids('dermato', scoreDermato, nDermato);
    appliquerPoids('pneumo', scorePneumo, nPneumo); appliquerPoids('ophtalmo', scoreOphtalmo, nOphtalmo);
    appliquerPoids('cardio', scoreCardio, nCardio); appliquerPoids('dentaire', scoreDentaire, nDentaire);

    setState(() { scoreTsCare = totalPoids == 0 ? -1.0 : totalScore / totalPoids; });
  }

  String _getInterpretation() {
    if (scoreTsCare == -1.0) return 'monitoring.interpretation'.tr();
    if (scoreTsCare >= 0.85) return 'tscare.score_optimal'.tr();
    if (scoreTsCare >= 0.60) return 'tscare.score_satisfactory'.tr();
    return 'tscare.score_insufficient'.tr();
  }

  Widget _buildModuleConclusion(List<String> questionsLiees) {
    // On récupère les questions qui ne sont pas "green"
    List<String> problemes = questionsLiees.where((q) => 
      reponses.containsKey(q) && reponses[q] != 'green' && reponses[q] != 'yes'
    ).toList();

    if (problemes.isEmpty && !questionsLiees.any((q) => reponses.containsKey(q))) {
      return const SizedBox.shrink();
    }

    bool isOk = problemes.isEmpty;
    bool isCritical = questionsLiees.any((q) => reponses[q] == 'red');

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOk ? Colors.green.withOpacity(0.05) : (isCritical ? Colors.red.withOpacity(0.05) : Colors.orange.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isOk ? Colors.green : (isCritical ? Colors.red : Colors.orange), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne de statut
          Row(
            children: [
              Icon(isOk ? Icons.check_circle : Icons.info, color: isOk ? Colors.green : (isCritical ? Colors.red : Colors.orange)),
              const SizedBox(width: 10),
              Text(
                isOk ? "monitoring.conclusion_ok".tr() : "monitoring.conclusion_warning".tr(),
                style: TextStyle(fontWeight: FontWeight.bold, color: isOk ? Colors.green : (isCritical ? Colors.red : Colors.orange)),
              ),
            ],
          ),
          
          // Détail des actions si non conforme
          if (!isOk) ...[
            const SizedBox(height: 12),
            Text("monitoring.medical_advice_title".tr(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ...problemes.map((q) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Text("• ${('monitoring.action_' + q).tr()}", style: const TextStyle(fontSize: 13)),
            )),
            const Divider(height: 25),
            // Phrase de prudence
            Text(
              "monitoring.disclaimer_text".tr(),
              style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.black54),
            ),
          ],
        ],
      ),
    );
  }

  Color _getScoreColor() {
    if (scoreTsCare == -1.0) return Colors.grey;
    if (scoreTsCare >= 0.85) return Colors.green;
    if (scoreTsCare >= 0.60) return Colors.lightGreen;
    if (scoreTsCare >= 0.40) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text('monitoring.page_title'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildJaugeCard(),
          const SizedBox(height: 20),

          // --- MODULE 1 : NEURO ---
          _construireSection('monitoring.mod_neuro'.tr(), [
            _passerelle('q1_1', 'monitoring.q1_1'.tr(), [{'id': 'yes', 'l': 'global.yes'.tr()}, {'id': 'no', 'l': 'global.no'.tr()}]),
            if (reponses['q1_1'] == 'yes')
              _score('q1_2', 'monitoring.q1_2'.tr(), [{'id': 'green', 'l': 'monitoring.less_1y'.tr()}, {'id': 'orange', 'l': 'monitoring.more_1y'.tr()}]),
            if (widget.agePatient <= 25)
              _score('q1_3', 'monitoring.q1_3'.tr(), [{'id': 'green', 'l': 'monitoring.less_1y'.tr()}, {'id': 'orange', 'l': 'monitoring.more_1y'.tr()}])
            else
              _score('q1_4', 'monitoring.q1_3'.tr(), [{'id': 'green', 'l': 'global.yes'.tr()}, {'id': 'orange', 'l': 'global.no'.tr()}]),
            _score('q1_5', 'monitoring.q1_5'.tr(), widget.agePatient <= 25 
              ? [{'id': 'green', 'l': 'monitoring.less_1y'.tr()}, {'id': 'orange', 'l': 'monitoring.1_3y'.tr()}, {'id': 'red', 'l': 'monitoring.more_3y'.tr()}]
              : [{'id': 'green', 'l': 'monitoring.less_3y'.tr()}, {'id': 'orange', 'l': 'monitoring.more_3y'.tr()}]),
            _buildModuleConclusion(['q1_2', 'q1_3', 'q1_5']), 
            ], 'key_neuro'),

          // --- MODULE 2 : NEPHRO ---
          _construireSection('monitoring.mod_nephro'.tr(), [
            _passerelle('q2_1', 'monitoring.q2_1'.tr(), [{'id': 'yes', 'l': 'global.yes'.tr()}, {'id': 'no', 'l': 'global.no'.tr()}, {'id': 'unknown', 'l': 'global.dont_know'.tr()}]),
            _score('q2_2', 'monitoring.q2_2'.tr(), [{'id': 'green', 'l': 'monitoring.less_1y'.tr()}, {'id': 'orange', 'l': 'monitoring.1_3y'.tr()}, {'id': 'red', 'l': 'monitoring.more_3y'.tr()}]),
            _score('q2_3', 'monitoring.q2_3'.tr(), [{'id': 'green', 'l': 'monitoring.less_1y'.tr()}, {'id': 'orange', 'l': 'monitoring.more_1y'.tr()}]),
            _score('q2_4', 'monitoring.q2_4'.tr(), [{'id': 'green', 'l': 'monitoring.less_1y'.tr()}, {'id': 'orange', 'l': 'monitoring.more_1y'.tr()}]),
            _buildModuleConclusion(['q2_1', 'q2_2', 'q2_3','q2_4']), 
            ], 'key_nephro'),

          // --- MODULE 3 : DERMATO ---
          _construireSection('monitoring.mod_dermato'.tr(), [
            _passerelle('q3_1', 'monitoring.q3_1'.tr(), [{'id': 'yes', 'l': 'global.yes'.tr()}, {'id': 'no', 'l': 'global.no'.tr()}]),
            _buildModuleConclusion(['q3_1']),  
            ], 'key_dermato'),

          // --- MODULE 4 : PNEUMO (Branchements complexes) ---
          if (widget.agePatient >= 18)
            _construireSection('monitoring.mod_pneumo'.tr(), [
              if (widget.sexePatient.toLowerCase().contains('fem')) 
                _score('q4_1', 'monitoring.q4_1'.tr(), [{'id': 'green', 'l': 'global.yes'.tr()}, {'id': 'orange', 'l': 'global.no'.tr()}])
              else 
                _score('q4_2', 'monitoring.q4_2'.tr(), [{'id': 'orange', 'l': 'global.yes'.tr()}, {'id': 'green', 'l': 'global.no'.tr()}]),
              
              _passerelle('q4_3', 'monitoring.q4_3'.tr(), [{'id': 'yes', 'l': 'global.yes'.tr()}, {'id': 'no', 'l': 'global.no'.tr()}, {'id': 'unknown', 'l': 'global.dont_know'.tr()}]),
              
              if (reponses['q4_3'] == 'yes') ...[
                _score('q4_4', 'monitoring.q4_4'.tr(), [{'id': 'green', 'l': 'monitoring.less_2y'.tr()}, {'id': 'orange', 'l': 'monitoring.2_3y'.tr()}, {'id': 'red', 'l': 'monitoring.more_3y'.tr()}]),
                _score('q4_5', 'monitoring.q4_5'.tr(), [{'id': 'green', 'l': 'monitoring.less_1y'.tr()}, {'id': 'orange', 'l': 'monitoring.more_1y'.tr()}]),
                _score('q4_6', 'monitoring.q4_6'.tr(), [{'id': 'green', 'l': 'monitoring.less_1y'.tr()}, {'id': 'orange', 'l': 'monitoring.more_1y'.tr()}]),
              ] else if (reponses['q4_3'] == 'no') ...[
                _score('q4_7', 'monitoring.q4_7'.tr(), [{'id': 'green', 'l': 'monitoring.less_5y'.tr()}, {'id': 'orange', 'l': 'monitoring.5_10y'.tr()}, {'id': 'red', 'l': 'monitoring.more_10y'.tr()}]),
              ],
            _buildModuleConclusion(['q4_1', 'q4_2', 'q4_3', 'q4_2', 'q4_4', 'q4_5', 'q4_6', 'q4_7']), 
            ], 'key_pneumo'),

          // --- MODULE 5 : OPHTALMO ---
          _construireSection('monitoring.mod_ophtalmo'.tr(), [
            _passerelle('q5_1', 'monitoring.q5_1'.tr(), [{'id': 'yes', 'l': 'global.yes'.tr()}, {'id': 'no', 'l': 'global.no'.tr()}]),
            if (reponses['q5_1'] == 'yes')
              _score('q5_2', 'monitoring.q5_2'.tr(), [{'id': 'green', 'l': 'monitoring.less_1y'.tr()}, {'id': 'orange', 'l': 'monitoring.more_1y'.tr()}]),
            _buildModuleConclusion(['q5_1', 'q5_2']), 
           ], 'key_ophtalmo'),

          // --- MODULE 6 : CARDIO (< 12 ans) ---
          if (widget.agePatient < 12)
            _construireSection('monitoring.mod_cardio'.tr(), [
              _passerelle('q6_1', 'monitoring.q6_1'.tr(), [{'id': 'yes', 'l': 'global.yes'.tr()}, {'id': 'no', 'l': 'global.no'.tr()}, {'id': 'unknown', 'l': 'global.dont_know'.tr()}]),
              if (reponses['q6_1'] == 'yes') ...[
                _passerelle('q6_2', 'monitoring.q6_2'.tr(), [{'id': 'yes', 'l': 'global.yes'.tr()}, {'id': 'no', 'l': 'global.no'.tr()}]),
                if (reponses['q6_2'] == 'yes') ...[
                  _score('q6_3', 'monitoring.q6_3'.tr(), [{'id': 'green', 'l': 'monitoring.less_1y'.tr()}, {'id': 'orange', 'l': 'monitoring.more_1y'.tr()}]),
                  _score('q6_4', 'monitoring.q6_4'.tr(), [{'id': 'green', 'l': 'monitoring.less_3y'.tr()}, {'id': 'orange', 'l': 'monitoring.more_3y'.tr()}]),
                ] else ...[
                  _score('q6_5', 'monitoring.q6_3'.tr(), [{'id': 'green', 'l': 'monitoring.less_1y'.tr()}, {'id': 'orange', 'l': 'monitoring.1_3y'.tr()}, {'id': 'red', 'l': 'monitoring.more_3y'.tr()}]),
                  _score('q6_6', 'monitoring.q6_4'.tr(), [{'id': 'green', 'l': 'monitoring.less_3y'.tr()}, {'id': 'orange', 'l': 'monitoring.3_5y'.tr()}, {'id': 'red', 'l': 'monitoring.more_5y'.tr()}]),
                ]
              ],
            _buildModuleConclusion(['q6_1', 'q6_2', 'q6_3', 'q6_4', 'q6_5', 'q6_6']), 
            ], 'key_cardio'),

          // --- MODULE 7 : DENTAIRE ---
          _construireSection('monitoring.mod_dentaire'.tr(), [
            if (widget.agePatient <= 6)
              _score('q7_1', 'monitoring.q7_1'.tr(), [{'id': 'green', 'l': 'global.yes'.tr()}, {'id': 'orange', 'l': 'global.no'.tr()}]),
            _score('q7_2', 'monitoring.q7_2'.tr(), [{'id': 'green', 'l': 'monitoring.less_6m'.tr()}, {'id': 'orange', 'l': 'monitoring.more_6m'.tr()}]),
          _buildModuleConclusion(['q7_1', 'q7_2']), 
          ], 'key_dentaire'),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIAIRES ---
  Widget _buildHeader() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: primaryTeal.withOpacity(0.3))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("monitoring.intro_text".tr(), style: const TextStyle(fontSize: 14)),
            InkWell(
              onTap: () => launchUrl(Uri.parse('https://www.has-sante.fr/jcms/p_3293728/fr/sclerose-tubereuse-de-bourneville')),
              child: Text("monitoring.pnds_link".tr(), style: TextStyle(color: primaryTeal, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJaugeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('monitoring.score_title'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            CircularProgressIndicator(value: scoreTsCare == -1 ? 0 : scoreTsCare, color: _getScoreColor(), strokeWidth: 10),
            const SizedBox(height: 10),
            Text(scoreTsCare == -1 ? '--%' : '${(scoreTsCare * 100).round()}%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _getScoreColor())),
            const SizedBox(height: 10),
            Text(_getInterpretation(), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: _getScoreColor())),
            if (avertissements.isNotEmpty || alertePrioritaire) ...[
              const Divider(height: 30),
              Text("monitoring.vigilance_title".tr(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
              ...avertissements.map((a) => Text("• ${a['message']}", style: const TextStyle(fontSize: 12))),
              if (alertePrioritaire) Text("• ${'monitoring.vigilance_critical'.tr()}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
            ]
          ],
        ),
      ),
    );
  }

  Widget _construireSection(String t, List<Widget> q, String k) {
    return Card(margin: const EdgeInsets.only(bottom: 12), child: ExpansionTile(key: PageStorageKey(k), title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), childrenPadding: const EdgeInsets.all(16), children: q));
  }

  Widget _passerelle(String k, String q, List<Map<String, String>> opts) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(q, style: const TextStyle(fontWeight: FontWeight.bold)),
      Wrap(spacing: 10, children: opts.map((o) => ChoiceChip(label: Text(o['l']!), selected: reponses[k] == o['id'], onSelected: (s) { setState(() { reponses[k] = o['id']!; _calculerScoreEtAlertes(); }); })).toList()),
      const SizedBox(height: 20),
    ]);
  }

  Widget _score(String k, String q, List<Map<String, String>> opts) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(q, style: const TextStyle(fontWeight: FontWeight.bold)),
      ...opts.map((o) => RadioListTile<String>(title: Text(o['l']!), value: o['id']!, groupValue: reponses[k], onChanged: (v) { setState(() { reponses[k] = v!; _calculerScoreEtAlertes(); }); })),
      const SizedBox(height: 20),
    ]);
  }
}

// ==========================================
// PAGE : COMPRENDRE LA STB
// ==========================================
class PageComprendreSTB extends StatelessWidget {
  const PageComprendreSTB({super.key});

  // Fonction pour ouvrir le détail de l'article
  void _ouvrirDetail(BuildContext context, String titre, String texte, String image) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            // Barre de fermeture
            Container(margin: const EdgeInsets.only(top: 12), height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(image, fit: BoxFit.cover, height: 250),
                  ),
                  const SizedBox(height: 24),
                  Text(titre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkNavy)),
                  const SizedBox(height: 16),
                  Text(texte, style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87), textAlign: TextAlign.justify),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: primaryTeal, foregroundColor: Colors.white),
                    child: const Text("Fermer la lecture"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double largeurEcran = MediaQuery.of(context).size.width;
    int nbColonnes = largeurEcran > 900 ? 2 : 1;
    double ratio = largeurEcran > 900 ? 1.4 : 0.9;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(title: Text('understand_tsc.title'.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Titre de la page
            Text('understand_tsc.title'.tr().toUpperCase(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: darkNavy, letterSpacing: 1.2)),
            const SizedBox(height: 5),
            Container(height: 3, width: 50, color: primaryTeal),
            const SizedBox(height: 30),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: nbColonnes,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: ratio,
              children: [
                _buildArticleCard(context, 'understand_tsc.sec1_title'.tr(), 'understand_tsc.sec1_text'.tr(), 'assets/images/principe_stb.jpg'),
                _buildArticleCard(context, 'understand_tsc.sec2_title'.tr(), 'understand_tsc.sec2_text'.tr(), 'assets/images/transmission.jpg'),
                _buildArticleCard(context, 'understand_tsc.sec3_title'.tr(), 'understand_tsc.sec3_text'.tr(), 'assets/images/variabilite.jpg'),
                _buildArticleCard(context, 'understand_tsc.sec4_title'.tr(), 'understand_tsc.sec4_text'.tr(), 'assets/images/empowerment.jpg'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, String title, String text, String imagePath) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell( // Rends la carte cliquable
        onTap: () => _ouvrirDetail(context, title, text, imagePath),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: darkNavy), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[800], height: 1.3), textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis, maxLines: 3),
                    ),
                    const SizedBox(height: 4),
                    // Le bouton ne s'affiche que visuellement ici car toute la carte est cliquable
                    Text("Lire la suite...", style: TextStyle(color: primaryTeal, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// PAGE : FONCTIONNALITÉS À VENIR (WIP)
// ==========================================
class PageFonctionnalite extends StatelessWidget {
  final String titreFocus;
  
  const PageFonctionnalite({super.key, required this.titreFocus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(titreFocus),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.handyman, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            Text(
              'Le module\n"$titreFocus"\nest en cours de développement.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Color(0xFF335061), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Bientôt disponible !',
              style: TextStyle(fontSize: 16, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}


// ==========================================
// PAGE : PRÉPARER MA PROCHAINE VISITE
// ==========================================
class PagePreparerVisite extends StatefulWidget {
  final String nomPatient;
  final int agePatient;
  final String sexePatient;

  const PagePreparerVisite({
    super.key,
    required this.nomPatient,
    required this.agePatient,
    required this.sexePatient,
  });

  @override
  State<PagePreparerVisite> createState() => _PagePreparerVisiteState();
}

class _PagePreparerVisiteState extends State<PagePreparerVisite> {
  // Variables d'état
  bool modeDemoDonneesDisponibles = true;
  String periodeSelectionnee = '1M';
  final List<Map<String, String>> periodes = [
    {'id': '1M', 'label': '1 Mois'},
    {'id': '6M', 'label': '6 Mois'}
  ];

  DateTime maintenant = DateTime.now();
  String dateDuJour = "";

  // Couleurs du thème
  static const Color primaryTeal = Colors.teal;
  static const Color darkNavy = Color(0xFF335061);
  static const Color cardColor = Colors.white;
  static const Color bgColor = Color(0xFFF5F5F5);

  // DONNÉES SIMULÉES (TS-CARE)
  final double scoreTsCareDemo = 0.58; 
  final List<Map<String, dynamic>> alertesMedecinDemo = [
    {'couleur': Colors.red, 'icone': Icons.error, 'domaine': 'Neurologie (IRM)', 'message': 'IRM cérébrale a mettre a jour rapidement.'},
    {'couleur': Colors.orange, 'icone': Icons.info, 'domaine': 'Neurologie (EEG)', 'message': 'Discuter indication de EEG de contrôle.'},
    {'couleur': Colors.orange, 'icone': Icons.info, 'domaine': 'Pneumologie', 'message': 'Consultation pneumologique recommandée.'},
  ];

  // DONNÉES SIMULÉES (Épilepsie)
  final Map<String, int> crises1Mois = {'Tonico-clonique': 5, 'Focale': 4, 'Absence': 3};
  final Map<String, int> crises6Mois = {'Tonico-clonique': 17, 'Focale': 10, 'Absence': 15};

  // Outils TS-CARE
  String _getTsCareLabel(double score) {
    if (score >= 0.85) return "Suivi optimal";
    if (score >= 0.60) return "Suivi satisfaisant";
    if (score >= 0.40) return "Suivi insuffisant";
    return "Suivi critique";
  }

  String _getTsCareMessage(double score) {
    if (score >= 0.85) return "Votre suivi est très bien organisé.";
    if (score >= 0.60) return "Votre suivi est globalement bon.";
    if (score >= 0.40) return "Certains examens sont à mettre à jour.";
    return "Votre suivi nécessite une mise à jour rapide.";
  }

  Color _getTsCareColor(double score) {
    if (score >= 0.85) return Colors.green;
    if (score >= 0.60) return Colors.lightGreen;
    if (score >= 0.40) return Colors.orange;
    return Colors.red;
  }

  PdfColor _getTsCarePdfColor(double score) {
    if (score >= 0.85) return PdfColors.green700;
    if (score >= 0.60) return PdfColors.lightGreen700;
    if (score >= 0.40) return PdfColors.orange700;
    return PdfColors.red700;
  }

  @override
  void initState() {
    super.initState();
    dateDuJour = "${maintenant.day.toString().padLeft(2, '0')}/${maintenant.month.toString().padLeft(2, '0')}/${maintenant.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Préparer ma visite'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.teal),
            tooltip: 'Générer le PDF',
            onPressed: () => _afficherMenuActionPDF(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: cardColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: primaryTeal.withOpacity(0.5))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.medical_information, color: primaryTeal, size: 30),
                        SizedBox(width: 15),
                        Expanded(child: Text('Synthèse pour la consultation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Cette page rassemble vos statistiques cliniques brutes pour le médecin. Le score TS-CARE évalue l\'adhésion aux recommandations PNDS.', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 15),
                    SwitchListTile(
                      title: const Text('Mode Démo : Simuler des données', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                      value: modeDemoDonneesDisponibles,
                      activeColor: primaryTeal,
                      onChanged: (val) => setState(() => modeDemoDonneesDisponibles = val),
                      dense: true,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Générer mon dossier PDF complet'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryTeal, foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => _afficherMenuActionPDF(context),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('1. Bilan du Suivi (Score TS-CARE)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkNavy)), const SizedBox(height: 10), _construireSectionSuivi(), const SizedBox(height: 25),
            const Text('2. Statistiques des Crises', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkNavy)), const SizedBox(height: 10), _construireSectionEpilepsie(), const SizedBox(height: 25),
            const Text('3. Questionnaire TAND', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkNavy)), const SizedBox(height: 10), _construireSectionTand(), const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // WIDGETS UI - TAND COMPLET AVEC CLES TR()
  // ==========================================
  Widget _construireSectionTand() {
    if (!modeDemoDonneesDisponibles) return _carteVide('Aucun dépistage TAND récent.');
    return Card(
      color: cardColor, elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Conclusion & Priorités (Blocs 9 à 12)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryTeal)), const SizedBox(height: 10),
            Container(padding: const EdgeInsets.all(12), width: double.infinity, decoration: BoxDecoration(color: primaryTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_texteGras('${'tand.step9_title'.tr()} : ', '7 / 10', Colors.red.shade700), const SizedBox(height: 8), Text('${'tand.step10_title'.tr()} :', style: const TextStyle(fontWeight: FontWeight.bold)), Text('  1. ${'tand.q3_6'.tr()} (Colère)'), Text('  2. ${'tand.q3_19'.tr()} (Sommeil)'), Text('  3. ${'tand.q3_15'.tr()} (Attention)'), const SizedBox(height: 8), _texteGras('${'tand.step11_title'.tr()} : ', 'tand.no'.tr(), Colors.black87), const SizedBox(height: 4), _texteGras('${'tand.step12_title'.tr()} : ', '6 / 10', Colors.black87)])), const SizedBox(height: 20),
            
            const Text('Détails du dépistage complet (Blocs 1 à 8)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryTeal)), const Divider(),
            
            _blocTandTr('tand.step1_title'.tr(), {
              'tand.q1_a_text'.tr(): '2 ${'tand.months'.tr()}', 'tand.q1_b_text'.tr(): '9 ${'tand.months'.tr()}', 'tand.q1_c_text'.tr(): '22 ${'tand.months'.tr()}', 
              'tand.q1_d_text'.tr(): '24 ${'tand.months'.tr()}', 'tand.q1_e_text'.tr(): 'tand.not_yet'.tr(), 'tand.q1_f_text'.tr(): 'tand.not_yet'.tr(), 'tand.q1_g_text'.tr(): 'tand.not_yet'.tr(),
            }),
            _blocTandTr('tand.step2_title'.tr(), {
              'tand.q2_lang'.tr(): 'tand.q2_lang_opt2'.tr(), 'tand.q2_auto'.tr(): 'tand.q2_auto_opt2'.tr(), 'tand.q2_mob'.tr(): 'tand.q2_mob_opt4'.tr(),
            }),
            _blocTandTr('tand.step3_title'.tr(), {
              'tand.q3_1'.tr(): 'tand.yes'.tr(), 'tand.q3_2'.tr(): 'tand.no'.tr(), 'tand.q3_3'.tr(): 'tand.no'.tr(), 'tand.q3_4'.tr(): 'tand.yes'.tr(), 'tand.q3_5'.tr(): 'tand.no'.tr(), 'tand.q3_6'.tr(): 'tand.yes'.tr(), 'tand.q3_7'.tr(): 'tand.no'.tr(), 'tand.q3_8'.tr(): 'tand.no'.tr(), 'tand.q3_9'.tr(): 'tand.yes'.tr(), 'tand.q3_10'.tr(): 'tand.no'.tr(), 'tand.q3_11'.tr(): 'tand.yes'.tr(), 'tand.q3_12'.tr(): 'tand.no'.tr(), 'tand.q3_13'.tr(): 'tand.yes'.tr(), 'tand.q3_14'.tr(): 'tand.no'.tr(), 'tand.q3_15'.tr(): 'tand.yes'.tr(), 'tand.q3_16'.tr(): 'tand.no'.tr(), 'tand.q3_17'.tr(): 'tand.yes'.tr(), 'tand.q3_18'.tr(): 'tand.no'.tr(), 'tand.q3_19'.tr(): 'tand.yes'.tr(),
            }),
            _blocTandTr('tand.step4_title'.tr(), {
              'tand.q4_1'.tr(): 'tand.no'.tr(), 'tand.q4_2'.tr(): 'tand.yes'.tr(), 'tand.q4_3'.tr(): 'tand.no'.tr(), 'tand.q4_4'.tr(): 'tand.no'.tr(), 'tand.q4_5'.tr(): 'tand.no'.tr(), 'tand.q4_6'.tr(): 'tand.no'.tr(),
            }),
            _blocTandTr('tand.step5_title'.tr(), {
              'tand.q5_a'.tr(): 'tand.yes'.tr(), 'tand.q5_b'.tr(): 'tand.no'.tr(), 'tand.q5_c'.tr(): 'tand.q5_c_opt2'.tr(),
            }),
            _blocTandTr('tand.step6_title'.tr(), {
              'tand.q6_a'.tr(): 'tand.yes'.tr(), 'tand.q6_b'.tr(): 'tand.yes'.tr(), 'tand.q6_c'.tr(): 'tand.yes'.tr(), 'tand.q6_d'.tr(): 'tand.yes'.tr(),
            }),
            _blocTandTr('tand.step7_title'.tr(), {
              'tand.q7_1'.tr(): 'tand.no'.tr(), 'tand.q7_2'.tr(): 'tand.yes'.tr(), 'tand.q7_3'.tr(): 'tand.yes'.tr(), 'tand.q7_4'.tr(): 'tand.no'.tr(), 'tand.q7_5'.tr(): 'tand.no'.tr(), 'tand.q7_6'.tr(): 'tand.no'.tr(),
            }),
            _blocTandTr('tand.step8_title'.tr(), {
              'tand.q8_1'.tr(): 'tand.yes'.tr(), 'tand.q8_2'.tr(): 'tand.no'.tr(), 'tand.q8_3'.tr(): 'tand.no'.tr(),
            }),
          ],
        ),
      ),
    );
  }

  Widget _texteGras(String label, String valeur, Color couleurValeur) => RichText(text: TextSpan(style: const TextStyle(fontSize: 13, color: Colors.black87), children: [TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: valeur, style: TextStyle(fontWeight: FontWeight.bold, color: couleurValeur))])); 

  Widget _blocTandTr(String titre, Map<String, String> elements) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: darkNavy)), const SizedBox(height: 4),
          ...elements.entries.map((e) {
            bool estPositif = e.value == 'tand.yes'.tr() || e.value == 'tand.not_yet'.tr() || e.value.contains('tand.q5_c_opt2'.tr()) || e.value.contains(RegExp(r'[0-9]'));
            return Padding(padding: const EdgeInsets.only(left: 8.0, bottom: 4.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: const EdgeInsets.only(top: 4, right: 8), child: Icon(Icons.circle, size: 8, color: estPositif ? Colors.orange : Colors.grey.shade400)), Expanded(child: Text("${e.key} : ${e.value}", style: TextStyle(fontSize: 12, color: estPositif ? Colors.orange.shade900 : Colors.black87, fontWeight: estPositif ? FontWeight.bold : FontWeight.normal)))]));
          })
        ],
      ),
    );
  }

  // ==========================================
  // WIDGETS UI : SUIVI & ÉPILEPSIE
  // ==========================================
  Widget _construireSectionSuivi() {
    if (!modeDemoDonneesDisponibles) return _carteVide('Aucun bilan disponible.');
    Color cScore = _getTsCareColor(scoreTsCareDemo);
    return Card(
      color: cardColor, elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Column(children: [Stack(alignment: Alignment.center, children: [SizedBox(height: 90, width: 90, child: CircularProgressIndicator(value: scoreTsCareDemo, backgroundColor: Colors.grey.shade200, color: cScore, strokeWidth: 8)), Text('${(scoreTsCareDemo * 100).round()}%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cScore))]), const SizedBox(height: 15), Text(_getTsCareLabel(scoreTsCareDemo).toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: cScore)), const SizedBox(height: 4), Text('"${_getTsCareMessage(scoreTsCareDemo)}"', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13, color: Colors.black87), textAlign: TextAlign.center)])), const SizedBox(height: 20),
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('Comprendre le score TS-CARE :', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: darkNavy)), SizedBox(height: 5), Text('🟢 ≥ 85% : Suivi optimal\n🟡 60-84% : Suivi satisfaisant\n🟠 40-59% : Suivi insuffisant\n🔴 < 40% : Suivi critique', style: TextStyle(fontSize: 11))])), const SizedBox(height: 20), const Divider(), const SizedBox(height: 10), const Text('Points à discuter :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: darkNavy)), const SizedBox(height: 15),
            ...alertesMedecinDemo.map((alerte) => Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(alerte['icone'], color: alerte['couleur'], size: 24), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(alerte['domaine'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: alerte['couleur'])), const SizedBox(height: 4), Text(alerte['message'], style: const TextStyle(fontSize: 13, color: Colors.black87))]))]))),
          ],
        ),
      ),
    );
  }

  Widget _construireSectionEpilepsie() {
    if (!modeDemoDonneesDisponibles) return _carteVide('Aucune donnée enregistrée.');
    return Card(color: cardColor, elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Container(padding: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: periodes.map((p) => ChoiceChip(label: Text(p['label']!, style: TextStyle(fontSize: 12, fontWeight: periodeSelectionnee == p['id'] ? FontWeight.bold : FontWeight.normal, color: periodeSelectionnee == p['id'] ? Colors.white : darkNavy)), selectedColor: primaryTeal, selected: periodeSelectionnee == p['id'], onSelected: (bool selected) { if (selected) setState(() => periodeSelectionnee = p['id']!); })).toList())), const SizedBox(height: 20), if (periodeSelectionnee == '1M') _construireStats(is1Mois: true) else _construireStats(is1Mois: false)])));
  }

  Widget _construireStats({required bool is1Mois}) {
    String periodeStr = is1Mois ? 'le dernier mois' : 'les 6 derniers mois';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Résumé sur $periodeStr', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_kpiCard('Total crises', is1Mois ? '12' : '42', Colors.red.shade400), _kpiCard('Jours sans crise', is1Mois ? '24' : '145', primaryTeal), _kpiCard('Accalmie max', is1Mois ? '11 jours' : '38 jours', darkNavy)]), const SizedBox(height: 20),
        const Text('Graphique d\'évolution (Crises Uniquement)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), const SizedBox(height: 10), 
        Wrap(spacing: 10, runSpacing: 5, children: [
          Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.square, color: Colors.red.shade400, size: 14), const SizedBox(width: 4), const Text('Tonico-clonique', style: TextStyle(fontSize: 12))]),
          Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.square, color: Colors.purple.shade400, size: 14), const SizedBox(width: 4), const Text('Focale', style: TextStyle(fontSize: 12))]),
          Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.square, color: Colors.blue.shade400, size: 14), const SizedBox(width: 4), const Text('Absence', style: TextStyle(fontSize: 12))]),
        ]),
        const SizedBox(height: 15),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)), child: const Center(child: Text('Le tableau statistique et le graphique détaillé sont disponibles dans l\'export PDF.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)))),
      ],
    );
  }

  Widget _carteVide(String texte) => Card(color: cardColor, child: Padding(padding: const EdgeInsets.all(16.0), child: Column(children: [const Icon(Icons.info_outline, size: 40, color: Colors.grey), const SizedBox(height: 10), Text(texte, textAlign: TextAlign.center)])));
  Widget _kpiCard(String titre, String valeur, Color couleur) => Expanded(child: Card(color: couleur.withOpacity(0.1), elevation: 0, child: Padding(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8), child: Column(children: [Text(titre, style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.bold), textAlign: TextAlign.center), const SizedBox(height: 5), Text(valeur, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: couleur))]))));

  // ==========================================
  // EXPORT PDF (MOTEUR AMÉLIORÉ ET EXHAUSTIF)
  // ==========================================
  void _afficherMenuActionPDF(BuildContext context) {
    showModalBottomSheet(context: context, backgroundColor: bgColor, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (BuildContext bottomSheetContext) {
      return Padding(padding: const EdgeInsets.all(20.0), child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Options du Rapport PDF', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy)), const SizedBox(height: 20),
        ListTile(leading: const Icon(Icons.visibility, color: Colors.teal), title: const Text('Visualiser le PDF'), onTap: () { Navigator.pop(bottomSheetContext); Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(appBar: AppBar(title: const Text('Aperçu du dossier')), body: PdfPreview(build: (format) => _genererDocumentPDF(), allowPrinting: false, allowSharing: false)))); }), const Divider(),
        ListTile(leading: const Icon(Icons.print, color: Colors.blueGrey), title: const Text('Imprimer le document'), onTap: () async { Navigator.pop(bottomSheetContext); final pdfBytes = await _genererDocumentPDF(); await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes); }), const Divider(),
      ]));
    });
  }

  // Nettoyage radical des apostrophes
  String _nettoyerTextePDF(String text) {
    return text.replaceAll(RegExp(r"['’‘`´]"), " ");
  }

  Future<Uint8List> _genererDocumentPDF() async {
    final pdf = pw.Document();
    PdfColor pdfColorScore = _getTsCarePdfColor(scoreTsCareDemo);

    // DONNÉES DU GRAPHIQUE (Dures en dur pour l'exemple)
    List<Map<String, dynamic>> dataBarres1Mois = List.generate(30, (index) {
      int r=0, p=0, b=0;
      if (index == 14) { r=1; p=1; } else if (index == 24) { b=1; } else if (index == 27) { p=1; }
      return {'label': (index+1).toString(), 'R': r, 'P': p, 'B': b};
    });
    
    List<Map<String, dynamic>> dataBarres6Mois = [
      {'label': 'M-5', 'R': 5, 'P': 3, 'B': 4},
      {'label': 'M-4', 'R': 4, 'P': 2, 'B': 5},
      {'label': 'M-3', 'R': 2, 'P': 2, 'B': 2},
      {'label': 'M-2', 'R': 0, 'P': 1, 'B': 1},
      {'label': 'M-1', 'R': 0, 'P': 0, 'B': 0},
      {'label': 'Mois Act.', 'R': 1, 'P': 2, 'B': 1},
    ];

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4, 
      margin: const pw.EdgeInsets.all(32), 
      build: (pw.Context context) {
        return [
          // EN TÊTE
          pw.Container(padding: const pw.EdgeInsets.all(15), decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF335061), borderRadius: pw.BorderRadius.all(pw.Radius.circular(8))), child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('Carnet STB - Synthese Medicale', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.white)), pw.Text('Edite le : $dateDuJour', style: const pw.TextStyle(fontSize: 10, color: PdfColors.white))])), pw.SizedBox(height: 20),
          
          // PDF SCORE TS-CARE
          pw.Text('Bilan du Suivi (Score TS-CARE)', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF335061))), pw.Divider(color: const PdfColor.fromInt(0xFF7DBEA5)), pw.SizedBox(height: 10),
          if (!modeDemoDonneesDisponibles) 
            pw.Text('Aucun score recent.') 
          else ...[
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(color: PdfColors.grey100, border: pw.Border.all(color: pdfColorScore, width: 2), borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8))),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Indice TS-CARE : ${(scoreTsCareDemo * 100).round()}% - ${_nettoyerTextePDF(_getTsCareLabel(scoreTsCareDemo))}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: pdfColorScore)),
                  pw.SizedBox(height: 5),
                  pw.Text('Legende : >= 85% Optimal | 60-84% Satisfaisant | 40-59% Insuffisant | < 40% Critique', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                  pw.SizedBox(height: 5),
                  pw.Text('"${_nettoyerTextePDF(_getTsCareMessage(scoreTsCareDemo))}"', style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic, color: PdfColors.black)),
                ]
              )
            ),
            pw.SizedBox(height: 15),
            pw.Text(_nettoyerTextePDF("Plan pour la consultation :"), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.black)), pw.SizedBox(height: 8),
            ...alertesMedecinDemo.map((alerte) => pw.Padding(padding: const pw.EdgeInsets.only(bottom: 8.0), child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [pw.Container(width: 6, height: 6, margin: const pw.EdgeInsets.only(top: 3, right: 8), decoration: pw.BoxDecoration(shape: pw.BoxShape.circle, color: alerte['couleur'] == Colors.red ? PdfColors.red : PdfColors.orange)), pw.Expanded(child: pw.Text(_nettoyerTextePDF('${alerte['domaine']} : ${alerte['message']}'), style: const pw.TextStyle(fontSize: 10, color: PdfColors.black)))]))),
          ],
          pw.SizedBox(height: 30),

          // PDF EPILEPSIE & GRAPHIQUES (AVEC TABLEAUX)
          pw.Container(padding: const pw.EdgeInsets.all(10), decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF335061), borderRadius: pw.BorderRadius.all(pw.Radius.circular(8))), child: pw.Text(_nettoyerTextePDF("Statistiques des crises (Sans traitements)"), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.white))), pw.SizedBox(height: 15),
          
          // LÉGENDE DU GRAPHIQUE
          pw.Row(children: [
            pw.Container(width: 8, height: 8, color: PdfColors.red400), pw.SizedBox(width: 4), pw.Text('Tonico-clonique', style: const pw.TextStyle(fontSize: 9)), pw.SizedBox(width: 15),
            pw.Container(width: 8, height: 8, color: PdfColors.purple400), pw.SizedBox(width: 4), pw.Text('Focale', style: const pw.TextStyle(fontSize: 9)), pw.SizedBox(width: 15),
            pw.Container(width: 8, height: 8, color: PdfColors.blue400), pw.SizedBox(width: 4), pw.Text('Absence', style: const pw.TextStyle(fontSize: 9)),
          ]),
          pw.SizedBox(height: 15),

          // GRAPHIQUE 1 MOIS
          pw.Text('Evolution sur 1 Mois (Derniers 30 Jours)', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF7DBEA5))), pw.SizedBox(height: 10), 
          _creerStats1MPDF(),
          pw.SizedBox(height: 15),
          _creerGraphiqueBarresEmpileesPDF(dataBarres1Mois, 120, false), // 120px height, false = barres fines
          pw.SizedBox(height: 30),
          
          // GRAPHIQUE 6 MOIS
          pw.Text('Evolution sur 6 Mois', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF7DBEA5))), pw.SizedBox(height: 10), 
          _creerStats6MPDF(),
          pw.SizedBox(height: 15),
          _creerGraphiqueBarresEmpileesPDF(dataBarres6Mois, 160, true), // 160px height, true = barres larges

          pw.NewPage(),

          // PDF TAND (EXHAUSTIF AVEC TOUTES LES QUESTIONS)
          pw.Container(padding: const pw.EdgeInsets.all(10), decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF335061), borderRadius: pw.BorderRadius.all(pw.Radius.circular(8))), child: pw.Text('Questionnaire TAND (Details du Depistage)', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.white))), pw.SizedBox(height: 15),
          if (!modeDemoDonneesDisponibles) pw.Text('Aucun depistage TAND recent.') else ..._genererContenuTandPDF(),
        ];
    }));
    return pdf.save();
  }

  // TABLEAUX PDF
  pw.Widget _creerStats1MPDF() { 
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.white), 
      headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF7DBEA5)), 
      cellStyle: const pw.TextStyle(fontSize: 10), 
      cellAlignment: pw.Alignment.centerLeft, 
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100), 
      data: [
        [_nettoyerTextePDF('Metrique (30 Jours)'), _nettoyerTextePDF('Donnees Enregistrees')], 
        [_nettoyerTextePDF('Total / Jours sans crise'), _nettoyerTextePDF('12 crises au total / 24 jours sans crise')], 
        [_nettoyerTextePDF('Types de crises'), _nettoyerTextePDF('5 TC, 4 Focales, 3 Absences')],
        [_nettoyerTextePDF('Freq. Avant J15 (Sabril 500mg)'), _nettoyerTextePDF('10 crises (0.6 / jour)')], 
        [_nettoyerTextePDF('Freq. Apres J15 (Sabril 1000mg)'), _nettoyerTextePDF('2 crises (0.1 / jour)')]
      ]
    ); 
  }

  pw.Widget _creerStats6MPDF() { 
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.white), 
      headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF7DBEA5)), 
      cellStyle: const pw.TextStyle(fontSize: 10), 
      cellAlignment: pw.Alignment.centerLeft, 
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100), 
      data: [
        [_nettoyerTextePDF('Metrique (6 Mois)'), _nettoyerTextePDF('Donnees Enregistrees')], 
        [_nettoyerTextePDF('Total / Jours sans crise'), _nettoyerTextePDF('42 crises au total / 145 jours sans crise')], 
        [_nettoyerTextePDF('Types de crises'), _nettoyerTextePDF('17 TC, 10 Focales, 15 Absences')],
        [_nettoyerTextePDF('M-6 a M-4 (Micropakine)'), _nettoyerTextePDF('35 crises (11.6 / mois)')], 
        [_nettoyerTextePDF('M-3 a M-1 (Urbanyl)'), _nettoyerTextePDF('7 crises (2.3 / mois)')], 
        [_nettoyerTextePDF('M-1 Avant (Sabril 500)'), _nettoyerTextePDF('4 crises (8.0 / mois)')], 
        [_nettoyerTextePDF('M-1 Apres (Sabril 1000)'), _nettoyerTextePDF('0 crise (0.0 / mois)')]
      ]
    ); 
  }

  // NOUVEAU GRAPHIQUE PDF : PLUS GRAND ET LISIBLE AVEC AXE Y
  pw.Widget _creerGraphiqueBarresEmpileesPDF(List<Map<String, dynamic>> data, double height, bool isLarge) {
    int maxTotal = 1;
    for (var d in data) {
      int total = (d['R'] as int) + (d['P'] as int) + (d['B'] as int);
      if (total > maxTotal) maxTotal = total;
    }
    // Arrondir au multiple de 5 supérieur pour un bel axe Y
    maxTotal = ((maxTotal / 5).ceil() * 5);
    if (maxTotal <= 0) maxTotal = 5;

    return pw.Container(
      height: height,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300), borderRadius: pw.BorderRadius.circular(8), color: PdfColors.white),
      child: pw.Row(
        children: [
          // Axe Y (Nombres)
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(maxTotal.toString(), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
              pw.Text((maxTotal ~/ 2).toString(), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
              pw.Text('0', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
              pw.SizedBox(height: 12), // Espace pour aligner avec l'axe X
            ]
          ),
          pw.SizedBox(width: 8),
          // Zone du Graphique
          pw.Expanded(
            child: pw.Stack(
              children: [
                // Lignes de fond (Grille)
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Divider(color: PdfColors.grey200, thickness: 1),
                    pw.Divider(color: PdfColors.grey200, thickness: 1),
                    pw.Divider(color: PdfColors.grey400, thickness: 1),
                    pw.SizedBox(height: 12),
                  ]
                ),
                // Les Barres de données
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: data.map((d) {
                    int r = d['R'] as int;
                    int p = d['P'] as int;
                    int b = d['B'] as int;
                    int total = r + p + b;
                    String label = d['label'];

                    double availableHeight = height - 34; // Soustrait les marges internes
                    double totalHeight = (total / maxTotal) * availableHeight;
                    double rH = total > 0 ? (r / total) * totalHeight : 0;
                    double pH = total > 0 ? (p / total) * totalHeight : 0;
                    double bH = total > 0 ? (b / total) * totalHeight : 0;

                    return pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        if (total > 0) pw.Text(total.toString(), style: pw.TextStyle(fontSize: isLarge ? 8 : 6, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
                        pw.SizedBox(height: 2),
                        pw.Container(
                          width: isLarge ? 20 : 8, // Barres plus larges pour les 6 mois, fines pour 30 jours
                          height: totalHeight > 0 ? totalHeight : 1, 
                          child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              if (bH > 0) pw.Container(height: bH, color: PdfColors.blue400),
                              if (pH > 0) pw.Container(height: pH, color: PdfColors.purple400),
                              if (rH > 0) pw.Container(height: rH, color: PdfColors.red400),
                            ]
                          )
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(_nettoyerTextePDF(label), style: pw.TextStyle(fontSize: isLarge ? 8 : 6, color: PdfColors.grey700)),
                      ]
                    );
                  }).toList(),
                )
              ]
            )
          )
        ]
      )
    );
  }

  // TAND PDF 100% EXHAUSTIF (Questions 1_a à 8_3) AVEC CLÉS DE TRADUCTION
  List<pw.Widget> _genererContenuTandPDF() {
    return [
      pw.Text('Patient : ${widget.nomPatient}  |  Age : ${widget.agePatient} ans  |  Date : $dateDuJour', style: const pw.TextStyle(fontSize: 10)), pw.SizedBox(height: 10),
      
      _titreSectionPdf('tand.step1_title'.tr()),
      _itemPdf('tand.q1_a_text'.tr(), '2 ${'tand.months'.tr()}', false),
      _itemPdf('tand.q1_b_text'.tr(), '9 ${'tand.months'.tr()}', false),
      _itemPdf('tand.q1_c_text'.tr(), '22 ${'tand.months'.tr()}', false),
      _itemPdf('tand.q1_d_text'.tr(), '24 ${'tand.months'.tr()}', false),
      _itemPdf('tand.q1_e_text'.tr(), 'tand.not_yet'.tr(), true),
      _itemPdf('tand.q1_f_text'.tr(), 'tand.not_yet'.tr(), true),
      _itemPdf('tand.q1_g_text'.tr(), 'tand.not_yet'.tr(), true),

      _titreSectionPdf('tand.step2_title'.tr()),
      _itemPdf('tand.q2_lang'.tr(), 'tand.q2_lang_opt2'.tr(), false),
      _itemPdf('tand.q2_auto'.tr(), 'tand.q2_auto_opt2'.tr(), false),
      _itemPdf('tand.q2_mob'.tr(), 'tand.q2_mob_opt4'.tr(), false),

      _titreSectionPdf('tand.step3_title'.tr()),
      _itemPdf('tand.q3_1'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q3_2'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q3_3'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q3_4'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q3_5'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q3_6'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q3_7'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q3_8'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q3_9'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q3_10'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q3_11'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q3_12'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q3_13'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q3_14'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q3_15'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q3_16'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q3_17'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q3_18'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q3_19'.tr(), 'tand.yes'.tr(), true),

      _titreSectionPdf('tand.step4_title'.tr()),
      _itemPdf('tand.q4_1'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q4_2'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q4_3'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q4_4'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q4_5'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q4_6'.tr(), 'tand.no'.tr(), false),

      _titreSectionPdf('tand.step5_title'.tr()),
      _itemPdf('tand.q5_a'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q5_b'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q5_c'.tr(), 'tand.q5_c_opt2'.tr(), true),

      _titreSectionPdf('tand.step6_title'.tr()),
      _itemPdf('tand.q6_a'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q6_b'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q6_c'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q6_d'.tr(), 'tand.yes'.tr(), true),

      _titreSectionPdf('tand.step7_title'.tr()),
      _itemPdf('tand.q7_1'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q7_2'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q7_3'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q7_4'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q7_5'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q7_6'.tr(), 'tand.no'.tr(), false),

      _titreSectionPdf('tand.step8_title'.tr()),
      _itemPdf('tand.q8_1'.tr(), 'tand.yes'.tr(), true),
      _itemPdf('tand.q8_2'.tr(), 'tand.no'.tr(), false),
      _itemPdf('tand.q8_3'.tr(), 'tand.no'.tr(), false),
    ];
  }

  pw.Widget _titreSectionPdf(String titre) { return pw.Container(width: double.infinity, margin: const pw.EdgeInsets.only(top: 8, bottom: 6), padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8), decoration: const pw.BoxDecoration(color: PdfColors.blueGrey50, borderRadius: pw.BorderRadius.all(pw.Radius.circular(4))), child: pw.Text(_nettoyerTextePDF(titre), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: PdfColors.blueGrey800))); }
  pw.Widget _itemPdf(String question, String reponse, bool estPositif) { return pw.Padding(padding: const pw.EdgeInsets.only(bottom: 4), child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [pw.Container(width: 4, height: 4, margin: const pw.EdgeInsets.only(top: 4, right: 6, left: 10), decoration: pw.BoxDecoration(shape: pw.BoxShape.circle, color: estPositif ? PdfColors.orange : PdfColors.grey400)), pw.SizedBox(width: 250, child: pw.Text(_nettoyerTextePDF(question), style: const pw.TextStyle(fontSize: 10, color: PdfColors.black))), pw.Expanded(child: pw.Text(_nettoyerTextePDF(reponse), style: pw.TextStyle(fontSize: 10, fontWeight: estPositif ? pw.FontWeight.bold : pw.FontWeight.normal, color: estPositif ? PdfColors.red800 : PdfColors.grey700)))])); }
}
// ==========================================
// PAGE : MES CRISES D'ÉPILEPSIE
// ==========================================
class PageMesCrises extends StatefulWidget {
  const PageMesCrises({super.key});
  @override
  State<PageMesCrises> createState() => _PageMesCrisesState();
}

class _PageMesCrisesState extends State<PageMesCrises> {
  String periodeSelectionnee = '1M';
  final List<String> periodes = ['1S', '1M', '6M', '1A', 'TOUT'];
  String dateDuJour = ""; 
  String heureActuelle = ""; 
  DateTime maintenant = DateTime.now();

  @override
  void initState() {
    super.initState();
    dateDuJour = "${maintenant.day.toString().padLeft(2, '0')}/${maintenant.month.toString().padLeft(2, '0')}/${maintenant.year}";
    heureActuelle = "${maintenant.hour.toString().padLeft(2, '0')}:${maintenant.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          title: Text('seizures.title'.tr()),
          bottom: TabBar(
            labelColor: primaryTeal,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryTeal,
            tabs: [
              Tab(icon: const Icon(Icons.add_circle_outline), text: 'seizures.tab_add'.tr()), 
              Tab(icon: const Icon(Icons.list_alt), text: 'seizures.tab_history'.tr()), 
              Tab(icon: const Icon(Icons.insights), text: 'seizures.tab_chart'.tr())
            ]
          )
        ),
        body: TabBarView(children: [_construireOngletSaisie(), _construireOngletHistorique(), _construireOngletGraphique()]),
      ),
    );
  }

  Widget _construireOngletSaisie() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Expanded(child: TextFormField(initialValue: heureActuelle, decoration: InputDecoration(labelText: 'seizures.input_time'.tr(), border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.access_time)))), const SizedBox(width: 10), Expanded(child: TextFormField(initialValue: dateDuJour, decoration: InputDecoration(labelText: 'seizures.input_date'.tr(), border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.calendar_today))))]), const SizedBox(height: 15),
          DropdownButtonFormField<String>(decoration: InputDecoration(labelText: 'seizures.input_type'.tr(), border: const OutlineInputBorder()), items: ['Tonico-clonique', 'Focale', 'Absence', 'Myoclonie', 'Spasme'].map((String val) => DropdownMenuItem(value: val, child: Text(val))).toList(), onChanged: (val) {}), const SizedBox(height: 15),
          TextFormField(decoration: InputDecoration(labelText: 'seizures.input_context'.tr(), border: const OutlineInputBorder())), const SizedBox(height: 15),
          Row(children: [Expanded(child: TextFormField(decoration: InputDecoration(labelText: 'seizures.input_duration'.tr(), border: const OutlineInputBorder()))), const SizedBox(width: 10), Expanded(child: TextFormField(initialValue: '1', decoration: InputDecoration(labelText: 'seizures.input_cluster'.tr(), border: const OutlineInputBorder())))]), const SizedBox(height: 15),
          Text('seizures.emergency_actions'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: darkNavy)), 
          CheckboxListTile(title: Text('seizures.rescue_meds'.tr()), value: false, activeColor: primaryTeal, onChanged: (val) {}, controlAffinity: ListTileControlAffinity.leading), 
          CheckboxListTile(title: Text('seizures.call_doctor'.tr()), value: false, activeColor: primaryTeal, onChanged: (val) {}, controlAffinity: ListTileControlAffinity.leading), 
          CheckboxListTile(title: Text('seizures.hospital_transfer'.tr()), value: false, activeColor: primaryTeal, onChanged: (val) {}, controlAffinity: ListTileControlAffinity.leading),
          const SizedBox(height: 20), 
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Crise enregistrée !'))); }, icon: const Icon(Icons.save), label: Text('seizures.save_seizure'.tr(), style: const TextStyle(fontSize: 16)), style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), backgroundColor: primaryTeal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))))
        ],
      ),
    );
  }

  Widget _construireOngletHistorique() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('seizures.tab_history'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkNavy)), ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.picture_as_pdf, size: 18), label: Text('global.btn_export'.tr()), style: ElevatedButton.styleFrom(backgroundColor: primaryTeal.withOpacity(0.1), foregroundColor: primaryTeal, elevation: 0))]), const SizedBox(height: 15),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Aujourd\'hui', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))), _creerCarteCrise('14:30', '3 min', 'Tonico-clonique', 'Fatigue extrême', 'Buccolam (14:32)', Colors.red.shade400), _creerCarteCrise('10:15', '45 sec', 'Focale', 'Aucun', 'Aucun', Colors.purple.shade400), _creerCarteCrise('08:05', '1 min', 'Focale', 'Réveil', 'Aucun', Colors.purple.shade400),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Hier', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))), _creerCarteCrise('18:20', '15 sec', 'Absence', 'Devoirs', 'Aucun', Colors.blue.shade400), _creerCarteCrise('09:00', '10 sec', 'Absence', 'École', 'Aucun', Colors.blue.shade400),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Il y a 3 jours', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))), _creerCarteCrise('23:45', '6 min', 'Tonico-clonique', 'Fièvre 39°C', 'Aimant VNS + Samu', Colors.red.shade400),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Semaine dernière', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))), _creerCarteCrise('15:32', '8 min', 'Myoclonie', 'Cluster', 'Aimant VNS (15:37)', Colors.orange.shade400), _creerCarteCrise('11:10', '20 sec', 'Absence', 'Aucun', 'Aucun', Colors.blue.shade400),
      ],
    );
  }

  Widget _creerCarteCrise(String heure, String duree, String type, String contexte, String urgence, Color couleurType) {
    return Card(margin: const EdgeInsets.only(bottom: 8), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)), color: cardColor, child: Padding(padding: const EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(Icons.access_time, size: 16, color: Colors.grey.shade700), const SizedBox(width: 5), Text(heure, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: darkNavy))]), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: couleurType.withAlpha(30), borderRadius: BorderRadius.circular(8)), child: Text(type, style: TextStyle(color: couleurType, fontWeight: FontWeight.bold, fontSize: 12)))]), const SizedBox(height: 8), Row(children: [const Icon(Icons.timer_outlined, size: 16, color: Colors.grey), const SizedBox(width: 4), Text('Durée : $duree', style: const TextStyle(fontSize: 13)), const SizedBox(width: 15), const Icon(Icons.info_outline, size: 16, color: Colors.grey), const SizedBox(width: 4), Text(contexte, style: const TextStyle(fontSize: 13))]), if (urgence != 'Aucun') ...[const SizedBox(height: 8), Container(padding: const EdgeInsets.all(6), width: double.infinity, decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)), child: Text('Urgence : $urgence', style: TextStyle(color: Colors.red.shade900, fontSize: 12, fontWeight: FontWeight.bold)))]])));
  }

  Widget _construireOngletGraphique() {
    double maxX = _getMaxX(); 
    List<BarChartGroupData> donneesCrises = _getDonneesCrises(); 
    double maxCrisesY = 0;
    for (var group in donneesCrises) { if (group.barRods.isNotEmpty && group.barRods.first.toY > maxCrisesY) maxCrisesY = group.barRods.first.toY; }
    maxCrisesY = maxCrisesY > 0 ? (maxCrisesY * 1.2).ceilToDouble() : 5;
    bool montrerMicropakine = ['6M', '1A', 'TOUT'].contains(periodeSelectionnee);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: periodes.map((p) => ChoiceChip(
              label: Text(p, style: TextStyle(fontWeight: periodeSelectionnee == p ? FontWeight.bold : FontWeight.normal)),
              selected: periodeSelectionnee == p,
              onSelected: (bool selected) {
                if (selected) setState(() => periodeSelectionnee = p);
              },
            )).toList(),
          ),
        ),
        
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Évolution des Traitements (ASM)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Icon(Icons.medication, color: Colors.grey.shade400)
                ],
              ),
              const SizedBox(height: 15),
              
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    _creerGraphiqueTraitement('Sabril (mg)', Colors.purple, 1500, _getSpotsSabril(maxX), maxX),
                    const Divider(height: 20),
                    _creerGraphiqueTraitement('Votubia (mg)', Colors.teal, 10, [FlSpot(0, 5), FlSpot(maxX, 5)], maxX, isDashed: true),
                    
                    if (montrerMicropakine) ...[
                      const Divider(height: 20),
                      _creerGraphiqueTraitement('Micropakine', Colors.red, 500, _getSpotsMicropakine(maxX), maxX),
                    ],

                    const Divider(height: 20),
                    _creerGraphiqueTraitement('Urbanyl (mg)', Colors.blue, 20, _getSpotsUrbanyl(maxX), maxX),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              const Text('Fréquence et types de crises', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              Wrap(
                spacing: 10, runSpacing: 5,
                children: [
                  _legende(Colors.red, 'Tonico-clonique'),
                  _legende(Colors.purple, 'Focale'),
                  _legende(Colors.blue, 'Absence'),
                ],
              ),
              const SizedBox(height: 15),

              Container(
                height: 250,
                padding: const EdgeInsets.only(top: 16, bottom: 8), 
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 85,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('Nombre\nde crises', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceBetween,
                          maxY: maxCrisesY,
                          minY: 0,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true, 
                                reservedSize: 25, 
                                getTitlesWidget: (value, meta) {
                                  if(value == 0) return const SizedBox.shrink();
                                  return SideTitleWidget(
                                    meta: meta, // On ne garde que meta
                                    child: Text(value.toInt().toString(), style: const TextStyle(color: Colors.grey, fontSize: 10))
                                  );
                                }
                              )
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true, reservedSize: 35, getTitlesWidget: (v, m) => const SizedBox.shrink())
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: _getTitresAxeX,
                                reservedSize: 30,
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1)),
                          barGroups: donneesCrises,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text(_genererConclusionClinique(), style: const TextStyle(color: Colors.teal, fontStyle: FontStyle.italic)),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Widget _creerGraphiqueTraitement(String nom, Color couleur, double maxY, List<FlSpot> spots, double maxX, {bool isDashed = false}) {
    double intervalY = maxY > 0 ? maxY / 2 : 1;
    return SizedBox(height: 60, child: Row(children: [SizedBox(width: 85, child: Padding(padding: const EdgeInsets.only(left: 8.0), child: Text(nom, style: TextStyle(color: couleur, fontWeight: FontWeight.bold, fontSize: 11)))), Expanded(child: LineChart(LineChartData(minX: 0, maxX: maxX, minY: 0, maxY: maxY, gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: intervalY, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1)), borderData: FlBorderData(show: false), titlesData: FlTitlesData(leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 35, interval: intervalY, getTitlesWidget: (value, meta) { if (value == 0 || value == maxY || value == maxY / 2) return SideTitleWidget( meta: meta, child: Text('${value.toInt()}', style: TextStyle(color: Colors.grey.shade500, fontSize: 10))); return const SizedBox.shrink(); })), topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false))), lineBarsData: [LineChartBarData(spots: spots, isCurved: false, color: couleur, barWidth: 2, dotData: const FlDotData(show: false), dashArray: isDashed ? [5, 5] : null)], lineTouchData: const LineTouchData(enabled: false))))]));
  }

  double _getMaxX() { switch (periodeSelectionnee) { case '1S': return 6; case '1M': return 29; case '6M': return 5; case '1A': return 11; case 'TOUT': return 4; default: return 6; } }
  List<FlSpot> _getSpotsMicropakine(double maxX) { if (periodeSelectionnee == '6M') { return [FlSpot(0, 500), FlSpot(2, 500), FlSpot(2, 0), FlSpot(maxX, 0)]; } else if (periodeSelectionnee == '1A') { return [FlSpot(0, 500), FlSpot(8, 500), FlSpot(8, 0), FlSpot(maxX, 0)]; } else { return [FlSpot(0, 500), FlSpot(3.8, 500), FlSpot(3.8, 0), FlSpot(maxX, 0)]; } }
  List<FlSpot> _getSpotsSabril(double maxX) { if (periodeSelectionnee == '1S') { return [FlSpot(0, 1000), FlSpot(maxX, 1000)]; } else if (periodeSelectionnee == '1M') { return [FlSpot(0, 500), FlSpot(14, 500), FlSpot(14, 1000), FlSpot(maxX, 1000)]; } else if (periodeSelectionnee == '6M') { return [FlSpot(0, 500), FlSpot(4.5, 500), FlSpot(4.5, 1000), FlSpot(maxX, 1000)]; } else if (periodeSelectionnee == '1A') { return [FlSpot(0, 500), FlSpot(10.5, 500), FlSpot(10.5, 1000), FlSpot(maxX, 1000)]; } else { return [FlSpot(0, 500), FlSpot(maxX - 0.1, 500), FlSpot(maxX - 0.1, 1000), FlSpot(maxX, 1000)]; } }
  List<FlSpot> _getSpotsUrbanyl(double maxX) { if (periodeSelectionnee == '1S' || periodeSelectionnee == '1M') { return [FlSpot(0, 10), FlSpot(maxX, 10)]; } else if (periodeSelectionnee == '6M') { return [FlSpot(0, 0), FlSpot(2, 0), FlSpot(2, 10), FlSpot(maxX, 10)]; } else if (periodeSelectionnee == '1A') { return [FlSpot(0, 0), FlSpot(8, 0), FlSpot(8, 10), FlSpot(maxX, 10)]; } else { return [FlSpot(0, 0), FlSpot(3.8, 0), FlSpot(3.8, 10), FlSpot(maxX, 10)]; } }

  Widget _getTitresAxeX(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10); 
    String texte = ''; 
    int val = value.toInt();
    switch (periodeSelectionnee) {
      case '1S': DateTime date = maintenant.subtract(Duration(days: 6 - val)); texte = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}'; break;
      case '1M': if (val % 6 == 0 || val == 29) { DateTime date = maintenant.subtract(Duration(days: 29 - val)); texte = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}'; } break;
      case '6M': DateTime date = DateTime(maintenant.year, maintenant.month - (5 - val), 1); texte = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'][(date.month - 1) % 12]; break;
      case '1A': DateTime date12 = DateTime(maintenant.year, maintenant.month - (11 - val), 1); texte = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'][(date12.month - 1) % 12]; break;
      case 'TOUT': if (val >= 0 && val < 5) texte = ['2022', '2023', '2024', '2025', '2026'][val]; break;
    }
    return SideTitleWidget(
      meta: meta, // AJOUT DE L'ARGUMENT MANQUANT
      child: Text(texte, style: style)
    );
  }

  List<BarChartGroupData> _getDonneesCrises() {
    List<BarChartGroupData> barres = []; 
    int max = _getMaxX().toInt();
    
    for (int i = 0; i <= max; i++) {
      double rouge = 0; double violet = 0; double bleu = 0;
      if (periodeSelectionnee == '1S') { if (i == 4) violet = 1; } 
      else if (periodeSelectionnee == '1M') { if (i == 14) { rouge = 1; violet = 1; } if (i == 24) bleu = 1; if (i == 27) violet = 1; } 
      else if (periodeSelectionnee == '6M') { if (i == 0) { rouge = 5; violet = 3; bleu = 4; } if (i == 1) { rouge = 4; violet = 2; bleu = 5; } if (i == 2) { rouge = 2; violet = 2; bleu = 2; } if (i == 3) { rouge = 0; violet = 1; bleu = 1; } if (i == 4) { rouge = 0; violet = 0; bleu = 0; } if (i == 5) { rouge = 1; violet = 2; bleu = 1; } } 
      else if (periodeSelectionnee == '1A') { if (i < 8) { rouge = 6; violet = 4; bleu = 5; } if (i == 8) { rouge = 2; violet = 2; bleu = 2; } if (i == 9) { rouge = 0; violet = 1; bleu = 1; } if (i == 10) { rouge = 0; violet = 0; bleu = 0; } if (i == 11) { rouge = 1; violet = 2; bleu = 1; } } 
      else if (periodeSelectionnee == 'TOUT') { if (i == 0) { rouge = 30; violet = 20; bleu = 40; } if (i == 1) { rouge = 25; violet = 15; bleu = 35; } if (i == 2) { rouge = 20; violet = 15; bleu = 30; } if (i == 3) { rouge = 15; violet = 10; bleu = 20; } if (i == 4) { rouge = 1; violet = 2; bleu = 2; } }
      
      barres.add(
        BarChartGroupData(
          x: i, 
          barRods: [
            BarChartRodData(
              toY: rouge + violet + bleu, 
              width: periodeSelectionnee == '1M' ? 6 : 12, 
              borderRadius: BorderRadius.circular(2), 
              color: Colors.transparent, 
              rodStackItems: (rouge + violet + bleu) > 0 ? [
                BarChartRodStackItem(0, rouge, Colors.red.shade400), 
                BarChartRodStackItem(rouge, rouge + violet, Colors.purple.shade400), 
                BarChartRodStackItem(rouge + violet, rouge + violet + bleu, Colors.blue.shade400)
              ] : []
            )
          ]
        )
      );
    }
    return barres;
  }

  String _genererConclusionClinique() { return (periodeSelectionnee == '1S' || periodeSelectionnee == '1M') ? "L'augmentation du Sabril effectuee il y a 15 jours semble avoir rapidement stabilise la frequence des crises." : "L'arret de la Micropakine et l'introduction de l'Urbanyl (il y a 3 mois) sont correles a une baisse tres nette des crises tonico-cloniques."; }
  Widget _legende(Color couleur, String texte) { return Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 12, height: 12, decoration: BoxDecoration(color: couleur, borderRadius: BorderRadius.circular(3))), const SizedBox(width: 4), Text(texte, style: const TextStyle(fontSize: 12))]); }
}