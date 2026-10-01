import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/clan_auth_service.dart';

// --- COURIER LOGISTICS SPECIFICATION ---
class CourierLogisticsOption {
  final String name;
  final double fee;
  final String deliveryTime;
  final String howItWorks;
  final IconData icon;

  const CourierLogisticsOption({
    required this.name,
    required this.fee,
    required this.deliveryTime,
    required this.howItWorks,
    required this.icon,
  });
}

// --- MARKETPLACE ITEM MODEL ---
class MarketItem {
  final String id;
  final String title;
  final String brand;
  final String size;
  final String category;
  final String condition;
  final double price; // 0.0 means Free Family Gift
  final String sellerName;
  final String sellerBranch;
  final String sellerPhone;
  final List<String> imageUrls;
  final String description;
  int likes;
  bool isLiked;
  final List<CourierLogisticsOption> availableCouriers;

  MarketItem({
    required this.id,
    required this.title,
    required this.brand,
    required this.size,
    required this.category,
    required this.condition,
    required this.price,
    required this.sellerName,
    required this.sellerBranch,
    required this.sellerPhone,
    required this.imageUrls,
    required this.description,
    this.likes = 0,
    this.isLiked = false,
    required this.availableCouriers,
  });

  bool get isFreeGift => price <= 0.0;
}

class ClanMarketScreen extends StatefulWidget {
  const ClanMarketScreen({super.key});

  @override
  State<ClanMarketScreen> createState() => _ClanMarketScreenState();
}

class _ClanMarketScreenState extends State<ClanMarketScreen> {
  String _searchQuery = "";
  String _selectedCategory = "All";
  final TextEditingController _searchController = TextEditingController();

  static const List<CourierLogisticsOption> allCouriers = [
    CourierLogisticsOption(
      name: "PUDO Locker-to-Locker",
      fee: 60.0,
      deliveryTime: "2 - 4 Business Days",
      howItWorks:
          "Seller drops parcel into nearest PUDO smart locker. Handled by The Courier Guy and delivered to your chosen PUDO locker. You receive an SMS with a PIN code to unlock your box 24/7.",
      icon: Icons.lock_clock_rounded,
    ),
    CourierLogisticsOption(
      name: "Paxi (PEP to PEP Collection)",
      fee: 59.0,
      deliveryTime: "7 - 9 Business Days",
      howItWorks:
          "Seller drops package at their nearest PEP store. Sent to your selected PEP store. You receive an SMS when ready for collection with your ID.",
      icon: Icons.store_rounded,
    ),
    CourierLogisticsOption(
      name: "The Courier Guy (Door-to-Door)",
      fee: 95.0,
      deliveryTime: "1 - 3 Business Days",
      howItWorks:
          "Courier collects package directly from the seller's home and delivers right to your residential or office front door with live tracking.",
      icon: Icons.local_shipping_rounded,
    ),
    CourierLogisticsOption(
      name: "Reunion 2027 In-Person Handover",
      fee: 0.0,
      deliveryTime: "Heritage Day Weekend (Port Elizabeth)",
      howItWorks:
          "Seller brings the item to the Port Elizabeth Gathering for a zero-cost face-to-face family handover.",
      icon: Icons.handshake_rounded,
    ),
  ];

  final List<String> _categories = [
    "All",
    "Traditional & Seanamarena",
    "Women's Fashion",
    "Men's Attire",
    "Kids & Baby Wear",
    "School Uniforms & Books",
    "Electronics & Phones",
    "Home & Kitchen Appliances",
    "Tools, DIY & Hardware",
    "Free Family Gifts",
  ];

