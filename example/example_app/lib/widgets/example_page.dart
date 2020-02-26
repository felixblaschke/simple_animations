import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExamplePage extends StatefulWidget {
  final String title;
  final String pathToFile;
  final WidgetBuilder builder;
  final bool delayStartup;

  ExamplePage(
      {this.title, this.pathToFile, this.builder, this.delayStartup = false})
      : assert(!pathToFile.contains("-"),
            "Don't use minus character in filenames.");

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  var renderBuilder = true;

  @override
  void initState() {
    if (widget.delayStartup) {
      renderBuilder = false;
      Future.delayed(Duration(milliseconds: 500)).then((_) {
        setState(() => renderBuilder = true);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: _buildPage(context)),
          ],
        ),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(widget.title),
      actions: <Widget>[_reloadExampleButton(), _moreMenu()],
    );
  }

  PopupMenuButton _moreMenu() {
    return PopupMenuButton<_MoreMenuResult>(
      onSelected: (itemClicked) {
        if (itemClicked == _MoreMenuResult.SHOW_SOURCE_CODE) {
          _openSource();
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: _MoreMenuResult.SHOW_SOURCE_CODE,
            child: Text("View source code"),
          )
        ];
      },
    );
  }

  IconButton _reloadExampleButton() {
    return IconButton(
      onPressed: () => setState(() {
            renderBuilder = false;
            Future.delayed(Duration(milliseconds: 200)).then((_) {
              setState(() => renderBuilder = true);
            });
          }),
      icon: Icon(
        Icons.refresh,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    if (!renderBuilder) {
      return Container();
    }
    return this.widget.builder(context);
  }

  _openSource() async {
    final url =
        "https://github.com/felixblaschke/simple_animations_example_app/blob/master/lib/examples/${widget.pathToFile}";
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

enum _MoreMenuResult { SHOW_SOURCE_CODE }
