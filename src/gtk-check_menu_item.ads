-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
-- Copyright (C) 1998 Emmanuel Briot and Joel Brobecker              --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
--         General Public License for more details.                  --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-----------------------------------------------------------------------


with Gtk.Menu_Item;

package Gtk.Check_Menu_Item is

   type Gtk_Check_Menu_Item is new Gtk.Menu_Item.Gtk_Menu_Item with private;

   procedure Gtk_New (Widget : out Gtk_Check_Menu_Item;
                      Label  : in String);
   procedure Gtk_New (Widget : out Gtk_Check_Menu_Item);
   procedure Set_Show_Toggle
      (Menu_Item : in Gtk_Check_Menu_Item'Class;
       Always    : in Boolean);
   procedure Set_State
      (Check_Menu_Item : in Gtk_Check_Menu_Item'Class;
       State           : in Gint);
   procedure Toggled (Check_Menu_Item : in Gtk_Check_Menu_Item'Class);

private
   type Gtk_Check_Menu_Item is new Gtk.Menu_Item.Gtk_Menu_Item
     with null record;

   --  mapping: NOT_IMPLEMENTED gtkcheckmenuitem.h gtk_check_menu_item_get_type
   --  mapping: Gtk_New gtkcheckmenuitem.h gtk_check_menu_item_new_with_label
   --  mapping: Gtk_New gtkcheckmenuitem.h gtk_check_menu_item_new
   --  mapping: Set_Show_Toggle gtkcheckmenuitem.h \
   --  mapping:      gtk_check_menu_item_set_show_toggle
   --  mapping: Set_State gtkcheckmenuitem.h gtk_check_menu_item_set_state
   --  mapping: Toggled gtkcheckmenuitem.h gtk_check_menu_item_toggled
end Gtk.Check_Menu_Item;
