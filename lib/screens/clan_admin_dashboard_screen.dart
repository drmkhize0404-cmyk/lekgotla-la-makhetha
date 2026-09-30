import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/clan_settings_service.dart';

class ClanAdminDashboardScreen extends StatefulWidget {
  const ClanAdminDashboardScreen({super.key});

  @override
  State<ClanAdminDashboardScreen> createState() =>
      _ClanAdminDashboardScreenState();
}

class _ClanAdminDashboardScreenState extends State<ClanAdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  bool _isAuthenticated = false;
  final TextEditingController _pinController = TextEditingController();

  late TabController _tabController;

  // Tabled Kgotla Topics (Admin Moderation)
  final List<Map<String, dynamic>> _adminTopics = [
    {
      "id": "T1",
      "title": "Establishment of the Makhetha Higher Education Bursary Trust",
      "author": "Ausi Refiloe (Gauteng)",
      "likes": 156,
      "dislikes": 4,
      "isFinalised": true,
    },
    {
      "id": "T2",
      "title": "Digital Archiving of Clan Praise Poems (Lithoko) & Lineage Tree",
      "author": "Ntate Sello (Free State)",
      "likes": 124,
      "dislikes": 2,
      "isFinalised": true,
    },
    {
      "id": "T3",
      "title": "Family Bereavement & Emergency Scheme (Mokotla wa Matshediso)",
      "author": "Mme Mpho (Lesotho)",
      "likes": 88,
      "dislikes": 6,
      "isFinalised": false,
    },
    {
      "id": "T4",
      "title": "Makhetha Commercial Cattle & Grain Agricultural Co-op",
      "author": "Abuti Tumelo (KZN)",
      "likes": 72,
      "dislikes": 14,
      "isFinalised": false,
    },
  ];

  // Family Artisans & Professionals (Verification Desk)
  final List<Map<String, dynamic>> _adminProfessionals = [
    {
      "id": "P1",
      "name": "Ntate Sello Makhetha",
      "profession": "Master Electrician & Solar Installer",
      "branch": "KZN Branch",
      "isVolunteer": false,
      "isEndorsed": true,
    },
    {
      "id": "P2",
      "name": "Adv. Tebogo Makhetha",
      "profession": "High Court Advocate & Legal Consultant",
      "branch": "Gauteng Branch",
      "isVolunteer": true,
      "isEndorsed": true,
    },
    {
      "id": "P3",
      "name": "Dr. Mamello Makhetha",
      "profession": "General Medical Practitioner",
      "branch": "Free State Branch",
      "isVolunteer": true,
      "isEndorsed": true,
    },
    {
      "id": "P4",
      "name": "Ausi Keketso Makhetha (CA)",
      "profession": "Tax & Accounting Consultant",
      "branch": "Lesotho Heritage Branch",
      "isVolunteer": false,
      "isEndorsed": false,
    },
  ];

  // Safe Haven Crisis Tokens (Bo-Rakgadi Triage)
  final List<Map<String, dynamic>> _crisisTokens = [
    {
      "token": "MK-SAFE-8412",
      "category": "Domestic Distress & Gender-Based Violence",
      "urgency": "Urgent (Within 24 Hours)",
      "assigned": "Bo-Rakgadi Aunts Circle",
      "status": "Elder Assigned • Shelter Coordinated",
    },
    {
      "token": "MK-SAFE-9218",
      "category": "Elderly Exploitation or Abandonment",
      "urgency": "Review & Home Visit Needed",
      "assigned": "Neutral Lekgotla Elder",
      "status": "Inquiry Underway",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _pinController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _verifyCouncilPin() {
    // Default Council PIN: 2027 (Matches the Reunion year)
    if (_pinController.text.trim() == "2027") {
      setState(() => _isAuthenticated = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Incorrect council PIN. Default testing PIN is 2027"),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
    }
  }

  Future<void> _launchExternal(String link) async {
    final Uri uri = Uri.parse(link);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  // 📍 1. ADMIN UPDATES REUNION LOCATION & HOST BRANCH
  void _showEditReunionHostModal(BuildContext context) {
    final settings = ClanSettingsService();
    final locC = TextEditingController(text: settings.reunionLocation);
    final hostC = TextEditingController(text: settings.reunionHostBranch);
    final venueC = TextEditingController(text: settings.reunionVenue);
    final themeC = TextEditingController(text: settings.reunionTheme);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(Icons.location_city_rounded, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            const Text("Update Host & Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Update the upcoming reunion hosting details. Changes apply app-wide in real time.",
                style: TextStyle(fontSize: 11.5, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locC,
                decoration: const InputDecoration(labelText: "Reunion Location *", hintText: "e.g. Gqeberha (Port Elizabeth)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: hostC,
                decoration: const InputDecoration(labelText: "Hosting Branch *", hintText: "e.g. Eastern Cape Host Branch", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: venueC,
                decoration: const InputDecoration(labelText: "Venue / Ground *", hintText: "e.g. Nelson Mandela Bay Marquee", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: themeC,
                decoration: const InputDecoration(labelText: "Theme / Slogan", hintText: "e.g. Kopano ya Lelapa", border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
            ),
            onPressed: () async {
              if (locC.text.isNotEmpty && hostC.text.isNotEmpty) {
                await settings.updateReunionInfo(
                  location: locC.text.trim(),
                  hostBranch: hostC.text.trim(),
                  venue: venueC.text.trim(),
                  theme: themeC.text.trim(),
                  date: settings.reunionDate,
                );
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("✅ Reunion host and location updated app-wide!"), backgroundColor: Color(0xFF16A34A)),
                  );
                }
              }
            },
            child: const Text("Save & Publish"),
          ),
        ],
      ),
    );
  }

  // 📍 2. ADMIN CONFIGURES IN-APP TICKET PRICES
  void _showEditTicketPricesDialog(BuildContext context) {
    final settings = ClanSettingsService();
    final adultC = TextEditingController(text: settings.adultTicketPrice.toStringAsFixed(0));
    final youthC = TextEditingController(text: settings.youthTicketPrice.toStringAsFixed(0));
    final tshirtC = TextEditingController(text: settings.tShirtPrice.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(Icons.price_change_rounded, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            const Text("Set Reunion Ticket Prices", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "These prices are automatically charged inside the app when relatives book passes.",
                style: TextStyle(fontSize: 11.5, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: adultC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Adult Clan Pass (ZAR) *", prefixText: "R ", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: youthC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Youth / Student Pass (ZAR) *", prefixText: "R ", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: tshirtC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Official Heritage T-Shirt (ZAR) *", prefixText: "R ", border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
            ),
            onPressed: () async {
              final aPrice = double.tryParse(adultC.text.trim()) ?? settings.adultTicketPrice;
              final yPrice = double.tryParse(youthC.text.trim()) ?? settings.youthTicketPrice;
              final tPrice = double.tryParse(tshirtC.text.trim()) ?? settings.tShirtPrice;

              await settings.updateTicketPrices(
                adultPrice: aPrice,
                youthPrice: yPrice,
                tshirtPrice: tPrice,
              );

              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Reunion ticket prices updated app-wide!"), backgroundColor: Color(0xFF16A34A)),
                );
              }
            },
            child: const Text("Save Prices"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final brandColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final cardColor = theme.cardColor;
    final borderColor = theme.dividerColor;

    if (!_isAuthenticated) {
      return _buildPinGateScreen(theme, cardColor, borderColor, brandColor, onSurfaceColor, isDark);
    }

    return AnimatedBuilder(
      animation: ClanSettingsService(),
      builder: (context, _) {
        final settings = ClanSettingsService();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            title: Text(
              "LEKGOTLA LA BAHOLO • COUNCIL DESK",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
                color: onSurfaceColor,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.logout_rounded, color: onSurfaceColor.withOpacity(0.6)),
                tooltip: "Lock Council Portal",
                onPressed: () => setState(() {
                  _isAuthenticated = false;
                  _pinController.clear();
                }),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: brandColor,
              labelColor: brandColor,
              unselectedLabelColor: onSurfaceColor.withOpacity(0.6),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              tabs: const [
                Tab(icon: Icon(Icons.speed_rounded, size: 16), text: "Pulse & Logistics"),
                Tab(icon: Icon(Icons.how_to_vote_rounded, size: 16), text: "Agenda Moderation"),
                Tab(icon: Icon(Icons.verified_rounded, size: 16), text: "Verify Trades"),
                Tab(icon: Icon(Icons.shield_rounded, size: 16), text: "Crisis Triage"),
              ],
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 950),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPulseTab(settings, cardColor, borderColor, brandColor, onSurfaceColor, isDark),
                  _buildAgendaModerationTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
                  _buildTradesVerificationTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
                  _buildCrisisTriageTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // PIN PASSCODE GATE SCREEN (DEFAULT: 2027)
  // ===========================================================================
  Widget _buildPinGateScreen(
    ThemeData theme,
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text("Council Security", style: TextStyle(color: onSurfaceColor, fontSize: 16)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: brandColor.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      )
                    ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: brandColor.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Text("🐊", style: TextStyle(fontSize: 34)),
                ),
                const SizedBox(height: 16),
                Text(
                  "Lekgotla la Baholo",
                  style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: onSurfaceColor),
                ),
                const SizedBox(height: 6),
                Text(
                  "Reserved for appointed Branch Elders, Aunts (Bo-Rakgadi), and Council Executives.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 12),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: onSurfaceColor,
                    fontSize: 20,
                    letterSpacing: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: "••••",
                    hintStyle: TextStyle(color: onSurfaceColor.withOpacity(0.3), letterSpacing: 8),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0B1120) : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Default testing PIN: 2027",
                  style: TextStyle(color: brandColor, fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandColor,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _verifyCouncilPin,
                    child: const Text("Enter Council Chamber", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 1: CLAN PULSE & LOGISTICS CONTROLLER
  // ===========================================================================
  Widget _buildPulseTab(
    ClanSettingsService settings,
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          "CLAN PULSE & REUNION LOGISTICS",
          style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.1),
        ),
        const SizedBox(height: 4),
        Text("Active Gathering Status",
            style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: onSurfaceColor)),
        const SizedBox(height: 14),

        // Live Reunion Info Card (Shows Port Elizabeth)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_city_rounded, color: brandColor, size: 20),
                  const SizedBox(width: 8),
                  Text("Next Gathering: ${settings.reunionLocation}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: onSurfaceColor)),
                ],
              ),
              const SizedBox(height: 4),
              Text("Host Branch: ${settings.reunionHostBranch}", style: TextStyle(fontSize: 11.5, color: brandColor)),
              Text("Venue: ${settings.reunionVenue}", style: TextStyle(fontSize: 11, color: onSurfaceColor.withOpacity(0.65))),
              const Divider(height: 18),
              Row(
                children: [
                  Text("Pass Prices: Adult R${settings.adultTicketPrice.toStringAsFixed(0)} | Youth R${settings.youthTicketPrice.toStringAsFixed(0)} | T-Shirt R${settings.tShirtPrice.toStringAsFixed(0)}",
                      style: TextStyle(fontSize: 11, color: onSurfaceColor.withOpacity(0.75))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 📍 DIRECTIVES & MODAL LAUNCHERS
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: brandColor, foregroundColor: isDark ? Colors.black : Colors.white),
              onPressed: () => _showEditReunionHostModal(context),
              icon: const Icon(Icons.edit_location_alt_rounded, size: 16),
              label: const Text("Edit Host & Location"),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
              onPressed: () => _showEditTicketPricesDialog(context),
              icon: const Icon(Icons.price_change_rounded, size: 16),
              label: const Text("Set Ticket Prices"),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Metrics Grid
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 700 ? 4 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.35,
          children: [
            _statMetricCard("Connected Households", "184 Families", Icons.family_restroom_rounded, brandColor, cardColor, borderColor, onSurfaceColor),
            _statMetricCard("Active Proposals", "${_adminTopics.length} Topics", Icons.how_to_vote_rounded, const Color(0xFF3B82F6), cardColor, borderColor, onSurfaceColor),
            _statMetricCard("Verified Artisans", "${_adminProfessionals.length} Members", Icons.verified_rounded, const Color(0xFF10B981), cardColor, borderColor, onSurfaceColor),
            _statMetricCard("Crisis Reports", "${_crisisTokens.length} Active", Icons.shield_rounded, const Color(0xFFEF4444), cardColor, borderColor, onSurfaceColor),
          ],
        ),
      ],
    );
  }

  Widget _statMetricCard(
    String label,
    String value,
    IconData icon,
    Color color,
    Color cardColor,
    Color borderColor,
    Color onSurfaceColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold, fontSize: 14)),
          Text(label, style: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 10)),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 2: KGOTLA TOPICS MODERATION (PROPOSALS VS FINALISED)
  // ===========================================================================
  Widget _buildAgendaModerationTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          "REUNION 2027 AGENDA DELIBERATION",
          style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11),
        ),
        Text("Ratify Proposals for the Finalised Agenda",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurfaceColor)),
        const SizedBox(height: 16),

        ..._adminTopics.map((topic) {
          final bool isFinalised = topic['isFinalised'] == true;
          final int netScore = (topic['likes'] as int) - (topic['dislikes'] as int);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isFinalised ? const Color(0xFF10B981).withOpacity(0.5) : borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: isFinalised ? const Color(0xFF10B981).withOpacity(0.12) : const Color(0xFFF59E0B).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isFinalised ? "✅ FINALISED FOR PE 2027" : "⏳ PROPOSAL IN VOTING",
                              style: TextStyle(color: isFinalised ? const Color(0xFF10B981) : brandColor, fontSize: 9.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text("Net: +$netScore (👍 ${topic['likes']} | 👎 ${topic['dislikes']})",
                              style: TextStyle(color: onSurfaceColor.withOpacity(0.6), fontSize: 10.5)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(topic['title'], style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text("Author: ${topic['author']}", style: TextStyle(color: brandColor, fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFinalised ? borderColor : const Color(0xFF10B981),
                    foregroundColor: isFinalised ? onSurfaceColor : Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                  onPressed: () {
                    setState(() {
                      topic['isFinalised'] = !isFinalised;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isFinalised ? "Moved back to proposals." : "Adopted for Finalised Reunion Agenda!")),
                    );
                  },
                  child: Text(isFinalised ? "Revoke" : "Adopt"),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ===========================================================================
  // TAB 3: TRADES & BUSINESS VERIFICATION
  // ===========================================================================
  Widget _buildTradesVerificationTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          "HOUSEHOLD OF FAITH DIRECTORY",
          style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11),
        ),
        Text("Verify & Endorse Makhetha Family Artisans",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurfaceColor)),
        const SizedBox(height: 16),

        ..._adminProfessionals.map((p) {
          final bool isEndorsed = p['isEndorsed'] == true;
          final bool isVolunteer = p['isVolunteer'] == true;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isEndorsed ? const Color(0xFF10B981).withOpacity(0.5) : borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(p['name'], style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold, fontSize: 13.5)),
                          if (isEndorsed) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 16),
                          ],
                        ],
                      ),
                      Text("${p['profession']} • ${p['branch']}", style: TextStyle(color: brandColor, fontSize: 11)),
                      Text(isVolunteer ? "🤝 Volunteers Pro Bono Family Guidance" : "🏷️ Standard Family Discount Rate",
                          style: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 10.5)),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEndorsed ? borderColor : brandColor,
                    foregroundColor: isEndorsed ? onSurfaceColor : (isDark ? Colors.black : Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      p['isEndorsed'] = !isEndorsed;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isEndorsed ? "Endorsement revoked." : "Awarded Bakoena Clan Endorsement Badge 🐊!")),
                    );
                  },
                  child: Text(isEndorsed ? "Revoke" : "Endorse"),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ===========================================================================
  // TAB 4: SAFE HAVEN CRISIS TRIAGE (BO-RAKGADI CIRCLE)
  // ===========================================================================
  Widget _buildCrisisTriageTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          "BO-RAKGADI & BO-MME CONFIDENTIAL DISPATCH",
          style: TextStyle(color: const Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 11),
        ),
        Text("Active Anonymous Crisis Tokens",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurfaceColor)),
        const SizedBox(height: 16),

        ..._crisisTokens.map((c) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(c['token'], style: const TextStyle(color: Color(0xFFEF4444), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    Text(c['urgency'], style: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(c['category'], style: TextStyle(fontWeight: FontWeight.bold, color: onSurfaceColor, fontSize: 13.5)),
                const SizedBox(height: 4),
                Text("Assigned Circle: ${c['assigned']}", style: TextStyle(color: brandColor, fontSize: 11.5)),
                Text("Status: ${c['status']}", style: const TextStyle(color: Color(0xFF10B981), fontSize: 11.5, fontWeight: FontWeight.w600)),
                Divider(color: borderColor, height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF16A34A), foregroundColor: Colors.white),
                    onPressed: () {
                      const String elderCircleWhatsApp = "27821234567";
                      final String msg = "Lekgotla la Baholo: Coordinating confidential response for Case Token ${c['token']}.";
                      _launchExternal("https://wa.me/$elderCircleWhatsApp?text=${Uri.encodeComponent(msg)}");
                    },
                    icon: const Icon(Icons.chat_bubble_rounded, size: 15),
                    label: const Text("Coordinate with Bo-Rakgadi Circle", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}