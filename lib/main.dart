import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// Services
import 'services/theme_service.dart';

// Screens
import 'screens/yaga_marketplace_screen.dart';
import 'screens/makhetha_professions_screen.dart';
import 'screens/reunion_kgotla_screen.dart';
import 'screens/family_tracer_screen.dart';
import 'screens/clan_escrow_wallet_screen.dart';
import 'screens/clan_contributions_screen.dart';
import 'screens/clan_vault_screen.dart';
import 'screens/safe_haven_crisis_screen.dart';
import 'screens/clan_admin_dashboard_screen.dart';
import 'screens/clan_committee_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService().initTheme();
  runApp(const MakhethaClanApp());
}

class MakhethaClanApp extends StatelessWidget {
  const MakhethaClanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppColorPalette>(
      valueListenable: ThemeService().currentPalette,
      builder: (context, palette, _) {
        return MaterialApp(
          title: 'Lekgotla la Makhetha',
          debugShowCheckedModeBanner: false,
          theme: ThemeService().getThemeData(palette),
          home: const MakhethaMasterHomeView(),
        );
      },
    );
  }
}

class MakhethaMasterHomeView extends StatefulWidget {
  const MakhethaMasterHomeView({super.key});

  @override
  State<MakhethaMasterHomeView> createState() => _MakhethaMasterHomeViewState();
}

class _MakhethaMasterHomeViewState extends State<MakhethaMasterHomeView> {
  final ScrollController _pageScroll = ScrollController();

  // 📍 24 SEPTEMBER 2027 REUNION COUNTDOWN
  static final DateTime _reunionDate = DateTime(2027, 9, 24, 9, 0, 0);
  Timer? _countdownTimer;
  Duration _timeUntilReunion = Duration.zero;

  // 12 Provincial & Global Branches
  String _selectedBranch = "All Branches (Global)";
  final List<String> _familyBranches = [
    "All Branches (Global)",
    "Free State Branch",
    "Gauteng Branch",
    "KwaZulu-Natal Branch",
    "Lesotho Heritage Branch",
    "Eastern Cape Branch",
    "Western Cape Branch",
    "Northern Cape Branch",
    "Mpumalanga Branch",
    "Limpopo Branch",
    "North West Branch",
    "International Diaspora (UK, USA, Global)",
  ];

  @override
  void initState() {
    super.initState();
    _updateReunionCountdown();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateReunionCountdown();
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pageScroll.dispose();
    super.dispose();
  }

  void _updateReunionCountdown() {
    final now = DateTime.now();
    final difference = _reunionDate.difference(now);
    setState(() {
      _timeUntilReunion = difference.isNegative ? Duration.zero : difference;
    });
  }

