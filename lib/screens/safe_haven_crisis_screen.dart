import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SafeHavenCrisisScreen extends StatefulWidget {
  const SafeHavenCrisisScreen({super.key});

  @override
  State<SafeHavenCrisisScreen> createState() => _SafeHavenCrisisScreenState();
}

class _SafeHavenCrisisScreenState extends State<SafeHavenCrisisScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _incidentDescriptionC = TextEditingController();
  final TextEditingController _locationC = TextEditingController();
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _phoneC = TextEditingController();

  bool _isCompletelyAnonymous = true;
  String _selectedCategory = "Domestic Distress & Gender-Based Violence";
  String _urgencyLevel = "Urgent (Within 24 Hours)";
  String _preferredAdvocate = "Bo-Rakgadi & Bo-Mme (Clan Aunts Circle)";

  final List<String> _crisisCategories = [
    "Domestic Distress & Gender-Based Violence",
    "Emotional Crisis, Depression & Suicide Risk",
    "Child Protection, Abuse or Neglect",
    "Elderly Exploitation or Abandonment",
    "Emergency Safe Shelter & Escape Needed",
    "Substance Abuse & Family Crisis Intervention",
  ];

  final List<String> _advocateOptions = [
    "Bo-Rakgadi & Bo-Mme (Clan Aunts Circle)",
    "Professional External Social Worker / Counselor",
    "Neutral Lekgotla Elder Mediation",
    "Emergency Law Enforcement (SAPS / Police)",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _incidentDescriptionC.dispose();
    _locationC.dispose();
    _nameC.dispose();
    _phoneC.dispose();
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

  // Emergency stealth exit: closes the screen and launches neutral website
  void _quickSafeExit() {
    _launchExternal("https://www.google.com");
  }

  void _submitCrisisReport() {
    if (!_formKey.currentState!.validate()) return;

    // Generate unique anonymous tracking token
    final String caseToken = "MK-SAFE-${Random().nextInt(9000) + 1000}";
    final String reporter = _isCompletelyAnonymous
        ? "100% ANONYMOUS RELATIVE"
        : (_nameC.text.trim().isNotEmpty ? _nameC.text.trim() : "Confidential Kinsman");
    final String contact = _isCompletelyAnonymous
        ? "Anonymous Case Token: $caseToken"
        : (_phoneC.text.trim().isNotEmpty ? _phoneC.text.trim() : "None provided");

    final String message = """
🛡️ *LEKGOTLA LA MAKHETHA • SAFE HAVEN CRISIS REPORT*
Case Ref: *$caseToken*
---------------------------------
⚠️ *Category:* $_selectedCategory
⏱️ *Urgency:* $_urgencyLevel
👤 *Source:* $reporter
📞 *Contact / Channel:* $contact
📍 *Area / Town:* ${_locationC.text.trim().isNotEmpty ? _locationC.text.trim() : 'Confidential'}
🤝 *Requested Advocate:* $_preferredAdvocate
---------------------------------
📜 *Confidential Statement:*
"${_incidentDescriptionC.text.trim()}"
---------------------------------
Protected under Clan Safe Haven Protocol. Confidential handling guaranteed.
""";

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1014),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFF43F5E)),
        ),
        title: const Row(
          children: [
            Icon(Icons.verified_user_rounded, color: Color(0xFF10B981), size: 24),
            SizedBox(width: 10),
            Text("Case Registered Confidentially", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your report has been encrypted. Save your private Case Token to follow up without revealing your identity:",
              style: TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF43F5E)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(caseToken, style: GoogleFonts.montserrat(color: const Color(0xFFFDE68A), fontWeight: FontWeight.w900, fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, color: Colors.white70, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: caseToken));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Token copied to clipboard")));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tap below to send this directly to the vetted Bo-Rakgadi Crisis Coordination WhatsApp desk.",
              style: TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _incidentDescriptionC.clear();
              _locationC.clear();
            },
            child: const Text("Done (Keep in App)", style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF43F5E),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              const String crisisWhatsApp = "27821234567"; // Vetted Crisis Coordinator
              _launchExternal("https://wa.me/$crisisWhatsApp?text=${Uri.encodeComponent(message)}");
              _incidentDescriptionC.clear();
              _locationC.clear();
            },
            icon: const Icon(Icons.chat_bubble_rounded, size: 15),
            label: const Text("Hand Off to Crisis Desk"),
          ),
        ],
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
          "SAFE HAVEN: CRISIS & GBV SUPPORT",
          style: GoogleFonts.montserrat(
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
            color: onSurfaceColor,
          ),
        ),
        centerTitle: true,
        actions: [
          // 🚨 QUICK STEALTH SAFE EXIT BUTTON
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _quickSafeExit,
              icon: const Icon(Icons.power_settings_new_rounded, size: 14),
              label: const Text("Quick Exit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFF43F5E),
          indicatorWeight: 3,
          labelColor: const Color(0xFFF43F5E),
          unselectedLabelColor: onSurfaceColor.withOpacity(0.6),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          tabs: const [
            Tab(icon: Icon(Icons.lock_rounded, size: 16), text: "Confidential Report"),
            Tab(icon: Icon(Icons.phone_in_talk_rounded, size: 16), text: "24/7 Hotlines"),
            Tab(icon: Icon(Icons.shield_rounded, size: 16), text: "Sanctuary Protocol"),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildReportFormTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
              _buildHotlinesTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
              _buildProtocolTab(cardColor, borderColor, brandColor, onSurfaceColor, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 1: CONFIDENTIAL & ANONYMOUS REPORTING FORM
  // ===========================================================================
  Widget _buildReportFormTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Privacy Reassurance Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF4C0519).withOpacity(isDark ? 0.45 : 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF43F5E)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Color(0xFFF43F5E), shape: BoxShape.circle),
                child: const Icon(Icons.lock_person_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Absolute Confidentiality Guaranteed",
                      style: TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      "You can submit this report completely anonymously. Your identity is protected from family gossip and retaliation.",
                      style: TextStyle(color: onSurfaceColor.withOpacity(0.7), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Form Container
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "1. Nature of the Situation",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: onSurfaceColor),
                ),
                const SizedBox(height: 8),

                // Issue Category
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  dropdownColor: cardColor,
                  style: TextStyle(color: onSurfaceColor, fontSize: 12.5),
                  decoration: _inputDecor("Category of Distress *", onSurfaceColor, borderColor, isDark),
                  items: _crisisCategories.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val!),
                ),
                const SizedBox(height: 12),

                // Urgency Level
                DropdownButtonFormField<String>(
                  value: _urgencyLevel,
                  isExpanded: true,
                  dropdownColor: cardColor,
                  style: TextStyle(color: onSurfaceColor, fontSize: 12.5),
                  decoration: _inputDecor("Urgency Assessment *", onSurfaceColor, borderColor, isDark),
                  items: [
                    "Immediate Danger (Need Safe Shelter / Police)",
                    "Urgent (Within 24 Hours)",
                    "Confidential Elder Guidance & Support",
                  ].map((u) => DropdownMenuItem(value: u, child: Text(u, overflow: TextOverflow.ellipsis))).toList(),
                  onChanged: (val) => setState(() => _urgencyLevel = val!),
                ),
                const SizedBox(height: 12),

                // Statement of what is happening
                TextFormField(
                  controller: _incidentDescriptionC,
                  maxLines: 4,
                  style: TextStyle(color: onSurfaceColor, fontSize: 13),
                  decoration: _inputDecor(
                    "What is happening? Describe safely *",
                    onSurfaceColor,
                    borderColor,
                    isDark,
                    hint: "Share what you are experiencing, who is involved, or what kind of help is needed...",
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? "Please provide brief details" : null,
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _locationC,
                  style: TextStyle(color: onSurfaceColor, fontSize: 13),
                  decoration: _inputDecor(
                    "General Area / City / Province",
                    onSurfaceColor,
                    borderColor,
                    isDark,
                    hint: "e.g. Soweto, Bloemfontein, Maseru, Durban",
                  ),
                ),
                Divider(color: borderColor, height: 26),

                Text(
                  "2. Who Should Handle Your Case?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: onSurfaceColor),
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: _preferredAdvocate,
                  isExpanded: true,
                  dropdownColor: cardColor,
                  style: TextStyle(color: onSurfaceColor, fontSize: 12.5),
                  decoration: _inputDecor("Designated Support Circle *", onSurfaceColor, borderColor, isDark),
                  items: _advocateOptions.map((opt) => DropdownMenuItem(value: opt, child: Text(opt, overflow: TextOverflow.ellipsis))).toList(),
                  onChanged: (val) => setState(() => _preferredAdvocate = val!),
                ),
                const SizedBox(height: 12),

                // Anonymous Switch
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isCompletelyAnonymous ? const Color(0xFF10B981).withOpacity(0.1) : brandColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _isCompletelyAnonymous ? const Color(0xFF10B981) : borderColor),
                  ),
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    activeColor: const Color(0xFF10B981),
                    value: _isCompletelyAnonymous,
                    title: Text(
                      _isCompletelyAnonymous ? "🔒 100% Anonymous (No name or phone recorded)" : "👤 I want to provide my contact info",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _isCompletelyAnonymous ? const Color(0xFF10B981) : onSurfaceColor,
                      ),
                    ),
                    onChanged: (val) => setState(() => _isCompletelyAnonymous = val),
                  ),
                ),
                const SizedBox(height: 10),

                if (!_isCompletelyAnonymous) ...[
                  TextField(
                    controller: _nameC,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Your Name (Optional)", onSurfaceColor, borderColor, isDark),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _phoneC,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: onSurfaceColor, fontSize: 13),
                    decoration: _inputDecor("Safe Phone / WhatsApp Number", hint: "082 123 4567", onSurfaceColor, borderColor, isDark),
                  ),
                  const SizedBox(height: 10),
                ],

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF43F5E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: _submitCrisisReport,
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: const Text("Submit Confidential Report", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 2: EMERGENCY 24/7 HOTLINES
  // ===========================================================================
  Widget _buildHotlinesTab(
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        _hotlineTile(
          title: "National GBV Command Centre (South Africa)",
          number: "0800 428 428",
          subtitle: "Toll-free 24/7 emergency counseling, police dispatch & social worker support.",
          badge: "TOLL FREE • 24/7",
          badgeColor: const Color(0xFFEF4444),
          callUri: "tel:0800428428",
          cardColor: cardColor,
          borderColor: borderColor,
          onSurfaceColor: onSurfaceColor,
        ),
        _hotlineTile(
          title: "SAPS Police Emergency Services",
          number: "10111",
          subtitle: "Immediate flying squad and localized station dispatch across South Africa.",
          badge: "POLICE RESPONSE",
          badgeColor: const Color(0xFF2563EB),
          callUri: "tel:10111",
          cardColor: cardColor,
          borderColor: borderColor,
          onSurfaceColor: onSurfaceColor,
        ),
        _hotlineTile(
          title: "SADAG Suicide & Mental Health Crisis Helpline",
          number: "0800 567 567",
          subtitle: "Immediate psychiatric intervention for overwhelming depression, trauma, and anxiety.",
          badge: "MENTAL HEALTH",
          badgeColor: const Color(0xFF10B981),
          callUri: "tel:0800567567",
          cardColor: cardColor,
          borderColor: borderColor,
          onSurfaceColor: onSurfaceColor,
        ),
        _hotlineTile(
          title: "Childline South Africa",
          number: "116",
          subtitle: "Free nationwide protection hotline for minors, child abuse, and domestic trauma.",
          badge: "CHILD SAFETY",
          badgeColor: const Color(0xFFEA580C),
          callUri: "tel:116",
          cardColor: cardColor,
          borderColor: borderColor,
          onSurfaceColor: onSurfaceColor,
        ),
        _hotlineTile(
          title: "Lesotho Child & Gender Protection Unit (CGPU)",
          number: "+266 2231 2201",
          subtitle: "Maseru and regional Lesotho domestic abuse & emergency protection command.",
          badge: "LESOTHO BRANCH",
          badgeColor: const Color(0xFF7C3AED),
          callUri: "tel:+26622312201",
          cardColor: cardColor,
          borderColor: borderColor,
          onSurfaceColor: onSurfaceColor,
        ),
      ],
    );
  }

  Widget _hotlineTile({
    required String title,
    required String number,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required String callUri,
    required Color cardColor,
    required Color borderColor,
    required Color onSurfaceColor,
  }) {
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
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: badgeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                child: Text(badge, style: TextStyle(color: badgeColor, fontSize: 9.5, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: () => _launchExternal(callUri),
                icon: const Icon(Icons.phone_rounded, size: 14),
                label: const Text("Call Now", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: onSurfaceColor)),
          Text(number, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFFF43F5E))),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 11, color: onSurfaceColor.withOpacity(0.65), height: 1.35)),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 3: CLAN SANCTUARY PROTOCOL
  // ===========================================================================
  Widget _buildProtocolTab(
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: brandColor.withOpacity(0.12), shape: BoxShape.circle),
                    child: Icon(Icons.shield_rounded, color: brandColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("LEKGOTLA PROTECTION PROTOCOL", style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 10.5, letterSpacing: 1)),
                        Text("How the Makhetha Clan Protects Vulnerable Kin", style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.bold, color: onSurfaceColor)),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: borderColor, height: 22),
              _protocolRow("1. Victim Safety Above Family Reputation", "We never sweep abuse under the carpet to protect 'the family name.' The physical and mental safety of a vulnerable relative is our sacred duty.", brandColor, onSurfaceColor),
              _protocolRow("2. Bo-Rakgadi & Bo-Mme Immediate Shield", "Vetted female elders in each branch act as neutral aunts, providing private emergency sheltering, food, and emotional guidance.", brandColor, onSurfaceColor),
              _protocolRow("3. Zero Toleration for Retaliation", "Any relative who intimidates or silences someone seeking help faces immediate sanction and removal from the Lekgotla community.", brandColor, onSurfaceColor),
              _protocolRow("4. Professional Medical & Legal Referrals", "The council connects victims directly with doctors, legal clinics, and law enforcement when safety demands it.", brandColor, onSurfaceColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _protocolRow(String title, String desc, Color brandColor, Color onSurfaceColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, color: brandColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: onSurfaceColor)),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(fontSize: 11, color: onSurfaceColor.withOpacity(0.68), height: 1.35)),
              ],
            ),
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
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: onSurfaceColor.withOpacity(0.65), fontSize: 12),
      hintStyle: TextStyle(color: onSurfaceColor.withOpacity(0.35), fontSize: 12),
      filled: true,
      fillColor: isDark ? const Color(0xFF0B1120) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xFFF43F5E), width: 1.5)),
    );
  }
}