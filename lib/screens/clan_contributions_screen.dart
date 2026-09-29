import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ClanFundGoal {
  final String id;
  final String name;
  final double targetAmount;
  double raisedAmount;
  final String category;
  final String description;
  final IconData icon;
  final Color accentColor;

  ClanFundGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.raisedAmount,
    required this.category,
    required this.description,
    required this.icon,
    required this.accentColor,
  });

  double get progress =>
      targetAmount > 0 ? (raisedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
}

class ClanLedgerEntry {
  final String id;
  final String contributorName;
  final String branch;
  final double amount;
  final String fundName;
  final String date;
  final bool isAnonymous;

  const ClanLedgerEntry({
    required this.id,
    required this.contributorName,
    required this.branch,
    required this.amount,
    required this.fundName,
    required this.date,
    this.isAnonymous = false,
  });
}

class ClanContributionsScreen extends StatefulWidget {
  const ClanContributionsScreen({super.key});

  @override
  State<ClanContributionsScreen> createState() =>
      _ClanContributionsScreenState();
}

class _ClanContributionsScreenState extends State<ClanContributionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ClanFundGoal> _funds = [
    ClanFundGoal(
      id: "F1",
      name: "Reunion 2027 Levy & Feast Fund",
      targetAmount: 120000.00,
      raisedAmount: 74500.00,
      category: "REUNION 2027",
      description:
          "Covers marquee hire, catering, sound equipment, commemorative gifts, and grounds preparation for the 24 September gathering.",
      icon: Icons.celebration_rounded,
      accentColor: const Color(0xFFF59E0B),
    ),
    ClanFundGoal(
      id: "F2",
      name: "Mokotla wa Matshediso (Bereavement Shield)",
      targetAmount: 50000.00,
      raisedAmount: 38200.00,
      category: "EMERGENCY & BEREAVEMENT",
      description:
          "Immediate emergency reserve to assist households facing bereavement with funeral grocery hampers, transport, and family support.",
      icon: Icons.shield_rounded,
      accentColor: const Color(0xFFEF4444),
    ),
    ClanFundGoal(
      id: "F3",
      name: "Makhetha Youth Education & Bursary Trust",
      targetAmount: 60000.00,
      raisedAmount: 31800.00,
      category: "YOUTH EMPOWERMENT",
      description:
          "Direct assistance for Makhetha students with university registration fees, technical college tools, and textbook stipends.",
      icon: Icons.school_rounded,
      accentColor: const Color(0xFF3B82F6),
    ),
  ];

  final List<ClanLedgerEntry> _ledger = [
    const ClanLedgerEntry(
      id: "TX-101",
      contributorName: "Free State Branch (Ficksburg Household)",
      branch: "Free State",
      amount: 4500.00,
      fundName: "Reunion 2027 Levy",
      date: "2 days ago",
    ),
    const ClanLedgerEntry(
      id: "TX-102",
      contributorName: "Adv. Tebogo Makhetha",
      branch: "Gauteng",
      amount: 2500.00,
      fundName: "Youth Bursary Trust",
      date: "3 days ago",
    ),
    const ClanLedgerEntry(
      id: "TX-103",
      contributorName: "Anonymous Ausi",
      branch: "Lesotho Heritage",
      amount: 1000.00,
      fundName: "Mokotla wa Matshediso",
      date: "5 days ago",
      isAnonymous: true,
    ),
    const ClanLedgerEntry(
      id: "TX-104",
      contributorName: "KZN Midlands Branch",
      branch: "KwaZulu-Natal",
      amount: 3200.00,
      fundName: "Reunion 2027 Levy",
      date: "1 week ago",
    ),
    const ClanLedgerEntry(
      id: "TX-105",
      contributorName: "Kagiso Makhetha",
      branch: "Diaspora (UK)",
      amount: 5000.00,
      fundName: "Youth Bursary Trust",
      date: "2 weeks ago",
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

  void _copyToClipboard(String label, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ Copied $label: $text"),
        backgroundColor: const Color(0xFF16A34A),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showContributeModal(
    BuildContext context, {
    required Color cardColor,
    required Color borderColor,
    required Color brandColor,
    required Color onSurfaceColor,
    required bool isDark,
    String? preselectedFund,
  }) {
    final amountC = TextEditingController();
    final nameC = TextEditingController();
    final branchC = TextEditingController(text: "Gauteng Branch");
    final refC = TextEditingController();

    String selectedFund = preselectedFund ?? _funds.first.name;
    bool isAnonymous = false;

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
                Icon(Icons.volunteer_activism_rounded, color: brandColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  "Make a Clan Contribution",
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
                    "Transfer funds directly via bank EFT, then submit your proof of payment for the transparent clan ledger.",
                    style: TextStyle(color: onSurfaceColor.withOpacity(0.7), fontSize: 11.5),
                  ),
                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(
                    value: selectedFund,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Select Target Fund *", onSurfaceColor, borderColor, isDark),
                    items: _funds.map((f) => DropdownMenuItem(value: f.name, child: Text(f.name, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setModalState(() => selectedFund = v!),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: amountC,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Contribution Amount (ZAR) *", hint: "e.g. 1000", prefix: "R ", onSurfaceColor, borderColor, isDark),
                  ),
                  const SizedBox(height: 10),

                  // Anonymous toggle
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    activeColor: brandColor,
                    value: isAnonymous,
                    title: Text(
                      "Publish as Anonymous Kinsman (Hide my name)",
                      style: TextStyle(fontSize: 12, color: onSurfaceColor),
                    ),
                    onChanged: (val) {
                      setModalState(() => isAnonymous = val ?? false);
                    },
                  ),

                  if (!isAnonymous) ...[
                    TextField(
                      controller: nameC,
                      style: TextStyle(color: onSurfaceColor, fontSize: 13),
                      decoration: _inputDecor("Your Name or Household *", hint: "e.g. Ntate Sello & Family", onSurfaceColor, borderColor, isDark),
                    ),
                    const SizedBox(height: 10),
                  ],

                  TextField(
                    controller: branchC,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Family Branch *", hint: "e.g. Free State / KZN / Diaspora", onSurfaceColor, borderColor, isDark),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: refC,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Bank EFT Reference Used", hint: "e.g. Makhetha - Reunion - Sello", onSurfaceColor, borderColor, isDark),
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
                  final double parsedAmt = double.tryParse(amountC.text.trim()) ?? 0.0;
                  if (parsedAmt > 0) {
                    final String donorName = isAnonymous
                        ? "Anonymous Kinsman"
                        : (nameC.text.trim().isNotEmpty ? nameC.text.trim() : "Makhetha Relative");

                    setState(() {
                      // Update fund raised amount
                      final matchFund = _funds.firstWhere((f) => f.name == selectedFund);
                      matchFund.raisedAmount += parsedAmt;

                      // Insert into ledger
                      _ledger.insert(
                        0,
                        ClanLedgerEntry(
                          id: "TX-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
                          contributorName: donorName,
                          branch: branchC.text.trim(),
                          amount: parsedAmt,
                          fundName: selectedFund,
                          date: "Just Now",
                          isAnonymous: isAnonymous,
                        ),
                      );
                    });

                    Navigator.pop(ctx);

                    // Send WhatsApp confirmation to Clan Treasury
                    final String popMessage = """
🐊 *LEKGOTLA LA MAKHETHA • CONTRIBUTION SUBMISSION*
Fund: $selectedFund
Amount: R ${parsedAmt.toStringAsFixed(2)}
From: $donorName (${branchC.text.trim()})
Bank Reference: ${refC.text.trim().isNotEmpty ? refC.text.trim() : 'EFT Transfer'}
---------------------------------
Proof of payment attached for the transparent clan ledger!
""";
                    const String treasuryPhone = "27821234567";
                    _launchExternal("https://wa.me/$treasuryPhone?text=${Uri.encodeComponent(popMessage)}");
                  }
                },
                child: const Text("Submit Contribution"),
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
    String? prefix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: prefix,
      prefixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
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
          "MOKOTLA WA MAKHETHA • FUNDS",
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
              onPressed: () => _showContributeModal(
                context,
                cardColor: cardColor,
                borderColor: borderColor,
                brandColor: brandColor,
                onSurfaceColor: onSurfaceColor,
                isDark: isDark,
              ),
              icon: const Icon(Icons.volunteer_activism_rounded, size: 15),
              label: const Text("Contribute", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5)),
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
            Tab(icon: Icon(Icons.pie_chart_rounded, size: 17), text: "Active Funds"),
            Tab(icon: Icon(Icons.receipt_long_rounded, size: 17), text: "Public Ledger"),
            Tab(icon: Icon(Icons.account_balance_rounded, size: 17), text: "Bank Details"),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildActiveFundsTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
              _buildPublicLedgerTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
              _buildBankDetailsTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 1: ACTIVE FUNDS & PROGRESS GOALS
  // ===========================================================================
  Widget _buildActiveFundsTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Heritage Banner
        _buildSolidarityBanner(cardColor, borderColor, onSurfaceColor, brandColor, isDark),
        const SizedBox(height: 16),

        Text(
          "ACTIVE CLAN TARGETS & LEVIES",
          style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
        ),
        const SizedBox(height: 10),

        ..._funds.map((fund) {
          final int percentInt = (fund.progress * 100).toInt();

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
                        color: brandColor.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      )
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: fund.accentColor.withOpacity(0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(fund.icon, color: fund.accentColor, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fund.category,
                            style: TextStyle(color: fund.accentColor, fontSize: 9.5, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            fund.name,
                            style: GoogleFonts.montserrat(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: onSurfaceColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  fund.description,
                  style: TextStyle(color: onSurfaceColor.withOpacity(0.72), fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 14),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: fund.progress,
                    minHeight: 7,
                    backgroundColor: onSurfaceColor.withOpacity(0.08),
                    color: fund.accentColor,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Raised: R ${fund.raisedAmount.toStringAsFixed(0)} ($percentInt%)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: fund.accentColor,
                      ),
                    ),
                    Text(
                      "Target: R ${fund.targetAmount.toStringAsFixed(0)}",
                      style: TextStyle(fontSize: 12, color: onSurfaceColor.withOpacity(0.6)),
                    ),
                  ],
                ),
                Divider(color: borderColor, height: 22),

                // Direct Contribute to this fund button
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: fund.accentColor,
                      side: BorderSide(color: fund.accentColor.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _showContributeModal(
                      context,
                      cardColor: cardColor,
                      borderColor: borderColor,
                      brandColor: brandColor,
                      onSurfaceColor: onSurfaceColor,
                      isDark: isDark,
                      preselectedFund: fund.name,
                    ),
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 15),
                    label: Text("Contribute to ${fund.name}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5)),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSolidarityBanner(
    Color cardColor,
    Color borderColor,
    Color onSurfaceColor,
    Color brandColor,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
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
            decoration: BoxDecoration(color: brandColor.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(Icons.shield_rounded, color: brandColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kopano ke Matla • Clan Solidarity",
                  style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold, fontSize: 12.5),
                ),
                Text(
                  "All funds are managed transparently by the elected Makhetha Treasury Council.",
                  style: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 2: PUBLIC CLAN LEDGER
  // ===========================================================================
  Widget _buildPublicLedgerTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    final double totalRaised = _ledger.fold(0.0, (sum, item) => sum + item.amount);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Total Ledger Summary Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(colors: [Color(0xFF0F1E36), Color(0xFF1E2A5E)])
                : const LinearGradient(colors: [Color(0xFF451A03), Color(0xFF78350F)]),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Tracked Contributions", style: TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 2),
                    Text(
                      "R ${totalRaised.toStringAsFixed(2)}",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 28),
            ],
          ),
        ),
        const SizedBox(height: 18),

        Text(
          "RECENT RECORDED DONATIONS",
          style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
        ),
        const SizedBox(height: 10),

        ..._ledger.map((entry) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: brandColor.withOpacity(0.12),
                  child: Icon(
                    entry.isAnonymous ? Icons.shield_rounded : Icons.person_rounded,
                    color: brandColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.contributorName,
                        style: TextStyle(
                          color: onSurfaceColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "${entry.fundName} • ${entry.branch} • ${entry.date}",
                        style: TextStyle(color: onSurfaceColor.withOpacity(0.6), fontSize: 10.5),
                      ),
                    ],
                  ),
                ),
                Text(
                  "R ${entry.amount.toStringAsFixed(0)}",
                  style: TextStyle(
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
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
  // TAB 3: OFFICIAL CLAN BANKING DETAILS (EFT)
  // ===========================================================================
  Widget _buildBankDetailsTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    const String accountName = "Makhetha Family Trust & Reunion Council";
    const String bankName = "First National Bank (FNB)";
    const String accountNum = "62891234509";
    const String branchCode = "250655";
    const String referenceTip = "[Surname/Branch] - [Fund Name]";

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: brandColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.account_balance_rounded, color: brandColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Official Clan Bank Account (EFT)",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: onSurfaceColor),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "Tap any row below to copy details into your banking app (FNB, Capitec, Standard Bank, Nedbank, Absa).",
                style: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 12),
              ),
              Divider(color: borderColor, height: 24),

              _copyRow("Account Holder", accountName, accountName, brandColor, onSurfaceColor, isDark),
              const SizedBox(height: 10),
              _copyRow("Bank", bankName, bankName, brandColor, onSurfaceColor, isDark),
              const SizedBox(height: 10),
              _copyRow("Account Number", accountNum, accountNum, brandColor, onSurfaceColor, isDark),
              const SizedBox(height: 10),
              _copyRow("Branch Code", branchCode, branchCode, brandColor, onSurfaceColor, isDark),
              const SizedBox(height: 10),
              _copyRow("Reference Format", referenceTip, "Makhetha-Reunion", brandColor, onSurfaceColor, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _copyRow(
    String title,
    String value,
    String toCopy,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    final bg = isDark ? const Color(0xFF1E293B).withOpacity(0.5) : brandColor.withOpacity(0.04);
    final border = isDark ? Colors.white12 : brandColor.withOpacity(0.15);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 10.5, color: brandColor, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 13, color: onSurfaceColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy_rounded, size: 17, color: onSurfaceColor.withOpacity(0.6)),
            tooltip: "Copy $title",
            onPressed: () => _copyToClipboard(title, toCopy),
          ),
        ],
      ),
    );
  }
}