import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class KgotlaTopic {
  final String id;
  final String title;
  final String authorName;
  final String branch;
  final String description;
  int votes;
  bool hasVoted;

  KgotlaTopic({
    required this.id,
    required this.title,
    required this.authorName,
    required this.branch,
    required this.description,
    required this.votes,
    this.hasVoted = false,
  });
}

class ReunionKgotlaScreen extends StatefulWidget {
  const ReunionKgotlaScreen({super.key});

  @override
  State<ReunionKgotlaScreen> createState() => _ReunionKgotlaScreenState();
}

class _ReunionKgotlaScreenState extends State<ReunionKgotlaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Interactive Voting State
  final List<KgotlaTopic> _tabledTopics = [
    KgotlaTopic(
      id: "1",
      title: "Establishment of the Makhetha Youth Education & Bursary Fund",
      authorName: "Ausi Refiloe Makhetha",
      branch: "Gauteng Branch",
      description:
          "Pooling collective clan funds to assist promising Makhetha students with tertiary registration fees and textbook allowances.",
      votes: 142,
    ),
    KgotlaTopic(
      id: "2",
      title: "Digital Archiving of Clan Praise Poems (Lithoko) & Lineage Tree",
      authorName: "Ntate Sello Makhetha",
      branch: "Free State Branch",
      description:
          "Interviewing surviving branch elders to record our ancestral origins, totems, and family tree dating back to the 1800s.",
      votes: 118,
    ),
    KgotlaTopic(
      id: "3",
      title: "Family Emergency & Bereavement Scheme (Mokotla wa Matshediso)",
      authorName: "Mme Mpho Makhetha",
      branch: "Lesotho Heritage Branch",
      description:
          "Formalizing transparent family contributions so bereaved households receive dignified financial and logistical support without panic.",
      votes: 95,
    ),
    KgotlaTopic(
      id: "4",
      title: "Makhetha Business Consortium & Agriculture Co-op",
      authorName: "Abuti Tumelo Makhetha",
      branch: "KZN Branch",
      description:
          "Collaborating on family agricultural land and giving first preference to clan contractors for building, transport, and catering.",
      votes: 76,
    ),
  ];

  // Ticket Booking State
  int _adultPasses = 1;
  int _youthPasses = 0;
  int _tShirts = 0;
  String _tShirtSize = "L (Large)";

  final double _adultPrice = 450.0; // All meals, banquet pass, reunion package
  final double _youthPrice = 200.0;
  final double _tShirtPrice = 180.0;

  double get _totalBookingAmount =>
      (_adultPasses * _adultPrice) +
      (_youthPasses * _youthPrice) +
      (_tShirts * _tShirtPrice);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

  void _submitTicketOrder() {
    final String msg = """
🐊 *LEKGOTLA LA MAKHETHA REUNION 2027 BOOKING*
Date: 24 September 2027 (Heritage Day Weekend)
---------------------------------
🎟️ *Adult Clan Passes:* $_adultPasses (R ${(_adultPasses * _adultPrice).toStringAsFixed(2)})
🎓 *Youth / Student Passes:* $_youthPasses (R ${(_youthPasses * _youthPrice).toStringAsFixed(2)})
👕 *Clan Heritage T-Shirts:* $_tShirts (Size: $_tShirtSize) (R ${(_tShirts * _tShirtPrice).toStringAsFixed(2)})
---------------------------------
💵 *Total Contribution Amount:* R ${_totalBookingAmount.toStringAsFixed(2)}

Please send me the official banking details and reference code for our household booking!
""";

    const String treasuryPhone = "27821234567"; // Reunion Committee WhatsApp
    _launchExternal("https://wa.me/$treasuryPhone?text=${Uri.encodeComponent(msg)}");
  }

  void _showSubmitTopicModal(
    BuildContext context, {
    required Color cardColor,
    required Color borderColor,
    required Color brandColor,
    required Color onSurfaceColor,
    required bool isDark,
  }) {
    final titleC = TextEditingController();
    final nameC = TextEditingController();
    final branchC = TextEditingController(text: "Gauteng Branch");
    final descC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor),
        ),
        title: Row(
          children: [
            Icon(Icons.how_to_vote_rounded, color: brandColor, size: 22),
            const SizedBox(width: 10),
            Text(
              "Table an Agenda Topic",
              style: TextStyle(color: onSurfaceColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Submit an issue, proposal, or family question to be discussed by the Elders Council at the 2027 Kgotla.",
                style: TextStyle(color: onSurfaceColor.withOpacity(0.7), fontSize: 11.5),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: titleC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Topic Title (e.g. Family Bursary Trust) *", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: nameC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Your Name (or Household Rep) *", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: branchC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Your Family Branch *", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: descC,
                maxLines: 3,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Explain why this matter should be tabled *", onSurfaceColor, borderColor, isDark),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: onSurfaceColor.withOpacity(0.6))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: brandColor,
              foregroundColor: isDark ? Colors.black : Colors.white,
            ),
            onPressed: () {
              if (titleC.text.isNotEmpty && nameC.text.isNotEmpty) {
                setState(() {
                  _tabledTopics.insert(
                    0,
                    KgotlaTopic(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleC.text.trim(),
                      authorName: nameC.text.trim(),
                      branch: branchC.text.trim(),
                      description: descC.text.trim(),
                      votes: 1,
                      hasVoted: true,
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Topic submitted to the Kgotla floor for voting!"),
                    backgroundColor: Color(0xFF16A34A),
                  ),
                );
              }
            },
            child: const Text("Table Topic"),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecor(String label, Color onSurfaceColor, Color borderColor, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 12),
      filled: true,
      fillColor: isDark ? const Color(0xFF0B1120) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 DYNAMIC THEME ACCESS
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final brandColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final cardColor = theme.cardColor;
    final borderColor = theme.dividerColor;

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
          indicatorColor: brandColor,
          indicatorWeight: 3,
          labelColor: brandColor,
          unselectedLabelColor: onSurfaceColor.withOpacity(0.6),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
          tabs: const [
            Tab(icon: Icon(Icons.how_to_vote_rounded, size: 17), text: "Kgotla Topics"),
            Tab(icon: Icon(Icons.event_note_rounded, size: 17), text: "Program & Speakers"),
            Tab(icon: Icon(Icons.confirmation_number_rounded, size: 17), text: "Tickets & Attire"),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTopicsVotingTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
              _buildProgramSpeakersTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
              _buildTicketBookingTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 1: KGOTLA TOPICS & DEMOCRATIC VOTING
  // ===========================================================================
  Widget _buildTopicsVotingTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Action Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: brandColor.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: brandColor.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(Icons.how_to_vote_rounded, color: brandColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Democratic Kgotla Floor",
                        style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold, fontSize: 13)),
                    Text("Upvote topics for the 2027 AGM agenda or table a new issue.",
                        style: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 11)),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandColor,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () => _showSubmitTopicModal(
                  context,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  brandColor: brandColor,
                  onSurfaceColor: onSurfaceColor,
                  isDark: isDark,
                ),
                icon: const Icon(Icons.add, size: 15),
                label: const Text("Table Topic", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Text(
          "PROPOSED ISSUES RANKED BY FAMILY VOTES",
          style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
        ),
        const SizedBox(height: 10),

        ..._tabledTopics.map((topic) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upvote Counter Column
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        topic.hasVoted ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
                        color: topic.hasVoted ? brandColor : onSurfaceColor.withOpacity(0.5),
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          if (topic.hasVoted) {
                            topic.votes--;
                            topic.hasVoted = false;
                          } else {
                            topic.votes++;
                            topic.hasVoted = true;
                          }
                        });
                      },
                    ),
                    Text(
                      "${topic.votes}",
                      style: TextStyle(
                        color: topic.hasVoted ? brandColor : onSurfaceColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                    Text("votes", style: TextStyle(color: onSurfaceColor.withOpacity(0.5), fontSize: 9.5)),
                  ],
                ),
                const SizedBox(width: 12),

                // Topic Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic.title,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: onSurfaceColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Proposed by ${topic.authorName} • ${topic.branch}",
                        style: TextStyle(fontSize: 11, color: brandColor, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        topic.description,
                        style: TextStyle(color: onSurfaceColor.withOpacity(0.7), fontSize: 12, height: 1.4),
                      ),
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
  // TAB 2: ITINERARY & KEYNOTE SPEAKERS
  // ===========================================================================
  Widget _buildProgramSpeakersTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        _dayProgramBlock(
          day: "DAY 1 • FRIDAY, 24 SEPTEMBER 2027",
          title: "Roots, Arrival & Ancestral Welcome",
          cardColor: cardColor,
          borderColor: borderColor,
          brandColor: brandColor,
          onSurfaceColor: onSurfaceColor,
          items: [
            "10:00 - 14:00: Arrival, Registration & Welcome Refreshments",
            "14:30 - 16:30: Tour of Ancestral Grounds & Historical Gravesite Respects",
            "17:30 - 19:30: Opening Ceremony & Cultural Welcome Feast (Kamogelo)",
          ],
        ),
        const SizedBox(height: 14),

        _dayProgramBlock(
          day: "DAY 2 • SATURDAY, 25 SEPTEMBER 2027",
          title: "The Grand Kgotla Assembly & Youth Forum",
          cardColor: cardColor,
          borderColor: borderColor,
          brandColor: brandColor,
          onSurfaceColor: onSurfaceColor,
          items: [
            "09:00 - 10:30: Morning Devotion & Thanksgiving Prayer",
            "10:45 - 13:00: Main Kgotla AGM: Deliberation on Tabled Member Topics",
            "13:00 - 14:30: Fellowship Lunch & Branch Photo Sessions",
            "15:00 - 17:30: Makhetha Youth Career & Entrepreneurship Panel",
            "18:30 - 21:00: Royal Clan Banquet & Traditional Music",
          ],
        ),
        const SizedBox(height: 14),

        _dayProgramBlock(
          day: "DAY 3 • SUNDAY, 26 SEPTEMBER 2027",
          title: "Resolutions, Feast & Safe Travels",
          cardColor: cardColor,
          borderColor: borderColor,
          brandColor: brandColor,
          onSurfaceColor: onSurfaceColor,
          items: [
            "09:30 - 11:30: Adoption of Resolutions & Election of Council Executives",
            "12:00 - 14:30: Grand Braai & Farewell Fellowship (Tsela Tshweu)",
          ],
        ),
      ],
    );
  }

  Widget _dayProgramBlock({
    required String day,
    required String title,
    required List<String> items,
    required Color cardColor,
    required Color borderColor,
    required Color brandColor,
    required Color onSurfaceColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day, style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.8)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold, fontSize: 14.5)),
          Divider(color: borderColor, height: 20),
          ...items.map((it) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_rounded, color: brandColor, size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(it, style: TextStyle(color: onSurfaceColor.withOpacity(0.75), fontSize: 12, height: 1.35)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 3: TICKETS, BANQUET PASSES & CLAN ATTIRE
  // ===========================================================================
  Widget _buildTicketBookingTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Ticket Calculator Card
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
              Text(
                "SELECT REUNION PASSES & PACKAGES",
                style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
              ),
              const SizedBox(height: 6),
              Text(
                "Reserve Seats for Your Household",
                style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: onSurfaceColor),
              ),
              const SizedBox(height: 4),
              Text(
                "Covers full weekend marquee, catering (all 3 days), banquet seating, and reunion program kit.",
                style: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 11.5),
              ),
              Divider(color: borderColor, height: 24),

              // Adult Pass Counter
              _counterRow(
                title: "Adult Full Clan Pass (18+ yrs)",
                price: "R ${_adultPrice.toStringAsFixed(0)} each",
                count: _adultPasses,
                onAdd: () => setState(() => _adultPasses++),
                onRemove: () => setState(() {
                  if (_adultPasses > 0) _adultPasses--;
                }),
                onSurfaceColor: onSurfaceColor,
                brandColor: brandColor,
              ),
              const SizedBox(height: 12),

              // Youth Pass Counter
              _counterRow(
                title: "Youth / Student Pass (12 - 17 yrs)",
                price: "R ${_youthPrice.toStringAsFixed(0)} each",
                count: _youthPasses,
                onAdd: () => setState(() => _youthPasses++),
                onRemove: () => setState(() {
                  if (_youthPasses > 0) _youthPasses--;
                }),
                onSurfaceColor: onSurfaceColor,
                brandColor: brandColor,
              ),
              const SizedBox(height: 12),

              // T-Shirt Counter
              _counterRow(
                title: "Official Makhetha Heritage T-Shirt",
                price: "R ${_tShirtPrice.toStringAsFixed(0)} each",
                count: _tShirts,
                onAdd: () => setState(() => _tShirts++),
                onRemove: () => setState(() {
                  if (_tShirts > 0) _tShirts--;
                }),
                onSurfaceColor: onSurfaceColor,
                brandColor: brandColor,
              ),

              if (_tShirts > 0) ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _tShirtSize,
                  dropdownColor: cardColor,
                  style: TextStyle(color: onSurfaceColor, fontSize: 12),
                  decoration: _inputDecor("Select Preferred T-Shirt Size", onSurfaceColor, borderColor, isDark),
                  items: ["S (Small)", "M (Medium)", "L (Large)", "XL (Extra Large)", "2XL", "3XL"]
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _tShirtSize = v!),
                ),
              ],
              Divider(color: borderColor, height: 24),

              // Total Calculation Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Contribution:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: onSurfaceColor)),
                  Text(
                    "R ${_totalBookingAmount.toStringAsFixed(2)}",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: brandColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _totalBookingAmount > 0 ? _submitTicketOrder : null,
                  icon: const Icon(Icons.confirmation_number_rounded, size: 16),
                  label: const Text(
                    "Submit Booking via WhatsApp to Treasury",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _counterRow({
    required String title,
    required String price,
    required int count,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
    required Color onSurfaceColor,
    required Color brandColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: onSurfaceColor)),
              Text(price, style: TextStyle(fontSize: 11, color: brandColor, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
          onPressed: onRemove,
          color: onSurfaceColor.withOpacity(0.6),
        ),
        Text("$count", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: onSurfaceColor)),
        IconButton(
          icon: Icon(Icons.add_circle_outline_rounded, size: 20, color: brandColor),
          onPressed: onAdd,
        ),
      ],
    );
  }
}