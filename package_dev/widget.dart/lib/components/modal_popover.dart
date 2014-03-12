library widget.modal;

import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:widget/effects.dart';
import 'show_hide.dart';

// TODO: ESC to close: https://github.com/kevmoo/widget.dart/issues/17
// TODO: clicking on background to close is broken - fix it!

/**
 * When added to a page, [ModalPopoverWidget] is hidden. It can be displayed by calling
 * the `show` method.
 *
 * Similar to [AlertWidget], elements with the attribute `data-dismiss="modal"`
 * will close [ModalPopoverWidget] when clicked.
 *
 * Content within [ModalPopoverWidget] is placed in a div with class `modal` so related
 * styles from Bootstrap are applied.
 *
 * The [ModalPopoverWidget] component leverages the [ModalManager] effect.
 */
@CustomTag('modal-popover-widget')
class ModalPopoverWidget extends ShowHideWidget {

bool get applyAuthorStyles => true;

  /** If false, clicking the backdrop closes the dialog. */
  bool staticBackdrop = false;

  // ShowHideEffect effect = new ScaleEffect();
  ShowHideEffect effect = new FadeEffect();

  ModalPopoverWidget.created() : super.created() {
    this.onClick.listen(_onClick);
  }

  @override
  void enteredView() {
    super.enteredView();
    var modal = _modalElement;

    if(modal != null && !isShown) {
      ModalManager.hide(modal);
    }
  }

  void set isShown(bool value) {
    super.isShown = value;
    _shown_changed();
  }

  void _shown_changed() {

    var modal = _modalElement;
    if(modal != null) {

      if(isShown) {
        ModalManager.show(modal, effect: effect,
            backdropClickHandler: _onBackdropClicked);
      } else {
        ModalManager.hide(modal, effect: effect);
      }
    }
  }

  // Element get _modalElement => shadowRoot.querySelector('.modal');
  Element get _modalElement => getShadowRoot("modal-popover-widget").querySelector('.modal');

  void _onClick(MouseEvent event) {

    if(!event.defaultPrevented) {
      final Element target = event.target as Element;
      if(target != null && target.dataset['dismiss'] == 'modal') {
        hide();
      }
    }
  }

  void _onBackdropClicked() {
    // TODO: ignoring some edge cases here
    // like what if this element has been removed from the tree before the backdrop is clicked
    // ...etc
    if (!staticBackdrop) {
      hide();
    }
  }

  void position(Element relatedTarget, [ num x, num y ])
  {
    // shadowRoot.querySelector(".modal-popover");
    Element modal = getShadowRoot("modal-popover-widget").querySelector(".modal-popover");
    Element popover = modal.querySelector(".popover");

    Rectangle relatedTargetPosition;

    // MH - Need to check this is actually a popover and not a normal modal
    if (popover != null) {
      // Placement
      String placement = getPlacement(popover);

      // Display the modal so you can calculate the dimensions of the popover
      modal.style.top = "0";
      modal.style.left = "0";
      modal.style.display = "block";

      if (relatedTarget != null) {
          // Calculate the position and dimensions of the element that was clicked
          relatedTargetPosition = getPosition(relatedTarget);
      } else {
          relatedTargetPosition = new Rectangle(x != null ? x : 0, y != null ? y : 0, 0, 0);
      }

      // Calculate the dimensions of the popover
      num popoverActualWidth = modal.offsetWidth;
      num popoverActualHeight = modal.offsetHeight;

      Point calculatedOffset = getCalculatedOffset(placement, relatedTargetPosition, popoverActualWidth, popoverActualHeight);

      applyPlacement(modal, calculatedOffset, placement);
    }
  }

  String getPlacement(Element el) {
    var match = new RegExp("right|top|left|bottom").firstMatch(el.className);
    return (match[0]);
  }

  Rectangle getPosition(Element el) {
    Rectangle boundingclientrect = el.getBoundingClientRect();
    Point offset = el.documentOffset;

    return (new Rectangle(offset.x, offset.y, boundingclientrect.width, boundingclientrect.height));
  }

