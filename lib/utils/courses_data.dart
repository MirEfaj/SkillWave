// lib/utils/courses_data.dart

import '../models/course_model.dart';

const List<Course> courses = [
  Course(
    id: 1,
    title: 'Flutter Development',
    description: 'Build beautiful cross-platform mobile apps with Flutter and Dart',
    lessons: '42 lessons',
    duration: '12 hours',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDEc7bbHEge7DfUAp-Eo1X6vB0h20Sbaw2X3DK5V80LOH1S_6A5E-qQLaXGjvtB_xCG24&usqp=CAU',
    videos: [
      'https://www.youtube.com/embed/1xipg02Wu8s',
      'https://www.youtube.com/embed/3kaGC_DrUnw',
      'https://www.youtube.com/embed/TclK5gNM_PM',
      'https://www.youtube.com/embed/56xvk6OHTpM&t=92s',
      'https://www.youtube.com/embed/eegl7of4g-o&t=388s',
    ],
    lectureTitle: [ "Introduction", "Dart Programming", "Flutter Dev", "API Integration", "Project 1", ],
    webpages: [
      'https://flutter.dev/docs',
      'https://dart.dev/guides',
      'https://flutter.dev/',
      'https://api.flutter.dev/',
      'https://docs.flutter.dev/get-started/codelab',
    ],
  ),
  Course(
    id: 2,
    title: 'Python Programming',
    description: 'Master Python from basics to advanced concepts and build real projects',
    lessons: '38 lessons',
    duration: '10 hours',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAVs3_JJYZ0OYWfWS-YJjWnytd7sUr_nTA6w&s',
    videos: [
      'https://youtu.be/python1',
      'https://youtu.be/python2',
    ],
    webpages: [
      'https://www.python.org/doc/',
      'https://realpython.com/',
    ],
    lectureTitle: ["Introduction", "Basic Programming"],
  ),
  Course(
    id: 3,
    title: 'MERN Stack',
    description: 'Build efficient and scalable web applications',
    lessons: '42 lessons',
    duration: '12 hours',
    image: 'https://cdn.hashnode.com/res/hashnode/image/upload/v1629412549688/UzB4CvEln.jpeg?w=1600&h=840&fit=crop&crop=entropy&auto=compress,format&format=webp',
    videos: [
      'https://www.youtube.com/embed/1xipg02Wu8s',
      'https://www.youtube.com/embed/3kaGC_DrUnw',
    ],
    webpages: [
      'https://flutter.dev/docs',
      'https://dart.dev/guides',
    ],
    lectureTitle: ["Introduction", "Basic Programming"],
  ),
  Course(
    id: 4,
    title: 'UI/UX Design',
    description: 'Learn user interface and experience design principles and tools',
    lessons: '28 lessons',
    duration: '8 hours',
    image: 'https://s3-alpha.figma.com/hub/file/5981008112/1693dcf9-d07a-45d0-89aa-974e605f49f2-cover.png',
    videos: [
      'https://youtu.be/uiux1',
      'https://youtu.be/uiux2',
    ],
    webpages: [
      'https://www.interaction-design.org/',
      'https://uxdesign.cc/',
    ],
    lectureTitle: ["Introduction", "Basic Programming"],
  ),
];
