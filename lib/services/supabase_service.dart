import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final String id;
  final String email;
  final String? address;
  final String? phoneNumber;
  final int? age;
  final String? notes;

  UserData({
    required this.id,
    required this.email,
    this.address,
    this.phoneNumber,
    this.age,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'address': address,
        'phone_number': phoneNumber,
        'age': age,
        'notes': notes,
      };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'].toString(),
        email: json['email'],
        address: json['address'],
        phoneNumber: json['phone_number'],
        age: json['age'],
        notes: json['notes'],
      );
}

class SupabaseService extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserData? _userData;

  UserData? get userData => _userData;

  Future<void> createUserData(UserData data) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw Exception('No authenticated user found');
      }

      final userData = {
        'id': firebaseUser.uid,
        'email': data.email,
        'address': data.address,
        'phone_number': data.phoneNumber,
        'age': data.age,
        'notes': data.notes,
      };

      await _client.from('user_data').upsert(userData);
      _userData = data;
      notifyListeners();
    } catch (e) {
      debugPrint('Error creating user data: $e');
      rethrow;
    }
  }

  Future<UserData?> fetchUserData(String userId) async {
    try {
      final response = await _client
          .from('user_data')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        _userData = null;
        return null;
      }

      _userData = UserData.fromJson(response);
      return _userData;
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      _userData = null;
      return null;
    }
  }

  Future<void> updateUserData(UserData data) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw Exception('No authenticated user found');
      }

      await _client
          .from('user_data')
          .update(data.toJson())
          .eq('id', firebaseUser.uid);
      _userData = data;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user data: $e');
      rethrow;
    }
  }

  Future<void> deleteUserData(String userId) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw Exception('No authenticated user found');
      }

      await _client.from('user_data').delete().eq('id', userId);
      _userData = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting user data: $e');
      rethrow;
    }
  }
}
