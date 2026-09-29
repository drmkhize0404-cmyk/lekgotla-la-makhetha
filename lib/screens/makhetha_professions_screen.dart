import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MakhethaProfessional {
  final String name;
  final String profession;
  final String category;
  final String branchLocation;
  final String serviceMode; // "Remote / Online Worldwide", "In-Person Only", "Hybrid"
  final bool isVolunteer; // True = Free / Pro Bono for family; False = Paid / Family Discount
  final String rateDescription;
  final String phone;
  final String qualifications;
  final String bio;

  const MakhethaProfessional({
    required this.name,
    required this.profession,
    required this.category,
    required this.branchLocation,
    required this.serviceMode,
    required this.isVolunteer,
    required this.rateDescription,
    required this.phone,
    required this.qualifications,
    required this.bio,
  });
}

class MakhethaProfessionsScreen extends StatefulWidget {
  const MakhethaProfessionsScreen({super.key});

  @override
  State<MakhethaProfessionsScreen> createState() =>
      _MakhethaProfessionsScreenState();
}

class _MakhethaProfessionsScreenState extends State<MakhethaProfessionsScreen> {
  String _searchQuery = "";
  String _selectedCategory = "All";
  String _rateFilter = "All"; // "All", "Volunteers (Free / Pro Bono)", "Paid / Family Rates"
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    "All",
    "Legal & Governance",
    "Health & Medicine",
    "Construction & Engineering",
    "Accounting & Finance",
    "Education & Academic Tutoring",
    "Agriculture & Farming",
    "IT, Design & Software",
  ];

  final List<MakhethaProfessional> _directory = [
    const MakhethaProfessional(
      name: "Adv. Tebogo Makhetha",
      profession: "High Court Advocate & Legal Consultant",
      category: "Legal & Governance",
      branchLocation: "Gauteng Branch • Pretoria",
      serviceMode: "Remote / Online Worldwide",
      isVolunteer: true,
      rateDescription: "Free 30-min legal advice & document review for Makhetha family members.",
      phone: "27821234567",
      qualifications: "LLB (UP), LLM (Wits) • High Court Admitted",
      bio: "Practicing advocate specializing in family law, estate planning, deceased estates, and contractual disputes.",
    ),
    const MakhethaProfessional(
      name: "Dr. Mamello Makhetha",
      profession: "General Medical Practitioner",
      category: "Health & Medicine",
      branchLocation: "Free State Branch • Bloemfontein",
      serviceMode: "In-Person & Telehealth",
      isVolunteer: true,
      rateDescription: "Free medical guidance & referrals; 25% discount for in-person family clinic visits.",
      phone: "27829988776",
      qualifications: "MBChB (UFS), Dip Obst (SA)",
      bio: "Family physician dedicated to preventative health, diabetes management, chronic care, and maternal wellness.",
    ),
    const MakhethaProfessional(
      name: "Ntate Sello Makhetha",
      profession: "Master Electrician & Solar Installer",
      category: "Construction & Engineering",
      branchLocation: "KZN Branch • Durban / Midlands",
      serviceMode: "In-Person Only",
      isVolunteer: false,
      rateDescription: "Free callout and quotes; 15% family discount on all solar backups and wiring.",
      phone: "27834449911",
      qualifications: "Red Seal Electrician (Wireman's License) • PV GreenCard",
      bio: "Over 18 years experience in residential wiring, commercial compliance certificates (COC), and solar inverter setups.",
    ),
    const MakhethaProfessional(
      name: "Ausi Keketso Makhetha",
      profession: "Chartered Accountant & Tax Consultant",
      category: "Accounting & Finance",
      branchLocation: "Lesotho Branch • Maseru",
      serviceMode: "Remote / Online Worldwide",
      isVolunteer: false,
      rateDescription: "Affordable family bookkeeping, SARS/LRA tax submissions & small business registration.",
      phone: "27712345678",
      qualifications: "BCom Accounting (NUL), CA(L)",
      bio: "Helping relatives structure their small businesses, maintain compliant financial statements, and handle tax filings.",
    ),
    const MakhethaProfessional(
      name: "Abuti Tumelo Makhetha",
      profession: "Livestock & Grain Agriculturalist",
      category: "Agriculture & Farming",
      branchLocation: "Free State Branch • Ficksburg",
      serviceMode: "In-Person Consultations",
      isVolunteer: true,
      rateDescription: "Volunteering free agricultural mentorship for family members entering cattle and grain farming.",
      phone: "27845558899",
      qualifications: "BSc Agriculture (Agronomy & Animal Science)",
      bio: "Commercial farmer managing beef cattle and maize. Passionate about food security and family land development.",
    ),
    const MakhethaProfessional(
      name: "Kagiso Makhetha",
      profession: "Senior Software Engineer & Cloud Architect",
      category: "IT, Design & Software",
      branchLocation: "International Diaspora • London, UK",
      serviceMode: "Remote / Online Worldwide",
      isVolunteer: true,
      rateDescription: "Volunteering free coding mentorship, university guidance & tech career coaching for Makhetha youth.",
      phone: "447700900123",
      qualifications: "BSc Computer Science (UCT)",
      bio: "10+ years experience building mobile and cloud applications. Available weekends on Zoom for family student mentorship.",
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
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

  void _openWhatsApp(MakhethaProfessional pro) {
    final String greeting = pro.isVolunteer
        ? "Greetings ${pro.name}! I saw on the Lekgotla la Makhetha app that you volunteer guidance in '${pro.profession}'. I would love to connect."
        : "Greetings ${pro.name}! I saw your professional listing for '${pro.profession}' on the Lekgotla la Makhetha app. I would like to inquire about your services.";

    final Uri uri = Uri.parse("https://wa.me/${pro.phone}?text=${Uri.encodeComponent(greeting)}");
    _launchExternal(uri.toString());
  }

  void _openCall(String phone) {
    final clean = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    _launchExternal("tel:$clean");
  }

  void _showAddProfessionModal(
    BuildContext context, {
    required Color cardColor,
    required Color borderColor,
    required Color brandColor,
    required Color onSurfaceColor,
    required bool isDark,
  }) {
    final nameC = TextEditingController();
    final profC = TextEditingController();
    final qualC = TextEditingController();
    final branchC = TextEditingController(text: "Gauteng Branch");
    final rateNoteC = TextEditingController();
    final phoneC = TextEditingController();
    final bioC = TextEditingController();

    String cat = _categories[1];
    String mode = "Remote & In-Person";
    bool isVolunteer = false;

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
                Icon(Icons.badge_rounded, color: brandColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  "List Your Profession / Skill",
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
                    "Showcase your qualifications and declare if you offer free volunteer advice or family discounted rates.",
                    style: TextStyle(color: onSurfaceColor.withOpacity(0.7), fontSize: 11.5),
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: nameC,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Full Name & Title (e.g. Dr. / Adv. / Bro.) *", onSurfaceColor, borderColor, isDark),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: profC,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Job Title / Specialization *", hint: "e.g. Attorney, Plumber, Accountant", onSurfaceColor, borderColor, isDark),
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: cat,
                    dropdownColor: cardColor,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Category *", onSurfaceColor, borderColor, isDark),
                    items: _categories.where((c) => c != "All").map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setModalState(() => cat = v!),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: qualC,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Degrees / Trade Certifications *", hint: "e.g. BCom, LLB, Red Seal", onSurfaceColor, borderColor, isDark),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: branchC,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Your Family Branch & City *", hint: "e.g. Free State (Bloemfontein)", onSurfaceColor, borderColor, isDark),
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: mode,
                    dropdownColor: cardColor,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Service Delivery Mode *", onSurfaceColor, borderColor, isDark),
                    items: ["Remote & In-Person", "In-Person Only", "Remote / Online Worldwide"]
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (v) => setModalState(() => mode = v!),
                  ),
                  const SizedBox(height: 10),

                  // 🤝 Volunteer vs Paid Switch
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isVolunteer ? const Color(0xFF10B981).withOpacity(0.12) : brandColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isVolunteer ? const Color(0xFF10B981) : brandColor),
                    ),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: const Color(0xFF10B981),
                      value: isVolunteer,
                      title: Text(
                        isVolunteer ? "🤝 Offering Free Advice / Volunteer Support" : "🏷️ Offering Paid Service (With Family Rates)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isVolunteer ? const Color(0xFF10B981) : brandColor,
                        ),
                      ),
                      onChanged: (val) {
                        setModalState(() => isVolunteer = val);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: rateNoteC,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor(
                      isVolunteer ? "Volunteer Terms (e.g. Free 30-min consultation)" : "Family Rate Offer (e.g. 15% discount for kin)",
                      onSurfaceColor,
                      borderColor,
                      isDark,
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: phoneC,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Phone / WhatsApp Number *", hint: "082 123 4567", onSurfaceColor, borderColor, isDark),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: bioC,
                    maxLines: 3,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Professional Bio & Summary", hint: "Years of experience, focus areas, and passion...", onSurfaceColor, borderColor, isDark),
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
                  if (nameC.text.isNotEmpty && profC.text.isNotEmpty) {
                    setState(() {
                      _directory.insert(
                        0,
                        MakhethaProfessional(
                          name: nameC.text.trim(),
                          profession: profC.text.trim(),
                          category: cat,
                          branchLocation: branchC.text.trim(),
                          serviceMode: mode,
                          isVolunteer: isVolunteer,
                          rateDescription: rateNoteC.text.trim().isNotEmpty
                              ? rateNoteC.text.trim()
                              : (isVolunteer ? "Pro Bono Family Advice" : "Family Discount Available"),
                          phone: phoneC.text.trim().replaceAll('+', ''),
                          qualifications: qualC.text.trim(),
                          bio: bioC.text.trim(),
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("🎉 Your professional profile has been published to the clan directory!"),
                        backgroundColor: Color(0xFF16A34A),
                      ),
                    );
                  }
                },
                child: const Text("Publish Profile"),
              ),
            ],
          );
        },
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

    final filtered = _directory.where((pro) {
      final matchesCat = _selectedCategory == "All" || pro.category == _selectedCategory;
      final matchesRate = _rateFilter == "All" ||
          (_rateFilter == "Volunteers (Free / Pro Bono)" && pro.isVolunteer) ||
          (_rateFilter == "Paid / Family Rates" && !pro.isVolunteer);

      final q = _searchQuery.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          pro.name.toLowerCase().contains(q) ||
          pro.profession.toLowerCase().contains(q) ||
          pro.branchLocation.toLowerCase().contains(q) ||
          pro.qualifications.toLowerCase().contains(q) ||
          pro.bio.toLowerCase().contains(q);

      return matchesCat && matchesRate && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "MAKHETHA PROFESSIONS & SKILLS",
          style: GoogleFonts.montserrat(
            fontSize: 13,
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
              onPressed: () => _showAddProfessionModal(
                context,
                cardColor: cardColor,
                borderColor: borderColor,
                brandColor: brandColor,
                onSurfaceColor: onSurfaceColor,
                isDark: isDark,
              ),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text("List Profession", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5)),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: Column(
            children: [
              // 1. Heritage Motto Banner
              _buildMottoBanner(cardColor, borderColor, onSurfaceColor, brandColor, isDark),

              // 2. Search Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v.trim()),
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Search doctors, lawyers, engineers, accountants, farmers, tutors...",
                      hintStyle: TextStyle(color: onSurfaceColor.withOpacity(0.4), fontSize: 12),
                      prefixIcon: Icon(Icons.search_rounded, color: brandColor, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: onSurfaceColor.withOpacity(0.6), size: 16),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = "");
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    ),
                  ),
                ),
              ),

              // 3. Dual Filter Chips: Category & Volunteer Mode
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    // Volunteer Filter Badges
                    _filterChip("All Services", _rateFilter == "All", () => setState(() => _rateFilter = "All"), brandColor, cardColor, borderColor, onSurfaceColor, isDark),
                    _filterChip("🤝 Volunteers (Pro Bono)", _rateFilter == "Volunteers (Free / Pro Bono)", () => setState(() => _rateFilter = "Volunteers (Free / Pro Bono)"), const Color(0xFF10B981), cardColor, borderColor, onSurfaceColor, isDark),
                    _filterChip("🏷️ Paid (Family Rates)", _rateFilter == "Paid / Family Rates", () => setState(() => _rateFilter = "Paid / Family Rates"), brandColor, cardColor, borderColor, onSurfaceColor, isDark),
                    const SizedBox(width: 8),
                    Container(height: 20, width: 1, color: borderColor),
                    const SizedBox(width: 8),
                    // Category Chips
                    ..._categories.map((cat) {
                      final isSel = _selectedCategory == cat;
                      return _filterChip(cat, isSel, () => setState(() => _selectedCategory = cat), brandColor, cardColor, borderColor, onSurfaceColor, isDark);
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // 4. Professionals List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          "No Makhetha professionals found matching '$_searchQuery'",
                          style: TextStyle(color: onSurfaceColor.withOpacity(0.6), fontSize: 13),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return _buildProfessionalCard(
                            filtered[index],
                            cardColor: cardColor,
                            borderColor: borderColor,
                            brandColor: brandColor,
                            onSurfaceColor: onSurfaceColor,
                            isDark: isDark,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(
    String label,
    bool isSel,
    VoidCallback onTap,
    Color activeColor,
    Color cardColor,
    Color borderColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSel,
        onSelected: (_) => onTap(),
        backgroundColor: cardColor,
        selectedColor: activeColor,
        checkmarkColor: isDark ? Colors.black : Colors.white,
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
          color: isSel ? (isDark ? Colors.black : Colors.white) : onSurfaceColor.withOpacity(0.75),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSel ? activeColor : borderColor),
        ),
      ),
    );
  }

  Widget _buildMottoBanner(Color cardColor, Color borderColor, Color onSurfaceColor, Color brandColor, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: brandColor.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(Icons.school_rounded, color: brandColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Batho ba ha Makhetha: Empowering Our Own",
                  style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold, fontSize: 11.5),
                ),
                Text(
                  "Support family lawyers, doctors, farmers, and artisans first. Check who volunteers free advice!",
                  style: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 10.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalCard(
    MakhethaProfessional pro, {
    required Color cardColor,
    required Color borderColor,
    required Color brandColor,
    required Color onSurfaceColor,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Avatar + Name + Volunteer/Rate Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: brandColor.withOpacity(0.15),
                child: Text(
                  pro.name.isNotEmpty ? pro.name[0] : "M",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: brandColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pro.name,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: onSurfaceColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pro.profession,
                      style: TextStyle(
                        fontSize: 12,
                        color: brandColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${pro.branchLocation} • ${pro.serviceMode}",
                      style: TextStyle(fontSize: 10.5, color: onSurfaceColor.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),

              // 🤝 Pro Bono vs. 🏷️ Family Rate Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: pro.isVolunteer ? const Color(0xFF10B981).withOpacity(0.14) : brandColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: pro.isVolunteer ? const Color(0xFF10B981) : brandColor.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      pro.isVolunteer ? Icons.volunteer_activism_rounded : Icons.loyalty_rounded,
                      size: 12,
                      color: pro.isVolunteer ? const Color(0xFF10B981) : brandColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      pro.isVolunteer ? "PRO BONO / VOLUNTEER" : "FAMILY RATE",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: pro.isVolunteer ? const Color(0xFF10B981) : brandColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Qualifications Badge
          if (pro.qualifications.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: onSurfaceColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "📜 ${pro.qualifications}",
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: onSurfaceColor.withOpacity(0.85)),
              ),
            ),
          const SizedBox(height: 8),

          // Bio / Summary
          Text(
            pro.bio,
            style: TextStyle(fontSize: 12, color: onSurfaceColor.withOpacity(0.72), height: 1.4),
          ),
          const SizedBox(height: 8),

          // Offer Note
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: pro.isVolunteer ? const Color(0xFF10B981).withOpacity(0.08) : brandColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: pro.isVolunteer ? const Color(0xFF10B981).withOpacity(0.3) : brandColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  pro.isVolunteer ? Icons.favorite_rounded : Icons.info_outline_rounded,
                  size: 14,
                  color: pro.isVolunteer ? const Color(0xFF10B981) : brandColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    pro.rateDescription,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: pro.isVolunteer ? const Color(0xFF10B981) : brandColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: borderColor, height: 20),

          // Action Buttons
          Row(
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: onSurfaceColor.withOpacity(0.8),
                  side: BorderSide(color: borderColor),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                onPressed: () => _openCall(pro.phone),
                icon: const Icon(Icons.phone_rounded, size: 14),
                label: const Text("Call", style: TextStyle(fontSize: 11)),
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _openWhatsApp(pro),
                icon: const Icon(Icons.chat_bubble_rounded, size: 14),
                label: Text(
                  pro.isVolunteer ? "Message Volunteer" : "Inquire via WhatsApp",
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}