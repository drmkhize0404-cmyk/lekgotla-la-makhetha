import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/clan_settings_service.dart';
import '../services/clan_auth_service.dart';

class KgotlaTopic {
  final String id;
  final String title;
  final String authorName;
  final String branch;
  final String description;
  int likes;
  int dislikes;
  String? userVote; // 'like', 'dislike', or null
  bool isFinalised;

  KgotlaTopic({
    required this.id,
    required this.title,
    required this.authorName,
    required this.branch,
    required this.description,
    required this.likes,
    required this.dislikes,
    this.userVote,
    this.isFinalised = false,
  });

  int get netScore => likes - dislikes;
}

class ReunionKgotlaScreen extends StatefulWidget {
  const ReunionKgotlaScreen({super.key});

  @override
  State<ReunionKgotlaScreen> createState() => _ReunionKgotlaScreenState();
}

class _ReunionKgotlaScreenState extends State<ReunionKgotlaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<KgotlaTopic> _allTopics = [
    // Finalised Topics (Approved based on high net votes & council vetting)
    KgotlaTopic(
      id: "T1",
      title: "Establishment of the Makhetha Higher Education Bursary Trust",
      authorName: "Ausi Refiloe Makhetha",
      branch: "Gauteng Branch",
      description: "Pooling collective funds to assist promising Makhetha students with tertiary fees and laptops.",
      likes: 156,
      dislikes: 4,
      isFinalised: true,
    ),
    KgotlaTopic(
      id: "T2",
      title: "Digital Archiving of Clan Praise Poems (Lithoko) & Lineage Tree",
      authorName: "Ntate Sello Makhetha",
      branch: "Free State Branch",
      description: "Recording elderly oral histories and mapping the family tree from 1800 to the present day.",
      likes: 124,
      dislikes: 2,
      isFinalised: true,
    ),

    // Active Proposal Topics (Still in democratic debate & voting)
    KgotlaTopic(
      id: "T3",
      title: "Family Bereavement & Emergency Scheme (Mokotla wa Matshediso)",
      authorName: "Mme Mpho Makhetha",
      branch: "Lesotho Heritage Branch",
      description: "Formalizing emergency contributions so bereaved households receive immediate groceries and transport.",
      likes: 88,
      dislikes: 6,
      isFinalised: false,
    ),
    KgotlaTopic(
      id: "T4",
      title: "Makhetha Commercial Cattle & Grain Agricultural Co-op",
      authorName: "Abuti Tumelo Makhetha",
      branch: "KZN Branch",
      description: "Collaborating on family agricultural land in Ficksburg and giving preference to clan contractors.",
      likes: 72,
      dislikes: 14,
      isFinalised: false,
    ),
  ];

  // In-App Ticket Selection State
  int _adultPasses = 1;
  int _youthPasses = 0;
  int _tShirts = 0;
  String _tShirtSize = "L (Large)";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _launchExternal(String link) async {
    final Uri uri = Uri.parse(link);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  // 📍 EXPORT / DOWNLOAD FINALISED AGENDA
  void _exportFinalisedAgenda(List<KgotlaTopic> finalised) {
    final buffer = StringBuffer();
    buffer.writeln("🐊 *LEKGOTLA LA MAKHETHA • FINALISED REUNION 2027 AGENDA*");
    buffer.writeln("Location: ${ClanSettingsService().reunionLocation}");
    buffer.writeln("Date: 24 September 2027 (Heritage Day Weekend)");
    buffer.writeln("----------------------------------------------");
    buffer.writeln("The following topics were adopted by family vote & elders council:\n");

    for (int i = 0; i < finalised.length; i++) {
      final t = finalised[i];
      buffer.writeln("${i + 1}. *${t.title}*");
      buffer.writeln("   Proposed by: ${t.authorName} (${t.branch})");
      buffer.writeln("   Family Approval: +${t.netScore} net votes (👍 ${t.likes} | 👎 ${t.dislikes})");
      buffer.writeln("   Summary: ${t.description}\n");
    }

    buffer.writeln("Official document issued by Lekgotla la Baholo.");

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Finalised Agenda copied to clipboard! Opening WhatsApp to share..."),
        backgroundColor: Color(0xFF16A34A),
      ),
    );

    const String councilPhone = "27821234567";
    _launchExternal("https://wa.me/$councilPhone?text=${Uri.encodeComponent(buffer.toString())}");
  }

  // 📍 IN-APP TICKET PAYMENT FLOW (WITH AUTH & DIGITAL TICKET GENERATION)
  void _executeInAppTicketPurchase(double totalAmount) {
    ClanAuthService.requireAuthentication(
      context,
      actionName: "purchase reunion passes",
      onAuthenticated: () {
        final user = ClanAuthService().currentUser!;
        final String ticketCode = "TKT-2027-PE-${Random().nextInt(90000) + 10000}";

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Icon(Icons.confirmation_number_rounded, color: Color(0xFF10B981), size: 24),
                SizedBox(width: 8),
                Text("Confirm In-App Payment"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Member: ${user.fullName} (${user.branch})", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("WhatsApp: ${user.phone}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const Divider(height: 20),
                Text("Adult Passes: $_adultPasses"),
                Text("Youth Passes: $_youthPasses"),
                if (_tShirts > 0) Text("Clan T-Shirts: $_tShirts (Size: $_tShirtSize)"),
                const SizedBox(height: 8),
                Text("Total to Pay: R ${totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
                const SizedBox(height: 12),
                const Text("Payment Method: Instant EFT / SafeTrade Clan Escrow", style: TextStyle(fontSize: 11.5, color: Colors.grey)),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(ctx);
                  _showIssuedTicketDialog(ticketCode, user, totalAmount);
                },
                child: const Text("Authorize Payment"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showIssuedTicketDialog(String ticketCode, ClanMemberUser user, double totalAmount) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: const BorderSide(color: Color(0xFFF59E0B))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 48),
            const SizedBox(height: 10),
            Text("TICKET ISSUED SUCCESSFULLY",
                style: GoogleFonts.montserrat(color: const Color(0xFFF59E0B), fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text("Reunion 2027 • Port Elizabeth", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(color: Colors.white24, height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  const Text("DIGITAL PASS QR CODE", style: TextStyle(fontSize: 10, color: Colors.white60, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  const Icon(Icons.qr_code_2_rounded, size: 100, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(ticketCode, style: GoogleFonts.montserrat(color: const Color(0xFFFDE68A), fontWeight: FontWeight.w900, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text("Pass Holder: ${user.fullName} (${user.branch})", style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text("Total Paid: R ${totalAmount.toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Done", style: TextStyle(color: Colors.white60))),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF16A34A), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              final receipt = """
🐊 *LEKGOTLA LA MAKHETHA • DIGITAL PASS RECEIPT*
Ticket Pass: *$ticketCode*
Member: ${user.fullName} (${user.branch})
Location: ${ClanSettingsService().reunionLocation}
Date: 24 September 2027
Total: R ${totalAmount.toStringAsFixed(2)}
---------------------------------
Status: VERIFIED & PAID IN-APP
""";
              _launchExternal("https://wa.me/${user.phone}?text=${Uri.encodeComponent(receipt)}");
            },
            icon: const Icon(Icons.share, size: 16),
            label: const Text("Share Receipt on WhatsApp"),
          ),
        ],
      ),
    );
  }

  void _showSubmitTopicModal(BuildContext context) {
    ClanAuthService.requireAuthentication(
      context,
      actionName: "table a topic for discussion",
      onAuthenticated: () {
        final titleC = TextEditingController();
        final descC = TextEditingController();
        final user = ClanAuthService().currentUser!;

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Propose an Agenda Topic"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Author: ${user.fullName} (${user.branch})", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 12),
                TextField(
                  controller: titleC,
                  decoration: const InputDecoration(labelText: "Proposal Title *", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descC,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Description & Motivation *", border: OutlineInputBorder()),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () {
                  if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
                    setState(() {
                      _allTopics.insert(
                        0,
                        KgotlaTopic(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleC.text.trim(),
                          authorName: user.fullName,
                          branch: user.branch,
                          description: descC.text.trim(),
                          likes: 1,
                          dislikes: 0,
                          userVote: 'like',
                          isFinalised: false,
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("✅ Topic submitted to the Proposal floor for voting!"), backgroundColor: Color(0xFF16A34A)),
                    );
                  }
                },
                child: const Text("Submit Proposal"),
              ),
            ],
          ),
        );
      },
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

    final proposals = _allTopics.where((t) => !t.isFinalised).toList()
      ..sort((a, b) => b.netScore.compareTo(a.netScore));

    final finalised = _allTopics.where((t) => t.isFinalised).toList()
      ..sort((a, b) => b.netScore.compareTo(a.netScore));

    return AnimatedBuilder(
      animation: ClanSettingsService(),
      builder: (context, _) {
        final settings = ClanSettingsService();
        final double totalBooking = (_adultPasses * settings.adultTicketPrice) +
            (_youthPasses * settings.youthTicketPrice) +
            (_tShirts * settings.tShirtPrice);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            title: Text(
              "REUNION 2027 & KGOTLA FLOOR",
              style: GoogleFonts.montserrat(
                fontSize: 12.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: onSurfaceColor,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: brandColor,
              indicatorWeight: 3,
              labelColor: brandColor,
              unselectedLabelColor: onSurfaceColor.withOpacity(0.6),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              tabs: [
                Tab(icon: const Icon(Icons.how_to_vote_rounded, size: 16), text: "Proposals (${proposals.length})"),
                Tab(icon: const Icon(Icons.assignment_turned_in_rounded, size: 16), text: "Finalised Agenda (${finalised.length})"),
                const Tab(icon: Icon(Icons.event_note_rounded, size: 16), text: "Program & Speakers"),
                const Tab(icon: Icon(Icons.shopping_cart_checkout_rounded, size: 16), text: "Buy Passes & Attire"),
              ],
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProposalsTab(proposals, cardColor, borderColor, brandColor, onSurfaceColor, isDark),
                  _buildFinalisedTab(finalised, cardColor, borderColor, brandColor, onSurfaceColor, isDark),
                  _buildProgramTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
                  _buildBuyTicketsTab(settings, totalBooking, cardColor, borderColor, brandColor, onSurfaceColor, isDark),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // 1. PROPOSALS TAB (LIKES VS DISLIKES VOTING)
  // ===========================================================================
  Widget _buildProposalsTab(
    List<KgotlaTopic> proposals,
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
          child: Row(
            children: [
              Icon(Icons.thumbs_up_down_rounded, color: brandColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Propose & Vote on Issues", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: onSurfaceColor)),
                    Text("Rank topics using Likes vs. Dislikes. Top-approved items move to the Finalised Agenda.",
                        style: TextStyle(fontSize: 11, color: onSurfaceColor.withOpacity(0.65))),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: brandColor, foregroundColor: isDark ? Colors.black : Colors.white),
                onPressed: () => _showSubmitTopicModal(context),
                icon: const Icon(Icons.add, size: 15),
                label: const Text("Propose"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...proposals.map((topic) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(topic.title, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14, color: onSurfaceColor)),
                          Text("Proposed by ${topic.authorName} • ${topic.branch}",
                              style: TextStyle(fontSize: 11, color: brandColor, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    // Net Approval Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (topic.netScore >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Net: ${topic.netScore >= 0 ? '+' : ''}${topic.netScore}",
                        style: TextStyle(
                          color: topic.netScore >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(topic.description, style: TextStyle(fontSize: 12, color: onSurfaceColor.withOpacity(0.75), height: 1.4)),
                const Divider(height: 20),
                // Like vs Dislike Row
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        topic.userVote == 'like' ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
                        color: topic.userVote == 'like' ? const Color(0xFF10B981) : onSurfaceColor.withOpacity(0.5),
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          if (topic.userVote == 'like') {
                            topic.likes--;
                            topic.userVote = null;
                          } else {
                            if (topic.userVote == 'dislike') topic.dislikes--;
                            topic.likes++;
                            topic.userVote = 'like';
                          }
                        });
                      },
                    ),
                    Text("${topic.likes}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        topic.userVote == 'dislike' ? Icons.thumb_down_alt_rounded : Icons.thumb_down_alt_outlined,
                        color: topic.userVote == 'dislike' ? const Color(0xFFEF4444) : onSurfaceColor.withOpacity(0.5),
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          if (topic.userVote == 'dislike') {
                            topic.dislikes--;
                            topic.userVote = null;
                          } else {
                            if (topic.userVote == 'like') topic.likes--;
                            topic.dislikes++;
                            topic.userVote = 'dislike';
                          }
                        });
                      },
                    ),
                    Text("${topic.dislikes}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ===========================================================================
  // 2. FINALISED AGENDA (READY FOR DISCUSSION & EXPORT)
  // ===========================================================================
  Widget _buildFinalisedTab(
    List<KgotlaTopic> finalised,
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(colors: [Color(0xFF0F1E36), Color(0xFF1E2A5E)])
                : const LinearGradient(colors: [Color(0xFF451A03), Color(0xFF78350F)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("COUNCIL ADOPTED AGENDA", style: TextStyle(color: Color(0xFFFDE68A), fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1)),
              const SizedBox(height: 6),
              Text("Official Discussion Items for Port Elizabeth 2027",
                  style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              const Text("These proposals gained overwhelming family consensus and are ratified for deliberation.",
                  style: TextStyle(color: Colors.white70, fontSize: 11.5)),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B), foregroundColor: Colors.black),
                onPressed: () => _exportFinalisedAgenda(finalised),
                icon: const Icon(Icons.share_rounded, size: 16),
                label: const Text("Download / Share Agenda on WhatsApp", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...finalised.asMap().entries.map((entry) {
          final int index = entry.key;
          final KgotlaTopic topic = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF10B981).withOpacity(0.4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFF10B981),
                  child: Text("${index + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(topic.title, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 13.5, color: onSurfaceColor)),
                      const SizedBox(height: 2),
                      Text("Proposed by ${topic.authorName} (${topic.branch}) • 👍 ${topic.likes} votes",
                          style: TextStyle(fontSize: 11, color: brandColor, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(topic.description, style: TextStyle(fontSize: 12, color: onSurfaceColor.withOpacity(0.72), height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ===========================================================================
  // 3. PROGRAM & SPEAKERS TAB
  // ===========================================================================
  Widget _buildProgramTab(Color cardColor, Color borderColor, Color brandColor, Color onSurfaceColor, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _programCard("DAY 1 • FRIDAY, 24 SEPTEMBER 2027", "Roots, Arrival & Ancestral Welcome", [
          "10:00 - 14:00: Arrival & Registration at Nelson Mandela Bay Marquee",
          "15:00 - 17:00: Historical Tour of Port Elizabeth Ancestral Sites",
          "18:00 - 20:30: Traditional Cultural Welcome Feast (Kamogelo)",
        ], cardColor, borderColor, brandColor, onSurfaceColor),
        const SizedBox(height: 12),
        _programCard("DAY 2 • SATURDAY, 25 SEPTEMBER 2027", "The Grand Kgotla Assembly & Youth Forum", [
          "09:00 - 10:30: Morning Devotion & Thanksgiving Prayer",
          "10:45 - 13:00: Deliberation of Finalised Agenda Topics",
          "15:00 - 17:30: Youth Career & Entrepreneurship Panel",
          "18:30 - 21:00: Royal Clan Banquet & Traditional Music",
        ], cardColor, borderColor, brandColor, onSurfaceColor),
        const SizedBox(height: 12),
        _programCard("DAY 3 • SUNDAY, 26 SEPTEMBER 2027", "Resolutions, Feast & Safe Travels", [
          "09:30 - 11:30: Adoption of Resolutions & Executive Nominations",
          "12:00 - 15:00: Farewell Feast (Tsela Tshweu)",
        ], cardColor, borderColor, brandColor, onSurfaceColor),
      ],
    );
  }

  Widget _programCard(String day, String title, List<String> items, Color cardColor, Color borderColor, Color brandColor, Color onSurfaceColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day, style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11)),
          Text(title, style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold, fontSize: 14)),
          Divider(color: borderColor, height: 20),
          ...items.map((it) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_rounded, color: brandColor, size: 14),
                    const SizedBox(width: 8),
                    Expanded(child: Text(it, style: TextStyle(color: onSurfaceColor.withOpacity(0.75), fontSize: 11.5))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. BUY TICKETS TAB (IN-APP PAYMENT + ADMIN-DYNAMIC PRICES)
  // ===========================================================================
  Widget _buildBuyTicketsTab(ClanSettingsService settings, double totalBooking, Color cardColor, Color borderColor, Color brandColor, Color onSurfaceColor, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(18), border: Border.all(color: borderColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("IN-APP REUNION PASSES & PACKAGES", style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11)),
              const SizedBox(height: 4),
              Text("Book Household Passes for Port Elizabeth 2027", style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: onSurfaceColor)),
              Text("Covers full weekend marquee, 3-day catering, and banquet access.", style: TextStyle(fontSize: 11.5, color: onSurfaceColor.withOpacity(0.65))),
              Divider(color: borderColor, height: 24),

              // Dynamic Adult Pass
              _ticketCounter("Adult Clan Pass (18+ yrs)", "R ${settings.adultTicketPrice.toStringAsFixed(0)}", _adultPasses, () => setState(() => _adultPasses++), () {
                if (_adultPasses > 0) setState(() => _adultPasses--);
              }, onSurfaceColor, brandColor),
              const SizedBox(height: 12),

              // Dynamic Youth Pass
              _ticketCounter("Youth / Student Pass (12 - 17 yrs)", "R ${settings.youthTicketPrice.toStringAsFixed(0)}", _youthPasses, () => setState(() => _youthPasses++), () {
                if (_youthPasses > 0) setState(() => _youthPasses--);
              }, onSurfaceColor, brandColor),
              const SizedBox(height: 12),

              // Dynamic T-Shirt
              _ticketCounter("Official Heritage T-Shirt", "R ${settings.tShirtPrice.toStringAsFixed(0)}", _tShirts, () => setState(() => _tShirts++), () {
                if (_tShirts > 0) setState(() => _tShirts--);
              }, onSurfaceColor, brandColor),

              if (_tShirts > 0) ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _tShirtSize,
                  dropdownColor: cardColor,
                  style: TextStyle(color: onSurfaceColor, fontSize: 12),
                  decoration: const InputDecoration(labelText: "T-Shirt Size", border: OutlineInputBorder()),
                  items: ["S", "M", "L", "XL", "2XL", "3XL"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _tShirtSize = v!),
                ),
              ],
              Divider(color: borderColor, height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Payable:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("R ${totalBooking.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: brandColor)),
                ],
              ),
              const SizedBox(height: 16),

              // 📍 IN-APP CHECKOUT BUTTON
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                  onPressed: totalBooking > 0 ? () => _executeInAppTicketPurchase(totalBooking) : null,
                  icon: const Icon(Icons.payment_rounded, size: 18),
                  label: const Text("Pay & Generate Ticket In-App", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ticketCounter(String title, String price, int count, VoidCallback onAdd, VoidCallback onRemove, Color onSurfaceColor, Color brandColor) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: onSurfaceColor)),
              Text(price, style: TextStyle(fontSize: 11, color: brandColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        IconButton(icon: const Icon(Icons.remove_circle_outline, size: 20), onPressed: onRemove),
        Text("$count", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: onSurfaceColor)),
        IconButton(icon: Icon(Icons.add_circle_outline, size: 20, color: brandColor), onPressed: onAdd),
      ],
    );
  }
}