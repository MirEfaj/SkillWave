
import 'package:flutter/material.dart';
import '../services/course_progress_service.dart';

class WebPage extends StatefulWidget {
  final String title;
  final List<String> webpageUrls;
  final List<String> lectureTitle;
  final int courseId;

  const WebPage({
    super.key,
    required this.title,
    required this.webpageUrls,
    required this.courseId,
    required this.lectureTitle,
  });

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  final ScrollController _scrollController = ScrollController();
  late final List<GlobalKey> _sectionKeys;
  int _activeChapterIndex = 0;

  // Enrollment & progress
  bool _enrolled = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _sectionKeys = List.generate(widget.webpageUrls.length, (index) => GlobalKey());
    _scrollController.addListener(_onScroll);
    _loadEnrollmentAndProgress();
  }

  Future<void> _loadEnrollmentAndProgress() async {
    final enrolled = await CourseProgressService.isEnrolled(widget.courseId, 'webpage');
    final progress = await CourseProgressService.getProgress(widget.courseId, 'webpage');
    if (!mounted) return;
    setState(() {
      _enrolled = enrolled;
      _progress = progress;
    });
  }

  void _onScroll() {
    for (var i = 0; i < _sectionKeys.length; i++) {
      final key = _sectionKeys[i];
      final ctx = key.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox;
      final pos = box.localToGlobal(Offset.zero).dy;
      if (pos < 200) {
        if (_activeChapterIndex != i) {
          setState(() {
            _activeChapterIndex = i;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToSection(int index) async {
    final key = _sectionKeys[index];
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() {
      _activeChapterIndex = index;
    });
    Navigator.of(context).maybePop();
  }

  Future<void> _toggleEnrollment() async {
    if (_enrolled) {
      await CourseProgressService.unenroll(widget.courseId, 'webpage', resetProgress: true);
      setState(() {
        _enrolled = false;
        _progress = 0.0;
      });
    } else {
      await CourseProgressService.enroll(widget.courseId, 'webpage');
      final p = await CourseProgressService.getProgress(widget.courseId, 'webpage');
      setState(() {
        _enrolled = true;
        _progress = p;
      });
    }
  }

  Future<void> _markSectionComplete(int sectionIndex) async {
    if (!_enrolled) {
      final shouldEnroll = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enroll required'),
          content: const Text('You are not enrolled for this course. Enroll now to track progress?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('No')),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Enroll')),
          ],
        ),
      );
      if (shouldEnroll != true) return;
      await CourseProgressService.enroll(widget.courseId, 'webpage');
      setState(() => _enrolled = true);
    }

    final total = widget.webpageUrls.isEmpty ? 1 : widget.webpageUrls.length;
    final step = 1.0 / total;
    await CourseProgressService.incrementProgressBy(widget.courseId, 'webpage', step);
    final newProgress = await CourseProgressService.getProgress(widget.courseId, 'webpage');
    if (!mounted) return;
    setState(() => _progress = newProgress);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Section completed — progress ${(newProgress * 100).toStringAsFixed(0)}%')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use lecture titles directly for drawer
    final chapters = List.generate(
      widget.lectureTitle.length,
          (i) => 'Lecture ${i + 1}: ${widget.lectureTitle[i]}',
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu_open, color: Colors.black),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: 'Chapters',
            );
          }),
        ],
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Table of Contents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: chapters.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final active = index == _activeChapterIndex;
                      return ListTile(
                        title: Text(chapters[index],
                          style: TextStyle(
                              fontWeight: active ? FontWeight.bold : FontWeight.normal,
                              color: active ? Colors.indigo : Colors.black),
                        ),
                        tileColor: active ? Colors.indigo.shade50 : null,
                        onTap: () => _scrollToSection(index),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('Close'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enrollment & progress
            Row(
              children: [
                ElevatedButton(
                  onPressed: _toggleEnrollment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _enrolled ? Colors.grey.shade200 : Colors.indigo,
                    foregroundColor: _enrolled ? Colors.black : Colors.white,
                  ),
                  child: Text(_enrolled ? 'Enrolled' : 'Enroll'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(value: _progress, minHeight: 8),
                      const SizedBox(height: 6),
                      Text('${(_progress * 100).toStringAsFixed(0)}% completed', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Lecture sections
            ...List.generate(widget.webpageUrls.length, (index) => _buildChapterSection(index)),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterSection(int index) {
    final title = widget.lectureTitle[index];
    final content = '''
Welcome to ${title}! This section illustrates how to structure course content.
(Associated resource: ${widget.webpageUrls[index]})
''';

    return Container(
      key: _sectionKeys[index],
      margin: const EdgeInsets.only(bottom: 28),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.book, color: Colors.indigo)),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ]),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(fontSize: 15, height: 1.5)),
          const SizedBox(height: 12),
          const Text('Key Points:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _bullet('Understanding the fundamental concepts'),
          _bullet('Practical examples and use cases'),
          _bullet('Best practices and common pitfalls to avoid'),
          const SizedBox(height: 12),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: index > 0 ? () => _scrollToSection(index - 1) : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous Lecture'),
                ),
                Row(children: [
                  ElevatedButton.icon(
                    onPressed: () => _markSectionComplete(index),
                    icon: const Icon(Icons.check),
                    label: const Text('Mark Complete'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: index < widget.webpageUrls.length - 1 ? () => _scrollToSection(index + 1) : null,
                    icon: const Text('Next Lecture'),
                    label: const Icon(Icons.arrow_forward),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Text('•  '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}


