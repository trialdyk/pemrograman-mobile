import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/local/note.dart';
import '../providers/note_providers.dart';
import '../widgets/note_form_dialog.dart';

/// Halaman detail: membaca catatan langsung dari repository lokal
/// (noteByIdProvider), bukan dari state halaman list.
class NoteDetailPage extends ConsumerWidget {
  const NoteDetailPage({super.key, required this.id});

  final int id;

  Future<void> _edit(BuildContext context, WidgetRef ref, Note note) async {
    final result = await showDialog<NoteFormResult>(
      context: context,
      builder: (_) => NoteFormDialog(initial: note),
    );
    if (result == null) return;
    await ref.read(noteActionsProvider).update(
          note.copyWith(title: result.title, body: result.body),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsync = ref.watch(noteByIdProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail catatan'),
        actions: [
          if (noteAsync.value != null) ...[
            IconButton(
              tooltip: 'Ubah',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _edit(context, ref, noteAsync.value!),
            ),
            IconButton(
              tooltip: 'Hapus',
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                await ref.read(noteActionsProvider).delete(id);
                if (context.mounted) context.pop();
              },
            ),
          ],
        ],
      ),
      body: noteAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal membaca catatan: $e')),
        data: (note) {
          if (note == null) {
            return const Center(child: Text('Catatan tidak ditemukan'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(note.title,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    note.dirty ? Icons.cloud_off : Icons.cloud_done,
                    size: 16,
                    color: note.dirty ? Colors.orange : Colors.green,
                  ),
                  const SizedBox(width: 6),
                  Text(note.dirty ? 'Belum tersinkron' : 'Tersinkron'),
                  const Spacer(),
                  Text(note.updatedAt.toIso8601String()),
                ],
              ),
              const Divider(height: 32),
              Text(note.body.isEmpty ? '(tanpa isi)' : note.body),
            ],
          );
        },
      ),
    );
  }
}
