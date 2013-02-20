# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.
#

"""

.. rubric:: Wrap modes

.. data:: ELM_WRAP_NONE

    No wrap

.. data:: ELM_WRAP_CHAR

    Wrap between characters

.. data:: ELM_WRAP_WORD

    Wrap in allowed wrapping points (as defined in the unicode standard)

.. data:: ELM_WRAP_MIXED

    Word wrap, and if that fails, char wrap.


.. rubric:: Slide modes

.. data:: ELM_LABEL_SLIDE_MODE_NONE

    The label will never slide.

.. data:: ELM_LABEL_SLIDE_MODE_AUTO

    The label slide if the content is bigger than it's container.

.. data:: ELM_LABEL_SLIDE_MODE_ALWAYS

    The label will always slide.

"""

include "widget_header.pxi"

from layout_class cimport LayoutClass
from efl.eo import _METHOD_DEPRECATED

cimport enums

ELM_WRAP_NONE = enums.ELM_WRAP_NONE
ELM_WRAP_CHAR = enums.ELM_WRAP_CHAR
ELM_WRAP_WORD = enums.ELM_WRAP_WORD
ELM_WRAP_MIXED = enums.ELM_WRAP_MIXED

ELM_LABEL_SLIDE_MODE_NONE = enums.ELM_LABEL_SLIDE_MODE_NONE
ELM_LABEL_SLIDE_MODE_AUTO = enums.ELM_LABEL_SLIDE_MODE_AUTO
ELM_LABEL_SLIDE_MODE_ALWAYS = enums.ELM_LABEL_SLIDE_MODE_ALWAYS


cdef class Label(LayoutClass):

    """

    Widget to display text, with simple html-like markup.

    The Label widget **doesn't** allow text to overflow its boundaries, if the
    text doesn't fit the geometry of the label it will be ellipsized or be
    cut. Elementary provides several styles for this widget:

    - default - No animation
    - marker - Centers the text in the label and makes it bold by default
    - slide_long - The entire text appears from the right of the screen and
        slides until it disappears in the left of the screen(reappearing on
        the right again).
    - slide_short - The text appears in the left of the label and slides to
        the right to show the overflow. When all of the text has been shown
        the position is reset.
    - slide_bounce - The text appears in the left of the label and slides to
        the right to show the overflow. When all of the text has been shown
        the animation reverses, moving the text to the left.

    Custom themes can of course invent new markup tags and style them any way
    they like.

    This widget emits the following signals, besides the ones sent from
    :py:class:`elementary.layout.Layout`:

    - *"language,changed"*: The program's language changed.

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_label_add(parent.obj))

    property line_wrap:
        """The wrapping behavior of the label

        By default no wrapping is done. Possible values for ``wrap`` are:

        - ELM_WRAP_NONE - No wrapping
        - ELM_WRAP_CHAR - wrap between characters
        - ELM_WRAP_WORD - wrap between words
        - ELM_WRAP_MIXED - Word wrap, and if that fails, char wrap

        :type: Elm_Wrap_Type

        """
        def __get__(self):
            return elm_label_line_wrap_get(self.obj)

        def __set__(self, wrap):
            elm_label_line_wrap_set(self.obj, wrap)

    def line_wrap_set(self, Elm_Wrap_Type wrap):
        elm_label_line_wrap_set(self.obj, wrap)
    def line_wrap_get(self):
        return elm_label_line_wrap_get(self.obj)

    property wrap_width:
        """Wrap width of the label

        This is the maximum width size hint of the label.

        .. warning:: This is only relevant if the label is inside a container.

        :type: int

        """
        def __get__(self):
            return elm_label_wrap_width_get(self.obj)

        def __set__(self, w):
            elm_label_wrap_width_set(self.obj, w)

    def wrap_width_set(self, int w):
        elm_label_wrap_width_set(self.obj, w)
    def wrap_width_get(self):
        return elm_label_wrap_width_get(self.obj)

    property ellipsis:
        """The ellipsis behavior of the label

        If set to True and the text doesn't fit in the label an
        ellipsis("...") will be shown at the end of the widget.

        .. warning:: This doesn't work with slide(:py:attr:`slide`) or if the
            chosen wrap method was ELM_WRAP_WORD.

        :type: bool

        """
        def __get__(self):
            return elm_label_ellipsis_get(self.obj)

        def __set__(self, ellipsis):
            elm_label_ellipsis_set(self.obj, ellipsis)

    def ellipsis_set(self, bint ellipsis):
        elm_label_ellipsis_set(self.obj, ellipsis)
    def ellipsis_get(self):
        return elm_label_ellipsis_get(self.obj)

    property slide:
        """The sliding effect of the label widget.

        If set to True, the text of the label will slide/scroll through the
        length of label.

        .. warning:: This only works with the themes "slide_short",
            "slide_long" and "slide_bounce".

        .. warning:: Deprecated. use slide_mode instead

        :type: bool

        """
        def __get__(self):
            _METHOD_DEPRECATED(self, replacement="slide_mode")
            return elm_label_slide_get(self.obj)

        def __set__(self, slide):
            _METHOD_DEPRECATED(self, replacement="slide_mode")
            elm_label_slide_set(self.obj, slide)

    def slide_set(self, bint slide):
        _METHOD_DEPRECATED(self, replacement="slide_mode")
        elm_label_slide_set(self.obj, slide)
    def slide_get(self):
        _METHOD_DEPRECATED(self, replacement="slide_mode")
        return elm_label_slide_get(self.obj)

    property slide_duration:
        """The duration time in moving text from slide begin position to
        slide end position

        :type: float

        """
        def __get__(self):
            return elm_label_slide_duration_get(self.obj)

        def __set__(self, duration):
            elm_label_slide_duration_set(self.obj, duration)

    def slide_duration_set(self, duration):
        elm_label_slide_duration_set(self.obj, duration)
    def slide_duration_get(self):
        return elm_label_slide_duration_get(self.obj)

    property slide_mode:
        """Change the slide mode of the label widget.

        By default, slide mode is none. Possible values for ``mode`` are:

        - ELM_LABEL_SLIDE_MODE_NONE - no slide effect
        - ELM_LABEL_SLIDE_MODE_AUTO - slide only if the label area is bigger than
            the text width length
        - ELM_LABEL_SLIDE_MODE_ALWAYS - slide always

        :type: Elm_Label_Slide_Mode

        """
        def __get__(self):
            return elm_label_slide_mode_get(self.obj)

        def __set__(self, mode):
            elm_label_slide_mode_set(self.obj, mode)

    def slide_mode_set(self, mode):
        elm_label_slide_mode_set(self.obj, mode)
    def slide_mode_get(self):
        return elm_label_slide_mode_get(self.obj)

    def slide_go(self):
        """Start the slide effect."""
        elm_label_slide_go(self.obj)

    def callback_language_changed_add(self, func, *args, **kwargs):
        """The program's language changed."""
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed", func)


_object_mapping_register("elm_label", Label)