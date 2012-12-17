------------------------------------------------------------------------------
--                                                                          --
--      Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet       --
--                     Copyright (C) 2000-2012, AdaCore                     --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

pragma Style_Checks (Off);
pragma Warnings (Off, "*is already use-visible*");
with Glib.Type_Conversion_Hooks; use Glib.Type_Conversion_Hooks;
with Interfaces.C.Strings;       use Interfaces.C.Strings;

package body Gtk.Tool_Item is

   package Type_Conversion_Gtk_Tool_Item is new Glib.Type_Conversion_Hooks.Hook_Registrator
     (Get_Type'Access, Gtk_Tool_Item_Record);
   pragma Unreferenced (Type_Conversion_Gtk_Tool_Item);

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Tool_Item : out Gtk_Tool_Item) is
   begin
      Tool_Item := new Gtk_Tool_Item_Record;
      Gtk.Tool_Item.Initialize (Tool_Item);
   end Gtk_New;

   -----------------------
   -- Gtk_Tool_Item_New --
   -----------------------

   function Gtk_Tool_Item_New return Gtk_Tool_Item is
      Tool_Item : constant Gtk_Tool_Item := new Gtk_Tool_Item_Record;
   begin
      Gtk.Tool_Item.Initialize (Tool_Item);
      return Tool_Item;
   end Gtk_Tool_Item_New;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
      (Tool_Item : not null access Gtk_Tool_Item_Record'Class)
   is
      function Internal return System.Address;
      pragma Import (C, Internal, "gtk_tool_item_new");
   begin
      Set_Object (Tool_Item, Internal);
   end Initialize;

   ------------------------
   -- Get_Ellipsize_Mode --
   ------------------------

   function Get_Ellipsize_Mode
      (Tool_Item : not null access Gtk_Tool_Item_Record)
       return Pango.Layout.Pango_Ellipsize_Mode
   is
      function Internal
         (Tool_Item : System.Address)
          return Pango.Layout.Pango_Ellipsize_Mode;
      pragma Import (C, Internal, "gtk_tool_item_get_ellipsize_mode");
   begin
      return Internal (Get_Object (Tool_Item));
   end Get_Ellipsize_Mode;

   ----------------
   -- Get_Expand --
   ----------------

   function Get_Expand
      (Tool_Item : not null access Gtk_Tool_Item_Record) return Boolean
   is
      function Internal (Tool_Item : System.Address) return Integer;
      pragma Import (C, Internal, "gtk_tool_item_get_expand");
   begin
      return Boolean'Val (Internal (Get_Object (Tool_Item)));
   end Get_Expand;

   ---------------------
   -- Get_Homogeneous --
   ---------------------

   function Get_Homogeneous
      (Tool_Item : not null access Gtk_Tool_Item_Record) return Boolean
   is
      function Internal (Tool_Item : System.Address) return Integer;
      pragma Import (C, Internal, "gtk_tool_item_get_homogeneous");
   begin
      return Boolean'Val (Internal (Get_Object (Tool_Item)));
   end Get_Homogeneous;

   -------------------
   -- Get_Icon_Size --
   -------------------

   function Get_Icon_Size
      (Tool_Item : not null access Gtk_Tool_Item_Record)
       return Gtk.Enums.Gtk_Icon_Size
   is
      function Internal
         (Tool_Item : System.Address) return Gtk.Enums.Gtk_Icon_Size;
      pragma Import (C, Internal, "gtk_tool_item_get_icon_size");
   begin
      return Internal (Get_Object (Tool_Item));
   end Get_Icon_Size;

   ----------------------
   -- Get_Is_Important --
   ----------------------

   function Get_Is_Important
      (Tool_Item : not null access Gtk_Tool_Item_Record) return Boolean
   is
      function Internal (Tool_Item : System.Address) return Integer;
      pragma Import (C, Internal, "gtk_tool_item_get_is_important");
   begin
      return Boolean'Val (Internal (Get_Object (Tool_Item)));
   end Get_Is_Important;

   ---------------------
   -- Get_Orientation --
   ---------------------

   function Get_Orientation
      (Tool_Item : not null access Gtk_Tool_Item_Record)
       return Gtk.Enums.Gtk_Orientation
   is
      function Internal
         (Tool_Item : System.Address) return Gtk.Enums.Gtk_Orientation;
      pragma Import (C, Internal, "gtk_tool_item_get_orientation");
   begin
      return Internal (Get_Object (Tool_Item));
   end Get_Orientation;

   -------------------------
   -- Get_Proxy_Menu_Item --
   -------------------------

   function Get_Proxy_Menu_Item
      (Tool_Item    : not null access Gtk_Tool_Item_Record;
       Menu_Item_Id : UTF8_String) return Gtk.Menu_Item.Gtk_Menu_Item
   is
      function Internal
         (Tool_Item    : System.Address;
          Menu_Item_Id : Interfaces.C.Strings.chars_ptr)
          return System.Address;
      pragma Import (C, Internal, "gtk_tool_item_get_proxy_menu_item");
      Tmp_Menu_Item_Id   : Interfaces.C.Strings.chars_ptr := New_String (Menu_Item_Id);
      Stub_Gtk_Menu_Item : Gtk.Menu_Item.Gtk_Menu_Item_Record;
      Tmp_Return         : System.Address;
   begin
      Tmp_Return := Internal (Get_Object (Tool_Item), Tmp_Menu_Item_Id);
      Free (Tmp_Menu_Item_Id);
      return Gtk.Menu_Item.Gtk_Menu_Item (Get_User_Data (Tmp_Return, Stub_Gtk_Menu_Item));
   end Get_Proxy_Menu_Item;

   ----------------------
   -- Get_Relief_Style --
   ----------------------

   function Get_Relief_Style
      (Tool_Item : not null access Gtk_Tool_Item_Record)
       return Gtk.Enums.Gtk_Relief_Style
   is
      function Internal
         (Tool_Item : System.Address) return Gtk.Enums.Gtk_Relief_Style;
      pragma Import (C, Internal, "gtk_tool_item_get_relief_style");
   begin
      return Internal (Get_Object (Tool_Item));
   end Get_Relief_Style;

   ------------------------
   -- Get_Text_Alignment --
   ------------------------

   function Get_Text_Alignment
      (Tool_Item : not null access Gtk_Tool_Item_Record) return Gfloat
   is
      function Internal (Tool_Item : System.Address) return Gfloat;
      pragma Import (C, Internal, "gtk_tool_item_get_text_alignment");
   begin
      return Internal (Get_Object (Tool_Item));
   end Get_Text_Alignment;

   --------------------------
   -- Get_Text_Orientation --
   --------------------------

   function Get_Text_Orientation
      (Tool_Item : not null access Gtk_Tool_Item_Record)
       return Gtk.Enums.Gtk_Orientation
   is
      function Internal
         (Tool_Item : System.Address) return Gtk.Enums.Gtk_Orientation;
      pragma Import (C, Internal, "gtk_tool_item_get_text_orientation");
   begin
      return Internal (Get_Object (Tool_Item));
   end Get_Text_Orientation;

   -------------------------
   -- Get_Text_Size_Group --
   -------------------------

   function Get_Text_Size_Group
      (Tool_Item : not null access Gtk_Tool_Item_Record)
       return Gtk.Size_Group.Gtk_Size_Group
   is
      function Internal (Tool_Item : System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_tool_item_get_text_size_group");
      Stub_Gtk_Size_Group : Gtk.Size_Group.Gtk_Size_Group_Record;
   begin
      return Gtk.Size_Group.Gtk_Size_Group (Get_User_Data (Internal (Get_Object (Tool_Item)), Stub_Gtk_Size_Group));
   end Get_Text_Size_Group;

   -----------------------
   -- Get_Toolbar_Style --
   -----------------------

   function Get_Toolbar_Style
      (Tool_Item : not null access Gtk_Tool_Item_Record)
       return Gtk.Enums.Gtk_Toolbar_Style
   is
      function Internal
         (Tool_Item : System.Address) return Gtk.Enums.Gtk_Toolbar_Style;
      pragma Import (C, Internal, "gtk_tool_item_get_toolbar_style");
   begin
      return Internal (Get_Object (Tool_Item));
   end Get_Toolbar_Style;

   -------------------------
   -- Get_Use_Drag_Window --
   -------------------------

   function Get_Use_Drag_Window
      (Tool_Item : not null access Gtk_Tool_Item_Record) return Boolean
   is
      function Internal (Tool_Item : System.Address) return Integer;
      pragma Import (C, Internal, "gtk_tool_item_get_use_drag_window");
   begin
      return Boolean'Val (Internal (Get_Object (Tool_Item)));
   end Get_Use_Drag_Window;

   ----------------------------
   -- Get_Visible_Horizontal --
   ----------------------------

   function Get_Visible_Horizontal
      (Tool_Item : not null access Gtk_Tool_Item_Record) return Boolean
   is
      function Internal (Tool_Item : System.Address) return Integer;
      pragma Import (C, Internal, "gtk_tool_item_get_visible_horizontal");
   begin
      return Boolean'Val (Internal (Get_Object (Tool_Item)));
   end Get_Visible_Horizontal;

   --------------------------
   -- Get_Visible_Vertical --
   --------------------------

   function Get_Visible_Vertical
      (Tool_Item : not null access Gtk_Tool_Item_Record) return Boolean
   is
      function Internal (Tool_Item : System.Address) return Integer;
      pragma Import (C, Internal, "gtk_tool_item_get_visible_vertical");
   begin
      return Boolean'Val (Internal (Get_Object (Tool_Item)));
   end Get_Visible_Vertical;

   ------------------
   -- Rebuild_Menu --
   ------------------

   procedure Rebuild_Menu (Tool_Item : not null access Gtk_Tool_Item_Record) is
      procedure Internal (Tool_Item : System.Address);
      pragma Import (C, Internal, "gtk_tool_item_rebuild_menu");
   begin
      Internal (Get_Object (Tool_Item));
   end Rebuild_Menu;

   ------------------------------
   -- Retrieve_Proxy_Menu_Item --
   ------------------------------

   function Retrieve_Proxy_Menu_Item
      (Tool_Item : not null access Gtk_Tool_Item_Record)
       return Gtk.Menu_Item.Gtk_Menu_Item
   is
      function Internal (Tool_Item : System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_tool_item_retrieve_proxy_menu_item");
      Stub_Gtk_Menu_Item : Gtk.Menu_Item.Gtk_Menu_Item_Record;
   begin
      return Gtk.Menu_Item.Gtk_Menu_Item (Get_User_Data (Internal (Get_Object (Tool_Item)), Stub_Gtk_Menu_Item));
   end Retrieve_Proxy_Menu_Item;

   ----------------
   -- Set_Expand --
   ----------------

   procedure Set_Expand
      (Tool_Item : not null access Gtk_Tool_Item_Record;
       Expand    : Boolean)
   is
      procedure Internal (Tool_Item : System.Address; Expand : Integer);
      pragma Import (C, Internal, "gtk_tool_item_set_expand");
   begin
      Internal (Get_Object (Tool_Item), Boolean'Pos (Expand));
   end Set_Expand;

   ---------------------
   -- Set_Homogeneous --
   ---------------------

   procedure Set_Homogeneous
      (Tool_Item   : not null access Gtk_Tool_Item_Record;
       Homogeneous : Boolean)
   is
      procedure Internal (Tool_Item : System.Address; Homogeneous : Integer);
      pragma Import (C, Internal, "gtk_tool_item_set_homogeneous");
   begin
      Internal (Get_Object (Tool_Item), Boolean'Pos (Homogeneous));
   end Set_Homogeneous;

   ----------------------
   -- Set_Is_Important --
   ----------------------

   procedure Set_Is_Important
      (Tool_Item    : not null access Gtk_Tool_Item_Record;
       Is_Important : Boolean)
   is
      procedure Internal
         (Tool_Item    : System.Address;
          Is_Important : Integer);
      pragma Import (C, Internal, "gtk_tool_item_set_is_important");
   begin
      Internal (Get_Object (Tool_Item), Boolean'Pos (Is_Important));
   end Set_Is_Important;

   -------------------------
   -- Set_Proxy_Menu_Item --
   -------------------------

   procedure Set_Proxy_Menu_Item
      (Tool_Item    : not null access Gtk_Tool_Item_Record;
       Menu_Item_Id : UTF8_String;
       Menu_Item    : not null access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class)
      
   is
      procedure Internal
         (Tool_Item    : System.Address;
          Menu_Item_Id : Interfaces.C.Strings.chars_ptr;
          Menu_Item    : System.Address);
      pragma Import (C, Internal, "gtk_tool_item_set_proxy_menu_item");
      Tmp_Menu_Item_Id : Interfaces.C.Strings.chars_ptr := New_String (Menu_Item_Id);
   begin
      Internal (Get_Object (Tool_Item), Tmp_Menu_Item_Id, Get_Object (Menu_Item));
      Free (Tmp_Menu_Item_Id);
   end Set_Proxy_Menu_Item;

   ------------------------
   -- Set_Tooltip_Markup --
   ------------------------

   procedure Set_Tooltip_Markup
      (Tool_Item : not null access Gtk_Tool_Item_Record;
       Markup    : UTF8_String)
   is
      procedure Internal
         (Tool_Item : System.Address;
          Markup    : Interfaces.C.Strings.chars_ptr);
      pragma Import (C, Internal, "gtk_tool_item_set_tooltip_markup");
      Tmp_Markup : Interfaces.C.Strings.chars_ptr := New_String (Markup);
   begin
      Internal (Get_Object (Tool_Item), Tmp_Markup);
      Free (Tmp_Markup);
   end Set_Tooltip_Markup;

   ----------------------
   -- Set_Tooltip_Text --
   ----------------------

   procedure Set_Tooltip_Text
      (Tool_Item : not null access Gtk_Tool_Item_Record;
       Text      : UTF8_String)
   is
      procedure Internal
         (Tool_Item : System.Address;
          Text      : Interfaces.C.Strings.chars_ptr);
      pragma Import (C, Internal, "gtk_tool_item_set_tooltip_text");
      Tmp_Text : Interfaces.C.Strings.chars_ptr := New_String (Text);
   begin
      Internal (Get_Object (Tool_Item), Tmp_Text);
      Free (Tmp_Text);
   end Set_Tooltip_Text;

   -------------------------
   -- Set_Use_Drag_Window --
   -------------------------

   procedure Set_Use_Drag_Window
      (Tool_Item       : not null access Gtk_Tool_Item_Record;
       Use_Drag_Window : Boolean)
   is
      procedure Internal
         (Tool_Item       : System.Address;
          Use_Drag_Window : Integer);
      pragma Import (C, Internal, "gtk_tool_item_set_use_drag_window");
   begin
      Internal (Get_Object (Tool_Item), Boolean'Pos (Use_Drag_Window));
   end Set_Use_Drag_Window;

   ----------------------------
   -- Set_Visible_Horizontal --
   ----------------------------

   procedure Set_Visible_Horizontal
      (Tool_Item          : not null access Gtk_Tool_Item_Record;
       Visible_Horizontal : Boolean)
   is
      procedure Internal
         (Tool_Item          : System.Address;
          Visible_Horizontal : Integer);
      pragma Import (C, Internal, "gtk_tool_item_set_visible_horizontal");
   begin
      Internal (Get_Object (Tool_Item), Boolean'Pos (Visible_Horizontal));
   end Set_Visible_Horizontal;

   --------------------------
   -- Set_Visible_Vertical --
   --------------------------

   procedure Set_Visible_Vertical
      (Tool_Item        : not null access Gtk_Tool_Item_Record;
       Visible_Vertical : Boolean)
   is
      procedure Internal
         (Tool_Item        : System.Address;
          Visible_Vertical : Integer);
      pragma Import (C, Internal, "gtk_tool_item_set_visible_vertical");
   begin
      Internal (Get_Object (Tool_Item), Boolean'Pos (Visible_Vertical));
   end Set_Visible_Vertical;

   --------------------------
   -- Toolbar_Reconfigured --
   --------------------------

   procedure Toolbar_Reconfigured
      (Tool_Item : not null access Gtk_Tool_Item_Record)
   is
      procedure Internal (Tool_Item : System.Address);
      pragma Import (C, Internal, "gtk_tool_item_toolbar_reconfigured");
   begin
      Internal (Get_Object (Tool_Item));
   end Toolbar_Reconfigured;

   ---------------------------
   -- Do_Set_Related_Action --
   ---------------------------

   procedure Do_Set_Related_Action
      (Self   : not null access Gtk_Tool_Item_Record;
       Action : not null access Gtk.Action.Gtk_Action_Record'Class)
   is
      procedure Internal (Self : System.Address; Action : System.Address);
      pragma Import (C, Internal, "gtk_activatable_do_set_related_action");
   begin
      Internal (Get_Object (Self), Get_Object (Action));
   end Do_Set_Related_Action;

   ------------------------
   -- Get_Related_Action --
   ------------------------

   function Get_Related_Action
      (Self : not null access Gtk_Tool_Item_Record)
       return Gtk.Action.Gtk_Action
   is
      function Internal (Self : System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_activatable_get_related_action");
      Stub_Gtk_Action : Gtk.Action.Gtk_Action_Record;
   begin
      return Gtk.Action.Gtk_Action (Get_User_Data (Internal (Get_Object (Self)), Stub_Gtk_Action));
   end Get_Related_Action;

   -------------------------------
   -- Get_Use_Action_Appearance --
   -------------------------------

   function Get_Use_Action_Appearance
      (Self : not null access Gtk_Tool_Item_Record) return Boolean
   is
      function Internal (Self : System.Address) return Integer;
      pragma Import (C, Internal, "gtk_activatable_get_use_action_appearance");
   begin
      return Boolean'Val (Internal (Get_Object (Self)));
   end Get_Use_Action_Appearance;

   ------------------------
   -- Set_Related_Action --
   ------------------------

   procedure Set_Related_Action
      (Self   : not null access Gtk_Tool_Item_Record;
       Action : not null access Gtk.Action.Gtk_Action_Record'Class)
   is
      procedure Internal (Self : System.Address; Action : System.Address);
      pragma Import (C, Internal, "gtk_activatable_set_related_action");
   begin
      Internal (Get_Object (Self), Get_Object (Action));
   end Set_Related_Action;

   -------------------------------
   -- Set_Use_Action_Appearance --
   -------------------------------

   procedure Set_Use_Action_Appearance
      (Self           : not null access Gtk_Tool_Item_Record;
       Use_Appearance : Boolean)
   is
      procedure Internal (Self : System.Address; Use_Appearance : Integer);
      pragma Import (C, Internal, "gtk_activatable_set_use_action_appearance");
   begin
      Internal (Get_Object (Self), Boolean'Pos (Use_Appearance));
   end Set_Use_Action_Appearance;

   ----------------------------
   -- Sync_Action_Properties --
   ----------------------------

   procedure Sync_Action_Properties
      (Self   : not null access Gtk_Tool_Item_Record;
       Action : access Gtk.Action.Gtk_Action_Record'Class)
   is
      procedure Internal (Self : System.Address; Action : System.Address);
      pragma Import (C, Internal, "gtk_activatable_sync_action_properties");
   begin
      Internal (Get_Object (Self), Get_Object_Or_Null (GObject (Action)));
   end Sync_Action_Properties;

end Gtk.Tool_Item;
