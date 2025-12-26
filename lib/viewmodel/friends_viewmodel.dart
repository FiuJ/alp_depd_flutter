// viewmodel/assignmentViewModel.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/friends_repository.dart';

class FriendsViewmodel with ChangeNotifier {
  final FriendsRepository _repo = FriendsRepository();
  bool _isLoading = false;

  // ADD THESE TWO LINES:
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  
}
