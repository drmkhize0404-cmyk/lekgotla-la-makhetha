import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/clan_auth_service.dart';

class MakhethaProfessional {
  final String name;
  final String profession;
  final String category;
  final String branchLocation;
  final String serviceMode;
  final bool isVolunteer;
  final String rateDescription;
  final String phone;
  final String qualifications;
  final String bio;
  final List<String> portfolioImages; // 📍 At least 5 photos
  final String? videoDemoUrl; // 📍 Video / Social Reel
  final Map<String, String> socialLinks; // 📍 LinkedIn, Instagram, TikTok

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
    this.portfolioImages = const [],
    this.videoDemoUrl,
    this.socialLinks = const {},
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
  String _rateFilter = "All";
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
      name: "Ntate Sello Makhetha",
      profession: "Master Electrician & Solar Installer",
      category: "Construction & Engineering",
      branchLocation: "KZN Branch • Durban / Midlands",
      serviceMode: "In-Person Only",
      isVolunteer: false,
      rateDescription: "Free quotes; 15% family discount on all solar backups.",
      phone: "27834449911",
      qualifications: "Red Seal Electrician • PV GreenCard Certified",
      bio: "18+ years experience in domestic wiring, solar inverters, and COC certificates.",
      videoDemoUrl: "https://www.youtube.com",
      portfolioImages: [
        "https://images.unsplash.com/photo-1508873696983-2df5293cb32f?q=80&w=600",
        "https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=600",
        "https://images.unsplash.com/photo-1581092160607-ee22621dd758?q=80&w=600",
        "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=600",
        "https://images.unsplash.com/photo-1509391365360-2e959784a276?q=80&w=600",
      ],
      socialLinks: {"LinkedIn": "https://linkedin.com", "Facebook": "https://facebook.com"},
    ),
    const MakhethaProfessional(
      name: "Adv. Tebogo Makhetha",
      profession: "High Court Advocate & Legal Consultant",
      category: "Legal & Governance",
      branchLocation: "Gauteng Branch • Pretoria",
      serviceMode: "Remote / Online Worldwide",
      isVolunteer: true,
      rateDescription: "Free 30-min legal advice & document review for clan members.",
      phone: "27821234567",
      qualifications: "LLB (UP), LLM (Wits) • High Court Admitted",
      bio: "Practicing advocate specializing in family law, estate planning, and commercial contracts.",
      videoDemoUrl: "https://www.youtube.com",
      portfolioImages: [
        "https://images.unsplash.com/photo-1589829545856-d10d557cf95f?q=80&w=600",
        "https://images.unsplash.com/photo-1453733197781-71785507b588?q=80&w=600",
        "https://images.unsplash.com/photo-1505664194779-8beaceb93744?q=80&w=600",
        "https://images.unsplash.com/photo-1521791136064-7986c2920216?q=80&w=600",
        "https://images.unsplash.com/photo-1450133064473-71024230f91b?q=80&w=600",
      ],
      socialLinks: {"LinkedIn": "https://linkedin.com"},
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

  void _showAddProfessionModal(BuildContext context) {
    ClanAuthService.requireAuthentication(
      context,
      actionName: "list a professional profile",
      onAuthenticated: () {
        final titleC = TextEditingController();
        final qualC = TextEditingController();
        final videoC = TextEditingController();
        final img1C = TextEditingController();
        final img2C = TextEditingController();
        final img3C = TextEditingController();
        final img4C = TextEditingController();
        final img5C = TextEditingController();
        final bioC = TextEditingController();
        final user = ClanAuthService().currentUser!;
        bool isVolunteer = false;
        String cat = _categories[1];

        showDialog(
          context: context,
          builder: (ctx) => StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                backgroundColor: Theme.of(context).cardColor,
                title: const Text("List Profession & 5 Work Photos"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Registered Member: ${user.fullName} (${user.branch})", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 10),
                      TextField(controller: titleC, decoration: const InputDecoration(labelText: "Profession / Specialty *", border: OutlineInputBorder())),
                      const SizedBox(height: 8),
                      TextField(controller: qualC, decoration: const InputDecoration(labelText: "Qualifications / Certifications *", border: OutlineInputBorder())),
                      const SizedBox(height: 8),
                      TextField(controller: videoC, decoration: const InputDecoration(labelText: "Video Reel / Showcase Link (YouTube/TikTok)", border: OutlineInputBorder())),
                      const SizedBox(height: 8),
                      const Text("5 Portfolio Work Photos (URLs):", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 4),
                      TextField(controller: img1C, decoration: const InputDecoration(hintText: "Photo 1 URL *", border: OutlineInputBorder())),
                      const SizedBox(height: 4),
                      TextField(controller: img2C, decoration: const InputDecoration(hintText: "Photo 2 URL *", border: OutlineInputBorder())),
                      const SizedBox(height: 4),
                      TextField(controller: img3C, decoration: const InputDecoration(hintText: "Photo 3 URL *", border: OutlineInputBorder())),
                      const SizedBox(height: 4),
                      TextField(controller: img4C, decoration: const InputDecoration(hintText: "Photo 4 URL *", border: OutlineInputBorder())),
                      const SizedBox(height: 4),
                      TextField(controller: img5C, decoration: const InputDecoration(hintText: "Photo 5 URL *", border: OutlineInputBorder())),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: isVolunteer,
                        title: Text(isVolunteer ? "🤝 Offering Free Advice / Volunteer" : "🏷️ Standard Family Discount Rate", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        onChanged: (v) => setModalState(() => isVolunteer = v),
                      ),
                      TextField(controller: bioC, maxLines: 2, decoration: const InputDecoration(labelText: "Professional Bio", border: OutlineInputBorder())),
                    ],
                  ),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                  ElevatedButton(
                    onPressed: () {
                      if (titleC.text.isNotEmpty && qualC.text.isNotEmpty) {
                        final images = [
                          img1C.text.trim().isNotEmpty ? img1C.text.trim() : "https://images.unsplash.com/photo-1581092160607-ee22621dd758?q=80&w=600",
                          img2C.text.trim().isNotEmpty ? img2C.text.trim() : "https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=600",
                          img3C.text.trim().isNotEmpty ? img3C.text.trim() : "https://images.unsplash.com/photo-1508873696983-2df5293cb32f?q=80&w=600",
                          img4C.text.trim().isNotEmpty ? img4C.text.trim() : "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=600",
                          img5C.text.trim().isNotEmpty ? img5C.text.trim() : "https://images.unsplash.com/photo-1509391365360-2e959784a276?q=80&w=600",
                        ];

                        setState(() {
                          _directory.insert(
                            0,
                            MakhethaProfessional(
                              name: user.fullName,
                              profession: titleC.text.trim(),
                              category: cat,
                              branchLocation: user.branch,
                              serviceMode: "In-Person & Remote",
                              isVolunteer: isVolunteer,
                              rateDescription: isVolunteer ? "Pro Bono Family Advice" : "Family Discount Available",
                              phone: user.phone,
                              qualifications: qualC.text.trim(),
                              bio: bioC.text.trim(),
                              portfolioImages: images,
                              videoDemoUrl: videoC.text.trim().isNotEmpty ? videoC.text.trim() : null,
                            ),
                          );
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Profile with 5 photos published!")));
                      }
                    },
                    child: const Text("Publish Profile"),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final cardColor = theme.cardColor;
    final borderColor = theme.dividerColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text("MAKHETHA PROFESSIONS & SKILLS",
            style: GoogleFonts.montserrat(fontSize: 12.5, fontWeight: FontWeight.w900, color: onSurfaceColor)),
        actions: [
          IconButton(
            icon: Icon(Icons.add_business_rounded, color: brandColor),
            onPressed: () => _showAddProfessionModal(context),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ..._directory.map((pro) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(pro.name, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 15, color: onSurfaceColor)),
                                Text("${pro.profession} • ${pro.branchLocation}", style: TextStyle(fontSize: 11.5, color: brandColor, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: pro.isVolunteer ? const Color(0xFF10B981).withOpacity(0.12) : brandColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              pro.isVolunteer ? "PRO BONO / FREE" : "FAMILY RATE",
                              style: TextStyle(color: pro.isVolunteer ? const Color(0xFF10B981) : brandColor, fontWeight: FontWeight.bold, fontSize: 9.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("📜 ${pro.qualifications}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(pro.bio, style: TextStyle(fontSize: 12, color: onSurfaceColor.withOpacity(0.72))),
                      const SizedBox(height: 12),

                      // 📍 5-PHOTO WORK GALLERY CAROUSEL
                      if (pro.portfolioImages.isNotEmpty) ...[
                        const Text("Work & Project Showcase (5 Photos):", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 75,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: pro.portfolioImages.length,
                            itemBuilder: (ctx, i) => Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(image: NetworkImage(pro.portfolioImages[i]), fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],

                      // 📍 VIDEO & SOCIAL CLIPS ROW
                      Row(
                        children: [
                          if (pro.videoDemoUrl != null)
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
                              onPressed: () => _launchExternal(pro.videoDemoUrl!),
                              icon: const Icon(Icons.play_circle_fill, size: 14),
                              label: const Text("Watch Video Reel", style: TextStyle(fontSize: 11)),
                            ),
                          const Spacer(),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF16A34A), foregroundColor: Colors.white),
                            onPressed: () {
                              ClanAuthService.requireAuthentication(
                                context,
                                actionName: "contact this professional",
                                onAuthenticated: () {
                                  _launchExternal("https://wa.me/${pro.phone}?text=${Uri.encodeComponent('Greetings ${pro.name}! I am reaching out through the Makhetha platform regarding your services.')}");
                                },
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_rounded, size: 14),
                            label: const Text("Contact on WhatsApp", style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}