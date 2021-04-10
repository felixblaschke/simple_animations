import 'dart:io';

void main() {
  process(File('tool/templates/README.md'), File('README.md'));
  processRootDir('doc');
  processRootDir('example');
}

void processRootDir(String dirName) {
  Directory('tool/templates/$dirName').listSync().forEach((file) {
    if (file.path.endsWith('.md')) {
      var name = file.path.split('/').last;
      process(file as File, File('$dirName/$name'));
    }
  });
}

void process(File file, File to) {
  print('Processing $file...');
  var lines = file.readAsLinesSync();

  lines = codeMacro(file, lines);

  to.writeAsStringSync(lines.join('\n'));
}

List<String> codeMacro(File docFile, List<String> lines) {
  final result = <String>[];

  for (var line in lines) {
    if (line.trim().startsWith('@code')) {
      var path = line.substring(line.indexOf('@code') + '@code'.length).trim();
      var file = File(path);
      var extension =
          file.path.substring(file.path.lastIndexOf('.') + '.'.length);
      var code = file.readAsStringSync().trim().split('\n');

      result.add('```$extension');
      result.addAll(code);
      result.add('```');

      result.addAll(checkNoSupercharged(docFile, file));
    } else {
      result.add(line);
    }
  }

  return result;
}

List<String> checkNoSupercharged(File docFile, File baseCodeFile) {
  final result = <String>[];

  var codeFile = File(baseCodeFile.path.replaceAll('.dart', '_ns.dart'));
  if (codeFile.existsSync()) {
    var file = File(
        'doc/no_supercharged/${codeFile.path.substring('tool/templates/code/'.length)}.md');
    file.createSync(recursive: true);
    file.writeAsStringSync('''
# ${baseCodeFile.path.split('/').last} without ⚡ Supercharged

Here is the example without using any syntactic sugar, provided by the [⚡️ Supercharged](https://pub.dev/packages/supercharged) package:

```dart
${codeFile.readAsStringSync()}
```
## About Supercharged


⚡️ **Supercharged** is created and maintained by the 🎬 **Simple Animations** developers.

It contains many useful **extension methods** that **increase readability** of your `Widget` code:

```dart
// Tweens
0.0.tweenTo(100.0); // Tween<double>(begin: 0.0, end: 100.0);
Colors.red.tweenTo(Colors.blue); // ColorTween(begin: Colors.red, end: Colors.blue);

// Durations
100.milliseconds; // Duration(milliseconds: 100);
2.seconds; // Duration(seconds: 2);

// Colors
'#ff0000'.toColor(); // Color(0xFFFF0000);
'red'.toColor(); // Color(0xFFFF0000);
```

But it also helps you with data processing:

```dart
var persons = [
    Person(name: "John", age: 21),
    Person(name: "Carl", age: 18),
    Person(name: "Peter", age: 56),
    Person(name: "Sarah", age: 61)
];

persons.groupBy(
    (p) => p.age < 40 ? "young" : "old",
    valueTransform: (p) => p.name
); // {"young": ["John", "Carl"], "old": ["Peter", "Sarah"]}
```

If you are curious of ⚡ Supercharged [take a look at more examples](https://pub.dev/packages/supercharged).

''');
    var ref =
        (docFile.parent.path != Directory('tool/templates').path ? '../' : '') +
            file.path;

    result.add(
        '*Note: This example uses **[⚡️ Supercharged](https://pub.dev/packages/supercharged)** to **simplify** the code and **improve** the readability. But if you don\'t want to use that package you can view a [dependency-less example]($ref).*');
  }

  return result;
}
