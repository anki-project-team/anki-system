import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/screens/login_screen.dart';
import 'package:ihk_ap1_prep/screens/register_screen.dart';
import 'package:ihk_ap1_prep/models/card_model.dart';
import 'purchase_screen.dart';

const _bg = Color(0xFF162447);
const _accent = Color(0xFFE8813A);
const _card = Color(0xFF1e3a5f);
const _green = Color(0xFF22C55E);

final List<CardModel> _freeCards = [
  CardModel(id: 'free-001', question: 'Was sind die 7 Schichten des OSI-Modells?', shortAnswer: 'Physical, Data Link, Network, Transport, Session, Presentation, Application (Schicht 1–7).', longAnswer: 'Merkhilfe: "Pls Do Not Throw Sausage Pizza Away"\n\nSchicht 1 — Physical: Kabel, Signale\nSchicht 2 — Data Link: MAC-Adressen, Switch\nSchicht 3 — Network: IP-Adressen, Router\nSchicht 4 — Transport: TCP/UDP, Ports\nSchicht 5 — Session: Verbindungsaufbau\nSchicht 6 — Presentation: Verschlüsselung, Kodierung\nSchicht 7 — Application: HTTP, FTP, DNS', url: 'https://de.wikipedia.org/wiki/OSI-Modell', hashtags: ['#Netzwerk', '#OSI', '#Protokolle', '#AP1']),
  CardModel(id: 'free-002', question: 'Was ist der Unterschied zwischen TCP und UDP?', shortAnswer: 'TCP: verbindungsorientiert, zuverlässig, langsamer. UDP: verbindungslos, schneller, kein Empfangsbestätigung.', longAnswer: 'TCP (Transmission Control Protocol):\n• 3-Wege-Handshake (SYN, SYN-ACK, ACK)\n• Fehlerkorrektur und Wiederholung\n• Reihenfolgegarantie\n• Geeignet: HTTP, E-Mail, Dateiübertragung\n\nUDP (User Datagram Protocol):\n• Kein Verbindungsaufbau\n• Kein Fehler-Handling\n• Geeignet: Streaming, DNS, VoIP', url: 'https://de.wikipedia.org/wiki/Transmission_Control_Protocol', hashtags: ['#Netzwerk', '#TCP', '#UDP', '#Protokolle', '#AP1']),
  CardModel(id: 'free-003', question: 'Was ist DHCP und wie funktioniert es (DORA)?', shortAnswer: 'DHCP verteilt IP-Adressen automatisch. DORA: Discover → Offer → Request → Acknowledge.', longAnswer: 'DORA-Prozess:\n1. Discover: Client sucht DHCP-Server (Broadcast)\n2. Offer: Server bietet IP-Adresse an\n3. Request: Client fordert die IP an\n4. Acknowledge: Server bestätigt die Vergabe\n\nPort 67 (Server) / Port 68 (Client)\nLeasetime: Adresse ist nur temporär vergeben', url: 'https://de.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol', hashtags: ['#Netzwerk', '#DHCP', '#IP-Adressierung', '#AP1']),
  CardModel(id: 'free-004', question: 'Was sind private IPv4-Adressbereiche?', shortAnswer: '10.0.0.0/8 | 172.16.0.0/12 | 192.168.0.0/16 — nicht im Internet geroutet (RFC 1918).', longAnswer: 'Private Adressbereiche (RFC 1918):\n• 10.0.0.0 – 10.255.255.255 (/8) → Klasse A\n• 172.16.0.0 – 172.31.255.255 (/12) → Klasse B\n• 192.168.0.0 – 192.168.255.255 (/16) → Klasse C\n\nWichtig: Diese Adressen werden nicht ins Internet geroutet.\nNAT übersetzt zwischen privaten und öffentlichen Adressen.', url: 'https://de.wikipedia.org/wiki/Private_IP-Adresse', hashtags: ['#Netzwerk', '#IPv4', '#IP-Adressierung', '#AP1']),
  CardModel(id: 'free-005', question: 'Was ist DNS und welche Eintragstypen gibt es?', shortAnswer: 'DNS löst Domainnamen in IPs auf. A (IPv4), AAAA (IPv6), MX (Mail), CNAME (Alias), NS (Nameserver).', longAnswer: 'DNS = Domain Name System (Port 53)\n\nEintragstypen:\n• A-Record: Domain → IPv4 (www → 93.184.216.34)\n• AAAA-Record: Domain → IPv6\n• MX-Record: Mailserver für Domain\n• CNAME: Alias (www → myapp.hosting.com)\n• NS-Record: Zuständiger Nameserver\n• TXT-Record: Textinformationen (SPF, DKIM)', url: 'https://de.wikipedia.org/wiki/Domain_Name_System', hashtags: ['#Netzwerk', '#DNS', '#Protokolle', '#AP1']),
  CardModel(id: 'free-006', question: 'Was ist der Unterschied zwischen Hub, Switch und Router?', shortAnswer: 'Hub: alle Ports (L1). Switch: MAC-basiert (L2). Router: IP-basiert (L3), verbindet Netzwerke.', longAnswer: 'Hub (Schicht 1):\n• Leitet Pakete an ALLE Ports weiter\n• Kollisionsdomäne für alle Geräte\n\nSwitch (Schicht 2):\n• Lernt MAC-Adressen\n• Sendet nur an Zielport (MAC-Table)\n• Eigene Kollisionsdomäne pro Port\n\nRouter (Schicht 3):\n• Verbindet verschiedene Netzwerke\n• Wertet IP-Adressen aus\n• Routing-Tabelle für Wegentscheidung', url: 'https://de.wikipedia.org/wiki/Router', hashtags: ['#Netzwerk', '#Hardware', '#Switch', '#Router', '#AP1']),
  CardModel(id: 'free-007', question: 'Was ist VPN und welche Arten gibt es?', shortAnswer: 'Virtual Private Network — verschlüsselter Tunnel über das Internet. Arten: Site-to-Site, Remote-Access, SSL-VPN.', longAnswer: 'VPN-Arten:\n• Site-to-Site VPN: Verbindet zwei Standorte (Firmennetz)\n• Remote-Access VPN: Einzelner Nutzer ins Firmennetz\n• SSL-VPN: Browserbasiert, kein Client nötig\n\nProtokolle:\n• IPsec: Sicher, komplex, für Site-to-Site\n• OpenVPN: Open Source, flexibel\n• WireGuard: Modern, schnell, einfach', url: 'https://de.wikipedia.org/wiki/Virtual_Private_Network', hashtags: ['#Netzwerk', '#VPN', '#IT-Sicherheit', '#AP1']),
  CardModel(id: 'free-008', question: 'Was sind wichtige Ports für Standard-Protokolle?', shortAnswer: 'HTTP:80 | HTTPS:443 | FTP:21 | SSH:22 | SMTP:25 | DNS:53 | DHCP:67/68 | RDP:3389', longAnswer: 'Wichtige Ports für die AP1-Prüfung:\n\nWeb: HTTP 80 | HTTPS 443\nMail: SMTP 25/587 | POP3 110 | IMAP 143\nDatei: FTP 21 | SFTP 22\nVerwaltung: SSH 22 | Telnet 23 | RDP 3389\nDienste: DNS 53 | DHCP 67/68 | SNMP 161\n\nMerke: Port < 1024 = Well-Known Ports', url: 'https://de.wikipedia.org/wiki/Liste_der_Portnummern', hashtags: ['#Netzwerk', '#Protokolle', '#Ports', '#AP1']),
  CardModel(id: 'free-009', question: 'Was ist der Unterschied zwischen IPv4 und IPv6?', shortAnswer: 'IPv4: 32 Bit, 4,3 Mrd. Adressen. IPv6: 128 Bit, praktisch unbegrenzt, kein NAT nötig.', longAnswer: 'IPv4:\n• 32 Bit = 4.294.967.296 Adressen\n• Adressknappheit → NAT als Lösung\n• Notation: 192.168.1.1\n\nIPv6:\n• 128 Bit = 340 Sextillionen Adressen\n• Kein NAT nötig\n• Notation: 2001:0db8:85a3::8a2e:0370:7334\n• Automatische Konfiguration (SLAAC)\n• Integriertes IPsec', url: 'https://de.wikipedia.org/wiki/IPv6', hashtags: ['#Netzwerk', '#IPv6', '#IPv4', '#IP-Adressierung', '#AP1']),
  CardModel(id: 'free-010', question: 'Was ist Cloud Computing und was sind SaaS, IaaS, PaaS?', shortAnswer: 'SaaS: fertige Software. IaaS: gemietete Infrastruktur. PaaS: Entwicklungsplattform in der Cloud.', longAnswer: 'Cloud-Servicemodelle:\n\nSaaS (Software as a Service):\n→ Fertige Anwendungen | Beispiel: Gmail, Office 365\n\nPaaS (Platform as a Service):\n→ Entwicklungsumgebung | Beispiel: Heroku, Firebase\n\nIaaS (Infrastructure as a Service):\n→ Virtuelle Server/Speicher | Beispiel: AWS EC2, Azure\n\nDeployment-Modelle: Public, Private, Hybrid Cloud', url: 'https://de.wikipedia.org/wiki/Cloud_Computing', hashtags: ['#Netzwerk', '#Cloud', '#SaaS', '#IaaS', '#PaaS', '#AP1']),
];

