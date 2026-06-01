class Question {
  final String category;
  final String question;
  final List<String> options;
  final int correctIndex;
  final int points;

  const Question({
    required this.category,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.points = 15,
  });
}

class QuizResult {
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final Duration timeTaken;
  final String category;

  const QuizResult({
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTaken,
    required this.category,
  });
}

class QuizCategory {
  final String name;
  final String icon;
  final List<Question> questions;

  const QuizCategory({
    required this.name,
    required this.icon,
    required this.questions,
  });
}

// ─── Question Bank ───────────────────────────────────────────────────────────

class QuizBank {
  static const List<Question> scienceQuestions = [
    Question(
      category: 'SCIENCE & TECH',
      question: 'Which theoretical particle is hypothesized to travel faster than the speed of light?',
      options: ['Neutrino', 'Tachyon', 'Quark', 'Graviton'],
      correctIndex: 1,
      points: 15,
    ),
    Question(
      category: 'SCIENCE & TECH',
      question: 'What is the chemical symbol for gold?',
      options: ['Go', 'Gd', 'Au', 'Ag'],
      correctIndex: 2,
      points: 10,
    ),
    Question(
      category: 'SCIENCE & TECH',
      question: 'Which planet has the most moons?',
      options: ['Jupiter', 'Saturn', 'Uranus', 'Neptune'],
      correctIndex: 1,
      points: 15,
    ),
    Question(
      category: 'SCIENCE & TECH',
      question: 'What does DNA stand for?',
      options: [
        'Deoxyribonucleic Acid',
        'Dinitrogen Acid',
        'Dynamic Nuclear Atom',
        'Dual Neutron Arrangement'
      ],
      correctIndex: 0,
      points: 10,
    ),
    Question(
      category: 'SCIENCE & TECH',
      question: 'What is the speed of light in km/s (approximately)?',
      options: ['150,000', '300,000', '500,000', '1,000,000'],
      correctIndex: 1,
      points: 20,
    ),
    Question(
      category: 'SCIENCE & TECH',
      question: 'Which element has the atomic number 1?',
      options: ['Helium', 'Oxygen', 'Carbon', 'Hydrogen'],
      correctIndex: 3,
      points: 10,
    ),
    Question(
      category: 'SCIENCE & TECH',
      question: 'What is the powerhouse of the cell?',
      options: ['Nucleus', 'Ribosome', 'Mitochondria', 'Golgi Body'],
      correctIndex: 2,
      points: 10,
    ),
    Question(
      category: 'SCIENCE & TECH',
      question: 'What programming language was created by James Gosling?',
      options: ['Python', 'C++', 'Java', 'JavaScript'],
      correctIndex: 2,
      points: 15,
    ),
    Question(
      category: 'SCIENCE & TECH',
      question: 'How many bits are in a byte?',
      options: ['4', '8', '16', '32'],
      correctIndex: 1,
      points: 10,
    ),
    Question(
      category: 'SCIENCE & TECH',
      question: 'What does HTTP stand for?',
      options: [
        'HyperText Transfer Protocol',
        'High Tech Transfer Process',
        'Hybrid Text Transmission Protocol',
        'Home Tool Transfer Platform'
      ],
      correctIndex: 0,
      points: 10,
    ),
  ];

