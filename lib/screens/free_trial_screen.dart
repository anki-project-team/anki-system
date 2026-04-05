import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/screens/login_screen.dart';
import 'package:ihk_ap1_prep/models/card_model.dart';

final List<CardModel> _freeCards = [
  CardModel(id: 'free-001', question: 'Was sind die 7 Schichten des OSI-Modells?', shortAnswer: 'Physical, Data Link, Network, Transport, Session, Presentation, Application (Schicht 1–7).', longAnswer: 'Merkhilfe: "Pls Do Not Throw Sausage Pizza Away"\\n\\nSchicht 1 — Physical: Kabel, Signale\\nSchicht 2 — Data Link: MAC-Adressen, Switch\\nSchicht 3 — Network: IP-Adressen, Router\\nSchicht 4 — Transport: TCP/UDP, Ports\\nSchicht 5 — Session: Verbindungsaufbau\\nSchicht 6 — Presentation: Verschlüsselung, Kodierung\\nSchicht 7 — Application: HTTP, FTP, DNS', url: 'https://de.wikipedia.org/wiki/OSI-Modell', hashtags: ['#Netzwerk', '#OSI', '#Protokolle', '#AP1']),
  CardModel(id: 'free-002', question: 'Was ist der Unterschied zwischen TCP und UDP?', shortAnswer: 'TCP: verbindungsorientiert, zuverlässig, langsamer. UDP: verbindungslos, schneller, kein Empfangsbestätigung.', longAnswer: 'TCP (Transmission Control Protocol):\\n• 3-Wege-Handshake (SYN, SYN-ACK, ACK)\\n• Fehlerkorrektur und Wiederholung\\n• Reihenfolgegarantie\\n• Geeignet: HTTP, E-Mail, Dateiübertragung\\n\\nUDP (User Datagram Protocol):\\n• Kein Verbindungsaufbau\\n• Kein Fehler-Handling\\n• Geeignet: Streaming, DNS, VoIP', url: 'https://de.wikipedia.org/wiki/Transmission_Control_Protocol', hashtags: ['#Netzwerk', '#TCP', '#UDP', '#Protokolle', '#AP1']),
  CardModel(id: 'free-003', question: 'Was ist DHCP und wie funktioniert es (DORA)?', shortAnswer: 'DHCP verteilt IP-Adressen automatisch. DORA: Discover → Offer → Request → Acknowledge.', longAnswer: 'DORA-Prozess:\\n1. Discover: Client sucht DHCP-Server (Broadcast)\\n2. Offer: Server bietet IP-Adresse an\\n3. Request: Client fordert die IP an\\n4. Acknowledge: Server bestätigt die Vergabe\\n\\nPort 67 (Server) / Port 68 (Client)\\nLeasetime: Adresse ist nur temporär vergeben', url: 'https://de.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol', hashtags: ['#Netzwerk', '#DHCP', '#IP-Adressierung', '#AP1']),
  CardModel(id: 'free-004', question: 'Was sind private IPv4-Adressbereiche?', shortAnswer: '10.0.0.0/8 | 172.16.0.0/12 | 192.168.0.0/16 — nicht im Internet geroutet (RFC 1918).', longAnswer: 'Private Adressbereiche (RFC 1918):\\n• 10.0.0.0 – 10.255.255.255 (/8) → Klasse A\\n• 172.16.0.0 – 172.31.255.255 (/12) → Klasse B\\n• 192.168.0.0 – 192.168.255.255 (/16) → Klasse C\\n\\nWichtig: Diese Adressen werden nicht ins Internet geroutet.\\nNAT übersetzt zwischen privaten und öffentlichen Adressen.', url: 'https://de.wikipedia.org/wiki/Private_IP-Adresse', hashtags: ['#Netzwerk', '#IPv4', '#IP-Adressierung', '#AP1']),
  CardModel(id: 'free-005', question: 'Was ist DNS und welche Eintragstypen gibt es?', shortAnswer: 'DNS löst Domainnamen in IPs auf. A (IPv4), AAAA (IPv6), MX (Mail), CNAME (Alias), NS (Nameserver).', longAnswer: 'DNS = Domain Name System (Port 53)\\n\\nEintragstypen:\\n• A-Record: Domain → IPv4 (www → 93.184.216.34)\\n• AAAA-Record: Domain → IPv6\\n• MX-Record: Mailserver für Domain\\n• CNAME: Alias (www → myapp.hosting.com)\\n• NS-Record: Zuständiger Nameserver\\n• TXT-Record: Textinformationen (SPF, DKIM)', url: 'https://de.wikipedia.org/wiki/Domain_Name_System', hashtags: ['#Netzwerk', '#DNS', '#Protokolle', '#AP1']),
  CardModel(id: 'free-006', question: 'Was ist der Unterschied zwischen Hub, Switch und Router?', shortAnswer: 'Hub: alle Ports (L1). Switch: MAC-basiert (L2). Router: IP-basiert (L3), verbindet Netzwerke.', longAnswer: 'Hub (Schicht 1):\\n• Leitet Pakete an ALLE Ports weiter\\n• Kollisionsdomäne für alle Geräte\\n\\nSwitch (Schicht 2):\\n• Lernt MAC-Adressen\\n• Sendet nur an Zielport (MAC-Table)\\n• Eigene Kollisionsdomäne pro Port\\n\\nRouter (Schicht 3):\\n• Verbindet verschiedene Netzwerke\\n• Wertet IP-Adressen aus\\n• Routing-Tabelle für Wegentscheidung', url: 'https://de.wikipedia.org/wiki/Router', hashtags: ['#Netzwerk', '#Hardware', '#Switch', '#Router', '#AP1']),
  CardModel(id: 'free-007', question: 'Was ist VPN und welche Arten gibt es?', shortAnswer: 'Virtual Private Network — verschlüsselter Tunnel über das Internet. Arten: Site-to-Site, Remote-Access, SSL-VPN.', longAnswer: 'VPN-Arten:\\n• Site-to-Site VPN: Verbindet zwei Standorte (Firmennetz)\\n• Remote-Access VPN: Einzelner Nutzer ins Firmennetz\\n• SSL-VPN: Browserbasiert, kein Client nötig\\n\\nProtokolle:\\n• IPsec: Sicher, komplex, für Site-to-Site\\n• OpenVPN: Open Source, flexibel\\n• WireGuard: Modern, schnell, einfach', url: 'https://de.wikipedia.org/wiki/Virtual_Private_Network', hashtags: ['#Netzwerk', '#VPN', '#IT-Sicherheit', '#AP1']),
  CardModel(id: 'free-008', question: 'Was sind wichtige Ports für Standard-Protokolle?', shortAnswer: 'HTTP:80 | HTTPS:443 | FTP:21 | SSH:22 | SMTP:25 | DNS:53 | DHCP:67/68 | RDP:3389', longAnswer: 'Wichtige Ports für die AP1-Prüfung:\\n\\nWeb: HTTP 80 | HTTPS 443\\nMail: SMTP 25/587 | POP3 110 | IMAP 143\\nDatei: FTP 21 | SFTP 22\\nVerwaltung: SSH 22 | Telnet 23 | RDP 3389\\nDienste: DNS 53 | DHCP 67/68 | SNMP 161\\n\\nMerke: Port < 1024 = Well-Known Ports', url: 'https://de.wikipedia.org/wiki/Liste_der_Portnummern', hashtags: ['#Netzwerk', '#Protokolle', '#Ports', '#AP1']),
  CardModel(id: 'free-009', question: 'Was ist der Unterschied zwischen IPv4 und IPv6?', shortAnswer: 'IPv4: 32 Bit, 4,3 Mrd. Adressen. IPv6: 128 Bit, praktisch unbegrenzt, kein NAT nötig.', longAnswer: 'IPv4:\\n• 32 Bit = 4.294.967.296 Adressen\\n• Adressknappheit → NAT als Lösung\\n• Notation: 192.168.1.1\\n\\nIPv6:\\n• 128 Bit = 340 Sextillionen Adressen\\n• Kein NAT nötig\\n• Notation: 2001:0db8:85a3::8a2e:0370:7334\\n• Automatische Konfiguration (SLAAC)\\n• Integriertes IPsec', url: 'https://de.wikipedia.org/wiki/IPv6', hashtags: ['#Netzwerk', '#IPv6', '#IPv4', '#IP-Adressierung', '#AP1']),
  CardModel(id: 'free-010', question: 'Was ist Cloud Computing und was sind SaaS, IaaS, PaaS?', shortAnswer: 'SaaS: fertige Software. IaaS: gemietete Infrastruktur. PaaS: Entwicklungsplattform in der Cloud.', longAnswer: 'Cloud-Servicemodelle:\\n\\nSaaS (Software as a Service):\\n→ Fertige Anwendungen | Beispiel: Gmail, Office 365\\n\\nPaaS (Platform as a Service):\\n→ Entwicklungsumgebung | Beispiel: Heroku, Firebase\\n\\nIaaS (Infrastructure as a Service):\\n→ Virtuelle Server/Speicher | Beispiel: AWS EC2, Azure\\n\\nDeployment-Modelle: Public, Private, Hybrid Cloud', url: 'https://de.wikipedia.org/wiki/Cloud_Computing', hashtags: ['#Netzwerk', '#Cloud', '#SaaS', '#IaaS', '#PaaS', '#AP1']),
];

