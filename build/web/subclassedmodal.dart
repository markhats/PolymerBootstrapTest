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

import 'package:polymer/polymer.dart';
import 'package:widget/components/modal_popover.dart';

///////////////////////////////////////////////////////////////////////////////
//                                                                           //
// Class ModalElement                                                        //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////
@CustomTag("modal-subclassed-element")
class ModalSubclassedElement extends ModalPopoverWidget
{
   // This lets the Bootstrap CSS "bleed through" into the Shadow DOM
   // of this element.
   bool get applyAuthorStyles => true;

   ////////////////////////////////////////////////////////////////////////////
   // Constructor                                                            //
   ////////////////////////////////////////////////////////////////////////////
   ModalSubclassedElement.created()
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
}