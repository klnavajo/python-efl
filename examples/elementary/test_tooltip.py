#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import ecore
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.entry import Entry
from efl.elementary.list import List
from efl.elementary.toolbar import Toolbar
from efl.elementary.icon import Icon


def _tt_icon(obj, *args, **kargs):
    ic = Icon(obj)
    ic.file_set("images/logo_small.png")
    ic.resizable_set(0, 0)
    ic.resize(64, 64)
    return ic

def _tt_item_icon(obj, item, *args, **kargs):
    return _tt_icon(obj,item, *args, **kargs)

def _tt_icon2(obj, *args, **kargs):
    ic = Icon(obj)
    ic.file_set("images/icon_00.png")
    ic.resizable_set(0, 0)
    ic.resize(64, 64)
    return ic

def _tt_timer_del(obj, data, *args):
    timer = data.get("timer")
    if timer:
        timer.delete()
        del data["timer"]


def tooltip_clicked(obj):
    win = Window("tooltips", elementary.ELM_WIN_BASIC)
    win.title_set("Tooltips")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.show()

    tb = Toolbar(win)
    tb.homogeneous_set(False)
    tb.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    tb.size_hint_align_set(evas.EVAS_HINT_FILL, 0.0)
    bx.pack_end(tb)
    tb.show()

    ti = tb.item_append("folder-new", "Open", None, None)
    ti.tooltip_text_set("Opens a file")

    ti = tb.item_append("clock", "Icon", None, None)
    ti.tooltip_content_cb_set(_tt_item_icon, None)
    ti.tooltip_style_set("transparent")

    bt = Button(win)
    bt.text_set("Simple text tooltip");
    bt.tooltip_text_set("Simple text tooltip")
    bx.pack_end(bt)
    bt.show()

    def _tt_text_replace(obj, data):
        value = data.get("value")
        if not value:
            value = 1
        obj.tooltip_text_set("count=%d" % value)
        value += 1
        data["value"] = value

    bt = Button(win)
    bt.text_set("Simple text tooltip, click to change");
    bt.tooltip_text_set("Initial")
    data = dict()
    bt.callback_clicked_add(_tt_text_replace, data)
    bx.pack_end(bt)
    bt.show()

    def _tt_text_replace_timer_cb(obj, data):
        _tt_text_replace(obj, data)
        return True

    def _tt_text_replace_timed(obj, data, *args, **kargs):
        timer = data.get("timer")
        if timer:
            timer.delete()
            del data["timer"]
            obj.text_set("Simple text tooltip, click to start changed timed")
            return
        data["timer"] = ecore.timer_add(1.5, _tt_text_replace_timer_cb, obj,
                                        data)
        obj.text_set("Simple text tooltip, click to stop changed timed")

    bt = Button(win)
    bt.text_set("Simple text tooltip, click to start changed timed");
    bt.tooltip_text_set("Initial")
    data = dict()
    bt.callback_clicked_add(_tt_text_replace_timed, data)
    bx.pack_end(bt)
    bt.show()
    bt.on_del_add(_tt_timer_del, data)

    bt = Button(win)
    bt.text_set("Icon tooltip");
    bt.tooltip_content_cb_set(_tt_icon, None)
    bx.pack_end(bt)
    bt.show()

    def _tt_icon_replace_timer_cb(obj, data):
        value = data.get("value")
        data["value"] = not value
        if value:
            obj.tooltip_content_cb_set(_tt_icon)
        else:
            obj.tooltip_content_cb_set(_tt_icon2)
        return True

    def _tt_icon_replace_timed(obj, data, *args, **kargs):
        timer = data.get("timer")
        if timer:
            timer.delete()
            del data["timer"]
            obj.text_set("Icon tooltip, click to start changed timed")
            return
        data["timer"] = ecore.timer_add(1.5, _tt_icon_replace_timer_cb, obj,
                                        data)
        obj.text_set("Icon tooltip, click to stop changed timed")

    bt = Button(win)
    bt.text_set("Icon tooltip, click to start changed timed");
    bt.tooltip_content_cb_set(_tt_icon)
    data = dict()
    bt.callback_clicked_add(_tt_icon_replace_timed, data)
    bx.pack_end(bt)
    bt.show()
    bt.on_del_add(_tt_timer_del, data)

    bt = Button(win)
    bt.text_set("Transparent Icon tooltip");
    bt.tooltip_content_cb_set(_tt_icon, None)
    bt.tooltip_style_set("transparent")
    bx.pack_end(bt)
    bt.show()

    def _tt_style_replace_timer_cb(obj, data):
        value = data.get("value")
        data["value"] = not value
        if value:
            obj.tooltip_style_set()
        else:
            obj.tooltip_style_set("transparent")
        return True

    def _tt_style_replace_timed(obj, data, *args, **kargs):
        timer = data.get("timer")
        if timer:
            timer.delete()
            del data["timer"]
            obj.text_set("Icon tooltip style, click to start changed timed")
            return
        data["timer"] = ecore.timer_add(1.5, _tt_style_replace_timer_cb, obj,
                                        data)
        obj.text_set("Icon tooltip, click to stop changed timed")

    bt = Button(win)
    bt.text_set("Icon tooltip style, click to start changed timed");
    bt.tooltip_content_cb_set(_tt_icon, None)
    data = dict()
    bt.callback_clicked_add(_tt_style_replace_timed, data)
    bx.pack_end(bt)
    bt.show()
    bt.on_del_add(_tt_timer_del, data)

    def _tt_visible_lock_toggle(obj, data, *args, **kargs):
        value = data.get("value")
        data["value"] = not value
        if value:
            obj.text_set("Unlocked tooltip visibility");
            obj.tooltip_hide()
        else:
            obj.text_set("Locked tooltip visibility");
            obj.tooltip_show()

    bt = Button(win)
    bt.text_set("Unlocked tooltip visibility");
    bt.tooltip_text_set("This tooltip is unlocked visible,<br> clock the button to lock!")
    data = dict()
    bt.callback_clicked_add(_tt_visible_lock_toggle, data)
    bx.pack_end(bt)
    bt.show()

    en = Entry(win)
    en.scrollable_set(True)
    en.single_line_set(True)
    en.entry_set("Hello, some scrolled entry here!")
    en.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    en.size_hint_align_set(evas.EVAS_HINT_FILL, 0.5)
    en.tooltip_text_set("Type something here!")
    bx.pack_end(en)
    en.show()

    lst = List(win)
    li = lst.item_append("Hello")
    li.tooltip_text_set("Something useful here?")
    li = lst.item_append("Icon Tooltip")
    li.tooltip_content_cb_set(_tt_item_icon, None)
    lst.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    lst.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    lst.size_hint_min_set(100, 100)
    bx.pack_end(lst)
    lst.go()
    lst.show()

    win.show()
    win.resize(400, 500)


if __name__ == "__main__":
    elementary.init()

    tooltip_clicked(None)

    elementary.run()
    elementary.shutdown()