class FreeTrialScreen extends StatefulWidget {
  const FreeTrialScreen({super.key});

  @override
  State<FreeTrialScreen> createState() => _FreeTrialScreenState();
}

class _FreeTrialScreenState extends State<FreeTrialScreen> {
  bool _showOverview = true;
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _erklaerungOpen = false;
  bool _weiterlernOpen = false;

  void _startLearning() {
    setState(() {
      _showOverview = false;
      _currentIndex = 0;
      _showAnswer = false;
    });
  }

  void _nextCard() {
    if (_currentIndex < _freeCards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
        _erklaerungOpen = false;
        _weiterlernOpen = false;
      });
    } else {
      _showUpgradeSheet();
    }
  }

  void _showUpgradeSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _UpgradeSheet(
        onRegister: () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const RegisterScreen()));
        },
        onReplay: () {
          Navigator.pop(context);
          setState(() {
            _currentIndex = 0;
            _showAnswer = false;
            _showOverview = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showOverview) return _buildOverview();
    final card = _freeCards[_currentIndex];
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: !_showAnswer
            ? _buildQuestionView(card)
            : _buildAnswerView(card),
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // MODULE OVERVIEW — wie das Mockup
  // ══════════════════════════════════════════════════════
  Widget _buildOverview() {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white70, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text('LF', style: TextStyle(
                            color: Colors.white, fontSize: 10,
                            fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Learn-Factory',
                        style: TextStyle(color: Colors.white,
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('GRATIS-MODUL',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),

              // Icon + Badge + Titel
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
                child: Column(
                  children: [
                    Container(
                      width: 72, height: 72,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2a4a6f),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                          child: Text('💻', style: TextStyle(fontSize: 32))),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: _green.withValues(alpha: 0.6), width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('KOSTENLOS · OHNE LOGIN',
                          style: TextStyle(color: _green,
                              fontSize: 10, fontWeight: FontWeight.w700,
                              letterSpacing: 0.5)),
                    ),
                    const SizedBox(height: 12),
                    const Text('Grundlagen IT',
                        style: TextStyle(color: Colors.white,
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Dein Einstieg in die IHK AP1-Prüfung',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats + Vorschau Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Stats Row
                      Row(
                        children: [
                          _statItem('${_freeCards.length}', 'Karten'),
                          Container(width: 1, height: 28,
                              color: Colors.white.withValues(alpha: 0.1)),
                          _statItem('4', 'Themen'),
                          Container(width: 1, height: 28,
                              color: Colors.white.withValues(alpha: 0.1)),
                          _statItem('~15', 'Minuten'),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Divider
                      Divider(color: Colors.white.withValues(alpha: 0.08),
                          height: 1),
                      const SizedBox(height: 12),

                      // Vorschau Fragen
                      _previewRow('Was sind die 7 Schichten des OSI-Modells?'),
                      _previewRow('Unterschied zwischen TCP und UDP'),
                      _previewRow('DHCP und der DORA-Prozess'),
                      _previewRow('Private IPv4-Adressbereiche'),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 4),
                        child: Text(
                            '+ ${_freeCards.length - 4} weitere Karten',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.3),
                                fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // FSRS Hinweis
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: _green.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: _green.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('FSRS 4.5 Algorithmus aktiv',
                                style: TextStyle(color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                            Text('Optimale Wiederholung berechnet',
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.45),
                                    fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Jetzt lernen Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                    onPressed: _startLearning,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Jetzt lernen →',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text('Kein Login nötig · Sofort starten · Kein Abo',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 11)),
              const SizedBox(height: 16),

              // Upgrade Teaser
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => const PurchaseScreen())),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: _accent.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Alle 24 Module freischalten',
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                  '450+ Karten · Simulator · Statistik',
                                  style: TextStyle(
                                      color: Colors.white
                                          .withValues(alpha: 0.4),
                                      fontSize: 11)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('29,99€',
                              style: TextStyle(color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(color: _accent,
                  fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 10)),
        ],
      ),
    );
  }

  Widget _previewRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 6, height: 6,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: _green),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // QUESTION VIEW — Dark Navy
  // ══════════════════════════════════════════════════════
  Widget _buildQuestionView(CardModel card) {
    final total = _freeCards.length;
    return Column(
      children: [
        // Header
        Container(
          color: _bg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _showOverview = true),
                child: const Icon(Icons.close,
                    color: Colors.white70, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Grundlagen IT',
                    style: TextStyle(color: Colors.white,
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              Text('${_currentIndex + 1} / $total',
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 13)),
            ],
          ),
        ),

        // Progress
        LinearProgressIndicator(
          value: (_currentIndex + 1) / total,
          backgroundColor: _card,
          valueColor: const AlwaysStoppedAnimation<Color>(_accent),
          minHeight: 4,
        ),

        // Card
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: _accent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.help_outline,
                          color: _accent, size: 26),
                    ),
                    const SizedBox(height: 20),
                    Text(card.question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20,
                            fontWeight: FontWeight.bold, height: 1.4)),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: () => setState(() => _showAnswer = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Antwort zeigen →',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════
  // ANSWER VIEW — Dark Navy
  // ══════════════════════════════════════════════════════
  Widget _buildAnswerView(CardModel card) {
    return Column(
      children: [
        // Header
        Container(
          color: _bg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _showOverview = true),
                child: const Icon(Icons.close,
                    color: Colors.white70, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Grundlagen IT',
                    style: TextStyle(color: Colors.white,
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              Text('${_currentIndex + 1} / ${_freeCards.length}',
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 13)),
            ],
          ),
        ),

        // Progress
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _freeCards.length,
          backgroundColor: _card,
          valueColor: const AlwaysStoppedAnimation<Color>(_accent),
          minHeight: 4,
        ),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Text('AKTUELLE KARTE',
                    style: TextStyle(color: _accent, fontSize: 10,
                        fontWeight: FontWeight.w700, letterSpacing: 1)),
                const SizedBox(height: 8),

                // Frage
                Text(card.question,
                    style: const TextStyle(color: Colors.white,
                        fontSize: 18, fontWeight: FontWeight.bold,
                        height: 1.4)),
                const SizedBox(height: 16),

                // KERNANTWORT
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(12),
                    border: const Border(
                      left: BorderSide(color: _accent, width: 3),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.star, color: _accent, size: 14),
                        const SizedBox(width: 6),
                        const Text('KERNANTWORT',
                            style: TextStyle(color: _accent, fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1)),
                      ]),
                      const SizedBox(height: 10),
                      Text(card.shortAnswer,
                          style: const TextStyle(color: Colors.white,
                              fontSize: 15, height: 1.5)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Erklärungen Accordion
                if (card.longAnswer.isNotEmpty)
                  _accordion(
                    icon: Icons.menu_book_outlined,
                    title: 'Erklärungen',
                    subtitle: 'Ausführliche Erklärung',
                    isOpen: _erklaerungOpen,
                    onTap: () => setState(
                        () => _erklaerungOpen = !_erklaerungOpen),
                    child: Text(card.longAnswer,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13, height: 1.6)),
                  ),
                const SizedBox(height: 8),

                // Weiterlernen Accordion
                if (card.url.isNotEmpty)
                  _accordion(
                    icon: Icons.open_in_new_outlined,
                    title: 'Weiterlernen',
                    subtitle: '1 Link · Wikipedia',
                    isOpen: _weiterlernOpen,
                    onTap: () => setState(
                        () => _weiterlernOpen = !_weiterlernOpen),
                    child: Row(children: [
                      const Icon(Icons.link, size: 14, color: _accent),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(card.url,
                            style: const TextStyle(
                                fontSize: 12, color: _accent)),
                      ),
                    ]),
                  ),
                const SizedBox(height: 12),

                // Hashtags
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: card.hashtags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(tag,
                        style: const TextStyle(
                            color: _accent, fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  )).toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // Rating Buttons
        Container(
          color: _card,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            children: [
              Text('Wie gut kennst du diese Karte?',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text('WÄHLE EIN INTERVALL',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 10, fontWeight: FontWeight.w600,
                      letterSpacing: 0.5)),
              const SizedBox(height: 10),
              Row(children: [
                _ratingBtn('Nochmal', '<1Min',
                    const Color(0xFFEF4444)),
                const SizedBox(width: 6),
                _ratingBtn('Schwer', '<10Min',
                    const Color(0xFFF59E0B)),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                _ratingBtn('Gut', '4 Tage',
                    const Color(0xFF22C55E)),
                const SizedBox(width: 6),
                _ratingBtn('Einfach', '14 Tage',
                    _accent),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _accordion({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isOpen,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(children: [
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: isOpen
                ? const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))
                : BorderRadius.circular(12),
          ),
          child: Row(children: [
            Icon(icon, size: 18,
                color: Colors.white.withValues(alpha: 0.5)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(color: Colors.white,
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 11)),
                ],
              ),
            ),
            Icon(isOpen
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
                color: Colors.white.withValues(alpha: 0.4)),
          ]),
        ),
      ),
      if (isOpen)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: child,
        ),
    ]);
  }

  Widget _ratingBtn(String label, String interval, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: _nextCard,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(children: [
            Text(label,
                style: TextStyle(fontSize: 13,
                    fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(interval,
                style: TextStyle(fontSize: 11,
                    color: color.withValues(alpha: 0.7))),
          ]),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// UPGRADE SHEET — nach den 10 Karten
// ══════════════════════════════════════════════════════
class _UpgradeSheet extends StatelessWidget {
  final VoidCallback onRegister;
  final VoidCallback onReplay;

  const _UpgradeSheet({
    required this.onRegister,
    required this.onReplay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events,
                color: _accent, size: 32),
          ),
          const SizedBox(height: 14),
          const Text('Alle 10 Karten gemeistert! 🎉',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Text(
            'Du hast gerade erlebt was Learn-Factory einzigartig macht:\n'
            'Kernantwort · Erklärung · Links · Hashtags\n\n'
            'Registriere dich kostenlos für ein komplettes Modul '
            'oder schalte alle 24 Module frei.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.6),
                height: 1.6),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: onRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Kostenlos registrieren →',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity, height: 44,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => const PurchaseScreen()));
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: _accent,
                side: BorderSide(
                    color: _accent.withValues(alpha: 0.4)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Vollversion — 29,99€',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onReplay,
              child: Text('Nochmal spielen',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 13)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
