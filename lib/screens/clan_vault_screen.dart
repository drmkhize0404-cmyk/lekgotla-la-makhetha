import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ClanVaultVideo {
  final String id;
  final String title;
  final String speakerOrEvent;
  final String year;
  final String duration;
  final String thumbnailUrl;
  final String videoUrl;
  final String description;
  final String category;

  const ClanVaultVideo({
    required this.id,
    required this.title,
    required this.speakerOrEvent,
    required this.year,
    required this.duration,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.description,
    required this.category,
  });
}

class ClanVaultDocument {
  final String id;
  final String title;
  final String year;
  final String category;
  final String pages;
  final String downloadUrl;
  final String summary;

  const ClanVaultDocument({
    required this.id,
    required this.title,
    required this.year,
    required this.category,
    required this.pages,
    required this.downloadUrl,
    required this.summary,
  });
}

class ClanVaultScreen extends StatefulWidget {
  const ClanVaultScreen({super.key});

  @override
  State<ClanVaultScreen> createState() => _ClanVaultScreenState();
}

class _ClanVaultScreenState extends State<ClanVaultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedYear = "All Gatherings";

  final List<String> _reunionYears = [
    "All Gatherings",
    "2026 Reunion",
    "2023 Reunion",
    "2018 Gathering",
    "Vintage Archives",
  ];

  final List<ClanVaultVideo> _videos = [
    const ClanVaultVideo(
      id: "V1",
      title: "Opening Keynote: Rebuilding the House of Makhetha",
      speakerOrEvent: "Ntate Sello Makhetha (Elder Council)",
      year: "2026 Reunion",
      duration: "42 min",
      thumbnailUrl: "https://images.unsplash.com/photo-1511578314322-379afb476865?q=80&w=800",
      videoUrl: "https://www.youtube.com",
      description: "Address delivered at the recent reunion detailing ancestral roots and economic unity for all branches.",
      category: "KEYNOTE SPEECH",
    ),
    const ClanVaultVideo(
      id: "V2",
      title: "Bakoena Traditional Dance & Praise Recital (Lithoko)",
      speakerOrEvent: "Free State & Lesotho Cultural Troupe",
      year: "2026 Reunion",
      duration: "28 min",
      thumbnailUrl: "https://images.unsplash.com/photo-1465847899084-d164df4dedc6?q=80&w=800",
      videoUrl: "https://www.youtube.com",
      description: "Traditional Mohobelo dance and recitation of the sacred Koena crocodile clan praises.",
      category: "CULTURAL CELEBRATION",
    ),
    const ClanVaultVideo(
      id: "V3",
      title: "Youth Entrepreneurship & Career Panel Discussion",
      speakerOrEvent: "Makhetha Young Professionals Network",
      year: "2023 Reunion",
      duration: "55 min",
      thumbnailUrl: "https://images.unsplash.com/photo-1524178232363-1fb2b075b655?q=80&w=800",
      videoUrl: "https://www.youtube.com",
      description: "Panel discussion on accessing bursaries, tech careers, and agricultural land development.",
      category: "YOUTH FORUM",
    ),
    const ClanVaultVideo(
      id: "V4",
      title: "Foundational Ancestral Documentary & Gravesite Visit",
      speakerOrEvent: "Elders Delegation to Ficksburg / Leribe",
      year: "2018 Gathering",
      duration: "1 hr 12 min",
      thumbnailUrl: "https://images.unsplash.com/photo-1507692049790-de58290a4334?q=80&w=800",
      videoUrl: "https://www.youtube.com",
      description: "Filmed pilgrimage documenting early 20th-century family homesteads and historical gravesites.",
      category: "DOCUMENTARY",
    ),
  ];

  final List<ClanVaultDocument> _documents = [
    const ClanVaultDocument(
      id: "DOC-01",
      title: "Official AGM Minutes & Adopted Resolutions",
      year: "2026 Reunion",
      category: "AGM MINUTES",
      pages: "14 Pages PDF",
      downloadUrl: "https://www.google.com",
      summary: "Adoption of the 2027 Heritage Day date, election of treasury executives, and approval of the Bereavement Fund policy.",
    ),
    const ClanVaultDocument(
      id: "DOC-02",
      title: "Lekgotla la Makhetha Official Constitution & Charter",
      year: "2026 Reunion",
      category: "CONSTITUTION",
      pages: "22 Pages PDF",
      downloadUrl: "https://www.google.com",
      summary: "Governing code for the branch councils, dispute resolution rules, and treasury accountability protocols.",
    ),
    const ClanVaultDocument(
      id: "DOC-03",
      title: "Annual Financial Audit & Contribution Report",
      year: "2026 Reunion",
      category: "TREASURY AUDIT",
      pages: "8 Pages PDF",
      downloadUrl: "https://www.google.com",
      summary: "Full reconciliation of all reunion dues, venue expenses, and catering expenditures.",
    ),
    const ClanVaultDocument(
      id: "DOC-04",
      title: "Historical Branch Genealogy Chart (1885 - 2020)",
      year: "Vintage Archives",
      category: "GENEALOGY ARCHIVE",
      pages: "6 Foldout Sheets",
      downloadUrl: "https://www.google.com",
      summary: "Hand-drafted and verified lineage tracing early migrations from the Caledon River valley.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

  void _showSubmitArchiveModal(
    BuildContext context, {
    required Color cardColor,
    required Color borderColor,
    required Color brandColor,
    required Color onSurfaceColor,
    required bool isDark,
  }) {
    final titleC = TextEditingController();
    final yearC = TextEditingController(text: "2026 Reunion");
    final nameC = TextEditingController();
    final linkC = TextEditingController();
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
            Icon(Icons.drive_folder_upload_rounded, color: brandColor, size: 22),
            const SizedBox(width: 10),
            Text(
              "Submit to Clan Archive",
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
                "Have old reunion photos, speech recordings, or family documents? Share them with the Clan Archivist.",
                style: TextStyle(color: onSurfaceColor.withOpacity(0.7), fontSize: 11.5),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: titleC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Title of Recording / Document *", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: yearC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Reunion Year / Era *", hint: "e.g. 2026 or 1995 Gathering", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: nameC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Your Name & Branch *", hint: "e.g. Ausi Mpho (Free State)", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: linkC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Google Drive / Cloud / YouTube Link", hint: "https://...", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: descC,
                maxLines: 3,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Historical Context & Notes", hint: "Who is speaking, what event was this, and why is it significant...", onSurfaceColor, borderColor, isDark),
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
                Navigator.pop(ctx);
                final String popMsg = """
🐊 *LEKGOTLA LA MAKHETHA • CLAN ARCHIVE SUBMISSION*
Title: ${titleC.text.trim()}
Era / Year: ${yearC.text.trim()}
Submitted by: ${nameC.text.trim()}
Link / Cloud URL: ${linkC.text.trim()}
Notes: ${descC.text.trim()}
---------------------------------
Kindly review and catalog this historical artifact in the Makhetha Vault!
""";
                const String archivistPhone = "27821234567";
                _launchExternal("https://wa.me/$archivistPhone?text=${Uri.encodeComponent(popMsg)}");
              }
            },
            child: const Text("Submit to Archivist"),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecor(String label, Color onSurfaceColor, Color borderColor, bool isDark, {String? hint}) {
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
          "THE CLAN VAULT & MINUTES",
          style: GoogleFonts.montserrat(
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: onSurfaceColor,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandColor,
                foregroundColor: isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => _showSubmitArchiveModal(
                context,
                cardColor: cardColor,
                borderColor: borderColor,
                brandColor: brandColor,
                onSurfaceColor: onSurfaceColor,
                isDark: isDark,
              ),
              icon: const Icon(Icons.upload_file_rounded, size: 15),
              label: const Text("Contribute Artifact", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5)),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: brandColor,
          indicatorWeight: 3,
          labelColor: brandColor,
          unselectedLabelColor: onSurfaceColor.withOpacity(0.6),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
          tabs: const [
            Tab(icon: Icon(Icons.video_library_rounded, size: 17), text: "Video Archives"),
            Tab(icon: Icon(Icons.description_rounded, size: 17), text: "Minutes & PDFs"),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              // Year Filter Dropdown Bar
              _buildYearFilterBar(cardColor, borderColor, brandColor, onSurfaceColor),

              // Tabbed Vault Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildVideoArchivesTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
                    _buildDocumentsTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearFilterBar(Color cardColor, Color borderColor, Color brandColor, Color onSurfaceColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Icon(Icons.history_rounded, size: 18, color: brandColor),
          const SizedBox(width: 8),
          Text("Archive Gathering:", style: TextStyle(color: onSurfaceColor, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedYear,
                dropdownColor: cardColor,
                isExpanded: true,
                style: TextStyle(color: onSurfaceColor, fontSize: 12, fontWeight: FontWeight.bold),
                items: _reunionYears.map((yr) => DropdownMenuItem(value: yr, child: Text(yr))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedYear = val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 1: VIDEO ARCHIVES & SPEECHES
  // ===========================================================================
  Widget _buildVideoArchivesTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    final filtered = _videos.where((v) {
      return _selectedYear == "All Gatherings" || v.year == _selectedYear;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text("No video recordings found for '$_selectedYear'",
            style: TextStyle(color: onSurfaceColor.withOpacity(0.6), fontSize: 13)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
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
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Thumbnail Banner
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(item.thumbnailUrl), fit: BoxFit.cover),
                    ),
                  ),
                  Container(height: 180, color: Colors.black.withOpacity(0.4)),
                  IconButton(
                    iconSize: 56,
                    icon: Icon(Icons.play_circle_fill_rounded, color: brandColor),
                    onPressed: () => _launchExternal(item.videoUrl),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(item.category,
                          style: TextStyle(color: brandColor, fontSize: 9.5, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text("${item.year} • ${item.duration}",
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),

              // Description & Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.montserrat(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: onSurfaceColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.speakerOrEvent,
                      style: TextStyle(fontSize: 11.5, color: brandColor, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.description,
                      style: TextStyle(fontSize: 12, color: onSurfaceColor.withOpacity(0.72), height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: onSurfaceColor,
                          side: BorderSide(color: borderColor),
                        ),
                        onPressed: () => _launchExternal(item.videoUrl),
                        icon: const Icon(Icons.open_in_new_rounded, size: 15),
                        label: const Text("Watch Full Address", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // TAB 2: MINUTES, RESOLUTIONS & AUDITS
  // ===========================================================================
  Widget _buildDocumentsTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    final filtered = _documents.where((d) {
      return _selectedYear == "All Gatherings" || d.year == _selectedYear;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text("No documents found for '$_selectedYear'",
            style: TextStyle(color: onSurfaceColor.withOpacity(0.6), fontSize: 13)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final doc = filtered[index];
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: brandColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.picture_as_pdf_rounded, color: brandColor, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: brandColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "${doc.category} • ${doc.year}",
                            style: TextStyle(color: brandColor, fontSize: 9.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        Text(doc.pages, style: TextStyle(color: onSurfaceColor.withOpacity(0.55), fontSize: 10.5)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      doc.title,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: onSurfaceColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doc.summary,
                      style: TextStyle(color: onSurfaceColor.withOpacity(0.7), fontSize: 11.5, height: 1.35),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF1F2937) : brandColor.withOpacity(0.1),
                        foregroundColor: isDark ? Colors.white : brandColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      onPressed: () => _launchExternal(doc.downloadUrl),
                      icon: const Icon(Icons.download_rounded, size: 14),
                      label: const Text("Read Document", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}