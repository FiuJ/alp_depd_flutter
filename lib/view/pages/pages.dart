import 'dart:async';
import 'dart:math' show Random, min;
import 'dart:ui' as ui;

import 'package:alp_depd_flutter/main.dart';
import 'package:alp_depd_flutter/model/model.dart';
import 'package:alp_depd_flutter/repository/friendRepository.dart';
import 'package:alp_depd_flutter/viewmodel/assignmentViewmodel.dart';
import 'package:alp_depd_flutter/viewmodel/journal_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:alp_depd_flutter/viewmodel/timerViewmodel.dart';
import 'package:alp_depd_flutter/repository/assignmentRepository.dart';
import 'package:alp_depd_flutter/shared/style.dart';
import 'package:alp_depd_flutter/viewmodel/auth_viewmodel.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// --- 1. IMPORT FILE MANDIRI (Agar file 'part' di bawah bisa mengenali class ini) ---
import 'profile_page.dart';
import 'update_profile_page.dart';
import 'other_user_profile_page.dart';
import 'users_list_page.dart';
import 'friendsPage.dart'; 

// --- 2. EXPORT FILE MANDIRI (Agar main.dart cukup import pages.dart) ---
export 'profile_page.dart';
export 'update_profile_page.dart';
export 'other_user_profile_page.dart';
export 'users_list_page.dart';
export 'friendsPage.dart'; // <-- Pastikan ini ada di sini

// --- 3. PARTS (File lama yang masih menggunakan "part of 'pages.dart'") ---
part 'home.dart';
part 'journal.dart';
// part 'profile.dart'; // <-- SUDAH BENAR DIHAPUS
part 'minigame.dart';
part 'wordlepage.dart';
part "memorygamepage.dart";
part 'summary.dart';
part 'journalHistory.dart';
part 'timerSettingsPage.dart';
part 'timerPage.dart';
part 'assignmentsListPage.dart';
part 'register_page.dart';
part 'login_page.dart';
part 'journal_detail.dart';
part 'assignmentFormPage.dart';
part 'assignmentDetailPage.dart';
part 'friendRequestPage.dart';
part 'friendDetailPage.dart';
// part 'friendsPage.dart'; // <-- SUDAH BENAR DIHAPUS (Karena sekarang file mandiri)
// part 'usersListPage.dart'; // <-- SUDAH BENAR DIHAPUS (Karena sekarang file mandiri)
part 'usersPage.dart';