import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_1123150074/core/constants/app_colors.dart';
import 'package:uts_1123150074/core/routes/app_router.dart';
import 'package:uts_1123150074/features/auth/presentation/providers/auth_provider.dart';
import 'package:uts_1123150074/features/dashboard/presentation/providers/product_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    // Fetch produk begitu halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
Widget build(BuildContext context) {
  final auth = context.watch<AuthProvider>();
  final product = context.watch<ProductProvider>();

  return Container(
    decoration: const BoxDecoration(
      gradient: AppColors.oceanGradient // 🌊 background laut
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent, // 🔥 wajib
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
                fontWeight: FontWeight.normal,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await auth.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, AppRouter.login);
            },
          ),
        ],
      ),

      body: switch (product.status) {
        ProductStatus.loading || ProductStatus.initial =>
          const Center(
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

        ProductStatus.error =>
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 64, color: Colors.white),
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

        ProductStatus.loaded =>
          RefreshIndicator(
            onRefresh: () => product.fetchProducts(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
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
                    color: Colors.white.withOpacity(0.2), // 🧊 glass
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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