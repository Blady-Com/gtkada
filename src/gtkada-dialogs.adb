-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--     Copyright (C) 2000 E. Briot, J. Brobecker and A. Charlet      --
--               Copyright (C) 2001-2002 ACT-Europe                  --
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

with Glib;              use Glib;
with Gdk.Pixmap;        use Gdk.Pixmap;
with Gdk.Color;         use Gdk.Color;
with Gtk.Main;          use Gtk.Main;
with Gtk.Box;           use Gtk.Box;
with Gtk.Button;        use Gtk.Button;
with Gtk.Dialog;        use Gtk.Dialog;
with Gtk.Enums;         use Gtk.Enums;
with Gtk.Label;         use Gtk.Label;
with Gtk.Pixmap;        use Gtk.Pixmap;
with Gtk.Stock;         use Gtk.Stock;
with Gtk.Widget;        use Gtk.Widget;
with Ada.Strings;       use Ada.Strings;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Gtkada.Handlers;   use Gtkada.Handlers;
with Gtkada.Pixmaps;    use Gtkada.Pixmaps;
with Gtkada.Intl;       use Gtkada.Intl;

package body Gtkada.Dialogs is

   subtype String_20 is String (1 .. 20);
   --  Give enough room for translations

   type String_Const_Ptr is access constant String;

   Dialog_Button_String : constant array (Button_Range) of String_20 :=
     ("Yes                 ",
      "No                  ",
      "All                 ",
      "OK                  ",
      "Cancel              ",
      "Abort               ",
      "Retry               ",
      "Ignore              ",
      "Help                ");

   Dialog_Button_Stock : constant array (Button_Range) of String_Const_Ptr :=
     (Stock_Yes'Access,
      Stock_No'Access,
      null,
      Stock_Ok'Access,
      Stock_Cancel'Access,
      null,
      null,
      null,
      Stock_Help'Access);

   type Gtkada_Dialog_Record is new Gtk_Dialog_Record with record
      Value    : Message_Dialog_Buttons := Button_None;
      Help_Msg : String_Ptr;
   end record;
   type Gtkada_Dialog is access all Gtkada_Dialog_Record'Class;

   type Dialog_Button_Record is new Gtk_Button_Record with record
      Button : Message_Dialog_Buttons := 0;
   end record;
   type Dialog_Button is access all Dialog_Button_Record'Class;

   function Delete_Cb (Win : access Gtk_Widget_Record'Class) return Boolean;
   procedure Clicked_Cb (Button : access Gtk_Widget_Record'Class);

   --------------------
   -- Destroy_Dialog --
   --------------------

   function Delete_Cb (Win : access Gtk_Widget_Record'Class) return Boolean is
      pragma Unreferenced (Win);
   begin
      Main_Quit;
      return True;
   end Delete_Cb;

   ----------------
   -- Clicked_Cb --
   ----------------

   procedure Clicked_Cb (Button : access Gtk_Widget_Record'Class) is
      Result : Message_Dialog_Buttons;
      Value  : constant Message_Dialog_Buttons :=
        Dialog_Button (Button).Button;

   begin
      if Value = Button_Help then
         Result := Message_Dialog
           (Gtkada_Dialog (Get_Toplevel (Button)).Help_Msg.all,
            Buttons => Button_OK, Title => -"Help");
         return;
      end if;

      Gtkada_Dialog (Get_Toplevel (Button)).Value := Value;
      Main_Quit;
   end Clicked_Cb;

   --------------------
   -- Message_Dialog --
   --------------------

   function Message_Dialog
     (Msg            : String;
      Dialog_Type    : Message_Dialog_Type := Information;
      Buttons        : Message_Dialog_Buttons := Button_OK or Button_Help;
      Default_Button : Message_Dialog_Buttons := Button_OK;
      Help_Msg       : String := "";
      Title          : String := "";
      Justification  : Gtk_Justification := Justify_Center;
      Parent         : Gtk.Window.Gtk_Window := null)
      return Message_Dialog_Buttons
   is
      Dialog      : Gtkada_Dialog;
      Label       : Gtk_Label;
      Button      : Dialog_Button;
      Box         : Gtk_Box;
      Value       : Message_Dialog_Buttons;
      Pix         : Gtk_Pixmap;
      Pixmap      : Gdk_Pixmap;
      Mask        : Gdk_Pixmap;

      use Gdk;
   begin
      Dialog := new Gtkada_Dialog_Record;
      Gtk.Dialog.Initialize (Dialog);

      --  Realize it so that we force the creation of its Gdk_Window.
      --  This is needed below to create a pixmap.

      Realize (Dialog);

      if Help_Msg = "" then
         Dialog.Help_Msg := new String' (-"No Help Available");
      else
         Dialog.Help_Msg := new String' (Help_Msg);
      end if;

      Set_Modal (Dialog);
      if Parent /= null then
         Set_Transient_For (Dialog, Parent);
      else
         Set_Position (Dialog, Win_Pos_Mouse);
      end if;
      Return_Callback.Connect
        (Dialog, "delete_event",
         Return_Callback.To_Marshaller (Delete_Cb'Access));

      case Dialog_Type is
         when Warning =>
            Create_From_Xpm_D
              (Pixmap, Get_Window (Dialog), Mask,
               Null_Color, Warning_Xpm);
            Set_Title (Dialog, -"Warning");

         when Error =>
            Create_From_Xpm_D
              (Pixmap, Get_Window (Dialog), Mask,
               Null_Color, Error_Xpm);
            Set_Title (Dialog, -"Error");

         when Information =>
            Create_From_Xpm_D
              (Pixmap, Get_Window (Dialog), Mask,
               Null_Color, Information_Xpm);
            Set_Title (Dialog, -"Information");

         when Confirmation =>
            Create_From_Xpm_D
              (Pixmap, Get_Window (Dialog), Mask,
               Null_Color, Confirmation_Xpm);
            Set_Title (Dialog, -"Confirmation");

         when Custom =>
            null;
      end case;

      if Title /= "" then
         Set_Title (Dialog, Title);
      end if;

      Gtk_New_Hbox (Box);
      Pack_Start (Get_Vbox (Dialog), Box, Padding => 10);

      if Pixmap /= null then
         Gtk_New (Pix, Pixmap, Mask);
         Pack_Start (Box, Pix, Padding => 10);
      end if;

      Gtk_New (Label, Msg);
      Set_Justify (Label, Justification);
      Pack_Start (Box, Label, Padding => 10);

      for J in Button_Range loop
         if (Buttons and
             2 ** Integer (J)) /= 0
         then
            Button := new Dialog_Button_Record;
            Button.Button := 2 ** Integer (J);

            if Dialog_Button_Stock (J) = null then
               Initialize (Button, Trim (-Dialog_Button_String (J), Right));
            else
               Initialize_From_Stock (Button, Dialog_Button_Stock (J).all);
            end if;

            Set_USize (Button, 80, -1);
            Pack_Start
              (Get_Action_Area (Dialog), Button,
               False, False, 14);
            Set_Flags (Button, Can_Default);
            Widget_Callback.Connect
              (Button, "clicked",
               Widget_Callback.To_Marshaller (Clicked_Cb'Access));

            if Default_Button = 2 ** Integer (J) then
               Grab_Default (Button);
            end if;
         end if;
      end loop;

      Show_All (Dialog);
      Main;
      Value := Dialog.Value;
      Free (Dialog.Help_Msg);
      Destroy (Dialog);

      return Value;
   end Message_Dialog;

end Gtkada.Dialogs;
