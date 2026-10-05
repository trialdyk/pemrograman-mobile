import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/mahasiswa.dart';
import 'providers.dart';

class PagedMahasiswaState {
  const PagedMahasiswaState({
    this.items = const [],
    this.page = 0,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
  });

  final List<Mahasiswa> items;
  final int page; // halaman terakhir yang berhasil dimuat
  final bool isLoadingMore;
  final bool hasMore;
  final Object? error;

  bool get isInitialLoading => page == 0 && isLoadingMore && items.isEmpty;
  bool get isInitialError => page == 0 && !isLoadingMore && error != null && items.isEmpty;
  bool get isEmpty => page > 0 && !isLoadingMore && items.isEmpty && error == null;
}

class PagedMahasiswaNotifier extends Notifier<PagedMahasiswaState> {
  static const _perPage = 10;

  @override
  PagedMahasiswaState build() {
    // Muat halaman pertama begitu provider dibuat
    Future.microtask(loadNextPage);
    return const PagedMahasiswaState();
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    final repo = ref.read(mahasiswaRepositoryProvider);
    final currentItems = state.items;
    final currentPage = state.page;

    state = PagedMahasiswaState(
      items: currentItems,
      page: currentPage,
      isLoadingMore: true,
      hasMore: state.hasMore,
    );

    try {
      final next = currentPage + 1;
      final result = await repo.fetchPage(page: next, perPage: _perPage);
      state = PagedMahasiswaState(
        items: [...currentItems, ...result.items],
        page: next,
        hasMore: result.hasMore,
      );
    } catch (e) {
      state = PagedMahasiswaState(
        items: currentItems,
        page: currentPage,
        hasMore: state.hasMore,
        error: e,
      );
    }
  }

  Future<void> refresh() async {
    state = const PagedMahasiswaState();
    await loadNextPage();
  }

  Future<void> hapus(int id) async {
    final repo = ref.read(mahasiswaRepositoryProvider);
    await repo.delete(id);
    state = PagedMahasiswaState(
      items: state.items.where((m) => m.id != id).toList(),
      page: state.page,
      hasMore: state.hasMore,
    );
  }
}

final pagedMahasiswaProvider =
    NotifierProvider<PagedMahasiswaNotifier, PagedMahasiswaState>(
  PagedMahasiswaNotifier.new,
);
