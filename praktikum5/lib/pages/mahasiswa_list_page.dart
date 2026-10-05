import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/mahasiswa.dart';
import '../data/network_errors.dart';
import '../data/paged_mahasiswa.dart';
import 'form_page.dart';

class MahasiswaListPage extends ConsumerStatefulWidget {
  const MahasiswaListPage({super.key});

  @override
  ConsumerState<MahasiswaListPage> createState() => _MahasiswaListPageState();
}

class _MahasiswaListPageState extends ConsumerState<MahasiswaListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(pagedMahasiswaProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // m == null -> tambah, m != null -> edit
  Future<void> _bukaForm([Mahasiswa? m]) async {
    final berhasil = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormPage(mahasiswa: m)),
    );
    if (berhasil == true) {
      ref.read(pagedMahasiswaProvider.notifier).refresh();
    }
  }

  Future<void> _hapus(Mahasiswa m) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus data?'),
        content: Text('Yakin menghapus ${m.nama}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await ref.read(pagedMahasiswaProvider.notifier).hapus(m.id!);
      _tampilPesan('Data berhasil dihapus');
    } catch (e) {
      _tampilPesan(friendlyErrorMessage(e));
    }
  }

  void _tampilPesan(String pesan) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  Widget _buildItem(Mahasiswa m) {
    return ListTile(
      leading: CircleAvatar(child: Text(m.nama[0].toUpperCase())),
      title: Text(m.nama),
      subtitle: Text('${m.nim} • ${m.prodi}'),
      onTap: () => _bukaForm(m),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => _hapus(m),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pagedMahasiswaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Data Mahasiswa')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bukaForm(),
        child: const Icon(Icons.add),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(PagedMahasiswaState state) {
    // 1) Loading awal
    if (state.isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2) Error awal (belum ada data sama sekali)
    if (state.isInitialError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(friendlyErrorMessage(state.error!), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.read(pagedMahasiswaProvider.notifier).refresh(),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // 3) Empty (server berhasil dipanggil tapi tidak ada data)
    if (state.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => ref.read(pagedMahasiswaProvider.notifier).refresh(),
        child: ListView(
          children: const [
            SizedBox(height: 120),
            Center(child: Text('Belum ada data')),
          ],
        ),
      );
    }

    // 4) Success (dengan footer infinite scroll)
    return RefreshIndicator(
      onRefresh: () => ref.read(pagedMahasiswaProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.items.length + 1, // +1 untuk footer
        itemBuilder: (context, index) {
          if (index == state.items.length) {
            return _buildFooter(state);
          }
          return _buildItem(state.items[index]);
        },
      ),
    );
  }

  Widget _buildFooter(PagedMahasiswaState state) {
    if (state.error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(friendlyErrorMessage(state.error!), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.read(pagedMahasiswaProvider.notifier).loadNextPage(),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (!state.hasMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Semua data termuat.')),
      );
    }
    return const SizedBox.shrink();
  }
}
