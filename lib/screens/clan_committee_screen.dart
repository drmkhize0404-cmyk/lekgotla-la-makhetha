import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CommitteeMember {
  final String name;
  final String role;
  final String branch;
  final String termTimeline; // 2-Year Term
  final String jobDescription;
  final String primaryContactPhone;
  final IconData icon;

  const CommitteeMember({
    required this.name,
    required this.role,
    required this.branch,
    required this.termTimeline,
    required this.jobDescription,
    required this.primaryContactPhone,
    required this.icon,
  });
}

class ClanCommitteeScreen extends StatelessWidget {
  const ClanCommitteeScreen({super.key});

  static const List<CommitteeMember> _members = [
    CommitteeMember(
      name: "Ntate Sello Makhetha",
      role: "Executive Council Chairperson",
      branch: "Free State Branch",
      termTimeline: "October 2026 - September 2028 (2-Year Term)",
      jobDescription:
          "Presides over the general Lekgotla assembly, chairs executive board sessions, liaises with elder councils in Lesotho and SA, and ensures constitution adherence.",
      primaryContactPhone: "27821234567",
      icon: Icons.account_balance_rounded,
    ),
    CommitteeMember(
      name: "Mme Thandi Makhetha (Port Elizabeth)",
      role: "Reunion 2027 Host Committee Convenor",
      branch: "Eastern Cape Branch (Port Elizabeth)",
      termTimeline: "October 2026 - September 2028 (2-Year Term)",
      jobDescription:
          "Leads local logistics for the 2027 Heritage Day Gathering in Gqeberha / Port Elizabeth. Oversees marquee hire, catering, municipal permits, and hotel blocks.",
      primaryContactPhone: "27829988776",
      icon: Icons.location_city_rounded,
    ),
    CommitteeMember(
      name: "Adv. Tebogo Makhetha",
      role: "Legal Advisor & Council Arbitrator",
      branch: "Gauteng Branch",
      termTimeline: "October 2026 - September 2028 (2-Year Term)",
      jobDescription:
          "Drafts and maintains the Makhetha Clan Constitution, oversees SafeTrade Escrow dispute arbitrations, and manages trust fund governance.",
      primaryContactPhone: "27834449911",
      icon: Icons.gavel_rounded,
    ),
    CommitteeMember(
      name: "Ausi Keketso Makhetha (CA)",
      role: "Treasurer General & Financial Secretary",
      branch: "Lesotho Heritage Branch",
      termTimeline: "October 2026 - September 2028 (2-Year Term)",
      jobDescription:
          "Custody of Mokotla wa Matshediso (Bereavement Fund), reunion ticket revenues, and bursary trust disbursements. Publishes the public transparent ledger.",
      primaryContactPhone: "27712345678",
      icon: Icons.account_balance_wallet_rounded,
    ),
    CommitteeMember(
      name: "Koko Masello & Bo-Rakgadi Circle",
      role: "Head of Safe Haven & Welfare (Bo-Rakgadi)",
      branch: "Free State & KZN Branches",
      termTimeline: "October 2026 - September 2028 (2-Year Term)",
      jobDescription:
          "Confidential elder aunt handling anonymous GBV and domestic crisis cases, coordinating emergency sheltering, and bereavement grocery hampers.",
      primaryContactPhone: "27845558899",
      icon: Icons.shield_rounded,
    ),
    CommitteeMember(
      name: "Abuti Tumelo Makhetha",
      role: "Youth & Entrepreneurship Convenor",
      branch: "KZN Branch",
      termTimeline: "October 2026 - September 2028 (2-Year Term)",
      jobDescription:
          "Moderates the AYS youth forum, coordinates student bursaries, organizes the Yaga fashion market, and supports young Makhetha artisans.",
      primaryContactPhone: "27723456789",
      icon: Icons.school_rounded,
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

  void _contactOfficial(CommitteeMember member) {
    final String msg = """
🐊 *LEKGOTLA LA MAKHETHA • EXECUTIVE CONTACT*
To: ${member.name} (${member.role})
Branch: ${member.branch}
---------------------------------
Greetings Executive Officer! I am reaching out to your office regarding:
""";
    _launchExternal("https://wa.me/${member.primaryContactPhone}?text=${Uri.encodeComponent(msg)}");
  }

  @override
  Widget build(BuildContext context) {
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
          "CLAN EXECUTIVE COMMITTEE",
          style: GoogleFonts.montserrat(
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: onSurfaceColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              // Constitutional 2-Year Term Banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? const LinearGradient(colors: [Color(0xFF0F1E36), Color(0xFF1E2A5E)])
                      : const LinearGradient(colors: [Color(0xFF451A03), Color(0xFF78350F)]),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "CONSTITUTIONAL MANDATE • 2-YEAR TENURE",
                        style: TextStyle(color: Color(0xFFFDE68A), fontWeight: FontWeight.bold, fontSize: 9.5),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Current Leadership: 2026 – 2028 Biennial Term",
                      style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Elected democratically by clan branches at the national AGM. Each committee officer serves a dedicated 2-year timeline before fresh nominations.",
                      style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              Text(
                "APPOINTED OFFICERS & PORTFOLIO DESCRIPTIONS",
                style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
              ),
              const SizedBox(height: 10),

              ..._members.map((m) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderColor),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: brandColor.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            )
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: brandColor.withOpacity(0.12), shape: BoxShape.circle),
                            child: Icon(m.icon, color: brandColor, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m.role,
                                  style: TextStyle(color: brandColor, fontSize: 11.5, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  m.name,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: onSurfaceColor,
                                  ),
                                ),
                                Text(
                                  "${m.branch} • ${m.termTimeline}",
                                  style: TextStyle(color: onSurfaceColor.withOpacity(0.6), fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Job Description & Scope of Office:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: onSurfaceColor.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        m.jobDescription,
                        style: TextStyle(fontSize: 12, color: onSurfaceColor.withOpacity(0.72), height: 1.4),
                      ),
                      Divider(color: borderColor, height: 20),
                      Row(
                        children: [
                          Text("Serving: Makhetha Clan Worldwide",
                              style: TextStyle(fontSize: 10.5, color: onSurfaceColor.withOpacity(0.55))),
                          const Spacer(),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF16A34A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => _contactOfficial(m),
                            icon: const Icon(Icons.chat_bubble_rounded, size: 14),
                            label: const Text("Contact Officer", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
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