import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_1123150074/core/constants/app_colors.dart';
import 'package:uts_1123150074/core/constants/app_strings.dart';
import 'package:uts_1123150074/core/services/notification_service.dart';
import 'package:uts_1123150074/core/utils/currency_helper.dart';
import 'package:uts_1123150074/features/cart/presentation/providers/cart_provider.dart';
import 'package:uts_1123150074/features/dashboard/presentation/providers/theme_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().fetchCart();
    });
  }
  

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final themeProvider = context.watch<ThemeProvider>(); // ← baca + dengarkan
    final isDark = themeProvider.isDark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.oceanGradientDark
            : AppColors.oceanGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(AppStrings.cart),
          actions: [
            if (cart.items.isNotEmpty)
              IconButton(
                tooltip: "Hapus semua",
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _showClearDialog(context),
              ),
          ],
        ),
        body: cart.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : cart.items.isEmpty
            ? _buildEmpty()
            : Column(
                children: [
                  Expanded(child: _buildList(cart)),
                  _buildBottomBar(cart),
                ],
              ),
      ),
    );
  }

  // EMPTY
  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.white70),
          SizedBox(height: 10),
          Text("Keranjang kosong", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // LIST
  Widget _buildList(CartProvider cart) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.glass,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.imageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 14),

                // INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        formatRupiah(item.price),
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // ACTION
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 🗑 DELETE PER ITEM
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: AppColors.primary,
                            title: const Text(
                              "Hapus produk?",
                              style: TextStyle(color: Colors.white),
                            ),
                            content: Text(
                              "Hapus ${item.productName} dari keranjang?",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(),
                                child: const Text(
                                  "Batal",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final name = item.productName;

                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();

                                  await cart.removeItem(item.id);

                                  if (!context.mounted) return;

                                  await NotificationService.showNotification(
                                    title: 'Keranjang',
                                    body: '$name berhasil dihapus',
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("$name berhasil dihapus"),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Hapus",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // QTY
                    Row(
                      children: [
                        _qtyButton(Icons.remove, () {
                          if (item.quantity > 1) {
                            cart.updateItem(item.id, item.quantity - 1);
                          }
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        _qtyButton(Icons.add, () {
                          cart.updateItem(item.id, item.quantity + 1);
                        }),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // QTY BUTTON
  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.glassStrong,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }

  // BOTTOM BAR
  Widget _buildBottomBar(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glass,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total", style: TextStyle(color: Colors.white)),
          Text(
            formatRupiah(cart.totalPrice),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  // CLEAR CART
  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Hapus semua?",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Keranjang akan dikosongkan",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              await context.read<CartProvider>().clearCart();
              Navigator.pop(context);

              await NotificationService.showNotification(
                title: 'Keranjang',
                body: 'Semua produk dihapus dari keranjang',
              );
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
