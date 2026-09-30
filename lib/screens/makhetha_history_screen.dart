import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryChapter {
  final String chapterNumber;
  final String title;
  final String subtitle;
  final String era;
  final String content;
  final String historicalHighlight;
  final IconData icon;

  const HistoryChapter({
    required this.chapterNumber,
    required this.title,
    required this.subtitle,
    required this.era,
    required this.content,
    required this.historicalHighlight,
    required this.icon,
  });
}

class MakhethaHistoryScreen extends StatefulWidget {
  const MakhethaHistoryScreen({super.key});

  @override
  State<MakhethaHistoryScreen> createState() => _MakhethaHistoryScreenState();
}

class _MakhethaHistoryScreenState extends State<MakhethaHistoryScreen> {
  int _selectedChapterIndex = 0;

  static const List<HistoryChapter> _chapters = [
    // CHAPTER 1
    HistoryChapter(
      chapterNumber: "CHAPTER 1",
      title: "Origins of Bakoena & Ntsuanatsatsi",
      subtitle: "From Ancient Migration to the Caledon Valley",
      era: "Circa 1450 – 1700s",
      icon: Icons.terrain_rounded,
      content:
          "The Makhetha family belongs to the great Bakoena dynasty of Southern Africa. Ancient Basotho oral tradition records that our early ancestors journeyed southward from the great lakes under Leader Kwena. \n\n"
          "Napo, a revered leader in the Bakoena line, led his followers southward and settled near the sacred hill of Ntsuanatsatsi (situated between Vrede and Frankfort in the modern Free State). At Ntsuanatsatsi, the Bakoena intermarried with the Bafokeng, giving birth to the foundational clans of the Basotho nation.\n\n"
          "From Napo came Motebang, father of Tšolo (founder of Bamolibeli) and Tšoloane, who established the famous royal house of Monaheng (also known as Kali). Under Monaheng, the clan established strong settlements at Fothane (near Fouriesburg) and expanded along the fertile valleys of the Caledon (Mohokare) and Senqu rivers.",
      historicalHighlight:
          "“Ntsoana-tsatsi ke moo Bakoena bohle ba tsoileng teng.” — Ntsuanatsatsi remains the revered sunrise cradle of the Bakoena people.",
    ),

    // CHAPTER 2
    HistoryChapter(
      chapterNumber: "CHAPTER 2",
      title: "The House of Nkopane & Morena Makhetha",
      subtitle: "The Royal Lineage of Bakoena ba Monaheng",
      era: "18th Century (Circa 1740 – 1810)",
      icon: Icons.shield_rounded,
      content:
          "From Monaheng came Monyane, who fathered Nkopane a Mathunya. Nkopane was a formidable paramount leader whose sons shaped the destiny of the region. \n\n"
          "Among his sons were two towering figures: the legendary sage Morena Mohlomi, and his brother Morena Makhetha. Morena Mohlomi was renowned as the greatest medical doctor, philosopher, and traveling seer of the interior, preaching peace, outlawing unnecessary war, and advocating for the poor.\n\n"
          "Chief Makhetha governed the people of Ramakhetheng and Likotsi. As a royal warrior-chief, Makhetha’s leadership earned him the praise: 'Petsana ke ea lehooa-hooa, Makhetha, e hooa e koma-komisa lichaba!' His line established the proud Makhetha surname that unites all our branches today.",
      historicalHighlight:
          "Chief Makhetha and Morena Mohlomi were sons of Nkopane. Mohlomi famously became the chief mentor and spiritual teacher to young King Moshoeshoe I.",
    ),

    // CHAPTER 3
    HistoryChapter(
      chapterNumber: "CHAPTER 3",
      title: "’Mantsopa Makhetha (1793–1908)",
      subtitle: "The Great Prophetess & Advisor to King Moshoeshoe I",
      era: "1793 – 1908 (Lived 115 Years)",
      icon: Icons.auto_awesome_rounded,
      content:
          "One of the most illustrious figures in all of Southern African history is Anna ’Mantsopa Makhetha, daughter of Chief Makhetha. Born in 1793 at Likotsi/Ramakhetheng, she grew up surrounded by the spiritual traditions of her royal household.\n\n"
          "By the 1840s and 1850s, ’Mantsopa rose to legendary prominence as a seer, diviner, and strategic advisor to her royal kinsman, King Moshoeshoe I of Lesotho. She correctly foretold the outcomes of crucial battles, including the Battle of Viervoet (1851) and the Battle of Berea (1852).\n\n"
          "In her later years, she moved to Modderpoort (near Ladybrand, Free State). She was baptized into Christianity in 1870, beautifully synthesizing Christian faith with Basotho cultural heritage. Today, her sacred pilgrimage site and natural spring at Modderpoort attract thousands of visitors from across Africa.",
      historicalHighlight:
          "’Mantsopa was the daughter of Makhetha. She was the chief female strategist behind King Moshoeshoe I during the foundation of the Basotho nation.",
    ),

    // CHAPTER 4
    HistoryChapter(
      chapterNumber: "CHAPTER 4",
      title: "Seboko sa Koena (The Sacred Crocodile)",
      subtitle: "The Moral Code & Totem of Brotherhood",
      era: "Ancestral & Timeless",
      icon: Icons.water_rounded,
      content:
          "In Basotho philosophy, an animal totem (seboko) is not merely an emblem; it is a sacred moral compass that defines the behavior, dignity, and spiritual ethics of the clan.\n\n"
          "The Bakoena venerate the Crocodile (Koena/Kwena)—the sovereign creature of deep waters. The sacred covenant of Bakoena states: 'Koena ha e lome ngoan’abo, e loma moeti a tsoang thoko' (A crocodile never bites its own brother or sister; it only defends the family against outside aggression).\n\n"
          "This timeless proverb is the foundation of Lekgotla la Makhetha. It commands that relatives must never cheat, defraud, or undermine one another. In business, family disputes, or times of poverty, a Makhetha must protect and shield another Makhetha.",
      historicalHighlight:
          "“Koena ha e lome ngoan’abo!” — The golden rule of the Makhetha clan: mutual loyalty, protection, and brotherhood.",
    ),

    // CHAPTER 5
    HistoryChapter(
      chapterNumber: "CHAPTER 5",
      title: "Lithoko tsa Bakoena ba ha Makhetha",
      subtitle: "The Authentic Clan Praises to Recite with Pride",
      era: "Oral Heritage",
      icon: Icons.record_voice_over_rounded,
      content:
          "Every young Makhetha boy and girl should know and recite their ancestral praise poem:\n\n"
          "“Re Bakoena!\n"
          "Re batho ba ha Maiyane a tsokotla,\n"
          "Ba tsokotla metsi ka mohatla wa noka e kgolo!\n"
          "Re Bakoena ba heso ba noka e koto ya Senqu!\n"
          "Ke molilimanyane, ngoan'a Ramakatsa,\n"
          "Morapela-putsoa, o e rapela a sa e bone!\n"
          "Petsana ke ea lehooa-hooa, Makhetha,\n"
          "E hooa e koma-komisa lichaba tsa heso tsa ha Monaheng.\n"
          "Makhetha ke tau, ngoan'a Ramakatsa!\n"
          "Koena ha e lome ngoan'abo!\n"
          "Mokwena! Kwena e ntlha, batho ba ha Makhetha!”",
      historicalHighlight:
          "Reciting Lithoko connects our spirits with our forefathers, grounding our children in dignity wherever they live in the world.",
    ),

    // CHAPTER 6
    HistoryChapter(
      chapterNumber: "CHAPTER 6",
      title: "The 12 Branches & Global Diaspora",
      subtitle: "From the Caledon to the Ends of the Earth",
      era: "20th Century – 2027 and Beyond",
      icon: Icons.public_rounded,
      content:
          "Following the Frontier Wars, the loss of the Conquered Territory, and the rise of 20th-century urban migrations, the children of Makhetha dispersed across the provinces of South Africa, Lesotho, and across the globe.\n\n"
          "Today, twelve vibrant branches exist:\n"
          "• Lesotho Heritage Branch (Maseru, Leribe, Berea)\n"
          "• Free State Branch (Ficksburg, QwaQwa, Harrismith, Bloemfontein)\n"
          "• Gauteng Branch (Soweto, Johannesburg, Pretoria, Vaal)\n"
          "• KwaZulu-Natal Branch (Pietermaritzburg, Durban, Midlands)\n"
          "• Eastern Cape Branch (Gqeberha / Port Elizabeth - 2027 Host!)\n"
          "• Western Cape, Northern Cape, Mpumalanga, Limpopo, North West\n"
          "• The Global Diaspora (United Kingdom, USA, Canada, Australia)\n\n"
          "Though separated by oceans and provincial borders, the bloodline is one. The 2027 Heritage Gathering in Port Elizabeth represents the great reunion of these dispersed branches.",
      historicalHighlight:
          "“Kopano ke Matla” — Different branches, one root. United under the Bakoena banner.",
    ),
  ];

