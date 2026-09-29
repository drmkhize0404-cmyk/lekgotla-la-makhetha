import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ShippingMethod {
  final String name;
  final double fee;
  final String timeline;
  final IconData icon;

  const ShippingMethod(this.name, this.fee, this.timeline, this.icon);
}

class MarketplaceItem {
  final String id;
  final String title;
  final String category;
  final String condition;
  final double price; // 0.0 means Free Family Gift
  final String sellerName;
  final String branchLocation;
  final String phone;
  final String imageUrl;
  final String description;
  String status; // "AVAILABLE", "LOCKED_IN_ESCROW", "SHIPPED", "COMPLETED"
  String? trackingCode;
  String? selectedCourier;

  MarketplaceItem({
    required this.id,
    required this.title,
    required this.category,
    required this.condition,
    required this.price,
    required this.sellerName,
    required this.branchLocation,
    required this.phone,
    required this.imageUrl,
    required this.description,
    this.status = "AVAILABLE",
    this.trackingCode,
    this.selectedCourier,
  });

  bool get isFreeGift => price <= 0.0;
}

class YagaMarketplaceScreen extends StatefulWidget {
  const YagaMarketplaceScreen({super.key});

  @override
  State<YagaMarketplaceScreen> createState() => _YagaMarketplaceScreenState();
}

