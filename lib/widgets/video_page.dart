// lib/widgets/video_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';
import '../services/course_progress_service.dart'; // Your progress service

class VideoPage extends StatefulWidget {
  final String title;
  final List<String> videoUrls;
  final List<String> lectureTitle;
  final int courseId;

  const VideoPage({
    super.key,
    required this.title,
    required this.videoUrls,
    required this.courseId,
    required this.lectureTitle,
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with WidgetsBindingObserver {
  late YoutubePlayerController _ytController;
  int _selectedIndex = 0;

  bool _enrolled = false;
  double _progress = 0.0; // 0.0 .. 1.0

  bool _isLandscape = false; // Track orientation

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize YouTube controller
    final firstVideoId = _extractYoutubeId(
        widget.videoUrls.isNotEmpty ? widget.videoUrls[0] : '');
    _ytController = YoutubePlayerController(
      initialVideoId: firstVideoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    // Load enrollment & progress
    _loadEnrollmentAndProgress();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ytController.dispose();
    _exitFullScreen(); // Reset to portrait on exit
    super.dispose();
  }

  // Listen to orientation changes
  @override
  void didChangeMetrics() {
    final orientation = MediaQuery.of(context).orientation;
    setState(() {
      _isLandscape = orientation == Orientation.landscape;
    });
    super.didChangeMetrics();
  }

  // Convert YouTube URL to video ID
  String? _extractYoutubeId(String url) {
    try {
      final id = YoutubePlayer.convertUrlToId(url);
      return id;
    } catch (_) {
      return null;
    }
  }

  // Load enrollment & progress state
  Future<void> _loadEnrollmentAndProgress() async {
    final enrolled =
    await CourseProgressService.isEnrolled(widget.courseId, 'video');
    final progress =
    await CourseProgressService.getProgress(widget.courseId, 'video');
    if (!mounted) return;
    setState(() {
      _enrolled = enrolled;
      _progress = progress;
    });
  }

  // Toggle enrollment
  Future<void> _toggleEnrollment() async {
    if (_enrolled) {
      await CourseProgressService.unenroll(widget.courseId, 'video',
          resetProgress: true);
      setState(() {
        _enrolled = false;
        _progress = 0.0;
      });
    } else {
      await CourseProgressService.enroll(widget.courseId, 'video');
      setState(() {
        _enrolled = true;
      });
      final progress =
      await CourseProgressService.getProgress(widget.courseId, 'video');
      if (!mounted) return;
      setState(() => _progress = progress);
    }
  }

  // Mark lesson complete
  Future<void> _markLessonComplete() async {
    if (!_enrolled) {
      final shouldEnroll = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enroll required'),
          content: const Text(
              'You are not enrolled for this course. Enroll now to track progress?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Enroll')),
          ],
        ),
      );

      if (shouldEnroll != true) return;
      await CourseProgressService.enroll(widget.courseId, 'video');
      setState(() => _enrolled = true);
    }

    final total = widget.videoUrls.isEmpty ? 1 : widget.videoUrls.length;
    final step = 1.0 / total;
    await CourseProgressService.incrementProgressBy(
        widget.courseId, 'video', step);
    final newProgress =
    await CourseProgressService.getProgress(widget.courseId, 'video');
    if (!mounted) return;
    setState(() => _progress = newProgress);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Lesson completed — progress ${(newProgress * 100).toStringAsFixed(0)}%')),
    );
  }

  // Play video at specific index
  void _openVideoAtIndex(int index) async {
    final url = widget.videoUrls[index];
    final videoId = _extractYoutubeId(url);

    setState(() {
      _selectedIndex = index;
    });

    if (videoId != null && videoId.isNotEmpty) {
      _ytController.load(videoId);
      _ytController.play();
      _enterFullScreen(); // Go fullscreen on play
    } else {
      final uri = Uri.tryParse(url);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open video URL')),
        );
      }
    }
  }

  // Enter landscape fullscreen
  Future<void> _enterFullScreen() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  // Exit fullscreen (portrait)
  Future<void> _exitFullScreen() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    final firstId =
    _extractYoutubeId(widget.videoUrls.isNotEmpty ? widget.videoUrls[0] : '');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isLandscape
          ? null
          : AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLandscape
          ? YoutubePlayerBuilder(
        player: YoutubePlayer(controller: _ytController),
        builder: (context, player) {
          // Full screen player in landscape
          return SizedBox.expand(child: player);
        },
      )
          : Column(
        children: [
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 220,
            child: firstId == null
                ? Center(
              child: Text(
                'No embeddable YouTube video found.\nTap a video below to open it.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.9)),
              ),
            )
                : YoutubePlayer(
              controller: _ytController,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.redAccent,
            ),
          ),
          // Enrollment & progress row
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _toggleEnrollment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    _enrolled ? Colors.grey.shade200 : Colors.indigo,
                    foregroundColor:
                    _enrolled ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(_enrolled ? 'Enrolled' : 'Enroll'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: _progress,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 6),
                      Text('${(_progress * 100).toStringAsFixed(0)}% completed',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _markLessonComplete,
                  icon: const Icon(Icons.check),
                  label: const Text('Mark Complete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.withAlpha(5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Lessons header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Course Lessons',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${widget.videoUrls.length} lessons',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Lesson list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: widget.videoUrls.length,
              itemBuilder: (context, index) {
                final lectureTitle = widget.lectureTitle[index];
                final selected = index == _selectedIndex;

                return GestureDetector(
                  onTap: () => _openVideoAtIndex(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                      selected ? Colors.indigo.shade50 : Colors.white,
                      border: Border.all(
                          color: selected
                              ? Colors.indigo
                              : Colors.grey.shade300,
                          width: selected ? 1.6 : 1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? Colors.indigo
                                : Colors.grey.shade200,
                          ),
                          child: Icon(Icons.play_arrow,
                              color:
                              selected ? Colors.white : Colors.black54),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Lesson ${index + 1}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selected
                                          ? Colors.indigo
                                          : Colors.black87)),
                              const SizedBox(height: 6),
                              Text(lectureTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (selected)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Playing',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.green)),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