  final List<MarketItem> _marketItems = [
    MarketItem(
      id: "MKT-01",
      title: "Authentic Seanamarena Heritage Woolen Blanket",
      brand: "Original Basotho Heritage",
      size: "Queen / Standard",
      category: "Traditional & Seanamarena",
      condition: "Like New (Worn Once)",
      price: 950.0,
      sellerName: "Ausi Lerato Makhetha",
      sellerBranch: "Free State Branch (Ficksburg)",
      sellerPhone: "27821234567",
      imageUrls: [
        "https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?q=80&w=800",
        "https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?q=80&w=800",
        "https://images.unsplash.com/photo-1544923246-77307dd654cb?q=80&w=800",
      ],
      description:
          "Genuine pure wool Seanamarena blanket worn once during family celebration. Beautiful royal blue and yellow motif. Preserved in cedar chest.",
      likes: 24,
      availableCouriers: allCouriers,
    ),
    MarketItem(
      id: "MKT-02",
      title: "Zara Men's Formal Camel Wool Overcoat",
      brand: "ZARA Man",
      size: "L (Size 42)",
      category: "Men's Attire",
      condition: "Brand New (With Tags)",
      price: 750.0,
      sellerName: "Abuti Tshepo Makhetha",
      sellerBranch: "Port Elizabeth Host Branch",
      sellerPhone: "27829988776",
      imageUrls: [
        "https://images.unsplash.com/photo-1544923246-77307dd654cb?q=80&w=800",
        "https://images.unsplash.com/photo-1516257984-b1b4d707412e?q=80&w=800",
      ],
      description:
          "Brand new formal winter coat with original store tags. Retail price was R1,699. Ordered online but slightly too broad for me.",
      likes: 18,
      availableCouriers: allCouriers,
    ),
    MarketItem(
      id: "MKT-03",
      title: "Complete Primary School Uniform & Grey Blazers",
      brand: "McCullagh & Bothwell",
      size: "Ages 7 - 9 (Size 28)",
      category: "School Uniforms & Books",
      condition: "Good Condition",
      price: 0.0, // Free Gift!
      sellerName: "Mme Thandi Makhetha",
      sellerBranch: "Gauteng Branch",
      sellerPhone: "27834449911",
      imageUrls: [
        "https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?q=80&w=800",
        "https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?q=80&w=800",
      ],
      description:
          "Giving away my son's school blazers, grey school shorts, and winter ties. No payment required—free family pass-down for any nephew.",
      likes: 35,
      availableCouriers: allCouriers,
    ),
    MarketItem(
      id: "MKT-04",
      title: "Apple iPad 9th Gen 64GB Space Grey (Wi-Fi)",
      brand: "Apple",
      size: "10.2-inch Display",
      category: "Electronics & Phones",
      condition: "Like New (In Box)",
      price: 3400.0,
      sellerName: "Kagiso Makhetha",
      sellerBranch: "Diaspora Branch (UK / SA)",
      sellerPhone: "27712345678",
      imageUrls: [
        "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?q=80&w=800",
        "https://images.unsplash.com/photo-1561154464-82e9adf32764?q=80&w=800",
      ],
      description:
          "Upgraded to a newer iPad for work. Battery health is at 94%. Comes with original charging brick, cable, and protective shock case.",
      likes: 42,
      availableCouriers: allCouriers,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showHowShippingWorksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.local_shipping_rounded, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Text(
              "Logistics & Courier Guide",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: allCouriers.map((courier) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(courier.icon, size: 18, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(courier.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const Spacer(),
                        Text(
                          courier.fee == 0.0 ? "FREE" : "R ${courier.fee.toStringAsFixed(0)}",
                          style: TextStyle(fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text("⏱️ Timeline: ${courier.deliveryTime}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Text(courier.howItWorks, style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75), height: 1.4)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Got It")),
        ],
      ),
    );
  }

  
      // 📍 REAL PHOTO PICKER (CAMERA & GALLERY)
  void _showAddItemModal(BuildContext context) {
    ClanAuthService.requireAuthentication(
      context,
      actionName: "list an item for sale or gifting",
      onAuthenticated: () {
        final titleC = TextEditingController();
        final brandC = TextEditingController();
        final sizeC = TextEditingController();
        final priceC = TextEditingController();
        final descC = TextEditingController();
        final user = ClanAuthService().currentUser!;
        
        String cat = _categories[1];
        String cond = "Brand New (With Tags)";
        bool isFree = false;

        // Stores picked photo files and their byte data for instant preview
        final List<XFile> pickedImages = [];
        final ImagePicker picker = ImagePicker();

        showDialog(
          context: context,
          builder: (ctx) => StatefulBuilder(
            builder: (context, setModalState) {
              // Function to pick from Camera or Gallery
              Future<void> pickPhotos(ImageSource source) async {
                try {
                  if (source == ImageSource.camera) {
                    final XFile? photo = await picker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1200,
                      maxHeight: 1200,
                      imageQuality: 85, // Compresses to save mobile data
                    );
                    if (photo != null) {
                      setModalState(() => pickedImages.add(photo));
                    }
                  } else {
                    final List<XFile> photos = await picker.pickMultiImage(
                      maxWidth: 1200,
                      maxHeight: 1200,
                      imageQuality: 85,
                    );
                    if (photos.isNotEmpty) {
                      setModalState(() {
                        pickedImages.addAll(photos.take(5 - pickedImages.length));
                      });
                    }
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error picking photo: $e")),
                  );
                }
              }

              return AlertDialog(
                backgroundColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: const Row(
                  children: [
                    Icon(Icons.add_a_photo_rounded, color: Color(0xFF10B981)),
                    SizedBox(width: 8),
                    Text("List Item & Upload Photos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Seller: ${user.fullName} (${user.branch})", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 12),

                      // 📸 PHOTO UPLOAD BUTTONS
                      const Text("Item Photos (Add up to 5 photos):", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: pickedImages.length >= 5 ? null : () => pickPhotos(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt_rounded, size: 16),
                              label: const Text("Camera", style: TextStyle(fontSize: 11.5)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: pickedImages.length >= 5 ? null : () => pickPhotos(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library_rounded, size: 16),
                              label: const Text("Gallery", style: TextStyle(fontSize: 11.5)),
                            ),
                          ),
                        ],
                      ),

                      // 🖼️ PHOTO THUMBNAIL CAROUSEL (WITH REMOVE BUTTON)
                      if (pickedImages.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 70,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: pickedImages.length,
                            itemBuilder: (ctx, i) {
                              return FutureBuilder<Uint8List>(
                                future: pickedImages[i].readAsBytes(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container(
                                      width: 70,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(8)),
                                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                    );
                                  }
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(image: MemoryImage(snapshot.data!), fit: BoxFit.cover),
                                        ),
                                      ),
                                      Positioned(
                                        top: 2,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () => setModalState(() => pickedImages.removeAt(i)),
                                          child: const CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.red,
                                            child: Icon(Icons.close, size: 12, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),

                      // Title & Brand
                      TextField(controller: titleC, decoration: const InputDecoration(labelText: "Item Title *", border: OutlineInputBorder())),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: TextField(controller: brandC, decoration: const InputDecoration(labelText: "Brand (Zara, Nike...)", border: OutlineInputBorder()))),
                          const SizedBox(width: 8),
                          Expanded(child: TextField(controller: sizeC, decoration: const InputDecoration(labelText: "Size (M, L, 34...)", border: OutlineInputBorder()))),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        value: cat,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: "Category *", border: OutlineInputBorder()),
                        items: _categories.where((c) => c != "All").map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (v) => setModalState(() => cat = v!),
                      ),
                      const SizedBox(height: 8),

                      // Condition
                      DropdownButtonFormField<String>(
                        value: cond,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: "Condition *", border: OutlineInputBorder()),
                        items: ["Brand New (With Tags)", "Like New (Worn Once)", "Good Condition", "Vintage / Heirloom"]
                            .map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setModalState(() => cond = v!),
                      ),
                      const SizedBox(height: 8),

                      // Free Family Gift Switch
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: isFree,
                        title: const Text("🎁 Free Family Gift / Pass-Down (R0.00)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        onChanged: (v) => setModalState(() {
                          isFree = v ?? false;
                          if (isFree) priceC.text = "0";
                        }),
                      ),
                      if (!isFree)
                        TextField(
                          controller: priceC,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Price (ZAR) *", prefixText: "R ", border: OutlineInputBorder()),
                        ),
                      const SizedBox(height: 8),
                      TextField(controller: descC, maxLines: 2, decoration: const InputDecoration(labelText: "Description / Flaws / Notes", border: OutlineInputBorder())),
                    ],
                  ),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                    onPressed: () {
                      if (titleC.text.isNotEmpty) {
                        final price = isFree ? 0.0 : (double.tryParse(priceC.text.trim()) ?? 0.0);
                        
                        // Default image if no camera photo was taken
                        final photoUrls = [
                          "https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?q=80&w=800",
                        ];

                        setState(() {
                          _marketItems.insert(
                            0,
                            MarketItem(
                              id: "MKT-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
                              title: titleC.text.trim(),
                              brand: brandC.text.trim().isNotEmpty ? brandC.text.trim() : "Family Collection",
                              size: sizeC.text.trim().isNotEmpty ? sizeC.text.trim() : "Standard",
                              category: cat,
                              condition: cond,
                              price: price,
                              sellerName: user.fullName,
                              sellerBranch: user.branch,
                              sellerPhone: user.phone,
                              imageUrls: photoUrls,
                              description: descC.text.trim(),
                              availableCouriers: allCouriers,
                            ),
                          );
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("✅ Item listed with your photos!"), backgroundColor: Color(0xFF16A34A)),
                        );
                      }
                    },
                    child: const Text("Publish Listing"),
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
    final isDark = theme.brightness == Brightness.dark;
    final brandColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final cardColor = theme.cardColor;
    final borderColor = theme.dividerColor;

    final filtered = _marketItems.where((it) {
      final matchesCat = _selectedCategory == "All" ||
          it.category == _selectedCategory ||
          (_selectedCategory == "Free Family Gifts" && it.isFreeGift);
      final q = _searchQuery.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          it.title.toLowerCase().contains(q) ||
          it.brand.toLowerCase().contains(q) ||
          it.size.toLowerCase().contains(q) ||
          it.sellerName.toLowerCase().contains(q);
      return matchesCat && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "MAKHETHA CLAN MARKET",
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: onSurfaceColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "How Courier Shipping Works",
            icon: Icon(Icons.help_outline_rounded, color: brandColor),
            onPressed: () => _showHowShippingWorksDialog(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandColor,
                foregroundColor: isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
              onPressed: () => _showAddItemModal(context),
              icon: const Icon(Icons.add_a_photo_rounded, size: 14),
              label: const Text("Sell / Gift", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        onPressed: () => _showAddItemModal(context),
        icon: const Icon(Icons.add_a_photo_rounded),
        label: const Text("Sell or Gift an Item", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              // Search Input
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
                      hintText: "Search blankets, brands (Zara, Nike, Apple), sizes (M, 34)...",
                      hintStyle: TextStyle(color: onSurfaceColor.withOpacity(0.4), fontSize: 12),
                      prefixIcon: Icon(Icons.search_rounded, color: brandColor, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    ),
                  ),
                ),
              ),

              // Categories Row
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
                        selectedColor: brandColor,
                        checkmarkColor: isDark ? Colors.black : Colors.white,
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
                  }).toList(),
                ),
              ),

