import 'dart:io';

import 'package:auth_flow_app/features/auth/data/datasources/storage_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageClientSupabase extends StorageClient {
  final SupabaseStorageClient _storageClient;

  StorageClientSupabase(this._storageClient);

  @override
  Future<String> uploadProfilePicture({required String filePath}) async {
    final exe = filePath.split('.').last;
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final storagePath = '$userId/avatar_${DateTime.now().millisecondsSinceEpoch}.$exe';

    final storage = _storageClient.from('avatars');
    await storage.upload(
      storagePath,
      File(filePath),
      fileOptions: const FileOptions(upsert: true),
    );

    return storage.getPublicUrl(storagePath);
  }
}
