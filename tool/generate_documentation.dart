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
# ${baseCodeFile.path.split('/').last}

Here is the example **without** using Supercharged: 

```dart
${codeFile.readAsStringSync()}
```
## What is Supercharged?

Supercharged is a package we created along Simple Animations.

I provides **extension methods** to simplify certain scenarios even further. Have a look:

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

var randomPerson = persons.pickOne();

persons.groupBy(
    (p) => p.age < 40 ? "young" : "old",
    valueTransform: (p) => p.name
); // {"young": ["John", "Carl"], "old": ["Peter", "Sarah"]}
```

So if you are curious take a look at [**more Supercharged examples**](https://pub.dev/packages/supercharged).

''');
    var ref =
        (docFile.parent.path != Directory('tool/templates').path ? '../' : '') +
            file.path;

    result.add(
        '> *Note: We use [supercharged extensions](https://pub.dev/packages/supercharged) here. If you don\'t like it, refer to this [dependency-less example]($ref).*');
  }

  return result;
}
