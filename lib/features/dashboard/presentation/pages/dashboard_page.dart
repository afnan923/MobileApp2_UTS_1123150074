import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_1123150074/core/constants/app_colors.dart';
import 'package:uts_1123150074/core/routes/app_router.dart';
import 'package:uts_1123150074/core/services/notification_service.dart';
import 'package:uts_1123150074/core/utils/currency_helper.dart';
import 'package:uts_1123150074/features/auth/presentation/providers/auth_provider.dart';
import 'package:uts_1123150074/features/dashboard/presentation/providers/product_provider.dart';
import 'package:uts_1123150074/features/cart/presentation/providers/cart_provider.dart';
import 'package:uts_1123150074/features/dashboard/presentation/providers/theme_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // ✅ TAMBAHAN SAJA (TIDAK UBAH STRUKTUR)
  final TextEditingController _searchCtrl = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  // ✅ FILTER FUNCTION (TAMBAHAN)
  List _filteredProducts(List products) {
    final query = _searchCtrl.text.toLowerCase();

    return products.where((p) {
      final matchCategory =
          _selectedCategory == 'All' ||
          p.category.toLowerCase() == _selectedCategory.toLowerCase();

      final matchSearch =
          query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query);

      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final product = context.watch<ProductProvider>();
    final themeProvider = context.watch<ThemeProvider>(); // ← baca + dengarkan
    final isDark = themeProvider.isDark;

    final filtered = product.status == ProductStatus.loaded
        ? _filteredProducts(product.products)
        : [];

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.oceanGradientDark
            : AppColors.oceanGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                'Halo Pemancing 🎣, ${auth.firebaseUser?.displayName ?? 'User'}!',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.yellowAccent,
                ),
              ),
            ],
          ),

          actions: [
            IconButton(
              tooltip: "Cart",
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.cart);
              },
            ),

            IconButton(
              tooltip: "Logout",
              icon: const Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppColors.primary,
                    title: const Text(
                      "Keluar akun?",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      "Apakah kamu yakin ingin logout?",
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Batal",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          context.read<CartProvider>().clearLocalCart();
                          await context.read<AuthProvider>().logout();

                          if (!context.mounted) return;

                          Navigator.pushReplacementNamed(
                            context,
                            AppRouter.login,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Berhasil logout")),
                          );
                        },
                        child: const Text(
                          "Keluar",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),

        body: switch (product.status) {
          ProductStatus.loading || ProductStatus.initial => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),

          ProductStatus.error => Center(
            child: Text(
              product.error ?? 'Error',
              style: const TextStyle(color: Colors.white),
            ),
          ),

          ProductStatus.loaded => Column(
            children: [
              // 🔥 SEARCH BAR (TAMBAHAN TANPA MERUSAK UI)
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (value) {
                    setState(
                      () {},
                    ); // 🔥 INI WAJIB (lebih stabil dari listener)
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isDark
                            ? Icons.dark_mode
                            : Icons.light_mode, // ← ikon berubah
                        size: 20,
                        color: isDark
                            ? Colors.amber
                            : Colors.grey.shade600, // ← warna berubah
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isDark
                            ? 'Mode Gelap'
                            : 'Mode Terang', // ← label berubah
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Switch(
                    value: isDark, // ← posisi switch
                    onChanged: (_) => context
                        .read<ThemeProvider>()
                        .toggle(), // ← panggil toggle
                  ),
                ],
              ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => product.fetchProducts(),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),

                    itemCount: filtered.length,

                    itemBuilder: (context, i) {
                      final p = filtered[i];

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.network(
                                p.imageUrl,
                                height: 130,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      formatRupiah(p.price),
                                      style: const TextStyle(
                                        color: Colors.yellow,
                                      ),
                                    ),

                                    const Spacer(),

                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        icon: const Icon(
                                          Icons.add_shopping_cart,
                                          size: 16,
                                        ),
                                        label: const Text(
                                          "Cart",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        onPressed: () async {
                                          await context
                                              .read<CartProvider>()
                                              .addToCart(p.ID, 1);

                                          await NotificationService.showNotification(
                                            title: 'Keranjang',
                                            body:
                                                '${p.name} berhasil ditambahkan',
                                          );

                                          if (!mounted) return;

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${p.name} berhasil ditambahkan',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        },
      ),
    );
  }
}