  static const List<Question> historyQuestions = [
    Question(
      category: 'HISTORY',
      question: 'In which year did World War II end?',
      options: ['1943', '1944', '1945', '1946'],
      correctIndex: 2,
      points: 10,
    ),
    Question(
      category: 'HISTORY',
      question: 'Who was the first President of the United States?',
      options: ['Thomas Jefferson', 'Abraham Lincoln', 'George Washington', 'John Adams'],
      correctIndex: 2,
      points: 10,
    ),
    Question(
      category: 'HISTORY',
      question: 'The Great Wall of China was primarily built to protect against invasions from which group?',
      options: ['Romans', 'Mongols', 'Persians', 'Vikings'],
      correctIndex: 1,
      points: 15,
    ),
    Question(
      category: 'HISTORY',
      question: 'Which ancient civilization built the pyramids of Giza?',
      options: ['Greeks', 'Romans', 'Egyptians', 'Mesopotamians'],
      correctIndex: 2,
      points: 10,
    ),
    Question(
      category: 'HISTORY',
      question: 'Who discovered America in 1492?',
      options: ['Vasco da Gama', 'Ferdinand Magellan', 'Christopher Columbus', 'Amerigo Vespucci'],
      correctIndex: 2,
      points: 10,
    ),
    Question(
      category: 'HISTORY',
      question: 'Which empire was ruled by Genghis Khan?',
      options: ['Roman Empire', 'Ottoman Empire', 'Mongol Empire', 'Persian Empire'],
      correctIndex: 2,
      points: 15,
    ),
    Question(
      category: 'HISTORY',
      question: 'The French Revolution began in which year?',
      options: ['1776', '1789', '1799', '1804'],
      correctIndex: 1,
      points: 15,
    ),
    Question(
      category: 'HISTORY',
      question: 'Who painted the Mona Lisa?',
      options: ['Michelangelo', 'Leonardo da Vinci', 'Raphael', 'Donatello'],
      correctIndex: 1,
      points: 10,
    ),
    Question(
      category: 'HISTORY',
      question: 'Which country was the first to land a man on the Moon?',
      options: ['Russia', 'USA', 'China', 'France'],
      correctIndex: 1,
      points: 10,
    ),
    Question(
      category: 'HISTORY',
      question: 'The Titanic sank in which year?',
      options: ['1905', '1910', '1912', '1920'],
      correctIndex: 2,
      points: 10,
    ),
  ];

  static const List<Question> popCultureQuestions = [
    Question(
      category: 'POP CULTURE',
      question: 'Which movie franchise features a character named "Darth Vader"?',
      options: ['Star Trek', 'Star Wars', 'Guardians of the Galaxy', 'Dune'],
      correctIndex: 1,
      points: 10,
    ),
    Question(
      category: 'POP CULTURE',
      question: 'Who is the lead singer of the band "Queen"?',
      options: ['Mick Jagger', 'Freddie Mercury', 'David Bowie', 'Elton John'],
      correctIndex: 1,
      points: 10,
    ),
    Question(
      category: 'POP CULTURE',
      question: 'Which video game features a plumber named Mario?',
      options: ['Sonic', 'Zelda', 'Super Mario Bros', 'Mega Man'],
      correctIndex: 2,
      points: 10,
    ),
    Question(
      category: 'POP CULTURE',
      question: 'Which TV show features dragons and the Iron Throne?',
      options: ['Lord of the Rings', 'Game of Thrones', 'The Witcher', 'Vikings'],
      correctIndex: 1,
      points: 10,
    ),
    Question(
      category: 'POP CULTURE',
      question: 'What is the best-selling video game of all time?',
      options: ['Tetris', 'Minecraft', 'GTA V', 'Wii Sports'],
      correctIndex: 1,
      points: 15,
    ),
    Question(
      category: 'POP CULTURE',
      question: 'Which artist released the album "Thriller"?',
      options: ['Prince', 'Michael Jackson', 'Whitney Houston', 'Madonna'],
      correctIndex: 1,
      points: 10,
    ),
    Question(
      category: 'POP CULTURE',
      question: 'In the Harry Potter series, what is the name of Harry\'s owl?',
      options: ['Errol', 'Pigwidgeon', 'Hedwig', 'Scabbers'],
      correctIndex: 2,
      points: 10,
    ),
    Question(
      category: 'POP CULTURE',
      question: 'Which superhero is known as the "Dark Knight"?',
      options: ['Superman', 'Spider-Man', 'Batman', 'Iron Man'],
      correctIndex: 2,
      points: 10,
    ),
    Question(
      category: 'POP CULTURE',
      question: 'What year was the first iPhone released?',
      options: ['2005', '2006', '2007', '2008'],
      correctIndex: 2,
      points: 15,
    ),
    Question(
      category: 'POP CULTURE',
      question: 'Which streaming service created the show "Stranger Things"?',
      options: ['Hulu', 'Amazon Prime', 'Netflix', 'Disney+'],
      correctIndex: 2,
      points: 10,
    ),
  ];

