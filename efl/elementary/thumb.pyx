# Copyright (C) 2007-2015 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

"""

:mod:`thumb` Module
###################

.. image:: /images/thumb-preview.png


Widget description
==================

A thumbnail object is used for displaying the thumbnail of an image
or video. You must have compiled Elementary with ``Ethumb_Client``
support. Also, Ethumb's DBus service must be present and
auto-activated in order to have thumbnails generated. You must also
have a **session** bus, not a **system** one.

Once the thumbnail object becomes visible, it will check if there
is a previously generated thumbnail image for the file set on
it. If not, it will start generating this thumbnail.

Different configuration settings will cause different thumbnails to
be generated even on the same file.

Generated thumbnails are stored under ``$HOME/.thumbnails/``. Check
Ethumb's documentation to change this path, and to see other
configuration options.


Emitted signals
===============

- ``clicked`` - This is called when a user has clicked the
  thumbnail object without dragging it around.
- ``clicked,double`` - This is called when a user has double-clicked
  the thumbnail object.
- ``press`` - This is called when a user has pressed down over the
  thumbnail object.
- ``generate,start`` - The thumbnail generation has started.
- ``generate,stop`` - The generation process has stopped.
- ``generate,error`` - The thumbnail generation failed.
- ``load,error`` - The thumbnail image loading failed.


Available styles
================

- ``default``
- ``noframe``


Enumerations
============

.. _Elm_Thumb_Animation_Setting:

Thumb animation mode
--------------------

.. data:: ELM_THUMB_ANIMATION_START

    Play animation once

.. data:: ELM_THUMB_ANIMATION_LOOP

    Keep playing animation until stop is requested

.. data:: ELM_THUMB_ANIMATION_STOP

    Stop playing the animation


.. _Ethumb_Thumb_FDO_Size:

Thumb FDO size
--------------

.. data:: ETHUMB_THUMB_NORMAL

    128x128 as defined by FreeDesktop.Org standard

.. data:: ETHUMB_THUMB_LARGE

    256x256 as defined by FreeDesktop.Org standard


.. _Ethumb_Thumb_Format:

Thumb format
------------

.. data:: ETHUMB_THUMB_FDO

    PNG as defined by FreeDesktop.Org standard

.. data:: ETHUMB_THUMB_JPEG

    JPEGs are often smaller and faster to read/write

.. data:: ETHUMB_THUMB_EET

    EFL's own storage system, supports key parameter


.. _Ethumb_Thumb_Aspect:

Thumb aspect
------------

.. data:: ETHUMB_THUMB_KEEP_ASPECT

    keep original proportion between width and height

.. data:: ETHUMB_THUMB_IGNORE_ASPECT

    ignore aspect and foce it to match thumbnail's width and height

.. data:: ETHUMB_THUMB_CROP

    keep aspect but crop (cut) the largest dimension


.. _Ethumb_Thumb_Orientation:

Thumb orientation
-----------------

.. data:: ETHUMB_THUMB_ORIENT_NONE

    keep orientation as pixel data is

.. data:: ETHUMB_THUMB_ROTATE_90_CW

    rotate 90° clockwise

.. data:: ETHUMB_THUMB_ROTATE_180

    rotate 180°

.. data:: ETHUMB_THUMB_ROTATE_90_CCW

    rotate 90° counter-clockwise

.. data:: ETHUMB_THUMB_FLIP_HORIZONTAL

    flip horizontally

.. data:: ETHUMB_THUMB_FLIP_VERTICAL

    flip vertically

.. data:: ETHUMB_THUMB_FLIP_TRANSPOSE

    transpose

.. data:: ETHUMB_THUMB_FLIP_TRANSVERSE

    transverse

.. data:: ETHUMB_THUMB_ORIENT_ORIGINAL

    use orientation from metadata (EXIF-only currently)


Inheritance diagram
===================

.. inheritance-diagram:: efl.elementary.thumb
    :parts: 2

"""

from cpython cimport PyUnicode_AsUTF8String

from efl.eo cimport _object_mapping_register
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Object as evasObject
from object cimport Object