  Point getCalculatedOffset(String placement, Rectangle pos, num actualWidth, num actualHeight) {
    return (placement == "bottom" ? new Point(pos.left + pos.width / 2 - actualWidth / 2, pos.top + pos.height) :
            placement == "top" ? new Point(pos.left + pos.width / 2 - actualWidth / 2, pos.top - actualHeight) :
            placement == "left" ? new Point(pos.left - actualWidth, pos.top + pos.height / 2 - actualHeight / 2) :
         /* placement == "right" */ new Point(pos.left + pos.width, pos.top + pos.height / 2 - actualHeight / 2));
  }

  void applyPlacement(Element element, Point offset, String placement) {

    num width = element.offsetWidth;
    num height = element.offsetHeight;

    // Regular Expression used to remove css units e.g. px, pt, cm, % etc.
    RegExp cssunitsregexp = new RegExp(r"[^\d\.]");

    // Manually read margins because getBoundingClientRect includes difference
    num marginTop = int.parse(element.getComputedStyle().marginTop.replaceAll(cssunitsregexp, ""));
    num marginLeft = int.parse(element.getComputedStyle().marginLeft.replaceAll(cssunitsregexp, ""));

    // We must check for NaN for ie 8/9
    if (marginTop.isNaN) marginTop = 0;
    if (marginLeft.isNaN) marginLeft = 0;

    num offsety = offset.y + marginTop;
    num offsetx = offset.x + marginLeft;

    setOffset(element, offset);
    num actualWidth = element.offsetWidth;
    num actualHeight = element.offsetHeight;

    // Diverge from tooltip.js here as I don't like the way they resize popovers near the edge.
    if (new RegExp("bottom|top").hasMatch(placement)) {

      num overlap = 0;
      num docWidth = document.documentElement.offsetWidth;

      if (offsetx < 0) {

        overlap = offsetx * -2;
        offsetx = 0;

        setOffset(element, new Point(offsetx, offsety));
        actualWidth = element.offsetWidth;
        actualHeight = element.offsetHeight;

      } else if (offsetx > docWidth - width) {

        overlap = (offsetx + width - docWidth) * -2;
        offsetx = docWidth - width;

        setOffset(element, new Point(offsetx, offsety));
        actualWidth = element.offsetWidth;
        actualHeight = element.offsetHeight;
      }

      replaceArrow(element, overlap - width + actualWidth, actualWidth, "left");

    } else {
      replaceArrow(element, height - actualHeight, actualHeight, "top");
    }
  }

  void replaceArrow(Element element, num delta, num dimension, String position) {
    // Element arrowelement = shadowRoot.querySelector(".arrow");
    Element arrowelement = getShadowRoot("modal-popover-widget").querySelector(".arrow");
    if (arrowelement != null) {
      arrowelement.style.setProperty(position, delta != 0 ? "${50 * (1 - delta / dimension)}%" : "");
    }
  }

  void setOffset(Element element, Point offset) {
    String position = element.getComputedStyle().position;

    // Set position first, in-case top/left are set even on static elem
    if (position == "static") {
      element.style.position = "relative";
    }

    Point curOffset = element.documentOffset;
    String curCSSTop = element.getComputedStyle().top;
    String curCSSLeft = element.getComputedStyle().left;
    bool calculatePosition = (position == "absolute" || position == "fixed" ) && [curCSSTop, curCSSLeft].indexOf("auto") > -1;

    Point curPosition;
    num curTop;
    num curLeft;

    // Need to be able to calculate position if either top or left is auto and position is either absolute or fixed
    if (calculatePosition) {
      // Fixed elements are offset from window (parentOffset = {top:0, left: 0}, because it is it's only offset parent
      if (position == "fixed") {
        // We assume that getBoundingClientRect is available when computed position is fixed
        curPosition = element.getBoundingClientRect().topLeft;
      }
      else {
        curPosition = element.offsetTo(element.offsetParent);
      }
      curTop = curPosition.y;
      curLeft = curPosition.x;
    } else {
      // Regular Expression used to remove css units e.g. px, pt, cm, % etc.
      RegExp cssunitsregexp = new RegExp(r"[^\d\.]");
      curTop = double.parse(curCSSTop.replaceAll(cssunitsregexp, ""), (source) { curTop = 0; });
      curLeft = double.parse(curCSSLeft.replaceAll(cssunitsregexp, ""), (source) { curLeft = 0; });
    }

    element.style.top = "${(offset.y - curOffset.y) + curTop}px";
    element.style.left = "${(offset.x - curOffset.x) + curLeft}px";
  }
}
