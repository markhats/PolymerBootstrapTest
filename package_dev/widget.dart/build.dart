#!/usr/bin/env dart

import 'dart:async';
import 'dart:io';
import 'package:html5lib/dom.dart';
import 'package:html5lib/parser.dart';
import 'package:html5lib/dom_parsing.dart';
import 'package:bot/bot.dart';

final _whitespaceRegex = new RegExp(r'\s+');

void main(List<String> args) {
  _log('** ARGS: $args');

  final changes = _getChangedFiles(args);

  if(!args.isEmpty && _onlyOutputFiles(changes)) {
    _log(' ** Nothing interesting changed');
    return;
  }

  _log('** CHANGES: $changes');

  final input = 'web/index_source.html';
  final output = 'web/index.html';

  if(changes.contains(input)) {
    _transform(input, output).then((bool value) {
      if(value) {
        _log('updated $output');
      } else {
        _log('no change to $output');
      }
    });
  } else {
    _log(" - skipping transform");
  }
}

void _log(value) {
  if(value != null) {
    print(value);
    /*
     * NOTE: if you're having trouble debugging what's going on in build.dart
     * You can un-comment this section. Changes to hidden files won't kick off the build
     * so the file is named `.build.log`
    final file = new File('.build.log');
    final str = "$value\n";
    file.writeAsStringSync(str, mode: FileMode.APPEND);
    */
  }
}

bool _onlyOutputFiles(List<String> files) {
  return files.every((value) => value.startsWith(r'web/out/'));
}

List<String> _getChangedFiles(List<String> args) {
  return args.where((value) => value.contains('='))
      .map((value) {
        final indexOfEqu = value.indexOf('=');
        return value.substring(indexOfEqu+1);
      })
      .toList();
}

Future<bool> _transform(String input, String output) {
  _log('doing big page transform');
  final file = new File(input);
  assert(file.existsSync());
  return file.readAsString()
      .then((String contents) {
        var parser = new HtmlParser(contents, generateSpans: true);
        var document = parser.parse();
        _tweakDocument(document);
        return _updateIfChanged(output, document.outerHtml);
      });
}

Future<bool> _updateIfChanged(String filePath, String newContent) {
  final file = new File(filePath);
  return file.exists()
      .then((bool exists) {
        if(exists) {
          return file.readAsString()
              .then((String content) => content != newContent);
        } else {
          return new Future.value(true);
        }
      }).then((bool shouldUpdate) {
        if(shouldUpdate) {
          return file.writeAsString(newContent)
            .then((_) => true);
        } else {
          return new Future.value(false);
        }
      });
}

// TODO: crazy hack. Really need select recursive
//       or propery query support...whichever
List<Element> _findElements(Element element, Func1<Element, bool> predicate, [List<Element> target]) {
  if(target == null) {
    target = new List<Element>();
  }

  if(predicate(element)) {
    target.add(element);
  }

  element.children.forEach((e) => _findElements(e, predicate, target));

  return target;
}

void _tweakDocument(Document document) {
  document.queryAll('section')
      .where((s) => s.attributes['class'] == 'component')
      .forEach((s) {
        _tweakComponentSection(s);
      });

  final sectionHeaders = _findElements(document.body, (e) {
    return e.tagName == 'h1' || e.tagName == 'h2';
  });

  //
  // TOC fun!
  //
  final tocUls = document.queryAll('div')
      .where((e) {
        return e.attributes['class'] != null &&
            e.attributes['class'].contains('list-group');
      });

  assert(tocUls.length == 1);
  final Element tocUl = $(tocUls).first;

  sectionHeaders.forEach((h) {
    final headerText = htmlSerializeEscape(h.innerHtml);
    final headerId = headerText.toLowerCase().replaceAll(_whitespaceRegex, '_');

    final link = new Element.tag('a')
      ..attributes['href'] = '#$headerId'
      ..attributes['class'] = 'level-${h.tagName} list-group-item'
      ..innerHtml = headerText;

    tocUl.children.add(link);

    h.attributes['id'] = headerId;
  });
}

void _tweakComponentSection(Element element) {
  // find demo section
  final demoSections = element.children.where((e) {
    return e.attributes['class'] == 'demo';
  }).toList();

  Element demoSection = null;
  if(demoSections.length == 1) {
    demoSection = demoSections[0];
  }

  // find code section
  final codeSections = element.children.where((e) {
    return e.attributes['class'] == 'code';
  }).toList();

  Element codeSection = null;
  if(demoSections.length == 1) {
    codeSection = codeSections[0];
  }

  // if we have both, take content of demo section, html encode and put it in demo
  if(demoSection != null && codeSection != null) {
    final demoMarkup = demoSection.innerHtml;
    codeSection.innerHtml = _cleanUpCode(demoMarkup);
  }
}

String _cleanUpCode(String input) {
  input = htmlSerializeEscape(input);

  //
  // Get all non-empty lines
  //
  var lines = input.split('\n')
      .where((String line) {
        return line.trim().length > 0;
      }).toList();

  //
  // Figure out the max number of spaces that prefix all lines
  // and remove them so the sample output is indented just enough
  //
  final regex = new RegExp(r'^([ ]*).*$');

  int minPrefix = null;
  lines.forEach((String line) {
    final match = regex.firstMatch(line);
    assert(match.groupCount == 1);
    final g = match.group(1);

    if(minPrefix == null) {
      minPrefix = g.length;
    } else if(minPrefix > g.length) {
      minPrefix = g.length;
    }
  });

  for(var i = 0; i < lines.length; i++) {
    lines[i] = lines[i].substring(minPrefix);
  }

  input = lines.join('\n');

  return input;
}
