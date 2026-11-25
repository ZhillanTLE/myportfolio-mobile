// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _year = "";
  String _description = "";
  String _techStack = "";
  String _projectUrl = "";
  String _projectImageUrl = "";
  bool _isSubmitting = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final apiClient = context.read<ApiClient>();
    final authState = context.read<AuthState>();
    final token = authState.token;
    if (token == null) return;

    final newProject = Project(
      title: _title.trim(),
      year: _year.trim(),
      description: _description.trim(),
      techStack: _techStack.trim(),
      projectUrl: _projectUrl.trim(),
      projectImageUrl: _projectImageUrl.trim(),
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      final created = await apiClient.createProject(newProject, token: token);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Proyek berhasil ditambahkan!'),
            content: Text(created.title),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
      if (!mounted) return;
      _formKey.currentState!.reset();
    } on ApiException catch (e) {
      // DRF answers 403 instead of 401 for a bad token because
      // SessionAuthentication comes first in the backend.
      if (e.statusCode == 401 || e.message.contains('Invalid token')) {
        await authState.logout();
        if (!mounted) return;
        _showMessage('Sesi berakhir, silakan login lagi.');
        await ensureLoggedIn(context);
      } else {
        if (!mounted) return;
        _showMessage('Gagal menyimpan proyek (${e.statusCode}).');
      }
    } on Exception {
      if (!mounted) return;
      _showMessage('Tidak dapat terhubung ke server.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Kolom ini tidak boleh kosong!";
    }
    return null;
  }

  Widget _field({
    required String label,
    required ValueChanged<String> onChanged,
    required FormFieldValidator<String> validator,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: label,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Project Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // maxLength mengikuti max_length pada model Django.
              _field(
                label: "Title",
                maxLength: 255,
                onChanged: (value) => _title = value,
                validator: _required,
              ),
              _field(
                label: "Year",
                maxLength: 16,
                onChanged: (value) => _year = value,
                validator: _required,
              ),
              _field(
                label: "Description",
                maxLines: 5,
                onChanged: (value) => _description = value,
                validator: _required,
              ),
              _field(
                label: "Tech Stack",
                maxLength: 255,
                onChanged: (value) => _techStack = value,
                validator: _required,
              ),
              _field(
                label: "Project URL",
                onChanged: (value) => _projectUrl = value,
                validator: (value) =>
                    _required(value) ?? validateThumbnailUrl(value),
              ),
              _field(
                label: "Project Image URL (Optional)",
                onChanged: (value) => _projectImageUrl = value,
                validator: validateThumbnailUrl,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
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
