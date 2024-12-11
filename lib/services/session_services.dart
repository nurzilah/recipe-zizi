import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  // Simpan token ke SharedPreferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token); // Menyimpan token dengan key 'authToken'
  }

  // Ambil token dari SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken'); // Mengambil token dengan key 'authToken'
  }

  // Fungsi untuk logout (menghapus token)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken'); // Menghapus token dari SharedPreferences
  }

  // Fungsi untuk membersihkan semua data session (opsional)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Menghapus semua data dalam SharedPreferences
  }
}