cdef class Thumb(Object):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Thumb(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_thumb_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def reload(self):
        """Reload thumbnail if it was generated before.

        This is useful if the ethumb client configuration changed, like its
        size, aspect or any other property one set in the handle returned
        by :py:func:`ethumb_client_get()`.

        If the options didn't change, the thumbnail won't be generated
        again, but the old one will still be used.

        .. seealso:: :py:attr:`file`

        """
        elm_thumb_reload(self.obj)

    property file:
        """The file that will be used as thumbnail **source**.

        The file can be an image or a video (in that case, acceptable
        extensions are: avi, mp4, ogv, mov, mpg and wmv). To start the
        video animation, use the function :py:func:`animate()`.

        .. seealso:: :py:func:`reload()` :py:func:`animate()`

        :type: string or tuple(string file, optional string eet_key)

        """
        def __set__(self, value):
            if isinstance(value, tuple) or isinstance(value, list):
                file_name, key = value
            else:
                file_name = value
                key = None
            if isinstance(file_name, unicode): file_name = PyUnicode_AsUTF8String(file_name)
            if isinstance(key, unicode): key = PyUnicode_AsUTF8String(key)
            elm_thumb_file_set(self.obj,
                <const char *>file_name if file_name is not None else NULL,
                <const char *>key if key is not None else NULL)
        def __get__(self):
            cdef:
                const char *file_name
                const char *key

            elm_thumb_file_get(self.obj, &file_name, &key)
            return(_ctouni(file_name), _ctouni(key))

    property path:
        """Get the path and key to the image or video thumbnail generated by
        ethumb.

        One just needs to make sure that the thumbnail was generated before
        getting its path; otherwise, the path will be None. One way to do
        that is by asking for the path when/after the "generate,stop" smart
        callback is called.

        .. seealso:: :py:attr:`file`

        :type: (string **path**, string **eet_key**)

        """
        def __get__(self):
            cdef:
                const char *path
                const char *key

            elm_thumb_path_get(self.obj, &path, &key)
            return(_ctouni(path), _ctouni(key))

    property aspect:
        """

        The aspect for the thumb object.

        :type: :ref:`Ethumb_Thumb_Aspect`

        .. versionadded:: 1.8

        """
        def __set__(self, aspect):
            elm_thumb_aspect_set(self.obj, aspect)

        def __get__(self):
            return elm_thumb_aspect_get(self.obj)

    property fdo_size:
        """

        The FDO size for the thumb object.

        :type: :ref:`Ethumb_Thumb_FDO_Size`

        .. versionadded:: 1.8

        """
        def __set__(self, size):
            elm_thumb_fdo_size_set(self.obj, size)

        def __get__(self):
            return elm_thumb_fdo_size_get(self.obj)

    property format:
        """

        The format for the thumb object.

        :type: :ref:`Ethumb_Thumb_Format`

        .. versionadded:: 1.8

        """
        def __set__(self, format):
            elm_thumb_format_set(self.obj, format)

        def __get__(self):
            return elm_thumb_format_get(self.obj)

    property orientation:
        """

        The orientation for the thumb object.

        :type: :ref:`Ethumb_Thumb_Orientation`

        .. versionadded:: 1.8

        """
        def __set__(self, orient):
            elm_thumb_orientation_set(self.obj, orient)

        def __get__(self):
            return elm_thumb_orientation_get(self.obj)

    property size:
        """

        The size for the thumb object.

        :type: (int **tw**, int **th**)

        .. versionadded:: 1.8

        """
        def __set__(self, value):
            tw, th = value
            elm_thumb_size_set(self.obj, tw, th)

        def __get__(self):
            cdef int tw, th
            elm_thumb_size_get(self.obj, &tw, &th)
            return tw, th

    property crop_align:
        """

        Set the crop alignment for the thumb object.

        :type: (float **cropx**, float **cropy**)

        .. versionadded:: 1.8

        """
        def __set__(self, value):
            cropx, cropy = value
            elm_thumb_crop_align_set(self.obj, cropx, cropy)

        def __get__(self):
            cdef double cropx, cropy
            elm_thumb_crop_align_get(self.obj, &cropx, &cropy)
            return cropx, cropy

    property compress:
        """

        Set the compression for the thumb object.

        :type: int

        .. versionadded:: 1.8

        """
        def __set__(self, compress):
            elm_thumb_compress_set(self.obj, compress)

        def __get__(self):
            cdef int compress
            elm_thumb_compress_get(self.obj, &compress)
            return compress

    property quality:
        """

        Set the quality for the thumb object.

        :type: int

        .. versionadded:: 1.8

        """
        def __set__(self, int quality):
            elm_thumb_quality_set(self.obj, quality)

        def __get__(self):
            cdef int quality
            elm_thumb_quality_get(self.obj, &quality)
            return quality

    property animate:
        """Set the animation state for the thumb object. If its content is
        an animated video, you may start/stop the animation or tell it to
        play continuously and looping.

        .. seealso:: :py:attr:`file`

        :type: :ref:`Elm_Thumb_Animation_Setting`

        """
        def __set__(self, s):
            elm_thumb_animate_set(self.obj, s)
        def __get__(self):
            return elm_thumb_animate_get(self.obj)

    def ethumb_client_get(self):
        """Get the ethumb_client handle so custom configuration can be made.

        This must be called before the objects are created to be sure no object is
        visible and no generation started.

        ..
            Example of usage:

            #include <Elementary.h>
            #ifndef ELM_LIB_QUICKLAUNCH
            EAPI_MAIN int
            elm_main(int argc, char **argv)
            {
               Ethumb_Client *client;

               elm_need_ethumb();

               // ... your code

               client = elm_thumb_ethumb_client_get();
               if (!client)
                 {
                    ERR("could not get ethumb_client");
                    return 1;
                 }
               ethumb_client_size_set(client, 100, 100);
               ethumb_client_crop_align_set(client, 0.5, 0.5);
               // ... your code

               // Create elm_thumb objects here

               elm_run();
               elm_shutdown();
               return 0;
            }
            #endif
            ELM_MAIN()

        .. note:: There's only one client handle for Ethumb, so once a
            configuration change is done to it, any other request for
            thumbnails (for any thumbnail object) will use that
            configuration. Thus, this configuration is global.

        :return: Ethumb_Client instance or None.
        :rtype: Ethumb_Client

        """
        return None
        # TODO: return elm_thumb_ethumb_client_get(void)

    property ethumb_client_connected:
        """Get the ethumb_client connection state.

        :type: bool

        """
        def __get__(self):
            return bool(elm_thumb_ethumb_client_connected_get())

    def ethumb_client_connected_get(self):
        return bool(elm_thumb_ethumb_client_connected_get())

    property editable:
        """Make the thumbnail 'editable'.

        This means the thumbnail is a valid drag target for drag and drop,
        and can be cut or pasted too.

        :type: bool

        :raise RuntimeError: when cannot be set as editable

        .. versionchanged:: 1.8
            Raises RuntimeError if cannot be set as editable

        """
        def __set__(self, edit):
            if not elm_thumb_editable_set(self.obj, edit):
                raise RuntimeError
        def __get__(self):
            return bool(elm_thumb_editable_get(self.obj))

    def callback_clicked_add(self, func, *args, **kwargs):
        """This is called when a user has clicked the thumbnail object
        without dragging it around."""
        self._callback_add("clicked", func, args, kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        """This is called when a user has double-clicked the thumbnail
        object."""
        self._callback_add("clicked,double", func, args, kwargs)

    def callback_clicked_double_del(self, func):
        self._callback_del("clicked,double", func)

    def callback_press_add(self, func, *args, **kwargs):
        """This is called when a user has pressed down over the thumbnail
        object."""
        self._callback_add("press", func, args, kwargs)

    def callback_press_del(self, func):
        self._callback_del("press", func)

    def callback_generate_start_add(self, func, *args, **kwargs):
        """The thumbnail generation has started."""
        self._callback_add("generate,start", func, args, kwargs)

    def callback_generate_start_del(self, func):
        self._callback_del("generate,start", func)

    def callback_generate_stop_add(self, func, *args, **kwargs):
        """The generation process has stopped."""
        self._callback_add("generate,stop", func, args, kwargs)

    def callback_generate_stop_del(self, func):
        self._callback_del("generate,stop", func)

    def callback_generate_error_add(self, func, *args, **kwargs):
        """The thumbnail generation failed."""
        self._callback_add("generate,error", func, args, kwargs)

    def callback_generate_error_del(self, func):
        self._callback_del("generate,error", func)

    def callback_load_error_add(self, func, *args, **kwargs):
        """The thumbnail image loading failed."""
        self._callback_add("load,error", func, args, kwargs)

    def callback_load_error_del(self, func):
        self._callback_del("load,error", func)


_object_mapping_register("Elm_Thumb", Thumb)
