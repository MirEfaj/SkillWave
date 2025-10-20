// lib/services/course_progress_service.dart
import 'package:shared_preferences/shared_preferences.dart';

/// CourseProgressService
/// Stores enrollment (bool) and progress (double 0.0 - 1.0) per course and per format.
/// Key patterns:
///   enrolled_{courseId}_{format} -> bool
///   progress_{courseId}_{format}  -> double (0.0 .. 1.0)
class CourseProgressService {
  static String _enrolledKey(int courseId, String format) => 'enrolled_${courseId}_$format';
  static String _progressKey(int courseId, String format) => 'progress_${courseId}_$format';

  /// Enrolls the user in the course for a specific format (video/webpage).
  static Future<void> enroll(int courseId, String format) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_enrolledKey(courseId, format), true);
    // if no progress key exists, set it to 0.0
    if (!sp.containsKey(_progressKey(courseId, format))) {
      await sp.setDouble(_progressKey(courseId, format), 0.0);
    }
  }

  /// Unenroll (optionally reset progress).
  static Future<void> unenroll(int courseId, String format, {bool resetProgress = true}) async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_enrolledKey(courseId, format));
    if (resetProgress) {
      await sp.setDouble(_progressKey(courseId, format), 0.0);
    }
  }

  static Future<bool> isEnrolled(int courseId, String format) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_enrolledKey(courseId, format)) ?? false;
  }

  static Future<double> getProgress(int courseId, String format) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getDouble(_progressKey(courseId, format)) ?? 0.0;
  }

  /// Set absolute progress (0.0..1.0). Clamped.
  static Future<void> setProgress(int courseId, String format, double value) async {
    final sp = await SharedPreferences.getInstance();
    final v = value.clamp(0.0, 1.0);
    await sp.setDouble(_progressKey(courseId, format), v);
  }

  /// Increment progress by a step (e.g. 1 / totalLessons).
  static Future<void> incrementProgressBy(int courseId, String format, double step) async {
    final sp = await SharedPreferences.getInstance();
    final current = sp.getDouble(_progressKey(courseId, format)) ?? 0.0;
    final next = (current + step).clamp(0.0, 1.0);
    await sp.setDouble(_progressKey(courseId, format), next);
  }

  /// Helper to clear all keys for a course (useful for debugging)
  static Future<void> resetAllForCourse(int courseId) async {
    final sp = await SharedPreferences.getInstance();
    final keys = sp.getKeys().where((k) => k.startsWith('enrolled_${courseId}_') || k.startsWith('progress_${courseId}_')).toList();
    for (final k in keys) {
      await sp.remove(k);
    }
  }
}
