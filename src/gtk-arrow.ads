-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 1998-2000                       --
--        Emmanuel Briot, Joel Brobecker and Arnaud Charlet          --
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

--  <description>
--  Gtk_Arrow should be used to draw simple arrows that need to point in one
--  of the four cardinal directions (up, down, left, or right). The style of
--  the arrow can be one of shadow in, shadow out, etched in, or etched out.
--  Note that these directions and style types may be ammended in versions of
--  Gtk to come.
--
--  Gtk_Arrow will fill any space alloted to it, but since it is inherited from
--  Gtk_Misc, it can be padded and/or aligned, to fill exactly the space you
--  desire.
--
--  Arrows are created with a call to Gtk_New. The direction or style of an
--  arrow can be changed after creation by using Set.
--  </description>
--  <c_version>1.2.8</c_version>

with Gtk.Enums; use Gtk.Enums;
with Gtk.Object;
with Gtk.Misc;

package Gtk.Arrow is

   type Gtk_Arrow_Record is new Gtk.Misc.Gtk_Misc_Record with private;
   type Gtk_Arrow is access all Gtk_Arrow_Record'Class;

   procedure Gtk_New
     (Arrow       : out Gtk_Arrow;
      Arrow_Type  : in Gtk_Arrow_Type;
      Shadow_Type : in Gtk_Shadow_Type);
   --  Create a new arrow widget.

   procedure Initialize
     (Arrow       : access Gtk_Arrow_Record'Class;
      Arrow_Type  : in Gtk_Arrow_Type;
      Shadow_Type : in Gtk_Shadow_Type);
   --  Internal initialization function.
   --  See the section "Creating your own widgets" in the documentation.

   function Get_Type return Gtk.Gtk_Type;
   --  Return the internal value associated with a Gtk_Arrow.

   procedure Set
     (Arrow       : access Gtk_Arrow_Record;
      Arrow_Type  : in Gtk_Arrow_Type;
      Shadow_Type : in Gtk_Shadow_Type);
   --  Set the direction and style of the Arrow.

   ----------------------------
   -- Support for Gate/Dgate --
   ----------------------------

   procedure Generate (N : in Node_Ptr; File : in File_Type);
   --  Gate internal function

   procedure Generate (Arrow : in out Gtk.Object.Gtk_Object; N : in Node_Ptr);
   --  Dgate internal function

   -------------
   -- Signals --
   -------------

   --  <signals>
   --  The following new signals are defined for this widget:
   --  </signals>

private
   type Gtk_Arrow_Record is new Gtk.Misc.Gtk_Misc_Record with null record;

   pragma Import (C, Get_Type, "gtk_arrow_get_type");
end Gtk.Arrow;
