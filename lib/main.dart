import 'package:flutter/material.dart';

void main() => runApp(SignUpApp());

class SignUpApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const SignUpScreen(),
        '/welcome': (context) => const WelcomeScreen()
      },
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: SignUpForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome!',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _userNameTextController = TextEditingController();

  //as one fills up the signup form the _formProgress value will increase
  double _formProgress = 0;

  //navigate to welcome screen
  void _showWelcomeScreen() {
    Navigator.of(context).pushNamed('/welcome');
  }

  //method to update form fill up progress
  //this method updates the _formProgress field based on the number of
  //non-empty text form fields
  void _updateFormProgress() {
    var progress = 0.0;
    //add all controllers to one list of controllers
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _userNameTextController,
    ];
    //function to update progress in the form
    for (final controller in controllers) {
      //check if the controller is being filled
      if (controller.value.text.isNotEmpty) {
        //if controller is filled then increase progress value
        //by one dividing the progress value by the number of controllers
        progress += 1 / controllers.length;
      }
    }

    //method to assign _formProgress as progress
    setState(() {
      _formProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text(
            'Sign up',
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(
                hintText: 'First name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(
                hintText: 'Last name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: _userNameTextController,
              decoration: const InputDecoration(
                hintText: 'Username',
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) {
                  return states.contains(MaterialState.disabled)
                      ? null
                      : Colors.white;
                },
              ),
              //change background color to blue if form is filled
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) {
                  return states.contains(MaterialState.disabled)
                      ? null
                      : Colors.blue;
                },
              ),
            ),
            //display the welcome screen only when the form is completely filled
            onPressed: _formProgress == 1 ? _showWelcomeScreen : null,
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}

//animate progress indicator
class AnimatedProgressIndicator extends StatefulWidget {
  const AnimatedProgressIndicator({
    Key? key,
    required this.value,
  }) : super(key: key);
  final double value;

  @override
  _AnimatedProgressIndicatorState createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  //animation controllers
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  //initialise animation controllers
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 1200,
      ),
      vsync: this,
    );
    //list of colorTweens to animate
    final colorTween = TweenSequence(
      [
        TweenSequenceItem(
          tween: ColorTween(
            begin: Colors.white,
            end: Colors.orange,
          ),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(
            begin: Colors.orange,
            end: Colors.yellow,
          ),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(
            begin: Colors.yellow,
            end: Colors.green,
          ),
          weight: 1,
        ),
      ],
    );
    //animate the tween colors
    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  //update the old widget with new animation
  @override
  void didUpdateWidget(AnimatedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }
}