  static const List<Question> indianCinemaQuestions = [
    Question(
      category: 'INDIAN CINEMA',
      question: 'Who is known as the "Father of Indian Cinema"?',
      options: ['Satyajit Ray', 'Dadasaheb Phalke', 'Raj Kapoor', 'Bimal Roy'],
      correctIndex: 1,
    ),
    Question(
      category: 'INDIAN CINEMA',
      question: 'Which was the first Indian sound film (talkie)?',
      options: ['Raja Harishchandra', 'Alam Ara', 'Devdas', 'Sholay'],
      correctIndex: 1,
    ),
    Question(
      category: 'INDIAN CINEMA',
      question: 'Which movie won the Academy Award for Best Original Song for "Naatu Naatu"?',
      options: ['Baahubali', 'RRR', 'Lagaan', 'Slumdog Millionaire'],
      correctIndex: 1,
    ),
    Question(
      category: 'INDIAN CINEMA',
      question: 'Who directed the classic movie "Sholay"?',
      options: ['Yash Chopra', 'Gopal Krishan', 'Ramesh Sippy', 'Sanjay Leela Bhansali'],
      correctIndex: 2,
    ),
    Question(
      category: 'INDIAN CINEMA',
      question: 'Which actress played the lead role in "Queen" (2014)?',
      options: ['Kangana Ranaut', 'Deepika Padukone', 'Priyanka Chopra', 'Kareena Kapoor'],
      correctIndex: 0,
    ),
    Question(
      category: 'INDIAN CINEMA',
      question: 'Who composed the music for "Roza"?',
      options: ['A.R. Rahman', 'Ilayaraja', 'Shankar-Ehsaan-Loy', 'Anirudh'],
      correctIndex: 0,
    ),
    Question(
      category: 'INDIAN CINEMA',
      question: 'Which movie features the dialogue "Kitne aadmi the?"',
      options: ['Deewaar', 'Sholay', 'Don', 'Mughal-e-Azam'],
      correctIndex: 1,
    ),
    Question(
      category: 'INDIAN CINEMA',
      question: 'The film "3 Idiots" is based on a book by which author?',
      options: ['Amish Tripathi', 'Chetan Bhagat', 'Arundhati Roy', 'Salman Rushdie'],
      correctIndex: 1,
    ),
    Question(
      category: 'INDIAN CINEMA',
      question: 'Which actor is famously known as the "King of Bollywood"?',
      options: ['Salman Khan', 'Aamir Khan', 'Shah Rukh Khan', 'Akshay Kumar'],
      correctIndex: 2,
    ),
    Question(
      category: 'INDIAN CINEMA',
      question: 'Who directed "Gangs of Wasseypur"?',
      options: ['Anurag Kashyap', 'Rajkumar Hirani', 'Karan Johar', 'Zoya Akhtar'],
      correctIndex: 0,
    ),
  ];

  static const List<Question> mathsQuestions = [
    Question(
      category: 'MATHS',
      question: 'What is the value of Pi to two decimal places?',
      options: ['3.12', '3.14', '3.16', '3.18'],
      correctIndex: 1,
    ),
    Question(
      category: 'MATHS',
      question: 'What is the square root of 144?',
      options: ['10', '12', '14', '16'],
      correctIndex: 1,
    ),
    Question(
      category: 'MATHS',
      question: 'What is 15% of 200?',
      options: ['20', '30', '40', '50'],
      correctIndex: 1,
    ),
    Question(
      category: 'MATHS',
      question: 'Which prime number comes after 7?',
      options: ['8', '9', '11', '13'],
      correctIndex: 2,
    ),
    Question(
      category: 'MATHS',
      question: 'What is 8 x 7?',
      options: ['54', '56', '64', '48'],
      correctIndex: 1,
    ),
    Question(
      category: 'MATHS',
      question: 'What is 12 x 12?',
      options: ['124', '144', '134', '154'],
      correctIndex: 1,
    ),
    Question(
      category: 'MATHS',
      question: 'What is the sum of angles in a triangle?',
      options: ['90', '180', '360', '270'],
      correctIndex: 1,
    ),
    Question(
      category: 'MATHS',
      question: 'Which number is known as a Ramanujan number?',
      options: ['1729', '1428', '1111', '108'],
      correctIndex: 0,
    ),
    Question(
      category: 'MATHS',
      question: 'How many degrees are in a right angle?',
      options: ['45', '90', '120', '180'],
      correctIndex: 1,
    ),
    Question(
      category: 'MATHS',
      question: 'What is the next prime number after 11?',
      options: ['12', '13', '15', '17'],
      correctIndex: 1,
    ),
  ];

