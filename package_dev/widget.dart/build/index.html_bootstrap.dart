library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'package:widget/components/accordion.dart' as i0;
import 'package:widget/components/alert.dart' as i1;
import 'package:widget/components/carousel.dart' as i2;
import 'package:widget/components/collapse.dart' as i3;
import 'package:widget/components/dropdown.dart' as i4;
import 'package:widget/components/modal.dart' as i5;
import 'package:widget/components/swap.dart' as i6;
import 'package:widget/components/tabs.dart' as i7;
import 'app.dart' as i8;

void main() {
  configureForDeployment([
      'package:widget/components/accordion.dart',
      'package:widget/components/alert.dart',
      'package:widget/components/carousel.dart',
      'package:widget/components/collapse.dart',
      'package:widget/components/dropdown.dart',
      'package:widget/components/modal.dart',
      'package:widget/components/swap.dart',
      'package:widget/components/tabs.dart',
      'app.dart',
    ]);
  i8.main();
}
