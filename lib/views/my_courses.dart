import 'package:flutter/material.dart';
import '../widgets/appBar.dart';
import '../widgets/gradient_background.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  static const String name = 'my-courses';

  // Sample courses data
  final List<Map<String, String>> courses = const [
    {
      "title": "Flutter for Beginners",
      "subtitle": "Start building apps in Flutter",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDEc7bbHEge7DfUAp-Eo1X6vB0h20Sbaw2X3DK5V80LOH1S_6A5E-qQLaXGjvtB_xCG24&usqp=CAU"
    },
    {
      "title": "Python Programming",
      "subtitle": "Deep dive into Python language",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAVs3_JJYZ0OYWfWS-YJjWnytd7sUr_nTA6w&s"
    },
    {
      "title": "Firebase Integration",
      "subtitle": "Learn to connect apps with Firebase",
      "image": "https://media2.dev.to/dynamic/image/width=1000,height=420,fit=cover,gravity=auto,format=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fi%2F1dicbsdszn7h1gcmw30y.jpg"
    },

  ];

  // Build a single course card
  Widget _buildCourseCard(Map<String, String> course) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(course["image"]!, width: 80, height: 80, fit: BoxFit.cover,),
        ),
        title: Text(course["title"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
        subtitle: Text(course["subtitle"]!),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {
          // TODO: Navigate to course detail page
          print('Tapped on ${course["title"]}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(appBarTitle: 'My Courses',),
      body: GradientBackground(
        child: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return _buildCourseCard(courses[index]);
          },
        ),
      ),
    );
  }
}