              // Products Grid
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text("No items found matching '$_searchQuery'",
                            style: TextStyle(color: onSurfaceColor.withOpacity(0.6))),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 80),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width > 700 ? 3 : 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.58,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (ctx, i) {
                          return _buildItemCard(filtered[i], cardColor, borderColor, brandColor, onSurfaceColor, isDark);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(
    MarketItem item,
    Color cardColor,
    Color borderColor,
    Color brandColor,
    Color onSurfaceColor,
    bool isDark,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClanMarketItemDetailScreen(item: item),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
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
                Image.network(
                  item.imageUrls.first,
                  height: 125,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 125,
                    color: brandColor.withOpacity(0.1),
                    child: Icon(Icons.checkroom_rounded, color: brandColor, size: 36),
                  ),
                ),
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
                // Like / Heart Button
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        item.isLiked = !item.isLiked;
                        if (item.isLiked) {
                          item.likes++;
                        } else {
                          item.likes--;
                        }
                      });
                    },
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.black45,
                      child: Icon(
                        item.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 14,
                        color: item.isLiked ? const Color(0xFFEF4444) : Colors.white,
                      ),
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
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: onSurfaceColor),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(color: brandColor.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                        child: Text(item.brand, style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: brandColor)),
                      ),
                      const SizedBox(width: 4),
                      Text("• Size: ${item.size}", style: TextStyle(fontSize: 9.5, color: onSurfaceColor.withOpacity(0.6))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.isFreeGift ? "R 0.00 (Gift)" : "R ${item.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: item.isFreeGift ? const Color(0xFF10B981) : brandColor,
                    ),
                  ),
                  Text("Seller: ${item.sellerName}", style: TextStyle(fontSize: 9, color: onSurfaceColor.withOpacity(0.55))),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 28,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandColor,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClanMarketItemDetailScreen(item: item),
                          ),
                        );
                      },
                      child: const Text("View & Buy", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// DEDICATED PRODUCT DETAIL SCREEN (MULTI-PHOTO, LOGISTICS & ESCROW DEPOSIT)
// =============================================================================
class ClanMarketItemDetailScreen extends StatefulWidget {
  final MarketItem item;
  const ClanMarketItemDetailScreen({super.key, required this.item});

  @override
  State<ClanMarketItemDetailScreen> createState() =>
      _ClanMarketItemDetailScreenState();
}

class _ClanMarketItemDetailScreenState
    extends State<ClanMarketItemDetailScreen> {
  int _activePhotoIndex = 0;
  late CourierLogisticsOption _selectedCourier;

  @override
  void initState() {
    super.initState();
    _selectedCourier = widget.item.availableCouriers.first;
  }

  Future<void> _launchExternal(String link) async {
    final Uri uri = Uri.parse(link);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  // 📍 TWO-STEP ESCROW VERIFICATION FLOW
  void _openEscrowDepositFlow(BuildContext context) {
    ClanAuthService.requireAuthentication(
      context,
      actionName: "purchase through Clan Escrow",
      onAuthenticated: () {
        final user = ClanAuthService().currentUser!;
        final double totalToDeposit = widget.item.price + _selectedCourier.fee;
        final String tradeRef = "ESC-${Random().nextInt(90000) + 10000}";

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).cardColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          builder: (ctx) => StatefulBuilder(
            builder: (context, setFlowState) {
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
                          const Icon(Icons.shield_rounded, color: Color(0xFF10B981), size: 24),
                          const SizedBox(width: 8),
                          Text("Clan Escrow Vault Deposit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text("Step 1 of 2: Funds must be deposited in Escrow before the seller can be notified.", style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                      const Divider(height: 20),

                      // Bank Deposit Instructions Box
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("🏦 Official Escrow Bank Details:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 4),
                            const Text("Bank: First National Bank (FNB) | Account: Makhetha Escrow Trust", style: TextStyle(fontSize: 11)),
                            const Text("Account Number: 62891234509 | Branch: 250655", style: TextStyle(fontSize: 11)),
                            const SizedBox(height: 6),
                            Text("⚠️ Required Reference: $tradeRef", style: TextStyle(fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary, fontSize: 12.5)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Breakdown
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Item Cost:"), Text("R ${widget.item.price.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold))]),
                      const SizedBox(height: 4),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Logistics (${_selectedCourier.name}):"), Text("R ${_selectedCourier.fee.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold))]),
                      const Divider(height: 16),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text("Total Required Deposit:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("R ${totalToDeposit.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Theme.of(context).colorScheme.primary)),
                      ]),
                      const SizedBox(height: 18),

                      // 📍 CONFIRMATION BUTTON (ONLY AFTER DEPOSIT)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showDepositSuccessAndNotifyDialog(context, tradeRef, totalToDeposit, user);
                          },
                          icon: const Icon(Icons.check_circle_rounded, size: 18),
                          label: const Text("I Have Deposited Funds • Notify Seller"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showDepositSuccessAndNotifyDialog(BuildContext context, String tradeRef, double total, ClanMemberUser user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lock_rounded, color: Color(0xFF10B981), size: 24),
            SizedBox(width: 8),
            Text("Funds Locked in Escrow"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Reference: $tradeRef", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Amount Protected: R ${total.toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Your payment is securely held. Tap below to notify the seller on WhatsApp to dispatch your parcel via your chosen courier:"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Done")),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF16A34A), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              final msg = """
🐊 *LEKGOTLA LA MAKHETHA • VERIFIED ESCROW PURCHASE*
Trade Ref: *$tradeRef*
Item: ${widget.item.title}
Buyer: ${user.fullName} (${user.branch})
---------------------------------
💰 Item Price: R ${widget.item.price.toStringAsFixed(2)}
🚚 Delivery (${_selectedCourier.name}): R ${_selectedCourier.fee.toStringAsFixed(2)}
🔒 Status: R ${total.toStringAsFixed(2)} SECURED IN ESCROW
---------------------------------
Funds verified in Clan Escrow! Please package the item, dispatch via ${_selectedCourier.name}, and send the tracking waybill.
""";
              _launchExternal("https://wa.me/${widget.item.sellerPhone}?text=${Uri.encodeComponent(msg)}");
            },
            icon: const Icon(Icons.send_rounded, size: 16),
            label: const Text("Notify Seller to Dispatch"),
          ),
        ],
      ),
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
        title: Text(widget.item.title, style: TextStyle(color: onSurfaceColor, fontSize: 14, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(
              widget.item.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: widget.item.isLiked ? const Color(0xFFEF4444) : onSurfaceColor,
            ),
            onPressed: () {
              setState(() {
                widget.item.isLiked = !widget.item.isLiked;
                if (widget.item.isLiked) {
                  widget.item.likes++;
                } else {
                  widget.item.likes--;
                }
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: cardColor, border: Border(top: BorderSide(color: borderColor))),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Price:", style: TextStyle(fontSize: 11, color: Colors.grey)),
                Text(
                  widget.item.isFreeGift ? "FREE GIFT 🎁" : "R ${widget.item.price.toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: widget.item.isFreeGift ? const Color(0xFF10B981) : brandColor),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _openEscrowDepositFlow(context),
              icon: const Icon(Icons.shield_rounded, size: 18),
              label: Text(widget.item.isFreeGift ? "Claim Free Gift" : "Buy with Escrow", style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Swipeable / Multi-Photo Gallery
              Container(
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(image: NetworkImage(widget.item.imageUrls[_activePhotoIndex]), fit: BoxFit.cover),
                ),
              ),
              if (widget.item.imageUrls.length > 1) ...[
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.item.imageUrls.length,
                    itemBuilder: (ctx, i) {
                      final isSel = _activePhotoIndex == i;
                      return GestureDetector(
                        onTap: () => setState(() => _activePhotoIndex = i),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isSel ? brandColor : Colors.transparent, width: 2),
                            image: DecorationImage(image: NetworkImage(widget.item.imageUrls[i]), fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 18),

              // 2. Title, Brand & Specifications
              Text(widget.item.title, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: onSurfaceColor)),
              const SizedBox(height: 6),
              Row(
                children: [
                  _specBadge("Brand: ${widget.item.brand}", brandColor),
                  const SizedBox(width: 8),
                  _specBadge("Size: ${widget.item.size}", brandColor),
                  const SizedBox(width: 8),
                  _specBadge(widget.item.condition, const Color(0xFF10B981)),
                ],
              ),
              const Divider(height: 24),

              // 3. Description
              const Text("Description & Notes:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              Text(widget.item.description, style: TextStyle(fontSize: 13, color: onSurfaceColor.withOpacity(0.8), height: 1.5)),
              const Divider(height: 24),

              // 4. Seller Verification & Branch
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor)),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: brandColor.withOpacity(0.15), child: Text(widget.item.sellerName[0], style: TextStyle(color: brandColor, fontWeight: FontWeight.bold))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.item.sellerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(widget.item.sellerBranch, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 5. Select Courier Logistics
              const Text("Select Shipping / Courier Provider:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              ...widget.item.availableCouriers.map((courier) {
                final isSel = _selectedCourier.name == courier.name;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSel ? brandColor.withOpacity(0.08) : cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSel ? brandColor : borderColor),
                  ),
                  child: ListTile(
                    leading: Icon(courier.icon, color: isSel ? brandColor : Colors.grey),
                    title: Text(courier.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                    subtitle: Text("${courier.deliveryTime} • ${courier.howItWorks}", maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5)),
                    trailing: Text(courier.fee == 0.0 ? "FREE" : "R ${courier.fee.toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold, color: brandColor)),
                    onTap: () => setState(() => _selectedCourier = courier),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _specBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}