import 'package:dio/dio.dart';

// Aturan: pengguna tidak boleh melihat pesan teknis mentah
// seperti "DioException [connection error]...".
String friendlyErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi lambat atau timeout. Periksa internet Anda lalu coba lagi.';
      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server. Periksa internet Anda.';
      case DioExceptionType.badResponse:
        return _pesanBadResponse(error);
      default:
        return 'Terjadi kesalahan jaringan. Coba lagi.';
    }
  }
  return 'Terjadi kesalahan tak terduga: $error';
}

String _pesanBadResponse(DioException error) {
  final status = error.response?.statusCode;
  final data = error.response?.data;
  String? pesanServer;
  if (data is Map && data['message'] is String) {
    pesanServer = data['message'] as String;
  }

  switch (status) {
    case 422:
      return pesanServer ?? 'Data yang dikirim tidak valid.';
    case 404:
      return 'Data tidak ditemukan (404).';
    case 401:
    case 403:
      return 'Akses ditolak ($status). Periksa kredensial Anda.';
    default:
      return pesanServer ?? 'Server bermasalah ($status). Coba lagi nanti.';
  }
}
