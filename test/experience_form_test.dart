// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  void useScreen(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Future<void> openFormFromDrawer(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Experience'));
    await tester.pumpAndSettle();
  }

  Future<void> pickDay(
      WidgetTester tester, String fieldLabel, String day) async {
    await tester.tap(find.widgetWithText(TextFormField, fieldLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(day));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  Future<void> tapSave(WidgetTester tester) async {
    final save = find.widgetWithText(ElevatedButton, 'Simpan');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
  }

  testWidgets('Action card opens the form and back returns home',
      (tester) async {
    useScreen(tester, const Size(800, 1400));
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    await tester.tap(find.text('Tambah Pengalaman'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);

    await tester.binding.handlePopRoute(); // tombol kembali bawaan perangkat
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsNothing);
    expect(find.text('Lihat Proyek'), findsOneWidget);
  });

  testWidgets('Drawer opens the form and Home returns to the main page',
      (tester) async {
    useScreen(tester, const Size(800, 1400));
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    await openFormFromDrawer(tester);
    expect(find.text('Add Experience Form'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.byType(ExperienceFormPage), findsNothing);
    expect(find.text('Lihat Proyek'), findsOneWidget);
  });

  testWidgets('Invalid input shows field errors and no dialog', (tester) async {
    useScreen(tester, const Size(800, 1400));
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));
    await openFormFromDrawer(tester);

    // Hanya spasi pada field wajib, dan URL tanpa skema.
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Judul Pengalaman'), '   ');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Deskripsi'), '  ');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'URL Thumbnail (opsional)'),
        'example.com');
    await tapSave(tester);

    expect(find.text('Judul tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi tidak boleh kosong!'), findsOneWidget);
    expect(find.textContaining('Masukkan URL yang valid'), findsOneWidget);
    expect(find.text('Tanggal mulai wajib diisi!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('End date before start date is rejected', (tester) async {
    useScreen(tester, const Size(800, 1400));
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));
    await openFormFromDrawer(tester);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Judul Pengalaman'), 'Intern');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Deskripsi'), 'Built things');
    await pickDay(tester, 'Tanggal Mulai', '15');
    await pickDay(
        tester, 'Tanggal Selesai (kosongkan jika masih berlangsung)', '10');
    await tapSave(tester);

    expect(find.text('Tanggal selesai tidak boleh sebelum tanggal mulai!'),
        findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Valid input shows every value in the dialog, Tutup closes it',
      (tester) async {
    useScreen(tester, const Size(800, 1400));
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));
    await openFormFromDrawer(tester);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Judul Pengalaman'),
        'Software Engineer Intern');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Organisasi (opsional)'),
        'Opsigo Asia');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Deskripsi'), 'Built the API');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'URL Thumbnail (opsional)'),
        'https://example.com/a.png');
    await pickDay(tester, 'Tanggal Mulai', '10');
    await pickDay(
        tester, 'Tanggal Selesai (kosongkan jika masih berlangsung)', '15');
    await tapSave(tester);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Judul: Software Engineer Intern'), findsOneWidget);
    expect(find.text('Organisasi: Opsigo Asia'), findsOneWidget);
    expect(find.text('Deskripsi: Built the API'), findsOneWidget);
    expect(find.text('Kategori: Full-Time'), findsOneWidget);
    expect(find.text('Thumbnail: https://example.com/a.png'), findsOneWidget);
    expect(find.textContaining('Mulai: 10 '), findsOneWidget);
    expect(find.textContaining('Selesai: 15 '), findsOneWidget);

    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(ExperienceFormPage), findsOneWidget);
  });

  testWidgets('Form fits a narrow phone screen and Simpan is reachable',
      (tester) async {
    useScreen(tester, const Size(320, 568));
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      home: const ExperienceFormPage(),
    ));

    await tapSave(tester); // would throw if Simpan could not be scrolled to
    expect(find.text('Judul tidak boleh kosong!'), findsOneWidget);
  });

  test('URL validator', () {
    String? check(String v) => validateThumbnailUrl(v);
    expect(check(''), isNull);
    expect(check('https://example.com/img.png'), isNull);
    expect(check('example.com'), isNotNull);
    expect(check('ftp://example.com'), isNotNull);
    expect(check('https://${'a' * 200}.com'), isNotNull);
  });
}