class FreeTrialScreen extends StatefulWidget {
  const FreeTrialScreen({super.key});

  @override
  State<FreeTrialScreen> createState() => _FreeTrialScreenState();
}

class _FreeTrialScreenState extends State<FreeTrialScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _erklaerungOpen = false;
  bool _weiterlernOpen = false;

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
      builder: (_) => const _UpgradeSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = _freeCards[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF1e3a5f),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text('LF', style: TextStyle(
                    color: Colors.white, fontSize: 11,
                    fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 8),
            const Text('IHK AP1 Prep',
                style: TextStyle(color: Colors.white,
                    fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8813A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('GRATIS',
                style: TextStyle(color: Colors.white,
                    fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: !_showAnswer ? _buildQuestionView(card) : _buildAnswerView(card),
    );
  }

  // ── FRAGE-VIEW ─────────────────────────────────────────────
  Widget _buildQuestionView(CardModel card) {
    final total = _freeCards.length;
    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentIndex + 1) / total,
          backgroundColor: const Color(0xFFE5E7EB),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE8813A)),
          minHeight: 4,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Netzwerktechnik',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              Text('${_currentIndex + 1} / $total',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: const Color(0xFF1e3a5f),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE53E3E)),
                      child: const Icon(Icons.question_mark,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 20),
                    Text(card.question,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20,
                            fontWeight: FontWeight.bold, height: 1.4),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _freeCards.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _currentIndex ? 18 : 7,
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: i == _currentIndex
                      ? const Color(0xFF162447)
                      : const Color(0xFFD1D5DB),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => setState(() => _showAnswer = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8813A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Antwort zeigen →',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LoginScreen())),
            child: Text('Schon registriert? Einloggen →',
                style: TextStyle(
                    color: Colors.grey[400], fontSize: 12,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.grey[300])),
          ),
        ),
      ],
    );
  }

  // ── ANTWORT-VIEW ───────────────────────────────────────────
  Widget _buildAnswerView(CardModel card) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _freeCards.length,
          backgroundColor: const Color(0xFFE5E7EB),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE8813A)),
          minHeight: 4,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge + Fortschritt
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('NEU',
                          style: TextStyle(fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E40AF))),
                    ),
                    Text('${_currentIndex + 1} / ${_freeCards.length}',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ),
                const SizedBox(height: 12),

                // Frage
                Text(card.question,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600,
                        color: Color(0xFF162447), height: 1.4)),
                const SizedBox(height: 12),

                // KERNANTWORT
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a2744),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('KERNANTWORT',
                          style: TextStyle(
                              color: Color(0xFFE8813A), fontSize: 11,
                              fontWeight: FontWeight.w700, letterSpacing: 0.6)),
                      const SizedBox(height: 10),
                      _highlightedText(card.shortAnswer, card.hashtags),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Erklärungen Accordion
                if (card.longAnswer.isNotEmpty)
                  _accordion(
                    icon: Icons.menu_book_outlined,
                    title: 'Erklärungen',
                    subtitle: 'Ausführliche Erklärung',
                    isOpen: _erklaerungOpen,
                    onTap: () => setState(
                        () => _erklaerungOpen = !_erklaerungOpen),
                    child: _formattedText(card.longAnswer),
                  ),
                const SizedBox(height: 8),

                // Weiterlernen Accordion
                _accordion(
                  icon: Icons.open_in_new_outlined,
                  title: 'Weiterlernen',
                  subtitle: card.url.isNotEmpty
                      ? '1 Link · Wikipedia'
                      : 'Ressourcen',
                  isOpen: _weiterlernOpen,
                  onTap: () => setState(
                      () => _weiterlernOpen = !_weiterlernOpen),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (card.url.isNotEmpty)
                        Row(children: [
                          const Icon(Icons.link,
                              size: 14, color: Color(0xFF3B82F6)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(card.url,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF3B82F6))),
                          ),
                        ]),
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.book_outlined,
                            size: 14, color: Color(0xFF6B7280)),
                        const SizedBox(width: 6),
                        const Text('IT-Handbuch: www.it-handbuch.de',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF6B7280))),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Hashtags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: card.hashtags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(tag,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF6B7280))),
                  )).toList(),
                ),
                const SizedBox(height: 20),

                // Bewertungsfrage
                const Center(
                  child: Text('Wie gut kennst du diese Karte?',
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 10),

                // Bewertungsbuttons
                Row(children: [
                  _ratingBtn('Nochmal', '<1 Min', const Color(0xFFEF4444)),
                  const SizedBox(width: 6),
                  _ratingBtn('Schwer', '<10 Min', const Color(0xFFF59E0B)),
                  const SizedBox(width: 6),
                  _ratingBtn('Gut', '4 Tage', const Color(0xFF22C55E)),
                  const SizedBox(width: 6),
                  _ratingBtn('Einfach', '14 Tage', const Color(0xFFE8813A)),
                ]),
                const SizedBox(height: 20),

                // Upgrade Teaser
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF162447).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFF162447).withOpacity(0.1)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.lock_outline,
                        color: Color(0xFFE8813A), size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Vollversion — 450+ Karten, Simulator, Statistik',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF162447))),
                          Text('+ Prüfungssimulator + Statistik + Lernkalender',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey[500])),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen())),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8813A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Mehr →',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _highlightedText(String text, List<String> hashtags) {
    final keywords = hashtags
        .where((h) => !h.contains('AP'))
        .map((h) => h.replaceAll('#', ''))
        .toList();
    final spans = <TextSpan>[];
    String remaining = text;
    while (remaining.isNotEmpty) {
      int earliest = remaining.length;
      String? match;
      for (final kw in keywords) {
        final idx = remaining.toLowerCase().indexOf(kw.toLowerCase());
        if (idx != -1 && idx < earliest) {
          earliest = idx;
          match = remaining.substring(idx, idx + kw.length);
        }
      }
      if (match == null) {
        spans.add(TextSpan(text: remaining,
            style: const TextStyle(color: Colors.white,
                fontSize: 14, height: 1.5)));
        break;
      }
      if (earliest > 0) {
        spans.add(TextSpan(text: remaining.substring(0, earliest),
            style: const TextStyle(color: Colors.white,
                fontSize: 14, height: 1.5)));
      }
      spans.add(TextSpan(text: match,
          style: const TextStyle(color: Color(0xFFE8813A),
              fontWeight: FontWeight.bold, fontSize: 14, height: 1.5)));
      remaining = remaining.substring(earliest + match.length);
    }
    return RichText(text: TextSpan(children: spans));
  }

  Widget _formattedText(String text) {
    final lines = text.split('\\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) => Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Text(line,
            style: const TextStyle(
                fontSize: 12, color: Color(0xFF374151), height: 1.6)),
      )).toList(),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isOpen
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))
                : BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(children: [
            Icon(icon, size: 17, color: const Color(0xFF6B7280)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: Color(0xFF111827))),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9CA3AF))),
                ],
              ),
            ),
            Icon(isOpen
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
                color: const Color(0xFF9CA3AF)),
          ]),
        ),
      ),
      if (isOpen)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFFF9FAFB),
            border: Border(
              left: BorderSide(color: Color(0xFFE5E7EB)),
              right: BorderSide(color: Color(0xFFE5E7EB)),
              bottom: BorderSide(color: Color(0xFFE5E7EB)),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
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
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            Text(interval,
                style: TextStyle(
                    fontSize: 9, color: color.withOpacity(0.7))),
          ]),
        ),
      ),
    );
  }
}

// ── Upgrade Sheet ────────────────────────────────────────────
class _UpgradeSheet extends StatelessWidget {
  const _UpgradeSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
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
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE8813A).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events,
                color: Color(0xFFE8813A), size: 32),
          ),
          const SizedBox(height: 14),
          const Text('Du hast alle 10 Karten gemeistert! 🎉',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold,
                  color: Color(0xFF162447))),
          const SizedBox(height: 8),
          Text(
            'Du hast gerade erlebt was Learn-Factory einzigartig macht:\n'
            'Kernantwort · Erklärung · Links · Hashtags\n\n'
            'Registriere dich kostenlos und lerne 440 weitere Karten '
            'mit Prüfungssimulator und Statistik.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.6),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => const LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF162447),
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
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Nochmal spielen',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
