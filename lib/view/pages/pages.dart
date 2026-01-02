import 'dart:async';
import 'dart:math' show Random, cos, min, sin;
import 'dart:ui' as ui;

import 'package:alp_depd_flutter/main.dart';
import 'package:alp_depd_flutter/model/model.dart';
import 'package:alp_depd_flutter/viewmodel/assignment_viewmodel.dart';
import 'package:alp_depd_flutter/viewmodel/bubble_game_viewmodel.dart';
import 'package:alp_depd_flutter/viewmodel/journal_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Ensure the casing here matches exactly what you have in main.dart
import 'package:alp_depd_flutter/viewmodel/timer_viewmodel.dart';
import 'package:alp_depd_flutter/model/assignment_model.dart';
import 'package:alp_depd_flutter/repository/assignment_repository.dart';
import 'package:alp_depd_flutter/shared/style.dart';
import 'package:alp_depd_flutter/viewmodel/auth_viewmodel.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

part 'home.dart';
part 'journal.dart';
part 'profile.dart';
part 'minigame.dart';
part 'wordle_page.dart';
part "memory_game_page.dart";
part 'summary.dart';
part 'journalHistory.dart';
part 'timer_settings_page.dart';
part 'timer_page.dart';
part 'assignments_list_page.dart';
part 'register_page.dart';
part 'login_page.dart';
part 'journal_detail.dart';
part 'assignment_form_page.dart';
part 'assignmentDetailPage.dart';
part 'bubble_game_page.dart';
