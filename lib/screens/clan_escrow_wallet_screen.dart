import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ClanEscrowTrade {
  final String id;
  final String title;
  final String buyerName;
  final String sellerName;
  final double amount;
  String status; // "HELD_IN_ESCROW", "WORK_COMPLETED", "RELEASED", "UNDER_MEDIATION"
  final String role; // "BUYER" or "SELLER"
  final String date;
  final String notes;

  ClanEscrowTrade({
    required this.id,
    required this.title,
    required this.buyerName,
    required this.sellerName,
    required this.amount,
    required this.status,
    required this.role,
    required this.date,
    required this.notes,
  });
}

class ClanEscrowWalletScreen extends StatefulWidget {
  const ClanEscrowWalletScreen({super.key});

  @override
  State<ClanEscrowWalletScreen> createState() => _ClanEscrowWalletScreenState();
}

class _ClanEscrowWalletScreenState extends State<ClanEscrowWalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  double _availableBalance = 1450.00;
  double _lockedInEscrow = 3200.00;

  final List<ClanEscrowTrade> _trades = [
    ClanEscrowTrade(
      id: "ESC-801",
      title: "Solar Backup & Inverter Installation",
      buyerName: "You (Buyer)",
      sellerName: "Ntate Sello Makhetha (Electrician)",
      amount: 2200.00,
      status: "HELD_IN_ESCROW",
      role: "BUYER",
      date: "Active • 2 days ago",
      notes: "Installation in progress at Ficksburg homestead. Funds locked until test certificate issued.",
    ),
    ClanEscrowTrade(
      id: "ESC-802",
      title: "Authentic Seanamarena Heritage Blanket",
      buyerName: "You (Buyer)",
      sellerName: "Ausi Lerato Makhetha",
      amount: 950.00,
      status: "WORK_COMPLETED",
      role: "BUYER",
      date: "Dispatched via PUDO Locker",
      notes: "Seller marked parcel as sent. Please inspect upon collection and release payment.",
    ),
    ClanEscrowTrade(
      id: "ESC-803",
      title: "Company Tax Compliance & Bookkeeping",
      buyerName: "Abuti Tshepo Makhetha",
      sellerName: "You (Seller / Accountant)",
      amount: 1450.00,
      status: "HELD_IN_ESCROW",
      role: "SELLER",
      date: "Funds Secured • In Progress",
      notes: "Client has locked R1,450.00 in escrow. Submit final financial statements to request payout.",
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

  void _releasePayment(ClanEscrowTrade trade) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 24),
            SizedBox(width: 10),
            Text("Release Escrow Payment?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          "Are you satisfied with the service or item delivered by ${trade.sellerName}? Releasing R ${trade.amount.toStringAsFixed(2)} will immediately transfer cleared funds to their wallet.",
          style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75), height: 1.45),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Not Yet / Inspect First")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                trade.status = "RELEASED";
                _lockedInEscrow -= trade.amount;
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("🎉 R ${trade.amount.toStringAsFixed(2)} released to ${trade.sellerName}! Family honor preserved."),
                  backgroundColor: const Color(0xFF16A34A),
                ),
              );
            },
            child: const Text("Yes, Release Funds"),
          ),
        ],
      ),
    );
  }

  void _requestElderMediation(ClanEscrowTrade trade) {
    final String msg = """
🐊 *LEKGOTLA LA BAHOLO • DISPUTE ARBITRATION REQUEST*
Trade Ref: ${trade.id}
Service / Item: ${trade.title}
Buyer: ${trade.buyerName}
Seller: ${trade.sellerName}
Amount Locked in Escrow: R ${trade.amount.toStringAsFixed(2)}
---------------------------------
Greetings Elders Council! I am requesting traditional family mediation regarding this trade to ensure fair resolution without conflict.
""";

    const String councilWhatsApp = "27821234567"; // Elder Council WhatsApp
    _launchExternal("https://wa.me/$councilWhatsApp?text=${Uri.encodeComponent(msg)}");
  }

  void _showInitiateTradeModal(
    BuildContext context, {
    required Color cardColor,
    required Color borderColor,
    required Color brandColor,
    required Color onSurfaceColor,
    required bool isDark,
  }) {
    final titleC = TextEditingController();
    final relativeNameC = TextEditingController();
    final amountC = TextEditingController();
    final termsC = TextEditingController();

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
            Icon(Icons.shield_rounded, color: brandColor, size: 22),
            const SizedBox(width: 10),
            Text(
              "Lock Funds in Clan Escrow",
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
                "Protect both parties. Lock agreed payment now; release only when the job or item is satisfactory.",
                style: TextStyle(color: onSurfaceColor.withOpacity(0.7), fontSize: 11.5),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: titleC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Job or Item Name *", hint: "e.g. Roof Repair, Seanamarena Blanket", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: relativeNameC,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Relative's Name (Contractor / Seller) *", hint: "e.g. Ntate Sello Makhetha", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: amountC,
                keyboardType: TextInputType.number,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Agreed Amount (ZAR Rands) *", hint: "e.g. 1500", prefix: "R ", onSurfaceColor, borderColor, isDark),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: termsC,
                maxLines: 2,
                style: TextStyle(color: onSurfaceColor, fontSize: 13),
                decoration: _inputDecor("Agreed Milestone / Terms", hint: "Payment released upon installation & inspection...", onSurfaceColor, borderColor, isDark),
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
              if (titleC.text.isNotEmpty && relativeNameC.text.isNotEmpty && parsedAmt > 0) {
                setState(() {
                  _lockedInEscrow += parsedAmt;
                  _trades.insert(
                    0,
                    ClanEscrowTrade(
                      id: "ESC-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
                      title: titleC.text.trim(),
                      buyerName: "You (Buyer)",
                      sellerName: relativeNameC.text.trim(),
                      amount: parsedAmt,
                      status: "HELD_IN_ESCROW",
                      role: "BUYER",
                      date: "Active • Just Now",
                      notes: termsC.text.trim().isNotEmpty
                          ? termsC.text.trim()
                          : "Funds locked in clan escrow pending delivery.",
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("🔒 R ${parsedAmt.toStringAsFixed(2)} safely locked in Clan Escrow!"),
                    backgroundColor: const Color(0xFF16A34A),
                  ),
                );
              }
            },
            child: const Text("Lock in Escrow"),
          ),
        ],
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
          "SAFETRADE CLAN ESCROW WALLET",
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
              onPressed: () => _showInitiateTradeModal(
                context,
                cardColor: cardColor,
                borderColor: borderColor,
                brandColor: brandColor,
                onSurfaceColor: onSurfaceColor,
                isDark: isDark,
              ),
              icon: const Icon(Icons.lock_clock_rounded, size: 15),
              label: const Text("New Escrow", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5)),
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
            Tab(icon: Icon(Icons.account_balance_wallet_rounded, size: 17), text: "Wallet & Active Trades"),
            Tab(icon: Icon(Icons.gavel_rounded, size: 17), text: "Lekgotla Arbitration"),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildWalletAndTradesTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
              _buildArbitrationGuideTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 1: WALLET & ACTIVE TRADES
  // ===========================================================================
  Widget _buildWalletAndTradesTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Balance Overview Card
        _buildBalanceCard(isDark, brandColor),
        const SizedBox(height: 18),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "ACTIVE PROTECTED ORDERS",
              style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
            ),
            Text(
              "${_trades.length} Trades Tracked",
              style: TextStyle(color: onSurfaceColor.withOpacity(0.6), fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 10),

        ..._trades.map((trade) {
          return _buildTradeCard(trade, cardColor, borderColor, brandColor, onSurfaceColor, isDark);
        }),
      ],
    );
  }

  Widget _buildBalanceCard(bool isDark, Color brandColor) {
    final gradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF0F1E36), Color(0xFF1E2A5E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF451A03), Color(0xFF78350F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.1),
            blurRadius: 14,
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
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("🛡️ ", style: TextStyle(fontSize: 12)),
                    Text(
                      "CLAN ESCROW TRUST PROTECTED",
                      style: TextStyle(color: Color(0xFFFDE68A), fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(Icons.fingerprint_rounded, color: Colors.white54, size: 24),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Available Wallet Balance", style: TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 2),
                    Text(
                      "R ${_availableBalance.toStringAsFixed(2)}",
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 36, width: 1, color: Colors.white24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Locked in Escrow", style: TextStyle(color: Color(0xFFFDE68A), fontSize: 11)),
                    const SizedBox(height: 2),
                    Text(
                      "R ${_lockedInEscrow.toStringAsFixed(2)}",
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 26),

          Row(
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white60),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Withdrawal request initiated to your South African / Lesotho bank account.")),
                  );
                },
                icon: const Icon(Icons.arrow_outward_rounded, size: 14),
                label: const Text("Withdraw to Bank", style: TextStyle(fontSize: 11)),
              ),
              const Spacer(),
              Text(
                "Zero family debt • Total peace of mind",
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradeCard(
    ClanEscrowTrade trade,
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    Color statusColor;
    String statusLabel;

    switch (trade.status) {
      case "HELD_IN_ESCROW":
        statusColor = const Color(0xFFF59E0B);
        statusLabel = "🔒 FUNDS LOCKED IN ESCROW";
        break;
      case "WORK_COMPLETED":
        statusColor = const Color(0xFF3B82F6);
        statusLabel = "🚚 COMPLETED • AWAITING INSPECTION";
        break;
      case "RELEASED":
        statusColor = const Color(0xFF10B981);
        statusLabel = "✅ RELEASED TO RELATIVE";
        break;
      default:
        statusColor = const Color(0xFFEF4444);
        statusLabel = "⚖️ UNDER ELDER MEDIATION";
    }

    final bool isBuyer = trade.role == "BUYER";

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
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(color: statusColor, fontSize: 9.5, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Text(
                "R ${trade.amount.toStringAsFixed(2)}",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: brandColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            trade.title,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14, color: onSurfaceColor),
          ),
          const SizedBox(height: 2),
          Text(
            isBuyer ? "Contractor / Seller: ${trade.sellerName}" : "Client: ${trade.buyerName}",
            style: TextStyle(fontSize: 11.5, color: onSurfaceColor.withOpacity(0.7), fontWeight: FontWeight.w500),
          ),
          Text(trade.date, style: TextStyle(fontSize: 10.5, color: onSurfaceColor.withOpacity(0.5))),
          const SizedBox(height: 6),
          Text(
            trade.notes,
            style: TextStyle(fontSize: 11.5, color: onSurfaceColor.withOpacity(0.75), height: 1.35),
          ),
          Divider(color: borderColor, height: 20),

          // Action Row
          Row(
            children: [
              // Dispute Trigger
              TextButton.icon(
                onPressed: () => _requestElderMediation(trade),
                icon: const Icon(Icons.gavel_rounded, size: 14, color: Color(0xFFEF4444)),
                label: const Text("Elder Mediation", style: TextStyle(color: Color(0xFFEF4444), fontSize: 11)),
              ),
              const Spacer(),

              // Buyer Action: Release Payment
              if (isBuyer && trade.status != "RELEASED")
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _releasePayment(trade),
                  icon: const Icon(Icons.check_circle_rounded, size: 15),
                  label: const Text("Release Payment", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                ),

              // Seller Action: Mark Completed
              if (!isBuyer && trade.status == "HELD_IN_ESCROW")
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    setState(() => trade.status = "WORK_COMPLETED");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("✅ Marked completed! Buyer notified to inspect.")),
                    );
                  },
                  icon: const Icon(Icons.done_all_rounded, size: 15),
                  label: const Text("Mark Delivered", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 2: LEKGOTLA ARBITRATION PROTOCOL
  // ===========================================================================
  Widget _buildArbitrationGuideTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
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
                      color: const Color(0xFFEF4444).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.gavel_rounded, color: Color(0xFFEF4444), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LEKGOTLA LA BAHOLO PROTOCOL",
                          style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
                        ),
                        Text(
                          "Traditional Clan Dispute Mediation",
                          style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: onSurfaceColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: borderColor, height: 22),
              Text(
                "Why we resolve business disputes within the family:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: onSurfaceColor),
              ),
              const SizedBox(height: 6),
              Text(
                "Taking a relative to court or engaging in public hostility tears down the Makhetha name. Our platform implements traditional African family jurisprudence:",
                style: TextStyle(color: onSurfaceColor.withOpacity(0.72), fontSize: 12, height: 1.45),
              ),
              const SizedBox(height: 14),
              _stepItem("Step 1: Quiet Brotherly Dialogue", "The buyer and contractor chat directly to explain what needs adjustment.", brandColor, onSurfaceColor),
              _stepItem("Step 2: Branch Elder Conciliation", "A trusted elder or aunt reviews photos/delivery notes to propose a fair compromise.", brandColor, onSurfaceColor),
              _stepItem("Step 3: Executive Council Determination", "If willful fraud or non-delivery occurs, the council votes to refund the buyer or pay the contractor, and dishonest individuals are barred from the directory.", brandColor, onSurfaceColor),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    const String councilWhatsApp = "27821234567";
                    _launchExternal("https://wa.me/$councilWhatsApp?text=${Uri.encodeComponent('Lekgotla la Baholo: Requesting confidential elder assistance with a family business dispute.')}");
                  },
                  icon: const Icon(Icons.chat_rounded, size: 16),
                  label: const Text("Contact Elder Arbitration Desk", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepItem(String title, String desc, Color brandColor, Color onSurfaceColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline_rounded, color: brandColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: onSurfaceColor)),
                Text(desc, style: TextStyle(fontSize: 11, color: onSurfaceColor.withOpacity(0.65), height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}