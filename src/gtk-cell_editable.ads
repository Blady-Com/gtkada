-----------------------------------------------------------------------
--              GtkAda - Ada95 binding for Gtk+/Gnome                --
--                                                                   --
--                Copyright (C) 2001-2002 ACT-Europe                 --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
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

--  <c_version>1.3.11</c_version>

with Gtk;
with Gdk.Event;
with Glib.Object;

package Gtk.Cell_Editable is

   type Gtk_Cell_Editable_Record is
     new Glib.Object.GObject_Record with private;
   type Gtk_Cell_Editable is access all Gtk_Cell_Editable_Record'Class;

   function Get_Type return Gtk.Gtk_Type;
   --  Return the internal value associated with a Gtk_Cell_Editable.

   procedure Start_Editing
     (Cell_Editable : access Gtk.Cell_Editable.Gtk_Cell_Editable_Record'Class;
      Event         : Gdk.Event.Gdk_Event);
   --  Begin editing on a Gtk_Cell_Editable.
   --  Event is the Gdk_Event that began the editing process. It may be null,
   --  if the instance that editing was initiated through programatic means.

   procedure Editing_Done
     (Cell_Editable : access Gtk.Cell_Editable.Gtk_Cell_Editable_Record'Class);
   --  Emit the "editing_done" signal.
   --  This signal is a sign for the cell renderer to update its value from the
   --  cell.

   procedure Remove_Widget
     (Cell_Editable : access Gtk.Cell_Editable.Gtk_Cell_Editable_Record'Class);
   --  Emit the "remove_widget" signal.
   --  This signal is meant to indicate that the cell is finished editing, and
   --  the widget may now be destroyed.

private
   type Gtk_Cell_Editable_Record is
     new Glib.Object.GObject_Record with null record;

   pragma Import (C, Get_Type, "gtk_cell_editable_get_type");
end Gtk.Cell_Editable;