  Future<void> _launchExternal(String link) async {
    final Uri uri = Uri.parse(link);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  void _openWhatsApp(String message) {
    const String councilNumber = "27821234567";
    final String query = Uri.encodeComponent(message);
    _launchExternal("https://wa.me/$councilNumber?text=$query");
  }

  void _showPalettePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.palette_rounded, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Text(
              "Choose App Theme Palette",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: AppColorPalette.values.map((palette) {
              final isSelected = ThemeService().currentPalette.value == palette;
              final color = ThemeService.getPaletteColor(palette);
              final name = ThemeService.getPaletteName(palette);

              return ListTile(
                leading: CircleAvatar(
                  radius: 14,
                  backgroundColor: color,
                  child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                ),
                title: Text(
                  name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  ThemeService().setPalette(palette);
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _quickCrisisExit() {
    _launchExternal("https://www.google.com");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final brandColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final cardColor = theme.cardColor;
    final borderColor = theme.dividerColor;

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideScreen = screenWidth > 880;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      endDrawer: _buildOrganizedSidebar(context, brandColor, onSurfaceColor, cardColor, borderColor),
      body: SafeArea(
        top: false,
        bottom: true,
        child: CustomScrollView(
          controller: _pageScroll,
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildTopNav(context, isWideScreen, isDark, brandColor, onSurfaceColor, cardColor, borderColor),
            SliverToBoxAdapter(
              child: _buildHeroDisplay(isWideScreen, isDark, brandColor, onSurfaceColor),
            ),
            SliverToBoxAdapter(
              child: _buildGbvCrisisBanner(context, isWideScreen, isDark, cardColor, borderColor),
            ),
            SliverToBoxAdapter(
              child: _buildReunionScheduleBar(context, isWideScreen, isDark, brandColor, onSurfaceColor, cardColor, borderColor),
            ),
            SliverToBoxAdapter(
              child: _buildPillarsGrid(context, isWideScreen, isDark, brandColor, onSurfaceColor, cardColor, borderColor),
            ),
            SliverToBoxAdapter(
              child: _buildYagaMarketplaceSpotlight(context, isWideScreen, isDark, brandColor, onSurfaceColor, cardColor, borderColor),
            ),
            SliverToBoxAdapter(
              child: _buildEscrowWalletSection(context, isWideScreen, isDark, brandColor),
            ),
            SliverToBoxAdapter(
              child: _buildClanFooter(context, isWideScreen, isDark, brandColor, bottomPadding),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. TOP NAV & CLAN CREST
  // ===========================================================================
  Widget _buildTopNav(
    BuildContext context,
    bool isWideScreen,
    bool isDark,
    Color brandColor,
    Color onSurfaceColor,
    Color cardColor,
    Color borderColor,
  ) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.96),
      toolbarHeight: 70,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: brandColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: brandColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("🐊", style: TextStyle(fontSize: 18)),
                const SizedBox(width: 4),
                Text(
                  "KOENA",
                  style: TextStyle(
                    color: brandColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "LEKGOTLA LA MAKHETHA",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w900,
                  fontSize: isWideScreen ? 14 : 12.5,
                  letterSpacing: 1.1,
                  color: onSurfaceColor,
                ),
              ),
              Text(
                "Bakoena ba heso • Global Clan Network",
                style: TextStyle(fontSize: 9.5, color: brandColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: "Change Theme Palette",
          icon: Icon(Icons.palette_rounded, color: brandColor, size: 22),
          onPressed: () => _showPalettePicker(context),
        ),
        if (isWideScreen) ...[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBranch,
                dropdownColor: cardColor,
                style: TextStyle(color: onSurfaceColor, fontSize: 12, fontWeight: FontWeight.bold),
                items: _familyBranches.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedBranch = val);
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          _navBtn("Yaga Shop", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const YagaMarketplaceScreen()));
          }),
          _navBtn("Committee", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ClanCommitteeScreen()));
          }),
          _navBtn("Professions", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MakhethaProfessionsScreen()));
          }),
          _navBtn("Escrow Wallet", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ClanEscrowWalletScreen()));
          }),
          _navBtn("Reunion 2027", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ReunionKgotlaScreen()));
          }),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: brandColor,
              foregroundColor: isDark ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _openWhatsApp("Greetings Makhetha Council! I would like to connect our household."),
            child: const Text("Join Household", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 20),
        ] else ...[
          IconButton(
            icon: Icon(Icons.menu_rounded, color: onSurfaceColor),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _navBtn(String title, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ===========================================================================
  // 2. HERO DISPLAY (ALL 11 PALETTES + 3 ACTION BUTTONS)
  // ===========================================================================
  Widget _buildHeroDisplay(bool isWideScreen, bool isDark, Color brandColor, Color onSurfaceColor) {
    final currentPalette = ThemeService().currentPalette.value;

    List<Color> heroGradient;
    Color accentColor;

    switch (currentPalette) {
      case AppColorPalette.heritageGold:
        heroGradient = [const Color(0xFF451A03), const Color(0xFF78350F), const Color(0xFF9A3412)];
        accentColor = const Color(0xFFFDE68A);
        break;
      case AppColorPalette.roseGrace:
        heroGradient = [const Color(0xFF4C0519), const Color(0xFF701A75), const Color(0xFF831843)];
        accentColor = const Color(0xFFFCE7F3);
        break;
      case AppColorPalette.darkObsidian:
        heroGradient = [const Color(0xFF080C15), const Color(0xFF111827), const Color(0xFF0F172A)];
        accentColor = const Color(0xFFF59E0B);
        break;
      case AppColorPalette.africanEmerald:
        heroGradient = [const Color(0xFF064E3B), const Color(0xFF065F46), const Color(0xFF047857)];
        accentColor = const Color(0xFFA7F3D0);
        break;
      case AppColorPalette.sapphireBlue:
        heroGradient = [const Color(0xFF1E3A8A), const Color(0xFF1D4ED8), const Color(0xFF172554)];
        accentColor = const Color(0xFF93C5FD);
        break;
      case AppColorPalette.forestWhisper:
        heroGradient = [const Color(0xFF1E293B), const Color(0xFF334155), const Color(0xFF0F172A)];
        accentColor = const Color(0xFFDDD6FE);
        break;
      case AppColorPalette.whitePearl:
        heroGradient = [const Color(0xFF0F766E), const Color(0xFF115E59), const Color(0xFF134E4A)];
        accentColor = const Color(0xFFCCFBF1);
        break;
      case AppColorPalette.sunsetAmber:
        heroGradient = [const Color(0xFF7C2D12), const Color(0xFF9A3412), const Color(0xFFC2410C)];
        accentColor = const Color(0xFFFED7AA);
        break;
      case AppColorPalette.oceanBreeze:
        heroGradient = [const Color(0xFF0C4A6E), const Color(0xFF0369A1), const Color(0xFF075985)];
        accentColor = const Color(0xFFBAE6FD);
        break;
      case AppColorPalette.lavenderDream:
        heroGradient = [const Color(0xFF4C1D95), const Color(0xFF5B21B6), const Color(0xFF3B0764)];
        accentColor = const Color(0xFFE9D5FF);
        break;
      case AppColorPalette.peachBlush:
        heroGradient = [const Color(0xFF831843), const Color(0xFF9D174D), const Color(0xFFBE185D)];
        accentColor = const Color(0xFFFBCFE8);
        break;
    }

    final int days = _timeUntilReunion.inDays;
    final int hours = _timeUntilReunion.inHours.remainder(24);
    final int minutes = _timeUntilReunion.inMinutes.remainder(60);
    final int seconds = _timeUntilReunion.inSeconds.remainder(60);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWideScreen ? 48 : 20,
        vertical: isWideScreen ? 46 : 34,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("🐊 ", style: TextStyle(fontSize: 14)),
                    Text(
                      "BAKOENA HERITAGE • SEBOKO: KOENA",
                      style: TextStyle(color: accentColor, fontSize: 10.5, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Text(
                "KOPANO YA LELAPA LA MAKHETHA",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w900,
                  fontSize: isWideScreen ? 34 : 22,
                  color: Colors.white,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                "Connecting every branch and generation worldwide. Preserving ancestral heritage, building clan businesses, and caring for one another in unity.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.88), fontSize: isWideScreen ? 14 : 12.5, height: 1.45),
              ),
              const SizedBox(height: 20),

              // Countdown Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: accentColor.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_available_rounded, color: accentColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          "HERITAGE DAY REUNION • 24 SEPTEMBER 2027",
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _countdownPill(days.toString(), "DAYS", accentColor),
                        _countdownColon(accentColor),
                        _countdownPill(hours.toString().padLeft(2, '0'), "HOURS", accentColor),
                        _countdownColon(accentColor),
                        _countdownPill(minutes.toString().padLeft(2, '0'), "MINS", accentColor),
                        _countdownColon(accentColor),
                        _countdownPill(seconds.toString().padLeft(2, '0'), "SECS", accentColor),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // 📍 3 Action Buttons (Tickets, Committee, Submit Topics)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xFFF59E0B) : Colors.white,
                      foregroundColor: isDark ? Colors.black : const Color(0xFF451A03),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ReunionKgotlaScreen()));
                    },
                    icon: const Icon(Icons.confirmation_number_rounded, size: 17),
                    label: const Text("Get Reunion Tickets", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ClanCommitteeScreen()));
                    },
                    icon: const Icon(Icons.people_alt_rounded, size: 17, color: Colors.white),
                    label: const Text("2026–2028 Committee", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white60, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ReunionKgotlaScreen()));
                    },
                    icon: Icon(Icons.how_to_vote_rounded, size: 17, color: accentColor),
                    label: const Text("Submit Reunion Topics"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _countdownPill(String value, String label, Color accentColor) {
    return Container(
      constraints: const BoxConstraints(minWidth: 54),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.montserrat(
              color: accentColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 8.5, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _countdownColon(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        ":",
        style: TextStyle(color: accentColor, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ===========================================================================
  // 3. ANONYMOUS GBV BANNER
  // ===========================================================================
  Widget _buildGbvCrisisBanner(
    BuildContext context,
    bool isWideScreen,
    bool isDark,
    Color cardColor,
    Color borderColor,
  ) {
    final currentPalette = ThemeService().currentPalette.value;

    Color bannerBg;
    Color bannerBorder;
    Color iconColor;
    Color buttonBg;
    Color buttonFg;

    switch (currentPalette) {
      case AppColorPalette.heritageGold:
        bannerBg = const Color(0xFF3B1207).withOpacity(0.95);
        bannerBorder = const Color(0xFFF59E0B);
        iconColor = const Color(0xFFFDE68A);
        buttonBg = const Color(0xFFF59E0B);
        buttonFg = const Color(0xFF3B1207);
        break;
      case AppColorPalette.roseGrace:
        bannerBg = const Color(0xFF4C0519).withOpacity(0.94);
        bannerBorder = const Color(0xFFF43F5E);
        iconColor = Colors.white;
        buttonBg = Colors.white;
        buttonFg = const Color(0xFF881337);
        break;
      case AppColorPalette.darkObsidian:
        bannerBg = const Color(0xFF181119).withOpacity(0.95);
        bannerBorder = const Color(0xFFEF4444);
        iconColor = const Color(0xFFFCA5A5);
        buttonBg = const Color(0xFFEF4444);
        buttonFg = Colors.white;
        break;
      case AppColorPalette.africanEmerald:
        bannerBg = const Color(0xFF022C22).withOpacity(0.95);
        bannerBorder = const Color(0xFF10B981);
        iconColor = const Color(0xFFA7F3D0);
        buttonBg = const Color(0xFF10B981);
        buttonFg = Colors.white;
        break;
      case AppColorPalette.sapphireBlue:
        bannerBg = const Color(0xFF1E3A8A).withOpacity(0.95);
        bannerBorder = const Color(0xFF3B82F6);
        iconColor = const Color(0xFF93C5FD);
        buttonBg = const Color(0xFF3B82F6);
        buttonFg = Colors.white;
        break;
      case AppColorPalette.forestWhisper:
        bannerBg = const Color(0xFF4C1D95).withOpacity(0.95);
        bannerBorder = const Color(0xFF8B5CF6);
        iconColor = const Color(0xFFD8B4FE);
        buttonBg = const Color(0xFF8B5CF6);
        buttonFg = Colors.white;
        break;
      case AppColorPalette.whitePearl:
        bannerBg = const Color(0xFF0F766E).withOpacity(0.95);
        bannerBorder = const Color(0xFF14B8A6);
        iconColor = const Color(0xFFA7F3D0);
        buttonBg = const Color(0xFF14B8A6);
        buttonFg = Colors.white;
        break;
      case AppColorPalette.sunsetAmber:
        bannerBg = const Color(0xFF7C2D12).withOpacity(0.95);
        bannerBorder = const Color(0xFFF97316);
        iconColor = const Color(0xFFFCD34D);
        buttonBg = const Color(0xFFF97316);
        buttonFg = Colors.white;
        break;
      case AppColorPalette.oceanBreeze:
        bannerBg = const Color(0xFF0C4A6E).withOpacity(0.95);
        bannerBorder = const Color(0xFF38BDF8);
        iconColor = const Color(0xFF7DD3FC);
        buttonBg = const Color(0xFF38BDF8);
        buttonFg = Colors.white;
        break;
      case AppColorPalette.lavenderDream:
        bannerBg = const Color(0xFF6D28D9).withOpacity(0.95);
        bannerBorder = const Color(0xFF8B5CF6);
        iconColor = const Color(0xFFD8B4FE);
        buttonBg = const Color(0xFF8B5CF6);
        buttonFg = Colors.white;
        break;
      case AppColorPalette.peachBlush:
        bannerBg = const Color(0xFF831843).withOpacity(0.95);
        bannerBorder = const Color(0xFFEC4899);
        iconColor = const Color(0xFFFBCFE8);
        buttonBg = const Color(0xFFEC4899);
        buttonFg = Colors.white;
        break;
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1050),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bannerBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: bannerBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: isWideScreen
            ? Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: iconColor.withOpacity(0.2), shape: BoxShape.circle),
                    child: Icon(Icons.shield_rounded, color: iconColor, size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Safe Haven: Confidential GBV & Crisis Support",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Facing domestic distress, abuse, or urgent crisis? Report anonymously or request private support.",
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBg,
                      foregroundColor: buttonFg,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SafeHavenCrisisScreen()));
                    },
                    child: const Text("Get Help / Report", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  IconButton(
                    tooltip: "Quick Safe Exit",
                    icon: const Icon(Icons.close_rounded, color: Colors.white60, size: 20),
                    onPressed: _quickCrisisExit,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: iconColor.withOpacity(0.2), shape: BoxShape.circle),
                        child: Icon(Icons.shield_rounded, color: iconColor, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "Safe Haven: Confidential Crisis Support",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.5),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: "Quick Exit",
                        icon: const Icon(Icons.close_rounded, color: Colors.white60, size: 18),
                        onPressed: _quickCrisisExit,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Facing domestic distress or abuse? Report 100% anonymously.",
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBg,
                        foregroundColor: buttonFg,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SafeHavenCrisisScreen()));
                      },
                      child: const Text("Get Confidential Help", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ===========================================================================
  // 4. REUNION SCHEDULE & TICKET STATUS
  // ===========================================================================
  Widget _buildReunionScheduleBar(
    BuildContext context,
    bool isWideScreen,
    bool isDark,
    Color brandColor,
    Color onSurfaceColor,
    Color cardColor,
    Color borderColor,
  ) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1050),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: isWideScreen
            ? Row(
                children: [
                  _eventPill("DAY 1", "Roots & Arrival", "Registration & Welcome", brandColor, onSurfaceColor),
                  const SizedBox(width: 20),
                  _eventPill("DAY 2", "The Grand Kgotla", "AGM, Voting & Youth Forum", brandColor, onSurfaceColor),
                  const SizedBox(width: 20),
                  _eventPill("DAY 3", "Celebration", "Traditional Feast & Photos", brandColor, onSurfaceColor),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: brandColor, foregroundColor: isDark ? Colors.black : Colors.white),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ReunionKgotlaScreen()));
                    },
                    icon: const Icon(Icons.event_available_rounded, size: 16),
                    label: const Text("Reunion Program", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            : Column(
                children: [
                  _eventPill("DAY 1", "Roots & Arrival", "Registration & Welcome", brandColor, onSurfaceColor),
                  Divider(height: 14, color: borderColor),
                  _eventPill("DAY 2", "The Grand Kgotla", "AGM, Voting & Youth Forum", brandColor, onSurfaceColor),
                  Divider(height: 14, color: borderColor),
                  _eventPill("DAY 3", "Celebration", "Traditional Feast & Photos", brandColor, onSurfaceColor),
                ],
              ),
      ),
    );
  }

  Widget _eventPill(String tag, String title, String sub, Color brandColor, Color onSurfaceColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: brandColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
          child: Text(tag, style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11)),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: onSurfaceColor)),
            Text(sub, style: TextStyle(fontSize: 10.5, color: onSurfaceColor.withOpacity(0.6))),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // 5. THE 6 LEKGOTLA HUBS
  // ===========================================================================
  Widget _buildPillarsGrid(
    BuildContext context,
    bool isWideScreen,
    bool isDark,
    Color brandColor,
    Color onSurfaceColor,
    Color cardColor,
    Color borderColor,
  ) {
    final List<Map<String, dynamic>> hubs = [
      {
        "title": "Yaga Pre-Loved Market",
        "desc": "Buy, sell, or gift pre-loved fashion, shoes, and home goods within the family safely.",
        "icon": Icons.storefront_rounded,
        "badge": "YAGA-STYLE",
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const YagaMarketplaceScreen()));
        },
      },
      {
        "title": "Family Professions & Skills",
        "desc": "Hire Makhetha contractors, doctors, tutors, and accountants. Check who volunteers free advice!",
        "icon": Icons.business_center_rounded,
        "badge": "VOLUNTEER / PAID",
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MakhethaProfessionsScreen()));
        },
      },
      {
        "title": "SafeTrade Escrow Wallet",
        "desc": "Lock funds safely when doing business with relatives. Released only upon full satisfaction.",
        "icon": Icons.shield_rounded,
        "badge": "ZERO CONFLICT",
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ClanEscrowWalletScreen()));
        },
      },
      {
        "title": "Mokotla wa Matshediso",
        "desc": "Reunion dues, bereavement emergency shield, and the Makhetha Youth Education Trust.",
        "icon": Icons.volunteer_activism_rounded,
        "badge": "BENEVOLENCE",
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ClanContributionsScreen()));
        },
      },
      {
        "title": "Family Lineage & Tracer",
        "desc": "Trace separated branches, missing kinsmen, clan praises (Lithoko), and lost & found heirlooms.",
        "icon": Icons.family_restroom_rounded,
        "badge": "KOENA HERITAGE",
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const FamilyTracerScreen()));
        },
      },
      {
        "title": "The Clan Vault & Minutes",
        "desc": "Official reunion meeting minutes, resolutions, and video archives of past speeches.",
        "icon": Icons.video_library_rounded,
        "badge": "ARCHIVES",
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ClanVaultScreen()));
        },
      },
    ];

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1050),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "LEKGOTLA CLAN PILLARS",
              style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2),
            ),
            const SizedBox(height: 4),
            Text(
              "Empowering Every Makhetha Branch",
              style: GoogleFonts.montserrat(fontSize: isWideScreen ? 22 : 18, fontWeight: FontWeight.bold, color: onSurfaceColor),
            ),
            const SizedBox(height: 14),
            isWideScreen
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: hubs.length,
                    itemBuilder: (ctx, i) => _buildHubCard(hubs[i], brandColor, onSurfaceColor, cardColor, borderColor),
                  )
                : Column(
                    children: hubs
                        .map((h) => Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: _buildHubCard(h, brandColor, onSurfaceColor, cardColor, borderColor),
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHubCard(Map<String, dynamic> data, Color brandColor, Color onSurfaceColor, Color cardColor, Color borderColor) {
    return InkWell(
      onTap: data['onTap'] as VoidCallback,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
                Icon(data['icon'] as IconData, color: brandColor, size: 24),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: brandColor.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                  child: Text(data['badge'], style: TextStyle(color: brandColor, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(data['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: onSurfaceColor)),
            const SizedBox(height: 4),
            Text(data['desc'], style: TextStyle(fontSize: 11, color: onSurfaceColor.withOpacity(0.65), height: 1.35)),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 6. YAGA MARKETPLACE SPOTLIGHT
  // ===========================================================================
  Widget _buildYagaMarketplaceSpotlight(
    BuildContext context,
    bool isWideScreen,
    bool isDark,
    Color brandColor,
    Color onSurfaceColor,
    Color cardColor,
    Color borderColor,
  ) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1050),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  decoration: BoxDecoration(color: const Color(0xFFEC4899).withOpacity(0.12), shape: BoxShape.circle),
                  child: const Icon(Icons.checkroom_rounded, color: Color(0xFFEC4899), size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  "MAKHETHA CLOSET & MARKET (YAGA-STYLE)",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: brandColor, letterSpacing: 0.8),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC4899),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const YagaMarketplaceScreen()));
                  },
                  icon: const Icon(Icons.add_a_photo_rounded, size: 14),
                  label: const Text("Open Closet Market", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Circular Economy: Pre-Loved Fashion & Family Gifting",
              style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: onSurfaceColor),
            ),
            const SizedBox(height: 4),
            Text(
              "Pass down gently used clothes, designer pieces, kids' school uniforms, and home appliances safely within the family. Funds are held in Escrow until delivery.",
              style: TextStyle(color: onSurfaceColor.withOpacity(0.68), fontSize: 12, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 7. SAFETRADE ESCROW WALLET
  // ===========================================================================
  Widget _buildEscrowWalletSection(
    BuildContext context,
    bool isWideScreen,
    bool isDark,
    Color brandColor,
  ) {
    final currentPalette = ThemeService().currentPalette.value;

    List<Color> walletGradient;
    Color pillColor;
    Color buttonBg;
    Color buttonFg;

    switch (currentPalette) {
      case AppColorPalette.heritageGold:
        walletGradient = [const Color(0xFF451A03), const Color(0xFF78350F)];
        pillColor = const Color(0xFFFDE68A);
        buttonBg = const Color(0xFFF59E0B);
        buttonFg = Colors.black;
        break;
      case AppColorPalette.roseGrace:
        walletGradient = [const Color(0xFF4C0519), const Color(0xFF881337)];
        pillColor = const Color(0xFFFCE7F3);
        buttonBg = Colors.white;
        buttonFg = const Color(0xFF881337);
        break;
      case AppColorPalette.darkObsidian:
        walletGradient = [const Color(0xFF1E293B), const Color(0xFF0F172A)];
        pillColor = const Color(0xFFF59E0B);
        buttonBg = const Color(0xFFF59E0B);
        buttonFg = Colors.black;
        break;
      case AppColorPalette.africanEmerald:
        walletGradient = [const Color(0xFF064E3B), const Color(0xFF065F46)];
        pillColor = const Color(0xFFA7F3D0);
        buttonBg = Colors.white;
        buttonFg = const Color(0xFF064E3B);
        break;
      case AppColorPalette.sapphireBlue:
        walletGradient = [const Color(0xFF1E3A8A), const Color(0xFF1E40AF)];
        pillColor = const Color(0xFF93C5FD);
        buttonBg = Colors.white;
        buttonFg = const Color(0xFF1E3A8A);
        break;
      case AppColorPalette.forestWhisper:
        walletGradient = [const Color(0xFF4C1D95), const Color(0xFF5B21B6)];
        pillColor = const Color(0xFFDDD6FE);
        buttonBg = Colors.white;
        buttonFg = const Color(0xFF4C1D95);
        break;
      case AppColorPalette.whitePearl:
        walletGradient = [const Color(0xFF0F766E), const Color(0xFF115E59)];
        pillColor = const Color(0xFFCCFBF1);
        buttonBg = Colors.white;
        buttonFg = const Color(0xFF0F766E);
        break;
      case AppColorPalette.sunsetAmber:
        walletGradient = [const Color(0xFF7C2D12), const Color(0xFF9A3412)];
        pillColor = const Color(0xFFFED7AA);
        buttonBg = Colors.white;
        buttonFg = const Color(0xFF7C2D12);
        break;
      case AppColorPalette.oceanBreeze:
        walletGradient = [const Color(0xFF0C4A6E), const Color(0xFF0369A1)];
        pillColor = const Color(0xFFBAE6FD);
        buttonBg = Colors.white;
        buttonFg = const Color(0xFF0C4A6E);
        break;
      case AppColorPalette.lavenderDream:
        walletGradient = [const Color(0xFF581C87), const Color(0xFF6B21A8)];
        pillColor = const Color(0xFFE9D5FF);
        buttonBg = Colors.white;
        buttonFg = const Color(0xFF581C87);
        break;
      case AppColorPalette.peachBlush:
        walletGradient = [const Color(0xFF831843), const Color(0xFF9D174D)];
        pillColor = const Color(0xFFFBCFE8);
        buttonBg = Colors.white;
        buttonFg = const Color(0xFF831843);
        break;
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1050),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: walletGradient),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isWideScreen
            ? Row(
                children: [
                  Expanded(child: _walletText(pillColor)),
                  const SizedBox(width: 24),
                  _walletButton(context, buttonBg, buttonFg),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _walletText(pillColor),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: _walletButton(context, buttonBg, buttonFg),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _walletText(Color pillColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ZERO CONFLICT • SAFE CLAN ESCROW",
          style: TextStyle(
            color: pillColor,
            fontWeight: FontWeight.bold,
            fontSize: 10,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Protecting Family Relationships & Money",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        const Text(
          "Doing business with relatives? Buyer locks funds in Escrow. Seller delivers. Buyer inspects and releases payment. If disputes arise, the Elder Council arbitrates peaceably.",
          style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
        ),
      ],
    );
  }

  Widget _walletButton(BuildContext context, Color buttonBg, Color buttonFg) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonBg,
        foregroundColor: buttonFg,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ClanEscrowWalletScreen()),
        );
      },
      icon: const Icon(Icons.account_balance_wallet_rounded, size: 18),
      label: const Text(
        "Open SafeTrade Wallet",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // ===========================================================================
  // 8. DEEP CLAN FOOTER
  // ===========================================================================
  Widget _buildClanFooter(
    BuildContext context,
    bool isWideScreen,
    bool isDark,
    Color brandColor,
    double bottomPadding,
  ) {
    final currentPalette = ThemeService().currentPalette.value;

    Color footerBg;
    Color footerAccent;

    switch (currentPalette) {
      case AppColorPalette.heritageGold:
        footerBg = const Color(0xFF1C1309);
        footerAccent = const Color(0xFFFDE68A);
        break;
      case AppColorPalette.roseGrace:
        footerBg = const Color(0xFF2E0814);
        footerAccent = const Color(0xFFFCE7F3);
        break;
      case AppColorPalette.darkObsidian:
        footerBg = const Color(0xFF030712);
        footerAccent = const Color(0xFFF59E0B);
        break;
      case AppColorPalette.africanEmerald:
        footerBg = const Color(0xFF022C22);
        footerAccent = const Color(0xFFA7F3D0);
        break;
      case AppColorPalette.sapphireBlue:
        footerBg = const Color(0xFF0A192F);
        footerAccent = const Color(0xFF93C5FD);
        break;
      case AppColorPalette.forestWhisper:
        footerBg = const Color(0xFF1E1B4B);
        footerAccent = const Color(0xFFDDD6FE);
        break;
      case AppColorPalette.whitePearl:
        footerBg = const Color(0xFF042F2E);
        footerAccent = const Color(0xFFCCFBF1);
        break;
      case AppColorPalette.sunsetAmber:
        footerBg = const Color(0xFF2C1A0D);
        footerAccent = const Color(0xFFFED7AA);
        break;
      case AppColorPalette.oceanBreeze:
        footerBg = const Color(0xFF082F49);
        footerAccent = const Color(0xFFBAE6FD);
        break;
      case AppColorPalette.lavenderDream:
        footerBg = const Color(0xFF2A1E3C);
        footerAccent = const Color(0xFFE9D5FF);
        break;
      case AppColorPalette.peachBlush:
        footerBg = const Color(0xFF3B071E);
        footerAccent = const Color(0xFFFBCFE8);
        break;
    }

    return Container(
      width: double.infinity,
      color: footerBg,
      padding: EdgeInsets.only(
        left: isWideScreen ? 60 : 20,
        right: isWideScreen ? 60 : 20,
        top: 30,
        bottom: bottomPadding + 24,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () => _openWhatsApp("Hello Makhetha Council"), icon: const Icon(Icons.chat_bubble_rounded, color: Colors.white70)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.email_rounded, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("🐊 ", style: TextStyle(fontSize: 16)),
              Text(
                "Lekgotla la Makhetha • Bakoena Heritage",
                style: TextStyle(color: footerAccent, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "“Kopano ke Matla” • Free State • Lesotho • Gauteng • KZN • Diaspora",
            style: TextStyle(color: Colors.white60, fontSize: 10.5),
          ),
          const SizedBox(height: 14),

          // Council Executive Portal Button
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClanAdminDashboardScreen()),
              );
            },
            icon: Icon(Icons.admin_panel_settings_rounded, size: 16, color: footerAccent),
            label: Text(
              "Lekgotla la Baholo • Elder Council Portal",
              style: TextStyle(
                color: footerAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 📍 3. COMPREHENSIVE SIDEBAR MENU (EVERY ACTION, BUTTON & PORTAL)
  // ===========================================================================
  Widget _buildOrganizedSidebar(
    BuildContext context,
    Color brandColor,
    Color onSurfaceColor,
    Color cardColor,
    Color borderColor,
  ) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [brandColor.withOpacity(0.85), brandColor],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Text("🐊", style: TextStyle(fontSize: 26)),
                      const SizedBox(width: 8),
                      Text(
                        "BAKOENA",
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text("Lekgotla la Makhetha • Global Council", style: TextStyle(color: Colors.white70, fontSize: 11)),
                  Text(
                    "Branch: $_selectedBranch",
                    style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // --- 1. SETTINGS & PREFERENCES ---
            _sidebarHeader("SETTINGS & PREFERENCES", brandColor),
            ListTile(
              dense: true,
              leading: Icon(Icons.palette_rounded, color: brandColor, size: 20),
              title: Text("Change Theme Palette", style: TextStyle(color: onSurfaceColor, fontSize: 12.5, fontWeight: FontWeight.bold)),
              subtitle: Text(
                ThemeService.getPaletteName(ThemeService().currentPalette.value),
                style: TextStyle(fontSize: 10.5, color: onSurfaceColor.withOpacity(0.6)),
              ),
              onTap: () {
                Navigator.pop(context);
                _showPalettePicker(context);
              },
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.location_on_rounded, color: brandColor, size: 20),
              title: Text("Active Family Branch", style: TextStyle(color: onSurfaceColor, fontSize: 12.5, fontWeight: FontWeight.bold)),
              subtitle: Text(_selectedBranch, style: TextStyle(fontSize: 10.5, color: onSurfaceColor.withOpacity(0.6))),
              trailing: const Icon(Icons.arrow_drop_down_rounded),
              onTap: () {
                Navigator.pop(context);
                _showBranchPickerDialog(context, cardColor, borderColor, brandColor, onSurfaceColor);
              },
            ),
            const Divider(),

            // --- 2. GOVERNANCE & REUNION 2027 ---
            _sidebarHeader("GOVERNANCE & REUNION 2027", brandColor),
            _sidebarTile(
              Icons.people_alt_rounded,
              "Elected Committee (2026–2028)",
              "Port Elizabeth Host & Executive Council",
              () => const ClanCommitteeScreen(),
              context,
              onSurfaceColor,
            ),
            _sidebarTile(
              Icons.confirmation_number_rounded,
              "Get Reunion Tickets & Passes",
              "Adult, student & child passes for 24 Sept 2027",
              () => const ReunionKgotlaScreen(),
              context,
              onSurfaceColor,
            ),
            _sidebarTile(
              Icons.how_to_vote_rounded,
              "Submit Reunion Topics & Voting",
              "Table family issues & upvote the Kgotla agenda",
              () => const ReunionKgotlaScreen(),
              context,
              onSurfaceColor,
            ),
            _sidebarTile(
              Icons.video_library_rounded,
              "The Clan Vault & Minutes",
              "Official AGM resolutions, documents & speech videos",
              () => const ClanVaultScreen(),
              context,
              onSurfaceColor,
            ),
            const Divider(),

            // --- 3. COMMERCE & TRADES ---
            _sidebarHeader("COMMERCE, FASHION & TRADES", brandColor),
            _sidebarTile(
              Icons.storefront_rounded,
              "Yaga Pre-Loved Closet & Market",
              "Shop blankets, clothes & goods with PUDO/Paxi",
              () => const YagaMarketplaceScreen(),
              context,
              onSurfaceColor,
            ),
            _sidebarTile(
              Icons.business_center_rounded,
              "Makhetha Professions & Trades",
              "Hire family doctors, lawyers, tutors & plumbers",
              () => const MakhethaProfessionsScreen(),
              context,
              onSurfaceColor,
            ),
            _sidebarTile(
              Icons.shield_rounded,
              "SafeTrade Escrow Wallet",
              "Protected payments & zero family debt dispute",
              () => const ClanEscrowWalletScreen(),
              context,
              onSurfaceColor,
            ),
            const Divider(),

            // --- 4. HERITAGE & SOLIDARITY ---
            _sidebarHeader("HERITAGE & SOLIDARITY", brandColor),
            _sidebarTile(
              Icons.family_restroom_rounded,
              "Family Lineage & Bakoena Roots",
              "Ancestral praises (Lithoko) & Koena crocodile totem",
              () => const FamilyTracerScreen(),
              context,
              onSurfaceColor,
            ),
            _sidebarTile(
              Icons.person_search_rounded,
              "Kinship Tracer (Missing Relatives)",
              "Search & reconnect with separated branches",
              () => const FamilyTracerScreen(),
              context,
              onSurfaceColor,
            ),
            _sidebarTile(
              Icons.inventory_2_rounded,
              "Reunion Lost & Found Vault",
              "Report or claim misplaced heirlooms & items",
              () => const FamilyTracerScreen(),
              context,
              onSurfaceColor,
            ),
            _sidebarTile(
              Icons.volunteer_activism_rounded,
              "Mokotla wa Matshediso & Funds",
              "Reunion dues, bereavement shield & bursary trust",
              () => const ClanContributionsScreen(),
              context,
              onSurfaceColor,
            ),
            _sidebarTile(
              Icons.gpp_maybe_rounded,
              "Safe Haven: GBV & Crisis Support",
              "100% confidential, anonymous help & direct hotlines",
              () => const SafeHavenCrisisScreen(),
              context,
              const Color(0xFFF43F5E),
            ),
            const Divider(),

            // --- 5. CONNECT WITH THE CLAN ---
            _sidebarHeader("CONNECT WITH THE CLAN", brandColor),
            ListTile(
              dense: true,
              leading: const Icon(Icons.chat_bubble_rounded, color: Color(0xFF16A34A), size: 20),
              title: Text("WhatsApp Council Secretariat",
                  style: TextStyle(color: onSurfaceColor, fontSize: 12.5, fontWeight: FontWeight.bold)),
              subtitle: Text("General clan inquiries & notices",
                  style: TextStyle(fontSize: 10.5, color: onSurfaceColor.withOpacity(0.6))),
              onTap: () {
                Navigator.pop(context);
                _openWhatsApp("Greetings Makhetha Council Secretariat! I am contacting you regarding: ");
              },
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.person_add_rounded, color: brandColor, size: 20),
              title: Text("Register / Join Household",
                  style: TextStyle(color: onSurfaceColor, fontSize: 12.5, fontWeight: FontWeight.bold)),
              subtitle: Text("Register your family branch on the roll",
                  style: TextStyle(fontSize: 10.5, color: onSurfaceColor.withOpacity(0.6))),
              onTap: () {
                Navigator.pop(context);
                _openWhatsApp("Greetings Makhetha Council! I would like to register our household under the $_selectedBranch.");
              },
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.power_settings_new_rounded, color: Color(0xFFDC2626), size: 20),
              title: const Text("Emergency Quick Exit",
                  style: TextStyle(color: Color(0xFFDC2626), fontSize: 12.5, fontWeight: FontWeight.bold)),
              subtitle: const Text("Instantly exits app to Google for crisis safety",
                  style: TextStyle(fontSize: 10.5, color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _quickCrisisExit();
              },
            ),
            const Divider(),

            // --- 6. ADMINISTRATION ---
            _sidebarHeader("COUNCIL ADMINISTRATION", brandColor),
            ListTile(
              dense: true,
              leading: Icon(Icons.admin_panel_settings_rounded, color: brandColor, size: 20),
              title: Text(
                "Lekgotla la Baholo (PIN: 2027)",
                style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
              subtitle: Text("Council Chamber & Verification Desk",
                  style: TextStyle(fontSize: 10.5, color: onSurfaceColor.withOpacity(0.6))),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ClanAdminDashboardScreen()));
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sidebarHeader(String label, Color brandColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
      child: Text(
        label,
        style: TextStyle(color: brandColor, fontSize: 9.5, fontWeight: FontWeight.w900, letterSpacing: 1.1),
      ),
    );
  }

  Widget _sidebarTile(
    IconData icon,
    String title,
    String subtitle,
    Widget Function() target,
    BuildContext context,
    Color textColor,
  ) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: textColor, size: 20),
      title: Text(title, style: TextStyle(color: textColor, fontSize: 12.5, fontWeight: FontWeight.bold)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: textColor.withOpacity(0.65), fontSize: 10.5),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(Icons.chevron_right_rounded, size: 16, color: textColor.withOpacity(0.4)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => target()));
      },
    );
  }

  void _showBranchPickerDialog(
    BuildContext context,
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor),
        ),
        title: Text(
          "Select Your Family Branch",
          style: TextStyle(color: onSurfaceColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: _familyBranches.map((branch) {
              final isSel = _selectedBranch == branch;
              return ListTile(
                leading: Icon(
                  isSel ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                  color: isSel ? brandColor : onSurfaceColor.withOpacity(0.4),
                  size: 18,
                ),
                title: Text(
                  branch,
                  style: TextStyle(
                    color: onSurfaceColor,
                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
                onTap: () {
                  setState(() => _selectedBranch = branch);
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}