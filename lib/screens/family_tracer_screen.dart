import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FamilyTracerNotice {
  final String id;
  final String inquiryTitle;
  final String ancestorNames;
  final String lastKnownArea;
  final String approximateYear;
  final String contactPerson;
  final String branch;
  final String phone;
  final String description;

  const FamilyTracerNotice({
    required this.id,
    required this.inquiryTitle,
    required this.ancestorNames,
    required this.lastKnownArea,
    required this.approximateYear,
    required this.contactPerson,
    required this.branch,
    required this.phone,
    required this.description,
  });
}

class LostAndFoundItem {
  final String id;
  final String title;
  final String status; // "LOST" or "FOUND"
  final String location;
  final String reportedBy;
  final String phone;
  final String description;

  const LostAndFoundItem({
    required this.id,
    required this.title,
    required this.status,
    required this.location,
    required this.reportedBy,
    required this.phone,
    required this.description,
  });
}

class FamilyTracerScreen extends StatefulWidget {
  const FamilyTracerScreen({super.key});

  @override
  State<FamilyTracerScreen> createState() => _FamilyTracerScreenState();
}

class _FamilyTracerScreenState extends State<FamilyTracerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<FamilyTracerNotice> _tracerInquiries = [
    const FamilyTracerNotice(
      id: "1",
      inquiryTitle: "Searching for Descendants of Ntate Molefi Makhetha",
      ancestorNames: "Molefi Makhetha & Mme Malisebo",
      lastKnownArea: "QwaQwa / Harrismith, Free State",
      approximateYear: "Circa 1978 - 1985",
      contactPerson: "Koko Masello Makhetha",
      branch: "Free State Branch",
      phone: "27821234567",
      description:
          "Our grandfather Molefi moved from Lesotho to QwaQwa in the late 1970s. We are looking to reconnect with his children and grandchildren before the 2027 reunion.",
    ),
    const FamilyTracerNotice(
      id: "2",
      inquiryTitle: "Reconnecting Branch of Mme Mathabo Makhetha (Soweto)",
      ancestorNames: "Mathabo Makhetha (Ma-Tshepo)",
      lastKnownArea: "Meadowlands / Moroka, Soweto",
      approximateYear: "1988 - 1994",
      contactPerson: "Abuti Tshepo Makhetha",
      branch: "Gauteng Branch",
      phone: "27829988776",
      description:
          "Looking for our cousins who grew up in Soweto Zone 4. Our family lineage traces back to the Makhetha household in Ficksburg.",
    ),
    const FamilyTracerNotice(
      id: "3",
      inquiryTitle: "Seeking Descendants of Rev. Elias Makhetha",
      ancestorNames: "Elias & Grace Makhetha",
      lastKnownArea: "Pietermaritzburg / Edendale, KZN",
      approximateYear: "1965 - 1975",
      contactPerson: "Ntate Sello Makhetha",
      branch: "KZN Branch",
      phone: "27834449911",
      description:
          "We are piecing together our KZN ancestral registry. Any relatives who are grandchildren of Rev. Elias are warmly requested to reach out.",
    ),
  ];

  final List<LostAndFoundItem> _lostAndFoundItems = [
    const LostAndFoundItem(
      id: "1",
      title: "Gold Engraved Makhetha Signet Ring",
      status: "LOST",
      location: "Reunion Main Hall / Marquee",
      reportedBy: "Bro. Kagiso Makhetha",
      phone: "27821234567",
      description:
          "Family heirloom ring engraved with 'M' and crocodile motif. Misplaced during the Saturday evening banquet fellowship.",
    ),
    const LostAndFoundItem(
      id: "2",
      title: "Blue & Yellow Seanamarena Heritage Blanket",
      status: "FOUND",
      location: "Found on Marquee Guest Chair",
      reportedBy: "Ausi Lerato (Organizing Committee)",
      phone: "27829988776",
      description:
          "Authentic woolen Basotho blanket left behind after Sunday morning farewell photos. In safe custody with the organizing team.",
    ),
    const LostAndFoundItem(
      id: "3",
      title: "Leather Photo Album (1998 Reunion Memories)",
      status: "FOUND",
      location: "Handed to Registration Desk",
      reportedBy: "Reunion Secretariat",
      phone: "27834449911",
      description:
          "Brown vintage leather album containing vintage family portraits and ancestral gravesite photos.",
    ),
  ];

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

  void _connectOnWhatsApp(String phone, String subject) {
    final String msg = """
🐊 *LEKGOTLA LA MAKHETHA • KINSHIP INQUIRY*
Greetings! I am contacting you regarding your family notice:
*'$subject'*

I believe our branch has valuable lineage information or connection to share.
""";
    final Uri uri = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(msg)}");
    _launchExternal(uri.toString());
  }

  void _showPostInquiryModal(
    BuildContext context, {
    required Color cardColor,
    required Color borderColor,
    required Color brandColor,
    required Color onSurfaceColor,
    required bool isDark,
  }) {
    final titleC = TextEditingController();
    final ancestorsC = TextEditingController();
    final areaC = TextEditingController();
    final yearC = TextEditingController();
    final contactC = TextEditingController();
    final branchC = TextEditingController(text: "Gauteng Branch");
    final phoneC = TextEditingController();
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
            Icon(Icons.person_search_rounded, color: brandColor, size: 22),
            const SizedBox(width: 10),
            Text(
              "Post a Family Tracer Notice",
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
                "Searching for a separated branch or long-lost relative? Post details so clan members worldwide can assist.",
                style: TextStyle(color: onSurfaceColor.withOpacity(0.7), fontSize: 11.5),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: titleC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Notice Title *", hint: "e.g. Seeking family of Ntate Molefi", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: ancestorsC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Ancestors / Relatives' Names *", hint: "Names of grandparents/parents", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: areaC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Last Known Town / District *", hint: "e.g. QwaQwa, Soweto, Maseru", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: yearC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Approximate Years", hint: "e.g. 1975 - 1985", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: contactC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Your Name & Relation *", hint: "e.g. Grandson / Niece", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: branchC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Your Branch *", hint: "e.g. Free State Branch", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: phoneC,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("WhatsApp Number *", hint: "082 123 4567", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: descC,
                maxLines: 3,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Lineage Clues & Story *", hint: "Share any known clans, villages, schools, or memories...", onSurfaceColor, borderColor, isDark),
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
              if (titleC.text.isNotEmpty && contactC.text.isNotEmpty && phoneC.text.isNotEmpty) {
                setState(() {
                  _tracerInquiries.insert(
                    0,
                    FamilyTracerNotice(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      inquiryTitle: titleC.text.trim(),
                      ancestorNames: ancestorsC.text.trim(),
                      lastKnownArea: areaC.text.trim(),
                      approximateYear: yearC.text.trim().isNotEmpty ? yearC.text.trim() : "Not specified",
                      contactPerson: contactC.text.trim(),
                      branch: branchC.text.trim(),
                      phone: phoneC.text.trim().replaceAll('+', ''),
                      description: descC.text.trim(),
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Family inquiry published to the Clan Tracer!"),
                    backgroundColor: Color(0xFF16A34A),
                  ),
                );
              }
            },
            child: const Text("Publish Inquiry"),
          ),
        ],
      ),
    );
  }

  void _showReportItemModal(
    BuildContext context, {
    required Color cardColor,
    required Color borderColor,
    required Color brandColor,
    required Color onSurfaceColor,
    required bool isDark,
  }) {
    final titleC = TextEditingController();
    final locationC = TextEditingController();
    final nameC = TextEditingController();
    final phoneC = TextEditingController();
    final descC = TextEditingController();
    String status = "LOST";

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            backgroundColor: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: borderColor),
            ),
            title: Row(
              children: [
                Icon(Icons.inventory_2_rounded, color: brandColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  "Report Lost / Found Item",
                  style: TextStyle(color: onSurfaceColor, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text("🔴 I Lost an Item"),
                          selected: status == "LOST",
                          selectedColor: const Color(0xFFEF4444).withOpacity(0.2),
                          onSelected: (_) => setModalState(() => status = "LOST"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text("🟢 I Found an Item"),
                          selected: status == "FOUND",
                          selectedColor: const Color(0xFF10B981).withOpacity(0.2),
                          onSelected: (_) => setModalState(() => status = "FOUND"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleC,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Item Name *", hint: "e.g. Basotho Blanket, Signet Ring", onSurfaceColor, borderColor, isDark),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: locationC,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Location / Gathering Venue *", hint: "e.g. Main Hall Chair, Parking", onSurfaceColor, borderColor, isDark),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameC,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Your Name *", hint: "e.g. Ausi Mpho", onSurfaceColor, borderColor, isDark),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneC,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("WhatsApp Number *", hint: "082 123 4567", onSurfaceColor, borderColor, isDark),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descC,
                    maxLines: 3,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Description & Identifying Marks", hint: "Color, markings, engravings...", onSurfaceColor, borderColor, isDark),
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
                      _lostAndFoundItems.insert(
                        0,
                        LostAndFoundItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleC.text.trim(),
                          status: status,
                          location: locationC.text.trim(),
                          reportedBy: nameC.text.trim(),
                          phone: phoneC.text.trim().replaceAll('+', ''),
                          description: descC.text.trim(),
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("✅ Notice posted to Lost & Found vault!"),
                        backgroundColor: Color(0xFF16A34A),
                      ),
                    );
                  }
                },
                child: const Text("Post Item"),
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _inputDecor(
    String label,
    Color onSurfaceColor,
    Color borderColor,
    bool isDark, {
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 12),
      hintStyle: TextStyle(color: onSurfaceColor.withOpacity(0.35), fontSize: 12),
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
          "LINEAGE, TRACER & CLAN ROOTS",
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
            Tab(icon: Icon(Icons.shield_rounded, size: 17), text: "Koena Roots"),
            Tab(icon: Icon(Icons.person_search_rounded, size: 17), text: "Kinship Tracer"),
            Tab(icon: Icon(Icons.inventory_2_rounded, size: 17), text: "Lost & Found"),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAncestralRootsTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
              _buildKinshipTracerTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
              _buildLostAndFoundTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 1: ANCESTRAL ROOTS & LITHOKO (CLAN PRAISES)
  // ===========================================================================
  Widget _buildAncestralRootsTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // 🐊 Totem Spotlight Card
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: brandColor.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    )
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: brandColor.withOpacity(0.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Text("🐊", style: TextStyle(fontSize: 26)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SEBOKO: KOENA (CROCODILE)",
                          style: TextStyle(
                            color: brandColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 1.1,
                          ),
                        ),
                        Text(
                          "Re Bakoena ba heso!",
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: onSurfaceColor,
                          ),
                        ),
                        Text(
                          "Batho ba noka e koto ya Senqu",
                          style: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: borderColor, height: 24),
              Text(
                "LITHOKO TSA BAKOENA (CLAN PRAISES)",
                style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: brandColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: brandColor.withOpacity(0.18)),
                ),
                child: Text(
                  "\"Re Bakoena!\nRe batho ba ha Maiyane a tsokotla,\nBa tsokotla metsi ka mohatla wa noka e kgolo!\nKoena ha e lome ngoan'abo,\nE loma moeti a tsoang thoko!\nMokwena! Kwena e ntlha, batho ba ha Makhetha!\"",
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                    color: onSurfaceColor.withOpacity(0.9),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Historical Lineage Overview",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: onSurfaceColor),
              ),
              const SizedBox(height: 4),
              Text(
                "The Makhetha house traces its roots to the royal Bakoena lineage of Southern Africa. As families expanded along the Caledon and Senqu rivers into the Free State, Natal, and modern urban centers, the core bond of blood, honor, and mutual brotherhood remains unbreakable.",
                style: TextStyle(color: onSurfaceColor.withOpacity(0.72), fontSize: 12, height: 1.45),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Branch Lineage Registry Card
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
                "REGISTERED CLAN BRANCHES",
                style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
              ),
              const SizedBox(height: 10),
              _branchRow("👑 Lesotho Heritage Branch", "Maseru, Leribe & Berea • Ancestral seat", onSurfaceColor),
              _branchRow("🌾 Free State Branch", "Bloemfontein, QwaQwa, Ficksburg & Harrismith", onSurfaceColor),
              _branchRow("⚡ Gauteng Branch", "Johannesburg, Soweto, Pretoria & Vaal", onSurfaceColor),
              _branchRow("🌊 KwaZulu-Natal Branch", "Durban, Pietermaritzburg & Midlands", onSurfaceColor),
              _branchRow("🌍 Global Diaspora Branch", "United Kingdom, United States, Canada & Australia", onSurfaceColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _branchRow(String title, String areas, Color onSurfaceColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right_rounded, size: 18, color: Color(0xFFF59E0B)),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: onSurfaceColor)),
                Text(areas, style: TextStyle(fontSize: 11, color: onSurfaceColor.withOpacity(0.6))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 2: KINSHIP TRACER (SEPARATED BRANCHES)
  // ===========================================================================
  Widget _buildKinshipTracerTab(
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
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: brandColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_search_rounded, color: brandColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Searching for Relatives?",
                        style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold, fontSize: 13)),
                    Text("Help reconnect separated family branches worldwide.",
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
                onPressed: () => _showPostInquiryModal(
                  context,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  brandColor: brandColor,
                  onSurfaceColor: onSurfaceColor,
                  isDark: isDark,
                ),
                icon: const Icon(Icons.add, size: 15),
                label: const Text("Post Inquiry", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Text(
          "ACTIVE FAMILY BRANCH INQUIRIES",
          style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
        ),
        const SizedBox(height: 10),

        ..._tracerInquiries.map((inquiry) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
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
                          Text(
                            inquiry.inquiryTitle,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              color: onSurfaceColor,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "Ancestors: ${inquiry.ancestorNames}",
                            style: TextStyle(fontSize: 11.5, color: brandColor, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: brandColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        inquiry.branch,
                        style: TextStyle(color: brandColor, fontSize: 9.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "📍 Last Known Area: ${inquiry.lastKnownArea} • (${inquiry.approximateYear})",
                  style: TextStyle(fontSize: 11, color: onSurfaceColor.withOpacity(0.7)),
                ),
                const SizedBox(height: 6),
                Text(
                  inquiry.description,
                  style: TextStyle(fontSize: 12, color: onSurfaceColor.withOpacity(0.75), height: 1.4),
                ),
                Divider(color: borderColor, height: 20),
                Row(
                  children: [
                    Text(
                      "Inquirer: ${inquiry.contactPerson}",
                      style: TextStyle(fontSize: 11, color: onSurfaceColor.withOpacity(0.65)),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: () => _connectOnWhatsApp(inquiry.phone, inquiry.inquiryTitle),
                      icon: const Icon(Icons.chat_bubble_rounded, size: 13),
                      label: const Text("I Have Lineage Info", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
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
  // TAB 3: LOST & FOUND CLAN HEIRLOOMS
  // ===========================================================================
  Widget _buildLostAndFoundTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Top Action Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: brandColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.inventory_2_rounded, color: brandColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Reunion Lost & Found Vault",
                        style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold, fontSize: 13)),
                    Text("Misplaced blankets, jewelry, keys, or family photos?",
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
                onPressed: () => _showReportItemModal(
                  context,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  brandColor: brandColor,
                  onSurfaceColor: onSurfaceColor,
                  isDark: isDark,
                ),
                icon: const Icon(Icons.add, size: 15),
                label: const Text("Report Item", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Text(
          "RECENT REUNION ITEMS IN VAULT",
          style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
        ),
        const SizedBox(height: 10),

        ..._lostAndFoundItems.map((item) {
          final isLost = item.status == "LOST";
          final statusColor = isLost ? const Color(0xFFEF4444) : const Color(0xFF10B981);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isLost ? "🔴 LOST ITEM" : "🟢 FOUND AT REUNION",
                        style: TextStyle(color: statusColor, fontSize: 9.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.location,
                        style: TextStyle(color: onSurfaceColor.withOpacity(0.6), fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: onSurfaceColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(fontSize: 12, color: onSurfaceColor.withOpacity(0.72), height: 1.4),
                ),
                Divider(color: borderColor, height: 18),
                Row(
                  children: [
                    Text(
                      "Reported by: ${item.reportedBy}",
                      style: TextStyle(fontSize: 11, color: onSurfaceColor.withOpacity(0.65)),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: () => _connectOnWhatsApp(item.phone, "${item.status}: ${item.title}"),
                      icon: const Icon(Icons.chat_bubble_rounded, size: 12),
                      label: Text(
                        isLost ? "I Found It" : "Claim Item",
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}