class _YagaMarketplaceScreenState extends State<YagaMarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = "";
  String _selectedCategory = "All";
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    "All",
    "Traditional & Seanamarena",
    "Women's Fashion",
    "Men's Attire",
    "Kids & Baby Wear",
    "Electronics & Appliances",
    "Free Family Gifts",
  ];

  static const List<ShippingMethod> _courierOptions = [
    ShippingMethod("PUDO Locker-to-Locker", 60.0, "2 - 4 Business Days", Icons.lock_clock_rounded),
    ShippingMethod("Paxi (PEP to PEP Collection)", 59.0, "7 - 9 Business Days", Icons.store_rounded),
    ShippingMethod("The Courier Guy (Door-to-Door)", 95.0, "1 - 3 Business Days", Icons.local_shipping_rounded),
    ShippingMethod("Reunion 2027 In-Person Handover", 0.0, "At Port Elizabeth Gathering", Icons.handshake_rounded),
  ];

  final List<MarketplaceItem> _items = [
    MarketplaceItem(
      id: "YAG-01",
      title: "Authentic Seanamarena Basotho Heritage Blanket",
      category: "Traditional & Seanamarena",
      condition: "Like New (Worn Once)",
      price: 950.0,
      sellerName: "Ausi Lerato Makhetha",
      branchLocation: "Free State Branch",
      phone: "27821234567",
      imageUrl: "https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?q=80&w=800",
      description: "Original pure wool Seanamarena blanket worn once during family celebration. Ready for courier shipping.",
      status: "AVAILABLE",
    ),
    MarketplaceItem(
      id: "YAG-02",
      title: "Kids' Winter School Blazer & Grey Trousers (Size 7-8)",
      category: "Kids & Baby Wear",
      condition: "Gently Loved",
      price: 0.0,
      sellerName: "Mme Thandi Makhetha",
      branchLocation: "Gauteng Branch",
      phone: "27829988776",
      imageUrl: "https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?q=80&w=800",
      description: "Giving away free to any nephew or family member who needs it for school.",
      status: "AVAILABLE",
    ),
    MarketplaceItem(
      id: "YAG-03",
      title: "Zara Men's Formal Camel Overcoat (Size L)",
      category: "Men's Attire",
      condition: "Brand New (With Tags)",
      price: 750.0,
      sellerName: "Abuti Tshepo Makhetha",
      branchLocation: "Port Elizabeth Branch",
      phone: "27834449911",
      imageUrl: "https://images.unsplash.com/photo-1544923246-77307dd654cb?q=80&w=800",
      description: "Brand new ordered online. Courier nationwide via PUDO or Paxi.",
      status: "SHIPPED",
      trackingCode: "PUDO-8841-KZN",
      selectedCourier: "PUDO Locker-to-Locker",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
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

  // 📍 YAGA CHECKOUT & ESCROW ORDER MODAL
  void _startBuyerCheckoutModal(BuildContext context, MarketplaceItem item) {
    ShippingMethod selectedShipping = _courierOptions.first;
    final addressC = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setCheckoutState) {
          final totalToLock = item.price + selectedShipping.fee;

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_rounded, color: Color(0xFF10B981), size: 22),
                      const SizedBox(width: 8),
                      Text("Yaga-Protected Escrow Checkout",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Item: ${item.title} • Sold by ${item.sellerName}",
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  const Divider(height: 24),

                  const Text("1. Select Delivery & Logistics Method:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                  const SizedBox(height: 8),

                  ..._courierOptions.map((opt) {
                    final isSel = selectedShipping.name == opt.name;
                    return InkWell(
                      onTap: () => setCheckoutState(() => selectedShipping = opt),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSel ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSel ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(opt.icon, size: 18, color: isSel ? Theme.of(context).colorScheme.primary : Colors.grey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(opt.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  Text(opt.timeline, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                            Text(
                              opt.fee == 0.0 ? "FREE" : "R ${opt.fee.toStringAsFixed(0)}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 10),

                  TextField(
                    controller: addressC,
                    decoration: const InputDecoration(
                      labelText: "Your Locker Code, PEP Store, or Delivery Address *",
                      hintText: "e.g. PUDO Locker at Shell Northdale or PEP Gqeberha",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Escrow Totals Breakdown
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Item Price:"),
                            Text("R ${item.price.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Logistics (${selectedShipping.name}):"),
                            Text("R ${selectedShipping.fee.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Locked in Escrow:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("R ${totalToLock.toStringAsFixed(2)}",
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Theme.of(context).colorScheme.primary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          item.status = "LOCKED_IN_ESCROW";
                          item.selectedCourier = selectedShipping.name;
                        });
                        Navigator.pop(ctx);

                        final String buyMsg = """
🐊 *LEKGOTLA LA MAKHETHA • YAGA PURCHASE ORDER*
Item: ${item.title}
Seller: ${item.sellerName}
---------------------------------
💰 Item Price: R ${item.price.toStringAsFixed(2)}
🚚 Delivery (${selectedShipping.name}): R ${selectedShipping.fee.toStringAsFixed(2)}
🔒 Total Locked in Escrow: R ${totalToLock.toStringAsFixed(2)}
📍 Delivery Destination: ${addressC.text.trim()}
---------------------------------
Payment secured in Makhetha Escrow. Please dispatch parcel and provide waybill tracking code!
""";
                        _launchExternal("https://wa.me/${item.phone}?text=${Uri.encodeComponent(buyMsg)}");
                      },
                      icon: const Icon(Icons.lock_rounded, size: 16),
                      label: const Text("Lock Funds & Notify Seller"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 📍 DISPATCH & TRACKING ENTRY (Seller side)
  void _showEnterTrackingModal(BuildContext context, MarketplaceItem item) {
    final codeC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Enter Courier Tracking Code"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Provide the PUDO, Paxi, or Aramex waybill number so the buyer can track delivery:"),
            const SizedBox(height: 12),
            TextField(
              controller: codeC,
              decoration: const InputDecoration(labelText: "Tracking / Locker Pin *", border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (codeC.text.isNotEmpty) {
                setState(() {
                  item.status = "SHIPPED";
                  item.trackingCode = codeC.text.trim();
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Tracking saved! Buyer alerted to collect parcel.")),
                );
              }
            },
            child: const Text("Save & Mark Shipped"),
          ),
        ],
      ),
    );
  }

  // 📍 CONFIRM RECEIPT & RELEASE MONEY (Buyer side)
  void _confirmReceiptAndRelease(MarketplaceItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Row(
          children: [
            Icon(Icons.verified_rounded, color: Color(0xFF10B981)),
            SizedBox(width: 8),
            Text("Release Escrow Payment?"),
          ],
        ),
        content: Text(
          "Have you collected and inspected '${item.title}'? Releasing funds will instantly transfer R ${item.price.toStringAsFixed(2)} to ${item.sellerName}'s wallet.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Not Yet")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                item.status = "COMPLETED";
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("🎉 Funds released to ${item.sellerName}! Transaction complete.")),
              );
            },
            child: const Text("Yes, Release Payout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final brandColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final cardColor = theme.cardColor;
    final borderColor = theme.dividerColor;

    final filtered = _items.where((it) {
      final matchesCat = _selectedCategory == "All" ||
          it.category == _selectedCategory ||
          (_selectedCategory == "Free Family Gifts" && it.isFreeGift);
      final q = _searchQuery.toLowerCase();
      return matchesCat &&
          (_searchQuery.isEmpty ||
              it.title.toLowerCase().contains(q) ||
              it.sellerName.toLowerCase().contains(q) ||
              it.description.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "MAKHETHA CLOSET & YAGA MARKET",
          style: GoogleFonts.montserrat(
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: onSurfaceColor,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFEC4899),
          labelColor: const Color(0xFFEC4899),
          unselectedLabelColor: onSurfaceColor.withOpacity(0.6),
          tabs: const [
            Tab(icon: Icon(Icons.storefront_rounded, size: 16), text: "Shop Pre-Loved & Gifts"),
            Tab(icon: Icon(Icons.local_shipping_rounded, size: 16), text: "Track Orders & Logistics"),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: TabBarView(
            controller: _tabController,
            children: [
              // TAB 1: SHOPPING
              Column(
                children: [
                  // Search & Filter Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          hintText: "Search Seanamarena blankets, blazers, shoes, baby items...",
                          hintStyle: TextStyle(color: onSurfaceColor.withOpacity(0.4), fontSize: 12),
                          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFEC4899), size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                        ),
                      ),
                    ),
                  ),

                  // Categories
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: _categories.map((cat) {
                        final isSel = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(cat),
                            selected: isSel,
                            onSelected: (_) => setState(() => _selectedCategory = cat),
                            backgroundColor: cardColor,
                            selectedColor: const Color(0xFFEC4899),
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              fontSize: 11,
                              color: isSel ? Colors.white : onSurfaceColor.withOpacity(0.7),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Product Grid
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 700 ? 3 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.60,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) => _buildProductCard(filtered[i], cardColor, borderColor, brandColor, onSurfaceColor, isDark),
                    ),
                  ),
                ],
              ),

              // TAB 2: LOGISTICS & ACTIVE ORDERS
              ListView(
                padding: const EdgeInsets.all(16),
                children: _items.where((i) => i.status != "AVAILABLE").map((item) {
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
                            Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                            const Spacer(),
                            Text("R ${item.price.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, color: brandColor)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text("Logistics: ${item.selectedCourier ?? 'Pending selection'}", style: TextStyle(fontSize: 11.5, color: brandColor)),
                        if (item.trackingCode != null)
                          Text("Waybill / Tracking: ${item.trackingCode}", style: const TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                        const Divider(height: 18),
                        Row(
                          children: [
                            Text("Status: ${item.status}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            if (item.status == "LOCKED_IN_ESCROW")
                              ElevatedButton(
                                onPressed: () => _showEnterTrackingModal(context, item),
                                child: const Text("Enter Waybill"),
                              ),
                            if (item.status == "SHIPPED")
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                                onPressed: () => _confirmReceiptAndRelease(item),
                                child: const Text("Confirm Receipt & Release"),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(MarketplaceItem item, Color cardColor, Color borderColor, Color brandColor, Color onSurfaceColor, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(item.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: item.isFreeGift ? const Color(0xFF10B981) : Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.isFreeGift ? "FREE GIFT 🎁" : item.condition,
                    style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5)),
                Text("${item.sellerName} • ${item.branchLocation}", style: TextStyle(fontSize: 9.5, color: brandColor)),
                const SizedBox(height: 6),
                Text(
                  item.isFreeGift ? "R 0.00" : "R ${item.price.toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: item.isFreeGift ? const Color(0xFF10B981) : const Color(0xFFEC4899)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEC4899), foregroundColor: Colors.white, padding: EdgeInsets.zero),
                    onPressed: () => _startBuyerCheckoutModal(context, item),
                    child: Text(item.isFreeGift ? "Claim Gift" : "Buy with Escrow", style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}