### Assignment 8 
1. Widget tree is a hierarchy structure where each widget nests on another widget. The parent widget nests and sovereign over the location + configuration of the child/children(if any) widget, while the children widget inherits the context of the parent's

2. the widgets that i used are:
MaterialApp = root aplikasi.
Scaffold = kerangka halaman.
AppBar = bar judul.
Text = menampilkan teks.
Padding = memberi jarak di sekeliling widget.
Column dan Row = menyusun widget secara vertikal dan horizontal.
SizedBox = pemberi jarak kosong.
Center = memusatkan widget.
GridView = menampilkan tombol dalam bentuk kisi.
Card = kartu informasi berbayangan.
Container = mengatur ukuran dan padding.
Material = memberi warna dan sudut membulat pada tombol.
InkWell = menangkap ketukan dan memberi efek riak.
Icon = menampilkan ikon.
SnackBar (dipanggil melalui ScaffoldMessenger) = menampilkan pesan singkat.
Widget buatan sendiri, yaitu MyApp, MyHomePage, InfoCard, dan ItemCard.

3. MaterialApp serves the foundation of the app with the style of Material Design, like themes, navigation or routing, and localization, so that generally it's the root widget for all widget underneath it can access the features

4. StatelessWidget doesn't have state that can change so that the interface only depends on the input data, while StatefulWidget has state that may change or trigger rebuild through setState(). Therefore StatelessWidget is chosen for static interface and StatefulWidget is chosen for dynamic interfaces that change because  of interactions / data, e.g., counter, form, or toggle.

5. BuildContext is the position marker of a widget in a widget tree that is important to acccess data from the ancestor widget, in the build method, it is used for example on Theme.of(context), MediaQuery.of(context), and ScaffoldMessenger.of(context).

6. hot reload injects code changes to application that is running without deleting state, while hot restart reruns the application from scratch so that the state is gone in the process. We need hot restart when changing stuff that is not rerun by build, like main() function, global variable initialization or statuc, initState, type changes or class structure, enumerate, and also native code changes, plugin, or even pubspec.yaml.