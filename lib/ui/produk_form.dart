import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:produk_flutter_indah/model/produk_model.dart';
import 'package:produk_flutter_indah/service/api_service.dart';

// Tema warna (konsisten dengan produk_page.dart)
const kPrimaryRed = Color(0xFFD32F2F);
const kDarkRed = Color(0xFFB71C1C);
const kLightRed = Color(0xFFFFCDD2);
const kBgWhite = Color(0xFFF8F8F8);

class ProdukForm extends StatefulWidget {
  final Produk? produk;
  const ProdukForm({super.key, this.produk});

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaProdukController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _deskripsiController = TextEditingController();

  bool _isLoading = false;
  bool get _isEditMode => widget.produk != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _namaProdukController.text = widget.produk!.namaProduk ?? '';
      _hargaController.text = widget.produk!.harga?.toString() ?? '';
      _stokController.text = widget.produk!.stok?.toString() ?? '';
      _deskripsiController.text = widget.produk!.deskripsi ?? '';
    }
  }

  @override
  void dispose() {
    _namaProdukController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgWhite,
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Produk' : 'Tambah Produk',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Lengkungan merah di atas form
          Container(
            color: kPrimaryRed,
            child: Container(
              height: 24,
              decoration: const BoxDecoration(
                color: kBgWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header form
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: kLightRed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _isEditMode
                                ? Icons.edit_note_rounded
                                : Icons.add_box_rounded,
                            color: kPrimaryRed,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEditMode ? 'Edit Data Produk' : 'Produk Baru',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                            ),
                            Text(
                              _isEditMode
                                  ? 'Perbarui informasi produk'
                                  : 'Isi detail produk di bawah ini',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Field: Nama Produk
                    _buildSectionLabel('Nama Produk'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _namaProdukController,
                      hint: 'Contoh: Baju Batik Premium',
                      icon: Icons.inventory_2_outlined,
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Nama produk wajib diisi';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Field: Harga & Stok berdampingan
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionLabel('Harga (Rp)'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _hargaController,
                                hint: '0',
                                icon: Icons.sell_outlined,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (v) {
                                  if (v == null || v.isEmpty)
                                    return 'Wajib diisi';
                                  if (int.tryParse(v) == null)
                                    return 'Harus angka';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionLabel('Stok'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _stokController,
                                hint: '0',
                                icon: Icons.layers_outlined,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (v) {
                                  if (v == null || v.isEmpty)
                                    return 'Wajib diisi';
                                  if (int.tryParse(v) == null)
                                    return 'Harus angka';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Field: Deskripsi
                    _buildSectionLabel('Deskripsi (opsional)'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _deskripsiController,
                      hint: 'Tulis deskripsi produk...',
                      icon: Icons.notes_rounded,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 32),

                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _isLoading ? null : _simpanProduk,
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isEditMode
                                        ? Icons.check_circle_outline
                                        : Icons.save_outlined,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isEditMode
                                        ? 'Perbarui Produk'
                                        : 'Simpan Produk',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Tombol Batal
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kPrimaryRed,
                          side: const BorderSide(color: kPrimaryRed),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
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
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF424242),
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 14, color: Color(0xFF212121)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: Icon(icon, color: kPrimaryRed, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimaryRed, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Future<void> _simpanProduk() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final produk = Produk(
        id: widget.produk?.id,
        namaProduk: _namaProdukController.text,
        harga: int.parse(_hargaController.text),
        stok: int.parse(_stokController.text),
        deskripsi: _deskripsiController.text.isNotEmpty
            ? _deskripsiController.text
            : null,
      );

      bool success;
      if (_isEditMode) {
        success = await ApiService.updateProduct(produk);
      } else {
        success = await ApiService.createProduct(produk);
      }

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  _isEditMode
                      ? 'Produk berhasil diperbarui!'
                      : 'Produk berhasil ditambahkan!',
                ),
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
                Text('Gagal menyimpan produk.'),
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
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
