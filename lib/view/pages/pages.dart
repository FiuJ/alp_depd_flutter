import 'dart:async';
import 'dart:math' show Random, min;
import 'dart:ui' as ui;

import 'package:alp_depd_flutter/main.dart';
import 'package:alp_depd_flutter/model/model.dart';
import 'package:alp_depd_flutter/viewmodel/assignmentViewmodel.dart';
import 'package:alp_depd_flutter/viewmodel/bubble_game_viewmodel.dart' show BubbleGameViewModel;
import 'package:alp_depd_flutter/viewmodel/journal_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Ensure the casing here matches exactly what you have in main.dart
import 'package:alp_depd_flutter/viewmodel/timerViewmodel.dart';
import 'package:alp_depd_flutter/model/assignmentModel.dart';
import 'package:alp_depd_flutter/repository/assignmentRepository.dart';
import 'package:alp_depd_flutter/shared/style.dart';
import 'package:alp_depd_flutter/viewmodel/auth_viewmodel.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; 

part 'home.dart';
part 'journal.dart';
part 'profile.dart';
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
part 'bubble_game_page.dart';