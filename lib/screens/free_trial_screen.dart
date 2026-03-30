import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/screens/login_screen.dart';
import 'package:ihk_ap1_prep/models/card_model.dart';

// 10 kostenlose Karten aus Netzwerktechnik
final List<CardModel> _freeCards = [
  CardModel(id: 'free-001', question: 'Was sind die 7 Schichten des OSI-Modells?', shortAnswer: 'Physical, Data Link, Network, Transport, Session, Presentation, Application (Schicht 1–7).', longAnswer: 'Merkhilfe: Pls Do Not Throw Sausage Pizza Away', url: '', hashtags: ['#Netzwerk', '#OSI', '#AP1']),
  CardModel(id: 'free-002', question: 'Was ist der Unterschied zwischen TCP und UDP?', shortAnswer: 'TCP: verbindungsorientiert, zuverlässig. UDP: verbindungslos, schneller, kein Empfangsbestätigung.', longAnswer: 'TCP = Einschreiben | UDP = Postwurf ohne Rückmeldung', url: '', hashtags: ['#Netzwerk', '#Protokolle', '#AP1']),
  CardModel(id: 'free-003', question: 'Was ist DHCP und wie funktioniert es (DORA)?', shortAnswer: 'DHCP verteilt IP-Adressen automatisch. DORA: Discover → Offer → Request → Acknowledge.', longAnswer: 'Port 67 (Server) / Port 68 (Client)', url: '', hashtags: ['#Netzwerk', '#DHCP', '#AP1']),
  CardModel(id: 'free-004', question: 'Was sind private IPv4-Adressbereiche?', shortAnswer: '10.0.0.0/8 | 172.16.0.0/12 | 192.168.0.0/16 — nicht im Internet geroutet.', longAnswer: 'RFC 1918 — sehr häufig in der Prüfung!', url: '', hashtags: ['#Netzwerk', '#IP', '#AP1']),
  CardModel(id: 'free-005', question: 'Was ist DNS und welche Eintragstypen gibt es?', shortAnswer: 'DNS löst Domainnamen in IPs auf. A (IPv4), AAAA (IPv6), MX (Mail), CNAME (Alias).', longAnswer: 'Port 53 UDP/TCP', url: '', hashtags: ['#Netzwerk', '#DNS', '#AP1']),
  CardModel(id: 'free-006', question: 'Was ist der Unterschied zwischen Hub, Switch und Router?', shortAnswer: 'Hub: alle Ports (L1). Switch: MAC-basiert (L2). Router: IP-basiert (L3), verbindet Netzwerke.', longAnswer: 'Hub = dumm | Switch = schlau | Router = klug', url: '', hashtags: ['#Netzwerk', '#Hardware', '#AP1']),
  CardModel(id: 'free-007', question: 'Was ist VPN und welche Arten gibt es?', shortAnswer: 'Virtual Private Network — verschlüsselter Tunnel. Site-to-Site, Remote-Access, SSL-VPN.', longAnswer: 'IPsec oder SSL/TLS als Verschlüsselungsprotokoll', url: '', hashtags: ['#Netzwerk', '#IT-Sicherheit', '#AP1']),
  CardModel(id: 'free-008', question: 'Was ist der Unterschied zwischen IPv4 und IPv6?', shortAnswer: 'IPv4: 32 Bit, 4,3 Mrd. Adressen. IPv6: 128 Bit, praktisch unbegrenzt, kein NAT nötig.', longAnswer: 'IPv6 Beispiel: 2001:0db8:85a3::8a2e:0370:7334', url: '', hashtags: ['#Netzwerk', '#IP', '#AP1']),
  CardModel(id: 'free-009', question: 'Was sind wichtige Ports für Standard-Protokolle?', shortAnswer: 'HTTP:80 | HTTPS:443 | FTP:21 | SSH:22 | SMTP:25 | DNS:53 | DHCP:67/68', longAnswer: 'Diese Ports kommen fast jede Prüfung!', url: '', hashtags: ['#Netzwerk', '#Protokolle', '#AP1']),
  CardModel(id: 'free-010', question: 'Was ist Cloud Computing und was sind SaaS, IaaS, PaaS?', shortAnswer: 'SaaS: Software as a Service. IaaS: Infrastruktur. PaaS: Entwicklungsplattform.', longAnswer: 'SaaS = Gmail | PaaS = Heroku | IaaS = AWS EC2', url: '', hashtags: ['#Netzwerk', '#Cloud', '#AP1']),
];

class FreeTrialScreen extends StatefulWidget {
  const FreeTrialScreen({super.key});

  @override
  State<FreeTrialScreen> createState() => _FreeTrialScreenState();
}

class _FreeTrialScreenState extends State<FreeTrialScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  void _nextCard() {
    if (_currentIndex < _freeCards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      _showUpgradeScreen();
    }
  }

  void _showUpgradeScreen() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => _UpgradeSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = _freeCards[_currentIndex];
    final total = _freeCards.length;

    return Scaffold(
      backgroundColor: const Color(0xFF162447),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  // LF Logo
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1e3a5f),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('LF',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('IHK AP1 Prep',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  // Gratis Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8813A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('GRATIS TESTEN',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Fortschrittsbalken
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Netzwerktechnik',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12)),
                      Text('${_currentIndex + 1} / $total',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / total,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFE8813A)),
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Karte
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        if (!_showAnswer) ...[
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE53E3E),
                            ),
                            child: const Icon(Icons.question_mark,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            card.question,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.4),
                            textAlign: TextAlign.center,
                          ),
                        ] else ...[
                          const Text('KERNANTWORT',
                              style: TextStyle(
                                  color: Color(0xFFE8813A),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6)),
                          const SizedBox(height: 12),
                          Text(
                            card.question,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                                height: 1.4),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              card.shortAnswer,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (card.longAnswer.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              card.longAnswer,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: !_showAnswer
                  ? SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () =>
                            setState(() => _showAnswer = true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8813A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Antwort zeigen →',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _ratingBtn('Nochmal', Colors.redAccent),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ratingBtn('Gut ✓', const Color(0xFF22C55E)),
                        ),
                      ],
                    ),
            ),

            // Login Link unten
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LoginScreen()),
                ),
                child: Text(
                  'Schon registriert? Einloggen →',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white.withOpacity(0.3)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingBtn(String label, Color color) {
    return GestureDetector(
      onTap: _nextCard,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// ─── Upgrade Sheet ─────────────────────────────────────────
class _UpgradeSheet extends StatelessWidget {
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
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE8813A).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events,
                color: Color(0xFFE8813A), size: 32),
          ),
          const SizedBox(height: 16),

          const Text('Du hast 10 Karten gemeistert! 🎉',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF162447))),
          const SizedBox(height: 8),
          Text(
            'Registriere dich kostenlos und lerne weitere 20 Karten.\n'
            'Upgrade auf Deluxe für alle 450+ Karten und den Prüfungssimulator.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.5),
          ),
          const SizedBox(height: 20),

          // Kostenlos registrieren
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LoginScreen()),
                );
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

          // Nochmal spielen
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Nochmal spielen',
                  style: TextStyle(
                      color: Colors.grey[500], fontSize: 13)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