  Future<void> _launchExternal(String link) async {
    final Uri uri = Uri.parse(link);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  void _shareHistorySnippet(HistoryChapter ch) {
    final String shareText = """
🐊 *LEKGOTLA LA MAKHETHA • CLAN HERITAGE ARCHIVE*
📜 *${ch.title}* (${ch.era})
---------------------------------
${ch.content}

---------------------------------
*Seboko: Koena • Bakoena ba ha Makhetha*
Shared from the Lekgotla la Makhetha Family Platform.
""";

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Chapter copied to clipboard! Opening WhatsApp to share with family..."),
        backgroundColor: Color(0xFF16A34A),
      ),
    );

    _launchExternal("https://wa.me/?text=${Uri.encodeComponent(shareText)}");
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

    final activeChapter = _chapters[_selectedChapterIndex];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "NALANE EA HA MAKHETHA",
          style: GoogleFonts.montserrat(
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: onSurfaceColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share_rounded, color: brandColor),
            tooltip: "Share Chapter on WhatsApp",
            onPressed: () => _shareHistorySnippet(activeChapter),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              // 1. Chapter Horizontal Carousel Selector
              Container(
                color: cardColor,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: List.generate(_chapters.length, (index) {
                      final ch = _chapters[index];
                      final isSel = _selectedChapterIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          avatar: Icon(ch.icon, size: 14, color: isSel ? Colors.black : brandColor),
                          label: Text("${ch.chapterNumber}: ${ch.title.split(' ')[0]}"),
                          selected: isSel,
                          onSelected: (_) => setState(() => _selectedChapterIndex = index),
                          backgroundColor: cardColor,
                          selectedColor: brandColor,
                          checkmarkColor: Colors.black,
                          labelStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                            color: isSel ? (isDark ? Colors.black : Colors.white) : onSurfaceColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: isSel ? brandColor : borderColor),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // 2. Main History Reading Pane
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  children: [
                    // Reading Header Card
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: isDark
                            ? const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)])
                            : const LinearGradient(colors: [Color(0xFF451A03), Color(0xFF78350F)]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "${activeChapter.chapterNumber} • ${activeChapter.era}",
                                  style: const TextStyle(color: Color(0xFFFDE68A), fontWeight: FontWeight.bold, fontSize: 10),
                                ),
                              ),
                              const Spacer(),
                              const Text("🐊", style: TextStyle(fontSize: 22)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            activeChapter.title,
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activeChapter.subtitle,
                            style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Historical Narrative Body
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeChapter.content,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: onSurfaceColor.withOpacity(0.85),
                              height: 1.7,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Historical Gold Quote Box
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: brandColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border(left: BorderSide(color: brandColor, width: 3.5)),
                            ),
                            child: Text(
                              activeChapter.historicalHighlight,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: onSurfaceColor,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Navigation Between Chapters
                    Row(
                      children: [
                        if (_selectedChapterIndex > 0)
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(foregroundColor: onSurfaceColor, side: BorderSide(color: borderColor)),
                            onPressed: () => setState(() => _selectedChapterIndex--),
                            icon: const Icon(Icons.arrow_back, size: 14),
                            label: const Text("Previous Chapter", style: TextStyle(fontSize: 11.5)),
                          ),
                        const Spacer(),
                        if (_selectedChapterIndex < _chapters.length - 1)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandColor,
                              foregroundColor: isDark ? Colors.black : Colors.white,
                            ),
                            onPressed: () => setState(() => _selectedChapterIndex++),
                            icon: const Icon(Icons.arrow_forward, size: 14),
                            label: const Text("Next Chapter", style: TextStyle(fontSize: 11.5)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}