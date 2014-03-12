import 'dart:html';
import 'package:polymer/polymer.dart';

////////////////////////////////////////////////////////////////////////////
// Main Entry Point                                                       //
////////////////////////////////////////////////////////////////////////////
void main()
{
   var dirtycheckingzone = initPolymer();

   // Run the whole app in the dirty checking zone so that observables are always updated in the DOM
   dirtycheckingzone.run(()
   {
       querySelector('#hostedModalOpenButton').onClick.listen((e)
       {
          var modal = querySelector("#hosted_modal_example");

          modal.Show(e.currentTarget);
       });

       querySelector('#subclassedModalOpenButton').onClick.listen((e)
       {
          var modal = querySelector("#subclassed_modal_example");

          modal.show();
          modal.position(e.currentTarget);
       });
   });
}