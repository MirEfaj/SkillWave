
import '../models/course_model.dart';

const List<Course> courses = [
  Course(
    id: 1,
    title: 'Flutter Development',
    description: 'Build beautiful cross-platform mobile apps with Flutter and Dart.',
    lessons: '42 lessons',
    duration: '12 hours',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDEc7bbHEge7DfUAp-Eo1X6vB0h20Sbaw2X3DK5V80LOH1S_6A5E-qQLaXGjvtB_xCG24&usqp=CAU',
    videos: [
      'https://www.youtube.com/embed/1xipg02Wu8s',
      'https://www.youtube.com/embed/3kaGC_DrUnw',
      'https://www.youtube.com/embed/TclK5gNM_PM',
      'https://www.youtube.com/embed/56xvk6OHTpM',
      'https://www.youtube.com/embed/eegl7of4g-o',
    ],
    // videos: [
    //   (title: "Dart Basics", videoUrl: 'https://www.youtube.com/embed/3kaGC_DrUnw',),
    //   (title: "Dart intermediate", videoUrl: 'https://www.youtube.com/embed/3kaGC_DrUnw',),
    //   (title: "Dart Advance", videoUrl: 'https://www.youtube.com/embed/3kaGC_DrUnw',),
    // ],
    // webpages: [
    //   (title: "Dart language", webUrl: 'https://flutter.dev/docs',),
    //   (title: "Dart oop", webUrl: 'https://dart.dev/guides',),
    //   (title: "Dart Basics", webUrl: 'https://docs.flutter.dev/ui',),
    // ],
    lectureTitle: [
      "Introduction to Flutter",
      "Dart Basics",
      "Building Layouts",
      "State Management with GetX",
      "Deploying Your App"
    ],
    webpages: [
      'https://flutter.dev/docs',
      'https://dart.dev/guides',
      'https://docs.flutter.dev/ui',
      'https://api.flutter.dev/',
      'https://docs.flutter.dev/get-started/codelab',
    ],
  ),

  Course(
    id: 2,
    title: 'Python Programming',
    description: 'Master Python from beginner to advanced and build automation projects.',
    lessons: '38 lessons',
    duration: '10 hours',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAVs3_JJYZ0OYWfWS-YJjWnytd7sUr_nTA6w&s',
    videos: [
      'https://www.youtube.com/embed/_uQrJ0TkZlc',
      'https://www.youtube.com/embed/rfscVS0vtbw',
    ],
    webpages: [
      'https://www.python.org/doc/',
      'https://realpython.com/',
      'https://docs.python.org/3/tutorial/',
    ],
    lectureTitle: [
      "Introduction to Python",
      "Data Types and Variables",
      "Functions & Loops",
      "File Handling",
      "Mini Projects"
    ],
  ),

  Course(
    id: 3,
    title: 'MERN Stack Development',
    description: 'Learn MongoDB, Express, React, and Node.js to build full-stack web apps.',
    lessons: '45 lessons',
    duration: '14 hours',
    image: 'https://cdn.hashnode.com/res/hashnode/image/upload/v1629412549688/UzB4CvEln.jpeg?w=1600&h=840&fit=crop&crop=entropy&auto=compress,format&format=webp',
    videos: [
      'https://www.youtube.com/embed/7CqJlxBYj-M',
      'https://www.youtube.com/embed/L72fhGm1tfE',
    ],
    webpages: [
      'https://react.dev/',
      'https://nodejs.org/en/docs',
      'https://www.mongodb.com/docs/',
      'https://expressjs.com/en/starter/installing.html',
    ],
    lectureTitle: [
      "MERN Overview",
      "Node & Express Setup",
      "React Fundamentals",
      "MongoDB Integration",
      "Deploying MERN App"
    ],
  ),

  Course(
    id: 4,
    title: 'UI/UX Design',
    description: 'Learn design thinking, wireframing, and prototyping using Figma.',
    lessons: '28 lessons',
    duration: '8 hours',
    image: 'https://tse2.mm.bing.net/th/id/OIP.X7NkbaUSo-AXNNNaXPybSgHaEK?pid=Api&P=0&h=220',
    videos: [
      'https://www.youtube.com/embed/c9Wg6Cb_YlU',
      'https://www.youtube.com/embed/3tG1jU2jw08',
    ],
    webpages: [
      'https://www.interaction-design.org/',
      'https://uxdesign.cc/',
      'https://www.figma.com/resources/learn-design/',
    ],
    lectureTitle: [
      "Introduction to UX",
      "Design Tools (Figma)",
      "Wireframes & Mockups",
      "Color Theory & Typography",
      "User Testing"
    ],
  ),

  Course(
    id: 5,
    title: 'Machine Learning with Python',
    description: 'Understand ML algorithms, data preprocessing, and model evaluation using Python.',
    lessons: '40 lessons',
    duration: '15 hours',
    image: 'https://tse4.mm.bing.net/th/id/OIP.1t6zNz6gnRfsF2VWXlNw7wHaD_?pid=Api&P=0&h=220',
    videos: [
      'https://www.youtube.com/embed/GwIo3gDZCVQ',
      'https://www.youtube.com/embed/i_LwzRVP7bg',
    ],
    webpages: [
      'https://scikit-learn.org/stable/',
      'https://pandas.pydata.org/docs/',
      'https://numpy.org/doc/',
    ],
    lectureTitle: [
      "Introduction to ML",
      "Data Preprocessing",
      "Supervised Learning",
      "Model Evaluation",
      "Capstone Project"
    ],
  ),

  Course(
    id: 6,
    title: 'React Native Development',
    description: 'Create powerful cross-platform apps using React Native and Expo.',
    lessons: '35 lessons',
    duration: '11 hours',
    image: 'https://tse1.mm.bing.net/th/id/OIP.CBhkGTVPtTxG6L5j61sSLAHaDz?pid=Api&P=0&h=220',
    videos: [
      'https://www.youtube.com/embed/0-S5a0eXPoc',
      'https://www.youtube.com/embed/0kL6nhutjQ8',
    ],
    webpages: [
      'https://reactnative.dev/docs/getting-started',
      'https://docs.expo.dev/',
    ],
    lectureTitle: [
      "Getting Started with React Native",
      "Expo Basics",
      "Navigation & Components",
      "APIs & Storage",
      "Publishing Your App"
    ],
  ),

  Course(
    id: 7,
    title: 'Data Science Fundamentals',
    description: 'Learn data visualization, analysis, and insights using Python libraries.',
    lessons: '37 lessons',
    duration: '13 hours',
    image: 'https://tse4.mm.bing.net/th/id/OIP.ZLbB5YMM1YWrWdTtEI_wUAHaEK?pid=Api&P=0&h=220',
    videos: [
      'https://www.youtube.com/embed/ua-CiDNNj30',
      'https://www.youtube.com/embed/r-uOLxNrNk8',
    ],
    webpages: [
      'https://www.kaggle.com/learn',
      'https://matplotlib.org/stable/users/index.html',
      'https://seaborn.pydata.org/',
    ],
    lectureTitle: [
      "Introduction to Data Science",
      "Data Wrangling",
      "Data Visualization",
      "Exploratory Data Analysis",
      "Machine Learning Intro"
    ],
  ),

  Course(
    id: 8,
    title: 'Cybersecurity Basics',
    description: 'Understand digital security, encryption, and ethical hacking concepts.',
    lessons: '25 lessons',
    duration: '9 hours',
    image: 'https://tse1.mm.bing.net/th/id/OIP.9ukuR9-7v_kFbaPXrw-hsAHaEH?pid=Api&P=0&h=220',
    videos: [
      'https://www.youtube.com/embed/inWWhr5tnEA',
      'https://www.youtube.com/embed/bPVaOlJ6ln0',
    ],
    webpages: [
      'https://www.cybrary.it/',
      'https://www.kaspersky.com/resource-center',
    ],
    lectureTitle: [
      "What is Cybersecurity?",
      "Common Threats",
      "Encryption Basics",
      "Network Security",
      "Ethical Hacking"
    ],
  ),

  Course(
    id: 9,
    title: 'Java Programming',
    description: 'Learn Java from scratch and understand object-oriented programming deeply.',
    lessons: '33 lessons',
    duration: '10 hours',
    image: 'https://tse3.mm.bing.net/th/id/OIP.FGPNqiVAuDvnHEMk8S5wiwHaEK?pid=Api&P=0&h=220',
    videos: [
      'https://www.youtube.com/embed/grEKMHGYyns',
      'https://www.youtube.com/embed/eIrMbAQSU34',
    ],
    webpages: [
      'https://docs.oracle.com/en/java/',
      'https://www.javatpoint.com/java-tutorial',
    ],
    lectureTitle: [
      "Introduction to Java",
      "OOP Concepts",
      "Data Structures in Java",
      "File I/O",
      "Mini Project"
    ],
  ),

  Course(
    id: 10,
    title: 'Cloud Computing (AWS)',
    description: 'Learn to build, deploy, and scale apps using AWS cloud infrastructure.',
    lessons: '32 lessons',
    duration: '9 hours',
    image: 'https://cmg-cmg-tv-10020-prod.cdn.arcpublishing.com/resizer/v2/7WMUL6SDLBD43LIL6V6HTB2C7E.jpg?smart=true&auth=94dd91ddbd2b802eb3ffa61b035d4d3f5c71abd12c5473086ccbe26ed5a1551c&width=1600&height=900',
    videos: [
      'https://www.youtube.com/embed/lrn2O7r4ZJU',
      'https://www.youtube.com/embed/ulprqHHWlng',
    ],
    webpages: [
      'https://aws.amazon.com/getting-started/',
      'https://docs.aws.amazon.com/',
    ],
    lectureTitle: [
      "Introduction to Cloud",
      "AWS Core Services",
      "S3 & EC2 Setup",
      "IAM & Security",
      "Deployment Example"
    ],
  ),
];
