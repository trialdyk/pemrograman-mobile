import 'package:dio/dio.dart';
import '../models/mahasiswa.dart';

class PagedResult {
  const PagedResult({required this.items, required this.hasMore});
  final List<Mahasiswa> items;
  final bool hasMore;
}

class MahasiswaRepository {
  MahasiswaRepository(this._dio);
  final Dio _dio;

  Future<PagedResult> fetchPage({required int page, int perPage = 10}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/mahasiswa',
      queryParameters: {'page': page, 'per_page': perPage},
    );

    final body = res.data ?? const {};
    final rawList = body['data'];
    final items = (rawList is List ? rawList : const [])
        .whereType<Map<String, dynamic>>()
        .map(Mahasiswa.fromJson)
        .toList();

    final currentPage = (body['current_page'] as num?)?.toInt();
    final lastPage = (body['last_page'] as num?)?.toInt();
    final hasMore = (currentPage != null && lastPage != null)
        ? currentPage < lastPage
        : items.length == perPage;

    return PagedResult(items: items, hasMore: hasMore);
  }

  Future<Mahasiswa> create(Mahasiswa m) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/mahasiswa',
      data: m.toJson(),
    );
    return Mahasiswa.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  Future<Mahasiswa> update(int id, Mahasiswa m) async {
    final res = await _dio.put<Map<String, dynamic>>(
      '/mahasiswa/$id',
      data: m.toJson(),
    );
    return Mahasiswa.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    await _dio.delete('/mahasiswa/$id');
  }
}
