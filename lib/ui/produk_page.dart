import 'package:flutter/material.dart';
import 'package:produk_flutter_indah/model/produk_model.dart';
import 'package:produk_flutter_indah/service/api_service.dart';
import 'package:produk_flutter_indah/ui/produk_form.dart';
import 'package:produk_flutter_indah/ui/produk_detail.dart';

// Warna utama aplikasi (tema merah & putih)
const kPrimaryRed = Color(0xFFD32F2F);
const kDarkRed = Color(0xFFB71C1C);
const kLightRed = Color(0xFFFFCDD2);
const kAccentRed = Color(0xFFFF5252);
const kBgWhite = Color(0xFFF8F8F8);
const kCardWhite = Colors.white;

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  late Future<List<Produk>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ApiService.getProducts();
  }

  void _refreshData() {
    setState(() {
      _futureProducts = ApiService.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgWhite,
      appBar: AppBar(
        title: const Text(
          'Manajemen Produk',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        backgroundColor: kPrimaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refreshData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header banner merah melengkung
          Container(
            width: double.infinity,
            color: kPrimaryRed,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              decoration: const BoxDecoration(
                color: kBgWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: const SizedBox.shrink(),
            ),
          ),

          // Konten daftar produk
          Expanded(
            child: FutureBuilder<List<Produk>>(
              future: _futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimaryRed),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: kLightRed,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.wifi_off_rounded,
                              size: 48,
                              color: kPrimaryRed,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Gagal Memuat Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _refreshData,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryRed,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final products = snapshot.data ?? [];

                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: kLightRed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            size: 56,
                            color: kPrimaryRed,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Belum Ada Produk',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tambahkan produk pertama Anda sekarang.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProdukForm(),
                              ),
                            );
                            if (result == true) _refreshData();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Tambah Produk'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: kPrimaryRed,
                  onRefresh: () async => _refreshData(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ItemProduk(
                        produk: products[index],
                        onRefresh: _refreshData,
                        index: index,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProdukForm()),
          );
          if (result == true) _refreshData();
        },
        backgroundColor: kPrimaryRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Tambah Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 4,
      ),
    );
  }
}

// ============================================================
// Widget Item Produk - Card profesional merah & putih
// ============================================================
class ItemProduk extends StatelessWidget {
  final Produk produk;
  final VoidCallback onRefresh;
  final int index;

  const ItemProduk({
    super.key,
    required this.produk,
    required this.onRefresh,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProdukDetail(produk: produk)),
        );
        if (result == true) onRefresh();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14.0),
        decoration: BoxDecoration(
          color: kCardWhite,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: kPrimaryRed.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left accent bar (merah)
            Container(
              width: 5,
              height: 80,
              decoration: const BoxDecoration(
                color: kPrimaryRed,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Icon produk
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: kLightRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.inventory_2,
                color: kPrimaryRed,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),

            // Info produk
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produk.namaProduk ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF212121),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.layers_outlined,
                          size: 13,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Stok: ${produk.stok ?? 0}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${_formatHarga(produk.harga ?? 0)}',
                      style: const TextStyle(
                        color: kPrimaryRed,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Arrow
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Icon(
                Icons.chevron_right_rounded,
                color: kPrimaryRed,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatHarga(int harga) {
    final str = harga.toString();
    final buffer = StringBuffer();
    int counter = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (counter > 0 && counter % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      counter++;
    }
    return buffer.toString().split('').reversed.join();
  }
}
