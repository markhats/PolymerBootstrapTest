# Changelog - Dart Widgets

## 0.2.7 2013-08-06 (SDK 0.6.15.1 r25788)

## 0.2.6+1 20 May 2013 (SDK 0.5.9.0 r22879)

* Updated to latest `web_ui` library

## 0.2.6 13 May 2013 (SDK 0.5.7+2 r22611)

* Updates for latest SDK
* Tweaks to test infrastructure

## 0.2.5 - 08 May 2013 (SDK 0.5.5 r22416)

Updated to lastest web_ui and SDK.

## 0.2.4 - 03 April 2013 (SDK 0.4.4+4 r20810)

Updated to lastest SDK.

## 0.2.3 - 26 March 2013 (SDK 0.4.3+1 r20444)

Updated to lastest SDK.

## 0.2.2 - 07 March 2013 (SDK 0.4.1 r19425)

Updated SDK and pub dependencies.

## 0.2.1 - 20 Feb 2013 (SDK 0.3.7.6 r18717)

Updated everything to align with latest Dart SDK release. Also updated related libraries.

No other changes.

## 0.2.0 - 9 Feb 2013 (SDK 0.3.5.1 r18300)

A lot more in-line documentation in libraries. Scripts harvest this data to populate
the demo page.

### Components

* __BREAKING__ Removed `HeaderedContent` - An interesting sample, but pretty useless.
* __BREAKING__ Renamed `Expander` to `Collapse`
* __BREAKING__ Leveraging Twitter Bootstrap for almost all component styles.
    * Internal styles have been stripped away from most components.
    * The content model for most components has changed to be compatible with that of
    Bootstrap.

## 0.1.0 - 25 Jan 2013 - (SDK 0.3.1.2 r17463)

* Integrated all samples into one page.
* Lot's of cleanup around samples and related code.
* Moved to new Dart SDK and related libraries.

### Components

* _NEW!_ `Modal`
* _NEW!_ `Alert`
* _NEW!_ `Swap` is now a seperate component.
* Removed a lot of state from individual components.
* Moved 4 components--`Alert`, `DropDown`, `Expander`, and `Modal`--to implement new
abstract class `ShowHideComponent` which standardizes methods, properties, and events

### Effects

* _NEW!_ `ModalManager`

## 0.0.2 - 17 Jan 2013 - (SDK 0.2.10.1 r16761)

* Using `build.dart` to do a lot of auto-generated content in the component sample.

### Effects

* _NEW!_ SlideEffect
* _NEW!_ Swapper

### Components

* _NEW!_ Tabs
* _NEW!_ Carousel
* Better about checking `defaultPrevented` and using `preventDefault` on events

## 0.0.1 - 14 Jan 2013 (SDK 0.2.10.1 r16761)

First release. Crazy pre-alpha. Play with `ShowHide` and the associated effects.
