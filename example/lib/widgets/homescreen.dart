import 'package:flutter/material.dart';
import 'package:simple_animations_example_app/examples_configuration.dart';

class Homescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Animations Example App"),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _GreetingText(),
              Container(
                height: 20,
              ),
              Text("Pick one demo:", style: Theme.of(context).textTheme.body1),
              Container(
                height: 5,
              )
            ]..addAll(generateDemosList(context)),
          ),
        )),
      ),
    );
  }

  void _openExample(BuildContext context, WidgetBuilder builder) {
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
  }

  Iterable<Widget> generateDemosList(BuildContext context) {
    var allExamples = getExamplesConfiguration().allExamples;
    return allExamples.map((example) => LinkToExample(
          label: example.name,
          click: () => _openExample(context, example.builder),
        ));
  }
}

class LinkToExample extends StatelessWidget {
  final String label;
  final Function click;

  const LinkToExample({
    this.label,
    this.click,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.video_library,
            size: 14,
          ),
          Text("   $label"),
        ],
      ),
      onPressed: click,
    );
  }
}

class _GreetingText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(style: Theme.of(context).textTheme.body1, children: [
        TextSpan(
            text:
                "Hey, hey! This is the companion app for the Flutter package "),
        TextSpan(
            text: "simple_animations",
            style: Theme.of(context).textTheme.body2),
        TextSpan(
            text: ". Here you can discover all features of this "
                "package by exploring examples. Inspire yourself and"
                " create beautiful Flutter apps.")
      ]),
    );
  }
}
