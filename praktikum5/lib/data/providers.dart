import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';
import 'repositories/mahasiswa_repository.dart';

final dioProvider = Provider<Dio>((ref) => createDio());

final mahasiswaRepositoryProvider = Provider<MahasiswaRepository>(
  (ref) => MahasiswaRepository(ref.watch(dioProvider)),
);
