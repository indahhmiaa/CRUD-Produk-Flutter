import 'package:flutter/material.dart';
import 'package:produk_flutter_indah/model/produk_model.dart';
import 'package:produk_flutter_indah/service/api_service.dart';
import 'package:produk_flutter_indah/ui/produk_form.dart';

// Tema warna (konsisten dengan halaman lain)
const kPrimaryRed = Color(0xFFD32F2F);
const kDarkRed = Color(0xFFB71C1C);
const kLightRed = Color(0xFFFFCDD2);
const kBgWhite = Color(0xFFF8F8F8);

class ProdukDetail extends StatefulWidget {
  final Produk produk;
  const ProdukDetail({super.key, required this.produk});

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;

    return Scaffold(
      backgroundColor: kBgWhite,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // ===== HEADER MERAH =====
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kPrimaryRed, kDarkRed],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 100, 24, 36),
            child: Column(
              children: [
                // Icon lingkaran putih
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  produk.namaProduk ?? '-',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                // Chip harga
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Rp ${_formatHarga(produk.harga ?? 0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== KONTEN DETAIL =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                children: [
                  // Kartu informasi
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: kPrimaryRed.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDetailTile(
                          icon: Icons.tag_rounded,
                          label: 'ID Produk',
                          value: produk.id?.toString() ?? '-',
                          isFirst: true,
                        ),
                        _buildDivider(),
                        _buildDetailTile(
                          icon: Icons.sell_outlined,
                          label: 'Harga',
                          value: 'Rp ${_formatHarga(produk.harga ?? 0)}',
                          valueColor: kPrimaryRed,
                          valueBold: true,
                        ),
                        _buildDivider(),
                        _buildDetailTile(
                          icon: Icons.layers_outlined,
                          label: 'Stok Tersedia',
                          value: '${produk.stok ?? 0} unit',
                        ),
                        _buildDivider(),
                        _buildDetailTile(
                          icon: Icons.notes_rounded,
                          label: 'Deskripsi',
                          value: produk.deskripsi?.isNotEmpty == true
                              ? produk.deskripsi!
                              : 'Tidak ada deskripsi',
                          valueColor: produk.deskripsi?.isNotEmpty == true
                              ? const Color(0xFF212121)
                              : Colors.grey,
                        ),
                        _buildDivider(),
                        _buildDetailTile(
                          icon: Icons.calendar_today_outlined,
                          label: 'Tanggal Dibuat',
                          value: produk.createdAt ?? '-',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Tombol Edit
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProdukForm(produk: produk),
                          ),
                        );
                        if (result == true && mounted) {
                          Navigator.pop(context, true);
                        }
                      },
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      label: const Text(
                        'Edit Produk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Tombol Hapus
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kPrimaryRed,
                        side: const BorderSide(color: kPrimaryRed),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _isDeleting ? null : _konfirmasiHapus,
                      icon: _isDeleting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: kPrimaryRed,
                              ),
                            )
                          : const Icon(Icons.delete_outline_rounded, size: 20),
                      label: Text(
                        _isDeleting ? 'Menghapus...' : 'Hapus Produk',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool valueBold = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, isFirst ? 16 : 12, 16, isLast ? 16 : 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kLightRed,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: kPrimaryRed, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: valueBold ? FontWeight.bold : FontWeight.w500,
                    color: valueColor ?? const Color(0xFF212121),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
      indent: 16,
      endIndent: 16,
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

  Future<void> _konfirmasiHapus() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: kPrimaryRed),
            SizedBox(width: 8),
            Text('Hapus Produk', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Yakin ingin menghapus "${widget.produk.namaProduk}"?\nTindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isDeleting = true);

    try {
      final success = await ApiService.deleteProduct(widget.produk.id!);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('Produk berhasil dihapus!'),
              ],
            ),
            backgroundColor: const Color(0xFF388E3C),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 10),
                Text('Gagal menghapus produk.'),
              ],
            ),
            backgroundColor: kPrimaryRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: kPrimaryRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }
}
