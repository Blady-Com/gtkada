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

with System;
with Gdk; use Gdk;

package body Gtk.Menu_Bar is

   ------------
   -- Append --
   ------------

   procedure Append
     (Menu_Bar : in Gtk_Menu_Bar'Class;
      Child    : in Gtk.Widget.Gtk_Widget'Class)
   is
      procedure Internal
        (Menu_Bar : System.Address;
         Child    : System.Address);
      pragma Import (C, Internal, "gtk_menu_bar_append");
   begin
      Internal (Get_Object (Menu_Bar), Get_Object (Child));
   end Append;

   ------------
   -- Insert --
   ------------

   procedure Insert
     (Menu_Bar : in Gtk_Menu_Bar'Class;
      Child    : in Gtk.Widget.Gtk_Widget'Class;
      Position : in Gint)
   is
      procedure Internal (Menu_Bar : System.Address;
                          Child    : System.Address;
                          Position : Gint);
      pragma Import (C, Internal, "gtk_menu_bar_insert");
   begin
      Internal (Get_Object (Menu_Bar), Get_Object (Child), Position);
   end Insert;

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Widget : out Gtk_Menu_Bar) is
      function Internal return System.Address;
      pragma Import (C, Internal, "gtk_menu_bar_new");
   begin
      Set_Object (Widget, Internal);
   end Gtk_New;

   -------------
   -- Prepend --
   -------------

   procedure Prepend
     (Menu_Bar : in Gtk_Menu_Bar'Class;
      Child    : in Gtk.Widget.Gtk_Widget'Class)
   is
      procedure Internal (Menu_Bar : System.Address;
                          Child    : System.Address);
      pragma Import (C, Internal, "gtk_menu_bar_prepend");
   begin
      Internal (Get_Object (Menu_Bar), Get_Object (Child));
   end Prepend;

end Gtk.Menu_Bar;
