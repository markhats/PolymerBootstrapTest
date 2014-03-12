library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'package:widget/components/show_hide.dart' as i0;
import 'package:widget/components/modal_popover.dart' as i1;
import 'hostedmodal.dart' as i2;
import 'subclassedmodal.dart' as i3;
import 'polymerbootstrap.dart' as i4;

void main() {
  configureForDeployment([
      'package:widget/components/show_hide.dart',
      'package:widget/components/modal_popover.dart',
      'hostedmodal.dart',
      'subclassedmodal.dart',
      'polymerbootstrap.dart',
    ]);
  i4.main();
}
