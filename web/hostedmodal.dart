//-----------------------------------------------------------------------------
//  Project Autograph
//  Eastmond Publishing Ltd.
//  Copyright © 2013. All Rights Reserved.
//
//  FILE:         popover.dart
//  AUTHOR:       Mark Hatsell
//
//  OVERVIEW
//  ~~~~~~~~
//  Source file for implementation of ModalElement
//
//-----------------------------------------------------------------------------

import 'dart:html';
import 'package:polymer/polymer.dart';

///////////////////////////////////////////////////////////////////////////////
//                                                                           //
// Class ModalElement                                                        //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////
@CustomTag("modal-host-element")
class ModalHostElement extends PolymerElement
{
  // This lets the Bootstrap CSS "bleed through" into the Shadow DOM
   // of this element.
   bool get applyAuthorStyles => true;

   ////////////////////////////////////////////////////////////////////////////
   // Constructor                                                            //
   ////////////////////////////////////////////////////////////////////////////
   ModalHostElement.created()
   :
      super.created()
   {
   }

   ////////////////////////////////////////////////////////////////////////////
   // Entered View                                                           //
   ////////////////////////////////////////////////////////////////////////////
   @override
   void enteredView()
   {
      super.enteredView();
   }

   ////////////////////////////////////////////////////////////////////////////
   // Show the popover                                                       //
   ////////////////////////////////////////////////////////////////////////////
   void Show([Element relatedtarget = null])
   {
      var target = shadowRoot.querySelector("modal-popover-widget");

      target.show();
      target.position(relatedtarget);
   }
}