import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_1123150074/core/constants/app_colors.dart';
import 'package:uts_1123150074/core/routes/app_router.dart';
import 'package:uts_1123150074/features/auth/presentation/providers/auth_provider.dart';
import 'package:uts_1123150074/features/dashboard/presentation/providers/product_provider.dart';
import 'package:uts_1123150074/features/cart/presentation/providers/cart_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final product = context.watch<ProductProvider>();

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.oceanGradient),
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
            Consumer<CartProvider>(
              builder: (context, cart, _) {
                return Stack(
                  children: [
                    IconButton(
                      tooltip: "Cart",
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.cart);
                      },
                    ),

                    // BADGE
                    if (cart.items.isNotEmpty)
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '${cart.items.fold(0, (sum, item) => sum + item.quantity)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
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
                          Navigator.pop(context); // tutup dialog dulu

                          await auth.logout();

                          if (!mounted) return;

                          Navigator.pushReplacementNamed(
                            context,
                            AppRouter.login,
                          );

                          // 🔥 feedback
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Memuat produk pancingan josjis...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          ProductStatus.error => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  product.error ?? 'Terjadi kesalahan Mas',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi Mas'),
                  onPressed: () => product.fetchProducts(),
                ),
              ],
            ),
          ),

          ProductStatus.loaded => RefreshIndicator(
            onRefresh: () => product.fetchProducts(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: product.products.length,
              itemBuilder: (context, i) {
                final p = product.products[i];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IMAGE
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          p.imageUrl,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            color: Colors.black26,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // CONTENT
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 4),

                            Text(
                              'Rp ${p.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                p.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 🛒 ADD TO CART BUTTON
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.add_shopping_cart,
                                  size: 16,
                                ),
                                label: const Text("Keranjang"),
                                onPressed: () async {
                                  await context.read<CartProvider>().addToCart(
                                    p.ID,
                                    1,
                                  );

                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Berhasil ditambahkan ke keranjang',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        },
      ),
    );
  }
}
