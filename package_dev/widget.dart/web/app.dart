import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:widget/effects.dart';

void main() {
  initPolymer();

  window.onHashChange.listen(_onNavigate);

  //
  // ShowHide Demo
  //
  var effects = {
     'Default' : null,
     'Door': new DoorEffect(),
     'Fade': new FadeEffect(),
     'Scale': new ScaleEffect(),
     'Scale [roll up]': new ScaleEffect(orientation: Orientation.VERTICAL, yOffset: VerticalAlignment.TOP),
     'Scale [corner]': new ScaleEffect(yOffset: VerticalAlignment.TOP, xOffset: HorizontalAlignment.LEFT),
     'Shrink': new ShrinkEffect(),
     'Spin': new SpinEffect()
  };

  var effectsDiv = querySelector('.demo.showhide .effects');
  effects.forEach((name, effect) {
    var button = new ButtonElement()
      ..appendText(name)
      ..classes.add('btn btn-default')
      ..onClick.listen((_) => _showHideDemo_toggle(effect));
    effectsDiv.append(button);
  });

  querySelector('#modalOpenButton').onClick.listen(_show);
}

void _show(event) {
  var modal = querySelector('#modal_example');
  modal.show();
}

void _showHideDemo_toggle(ShowHideEffect effect) {
  querySelectorAll('.demo.showhide .logo_wrapper > img').forEach((Element e) {
    ShowHide.toggle(e, effect: effect);
  });
}

void _onNavigate(HashChangeEvent e) {
  final matches = _hashBitRegEx.firstMatch(e.newUrl);
  if(matches != null) {
    final elementId = matches[1];

    final element = querySelector('#$elementId');
    if(element != null) {
      _flashElement(element);
    }
  }
}

void _flashElement(Element element) {
  element.classes.add(_HIGHLIGHTED_CLASS);
  new Timer(const Duration(seconds: 1), () => element.classes.remove(_HIGHLIGHTED_CLASS));
}

const _HIGHLIGHTED_CLASS = 'highlighted';

// these are the rules applied by build.dart
final _hashBitRegEx = new RegExp(r'.*#([a-z_]+)');
