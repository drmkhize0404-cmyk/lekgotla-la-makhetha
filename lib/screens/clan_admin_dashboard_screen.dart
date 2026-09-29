import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lekgotla_la_makhetha/services/clan_settings_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
        title: const Text("Update Reunion Host & Location"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: locC,
                decoration: const InputDecoration(labelText: "Upcoming Location (e.g. Port Elizabeth)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: hostC,
                decoration: const InputDecoration(labelText: "Hosting Branch (e.g. Eastern Cape Branch)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: venueC,
                decoration: const InputDecoration(labelText: "Venue / Ground Name", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: themeC,
                decoration: const InputDecoration(labelText: "Reunion Theme / Slogan", border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
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
                  const SnackBar(content: Text("✅ Reunion host & location updated app-wide!")),
                );
              }
            },
            child: const Text("Save & Publish"),
          ),
        ],
      ),
    );
  }

  // Mock Moderation Items
  final List<Map<String, dynamic>> _pendingTopics = [
    {
      "id": "T1",
      "title": "Establishment of the Makhetha Youth Education & Bursary Fund",
      "author": "Ausi Refiloe (Gauteng)",
      "votes": 142,
      "isApproved": true,
    },
    {
      "id": "T2",
      "title": "Digital Archiving of Clan Praise Poems (Lithoko) & Lineage Tree",
      "author": "Ntate Sello (Free State)",
      "votes": 118,
      "isApproved": true,
    },
    {
      "id": "T3",
      "title": "Establishment of Makhetha Commercial Cattle & Grain Co-op",
      "author": "Abuti Tumelo (KZN)",
      "votes": 76,
      "isApproved": false,
    },
  ];

  final List<Map<String, dynamic>> _pendingBusinesses = [
    {
      "id": "B1",
      "business": "Midlands Faith Plumbing & Leak Detection",
      "owner": "Bro. S. Mkhize (KZN)",
      "trade": "Plumbing & Drainage (Red Seal)",
      "isEndorsed": true,
    },
    {
      "id": "B2",
      "business": "Northdale Auto Electrical & Diagnostics",
      "owner": "Bro. D. Govender (KZN)",
      "trade": "Auto Diagnostics & Solar",
      "isEndorsed": true,
    },
    {
      "id": "B3",
      "business": "Lesotho Heritage Organic Wool & Honey",
      "owner": "Mme Mpho Makhetha (Maseru)",
      "trade": "Agriculture & Export",
      "isEndorsed": false,
    },
  ];

  final List<Map<String, dynamic>> _crisisCases = [
    {
      "token": "MK-SAFE-8412",
      "category": "Domestic Distress & Gender-Based Violence",
      "urgency": "Urgent (Within 24 Hours)",
      "advocate": "Bo-Rakgadi Circle",
      "status": "Elder Assigned • Shelter Coordinated",
    },
    {
      "token": "MK-SAFE-9218",
      "category": "Elderly Exploitation or Abandonment",
      "urgency": "Review & Visit Needed",
      "advocate": "Neutral Lekgotla Elder",
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
    // Default Council PIN: 2027 (Heritage Day Reunion year)
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "LEKGOTLA LA BAHOLO • COUNCIL DESK",
          style: GoogleFonts.montserrat(
            fontSize: 12.5,
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
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
          tabs: const [
            Tab(icon: Icon(Icons.speed_rounded, size: 17), text: "Clan Pulse"),
            Tab(icon: Icon(Icons.how_to_vote_rounded, size: 17), text: "Kgotla Agenda"),
            Tab(icon: Icon(Icons.verified_rounded, size: 17), text: "Verify Trades"),
            Tab(icon: Icon(Icons.shield_rounded, size: 17), text: "Crisis Triage"),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPulseTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
              _buildAgendaModerationTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
              _buildTradesVerificationTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
              _buildCrisisTriageTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // COUNCIL PASSCODE GATE
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
  // TAB 1: CLAN PULSE & METRICS
  // ===========================================================================
  Widget _buildPulseTab(
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
          "CLAN PULSE & DEMOGRAPHICS",
          style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.1),
        ),
        const SizedBox(height: 4),
        Text("Global Makhetha Family Overview",
            style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: onSurfaceColor)),
        const SizedBox(height: 16),

        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 700 ? 4 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.35,
          children: [
            _statMetricCard("Connected Households", "184 Families", Icons.family_restroom_rounded, brandColor, cardColor, borderColor, onSurfaceColor),
            _statMetricCard("Reunion 2027 Target", "62% Raised", Icons.celebration_rounded, const Color(0xFF10B981), cardColor, borderColor, onSurfaceColor),
            _statMetricCard("Active Escrow Volume", "R 3,200 Locked", Icons.shield_rounded, const Color(0xFF3B82F6), cardColor, borderColor, onSurfaceColor),
            _statMetricCard("Active Crisis Reports", "${_crisisCases.length} In Progress", Icons.gpp_maybe_rounded, const Color(0xFFEF4444), cardColor, borderColor, onSurfaceColor),
          ],
        ),
        const SizedBox(height: 24),

        // Elder Council Quick Actions
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Council Executive Directives",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: onSurfaceColor)),
              Divider(color: borderColor, height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: brandColor, foregroundColor: isDark ? Colors.black : Colors.white),
                    onPressed: () => _tabController.animateTo(1),
                    icon: const Icon(Icons.how_to_vote_rounded, size: 16),
                    label: const Text("Moderate Agenda Topics"),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: onSurfaceColor, side: BorderSide(color: borderColor)),
                    onPressed: () => _tabController.animateTo(2),
                    icon: const Icon(Icons.verified_rounded, size: 16),
                    label: const Text("Review Trade Listings"),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFEF4444), side: const BorderSide(color: Color(0xFFEF4444))),
                    onPressed: () => _tabController.animateTo(3),
                    icon: const Icon(Icons.shield_rounded, size: 16),
                    label: const Text("Review Safe Haven Desk"),
                  ),
                ],
              ),
            ],
          ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold, fontSize: 15)),
          Text(label, style: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 10.5)),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 2: KGOTLA TOPICS MODERATION
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
        Text("Approve Tabled Topics for Official Kgotla Floor",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurfaceColor)),
        const SizedBox(height: 16),

        ..._pendingTopics.map((topic) {
          final bool isApproved = topic['isApproved'] == true;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isApproved ? const Color(0xFF10B981).withOpacity(0.5) : borderColor),
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
                              color: isApproved ? const Color(0xFF10B981).withOpacity(0.12) : const Color(0xFFF59E0B).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isApproved ? "✅ ADOPTED FOR AGENDA" : "⏳ UNDER ELDER REVIEW",
                              style: TextStyle(color: isApproved ? const Color(0xFF10B981) : brandColor, fontSize: 9.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text("${topic['votes']} member votes", style: TextStyle(color: onSurfaceColor.withOpacity(0.6), fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(topic['title'], style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold, fontSize: 13.5)),
                      const SizedBox(height: 3),
                      Text("Submitted by: ${topic['author']}", style: TextStyle(color: brandColor, fontSize: 11.5)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isApproved ? borderColor : const Color(0xFF10B981),
                    foregroundColor: isApproved ? onSurfaceColor : Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                  onPressed: () {
                    setState(() {
                      topic['isApproved'] = !isApproved;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isApproved ? "Topic moved back to review." : "Topic adopted for 2027 Kgotla Floor!")),
                    );
                  },
                  child: Text(isApproved ? "Revoke" : "Adopt"),
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
          "SUPPORTING THE HOUSEHOLD OF FAITH",
          style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11),
        ),
        Text("Verify & Endorse Makhetha Family Artisans",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurfaceColor)),
        const SizedBox(height: 16),

        ..._pendingBusinesses.map((b) {
          final bool isEndorsed = b['isEndorsed'] == true;

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
                          Text(b['business'], style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold, fontSize: 13.5)),
                          if (isEndorsed) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 16),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text("Member: ${b['owner']} • ${b['trade']}", style: TextStyle(color: brandColor, fontSize: 11.5)),
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
                      b['isEndorsed'] = !isEndorsed;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isEndorsed ? "Endorsement removed." : "Awarded Bakoena Clan Endorsement Badge!")),
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
  // TAB 4: SAFE HAVEN CRISIS TRIAGE
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

        ..._crisisCases.map((c) {
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
                Text("Assigned Circle: ${c['advocate']}", style: TextStyle(color: brandColor, fontSize: 11.5)),
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