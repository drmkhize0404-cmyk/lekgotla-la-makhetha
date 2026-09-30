import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClanSettingsService extends ChangeNotifier {
  static final ClanSettingsService _instance = ClanSettingsService._internal();
  factory ClanSettingsService() => _instance;
  ClanSettingsService._internal();

  // 📍 Upcoming Reunion Settings (Admin Editable)
  String reunionLocation = "Gqeberha (Port Elizabeth), Eastern Cape";
  String reunionHostBranch = "Eastern Cape Host Branch (Port Elizabeth)";
  String reunionVenue = "Nelson Mandela Bay Multi-Purpose Hall & Beachfront Marquee";
  String reunionTheme = "Kopano le Kutlwano • Bakoena Reunited";
  DateTime reunionDate = DateTime(2027, 9, 24, 9, 0, 0);

  // 📍 Dynamic Ticket Prices (Admin Editable)
  double adultTicketPrice = 450.0;
  double youthTicketPrice = 200.0;
  double tShirtPrice = 180.0;
  double childTicketPrice = 0.0; // Free for kids under 12

  static const String _locKey = 'clan_reunion_location';
  static const String _hostKey = 'clan_reunion_host';
  static const String _venueKey = 'clan_reunion_venue';
  static const String _themeKey = 'clan_reunion_theme';
  static const String _dateKey = 'clan_reunion_date';
  static const String _adultPriceKey = 'clan_price_adult';
  static const String _youthPriceKey = 'clan_price_youth';
  static const String _tshirtPriceKey = 'clan_price_tshirt';

  Future<void> initSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      reunionLocation = prefs.getString(_locKey) ?? reunionLocation;
      reunionHostBranch = prefs.getString(_hostKey) ?? reunionHostBranch;
      reunionVenue = prefs.getString(_venueKey) ?? reunionVenue;
      reunionTheme = prefs.getString(_themeKey) ?? reunionTheme;
      adultTicketPrice = prefs.getDouble(_adultPriceKey) ?? adultTicketPrice;
      youthTicketPrice = prefs.getDouble(_youthPriceKey) ?? youthTicketPrice;
      tShirtPrice = prefs.getDouble(_tshirtPriceKey) ?? tShirtPrice;

      final savedDate = prefs.getString(_dateKey);
      if (savedDate != null) {
        reunionDate = DateTime.parse(savedDate);
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> updateReunionInfo({
    required String location,
    required String hostBranch,
    required String venue,
    required String theme,
    required DateTime date,
  }) async {
    reunionLocation = location;
    reunionHostBranch = hostBranch;
    reunionVenue = venue;
    reunionTheme = theme;
    reunionDate = date;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_locKey, location);
      await prefs.setString(_hostKey, hostBranch);
      await prefs.setString(_venueKey, venue);
      await prefs.setString(_themeKey, theme);
      await prefs.setString(_dateKey, date.toIso8601String());
    } catch (_) {}
  }

  // 📍 Admin Sets Ticket Prices
  Future<void> updateTicketPrices({
    required double adultPrice,
    required double youthPrice,
    required double tshirtPrice,
  }) async {
    adultTicketPrice = adultPrice;
    youthTicketPrice = youthPrice;
    tShirtPrice = tshirtPrice;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_adultPriceKey, adultPrice);
      await prefs.setDouble(_youthPriceKey, youthPrice);
      await prefs.setDouble(_tshirtPriceKey, tshirtPrice);
    } catch (_) {}
  }
}