// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Default max_length URLField pada Django.
const int thumbnailMaxLength = 200;

/// Field opsional boleh kosong; jika diisi harus URL http/https yang lengkap.
String? validateThumbnailUrl(String? value) {
  final text = value?.trim() ?? "";
  if (text.isEmpty) return null;
  if (text.length > thumbnailMaxLength) {
    return "URL maksimal $thumbnailMaxLength karakter!";
  }
  final uri = Uri.tryParse(text);
  final valid = uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.contains('.');
  return valid ? null : "Masukkan URL yang valid (diawali http:// atau https://)!";
}

/// Formulir untuk menambahkan pengalaman (model Experience pada web portofolio).
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Batas panjang mengikuti max_length pada model Django.
  static const int titleMaxLength = 255;
  static const int organizationMaxLength = 160;

  // Pilihan kategori mengikuti EXPERIENCE_CHOICES pada model.
  static const Map<String, String> categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  String _title = "";
  String _organization = "";
  String _description = "";
  String _category = "full-time"; // default sama dengan model
  String _thumbnail = "";
  DateTime? _startedAt;
  DateTime? _endedAt; // null berarti masih berlangsung

  final _startedController = TextEditingController();
  final _endedController = TextEditingController();

  @override
  void dispose() {
    _startedController.dispose();
    _endedController.dispose();
    super.dispose();
  }

  static String formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = (isStart ? _startedAt : _endedAt) ?? _startedAt ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      helpText: isStart ? 'Pilih tanggal mulai' : 'Pilih tanggal selesai',
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startedAt = picked;
        _startedController.text = formatDate(picked);
      } else {
        _endedAt = picked;
        _endedController.text = formatDate(picked);
      }
    });
  }

  void _clearEndDate() {
    setState(() {
      _endedAt = null;
      _endedController.clear();
    });
  }

  InputDecoration _decoration(String label, {String? hint, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pengalaman berhasil disimpan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Judul: ${_title.trim()}'),
                Text('Organisasi: ${_organization.trim().isEmpty ? "-" : _organization.trim()}'),
                Text('Deskripsi: ${_description.trim()}'),
                Text('Kategori: ${categories[_category]}'),
                Text('Thumbnail: ${_thumbnail.trim().isEmpty ? "-" : _thumbnail.trim()}'),
                Text('Mulai: ${formatDate(_startedAt!)}'),
                Text('Selesai: ${_endedAt == null ? "Masih berlangsung" : formatDate(_endedAt!)}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Tutup'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // AppBar mengikuti tema halaman utama.
      appBar: AppBar(
        title: const Text(
          'Add Experience Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        // SingleChildScrollView agar semua field dan tombol Simpan tetap bisa
        // dijangkau di layar sempit atau saat papan ketik tampil.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Title ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: titleMaxLength,
                  decoration: _decoration("Judul Pengalaman",
                      hint: "Contoh: Software Engineer Intern"),
                  onChanged: (value) => setState(() => _title = value),
                  validator: (value) {
                    final text = value?.trim() ?? "";
                    if (text.isEmpty) return "Judul tidak boleh kosong!";
                    if (text.length > titleMaxLength) {
                      return "Judul maksimal $titleMaxLength karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Organization (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: organizationMaxLength,
                  decoration: _decoration("Organisasi (opsional)",
                      hint: "Contoh: Opsigo Asia · Jakarta"),
                  onChanged: (value) => setState(() => _organization = value),
                  validator: (value) {
                    if ((value?.trim().length ?? 0) > organizationMaxLength) {
                      return "Organisasi maksimal $organizationMaxLength karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  minLines: 3,
                  maxLines: 6,
                  keyboardType: TextInputType.multiline,
                  decoration: _decoration("Deskripsi",
                      hint: "Satu poin per baris"),
                  onChanged: (value) => setState(() => _description = value),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: _decoration("Kategori"),
                  initialValue: _category,
                  items: categories.entries
                      .map((entry) => DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _category = value!),
                  validator: (value) => categories.containsKey(value)
                      ? null
                      : "Pilih kategori yang tersedia!",
                ),
              ),

              // === Thumbnail URL (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: _decoration("URL Thumbnail (opsional)",
                      hint: "https://..."),
                  onChanged: (value) => setState(() => _thumbnail = value),
                  validator: validateThumbnailUrl,
                ),
              ),

              // === Started at ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startedController,
                  readOnly: true,
                  decoration: _decoration("Tanggal Mulai",
                      hint: "Pilih tanggal",
                      suffix: const Icon(Icons.calendar_today)),
                  onTap: () => _pickDate(isStart: true),
                  validator: (_) =>
                      _startedAt == null ? "Tanggal mulai wajib diisi!" : null,
                ),
              ),

              // === Ended at (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _endedController,
                  readOnly: true,
                  decoration: _decoration(
                    "Tanggal Selesai (kosongkan jika masih berlangsung)",
                    hint: "Pilih tanggal",
                    suffix: _endedAt == null
                        ? const Icon(Icons.calendar_today)
                        : IconButton(
                            tooltip: 'Hapus tanggal selesai',
                            icon: const Icon(Icons.clear),
                            onPressed: _clearEndDate,
                          ),
                  ),
                  onTap: () => _pickDate(isStart: false),
                  validator: (_) {
                    if (_startedAt != null &&
                        _endedAt != null &&
                        _endedAt!.isBefore(_startedAt!)) {
                      return "Tanggal selesai tidak boleh sebelum tanggal mulai!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _save,
                    child: const Text("Simpan"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