  static const List<Question> gkQuestions = [
    Question(
      category: 'GK',
      question: 'What is the capital of India?',
      options: ['Mumbai', 'New Delhi', 'Kolkata', 'Chennai'],
      correctIndex: 1,
    ),
    Question(
      category: 'GK',
      question: 'Who wrote the Indian National Anthem?',
      options: ['Bankim Chandra Chatterjee', 'Rabindranath Tagore', 'Mahatma Gandhi', 'Subhas Chandra Bose'],
      correctIndex: 1,
    ),
    Question(
      category: 'GK',
      question: 'Which is the largest desert in the world?',
      options: ['Sahara', 'Gobi', 'Thar', 'Antarctic'],
      correctIndex: 3, 
    ),
    Question(
      category: 'GK',
      question: 'How many continents are there on Earth?',
      options: ['5', '6', '7', '8'],
      correctIndex: 2,
    ),
    Question(
      category: 'GK',
      question: 'Who discovered Penicillin?',
      options: ['Marie Curie', 'Alexander Fleming', 'Louis Pasteur', 'Isaac Newton'],
      correctIndex: 1,
    ),
    Question(
      category: 'GK',
      question: 'Which is the largest ocean on Earth?',
      options: ['Atlantic', 'Indian', 'Pacific', 'Arctic'],
      correctIndex: 2,
    ),
    Question(
      category: 'GK',
      question: 'Who is known as the Iron Man of India?',
      options: ['Bhagat Singh', 'Subhas Chandra Bose', 'Sardar Vallabhbhai Patel', 'Jawaharlal Nehru'],
      correctIndex: 2,
    ),
    Question(
      category: 'GK',
      question: 'Which planet is known as the Red Planet?',
      options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      correctIndex: 1,
    ),
    Question(
      category: 'GK',
      question: 'What is the hardest natural substance on Earth?',
      options: ['Gold', 'Iron', 'Diamond', 'Platinum'],
      correctIndex: 2,
    ),
    Question(
      category: 'GK',
      question: 'In which year did India gain Independence?',
      options: ['1942', '1945', '1947', '1950'],
      correctIndex: 2,
    ),
  ];

  static List<Question> _shuffleQuestionsAndOptions(List<Question> list) {
    final shuffledList = List<Question>.from(list)..shuffle();
    
    return shuffledList.map((q) {
      final oldOptions = List<String>.from(q.options);
      final correctAnswer = oldOptions[q.correctIndex];
      oldOptions.shuffle();
      final newCorrectIndex = oldOptions.indexOf(correctAnswer);

      return Question(
        category: q.category,
        question: q.question,
        options: oldOptions,
        correctIndex: newCorrectIndex,
        points: q.points,
      );
    }).toList();
  }

  static List<Question> getQuestions(String category) {
    List<Question> selected;
    switch (category) {
      case 'SCIENCE':
        selected = scienceQuestions;
        break;
      case 'HISTORY':
        selected = historyQuestions;
        break;
      case 'POP CULTURE':
        selected = popCultureQuestions;
        break;
      case 'INDIAN CINEMA':
        selected = indianCinemaQuestions;
        break;
      case 'MATHS':
        selected = mathsQuestions;
        break;
      case 'GK':
        selected = gkQuestions;
        break;
      default:
        selected = [
          ...scienceQuestions,
          ...historyQuestions,
          ...popCultureQuestions,
          ...indianCinemaQuestions,
          ...mathsQuestions,
          ...gkQuestions
        ];
    }
    // Limit to exactly 10 questions per quiz session
    return _shuffleQuestionsAndOptions(selected).take(10).toList();
  }

  static List<Question> getDailyChallenge() {
    final all = getQuestions('ALL');
    return all.take(10).toList();
  }
}
