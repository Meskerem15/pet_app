import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({super.key});

  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  Timer? _hungerTimer;

  @override
  void initState() {
    super.initState();
    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateHunger();
      _checkWinLossConditions();
    });
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    super.dispose();
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _checkWinLossConditions();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _checkWinLossConditions();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // Check win/loss conditions
  void _checkWinLossConditions() {
    if (happinessLevel > 80) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("You Win!"),
          content: const Text("Your pet is extremely happy!"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Game Over"),
          content: const Text("Your pet is too hungry and unhappy."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  // Get mood text based on happiness level
  String _getMood() {
    if (happinessLevel > 70) {
      return 'Happy';
    } else if (happinessLevel >= 30) {
      return 'Neutral';
    } else {
      return 'Unhappy';
    }
  }

  // Get mood emoji based on happiness level
  String _getMoodEmoji() {
    if (happinessLevel > 70) {
      return '😊'; // Happy emoji
    } else if (happinessLevel >= 30) {
      return '😐'; // Neutral emoji
    } else {
      return '😢'; // Unhappy emoji
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet'),
      ),
      body: SingleChildScrollView( // Wrap Column in SingleChildScrollView
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Pet color representation
              Container(
                width: 100,
                height: 100,
                color: happinessLevel > 70
                    ? Colors.green
                    : happinessLevel >= 30
                    ? Colors.yellow
                    : Colors.red,
                child: const Center(
                  child: Text(
                    'Pet',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Pet Name: $petName',
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Mood: ${_getMood()}',
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                _getMoodEmoji(),
                style: const TextStyle(fontSize: 40.0),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Happiness Level: $happinessLevel',
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Hunger Level: $hungerLevel',
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _playWithPet,
                child: const Text('Play with Your Pet'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _feedPet,
                child: const Text('Feed Your Pet'),
              ),
              const SizedBox(height: 32.0),
              TextField(
                onChanged: (value) {
                  petName = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter pet name',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {}); // Update UI to show the new name
                },
                child: const Text('Set Pet Name'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
