with Gdk; use Gdk;
with Gtk.Enums; use Gtk.Enums;

package body Gtk.Style is

   ------------
   -- Adjust --
   ------------

   procedure Adjust (Object : in out Gtk_Style) is
   begin
      null;
      --  IFREF Ref (Object);
   end Adjust;

   --------------
   --  Attach  --
   --------------

   function Attach (Style  : in Gtk_Style;
                    Window : in Gdk.Window.Gdk_Window) return Gtk_Style is
      function Internal (Style : in System.Address;
                         Window : in System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_style_attach");
      Result : Gtk_Style;
   begin
      Gtk.Set_Object (Result, Internal (Gtk.Get_Object (Style),
                                        Gdk.Get_Object (Window)));
      return Result;
   end Attach;


   ------------
   --  Copy  --
   ------------

   procedure Copy (Source : in Gtk_Style;
                   Destination : out Gtk_Style) is
      function Internal (Style : in System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_style_copy");
   begin
      Gtk.Set_Object (Destination, Internal (Gtk.Get_Object (Source)));
   end Copy;


   --------------
   --  Detach  --
   --------------

   procedure Detach (Style : in out Gtk_Style) is
      procedure Internal (Style : in System.Address);
      pragma Import (C, Internal, "gtk_style_detach");
   begin
      Internal (Gtk.Get_Object (Style));
   end Detach;


   ------------------
   --  Draw_Arrow  --
   ------------------

   procedure Draw_Arrow (Style       : in Gtk_Style;
                         Window      : in Gdk.Window.Gdk_Window;
                         State_Type  : in Enums.Gtk_State_Type;
                         Shadow_Type : in Enums.Gtk_Shadow_Type;
                         Arrow_Type  : in Enums.Gtk_Arrow_Type;
                         Fill        : in Gint;
                         X, Y        : in Gint;
                         Width       : in Gint;
                         Height      : in Gint) is
      procedure Internal (Style, Window : in System.Address;
                          State_Type  : in Enums.Gtk_State_Type;
                          Shadow_Type : in Enums.Gtk_Shadow_Type;
                          Arrow_Type  : in Enums.Gtk_Arrow_Type;
                          Fill        : in Gint;
                          X, Y        : in Gint;
                          Width       : in Gint;
                          Height      : in Gint);
      pragma Import (C, Internal, "gtk_draw_arrow");
   begin
      Internal (Gtk.Get_Object (Style), Gdk.Get_Object (Window), State_Type,
                Shadow_Type, Arrow_Type, Fill, X, Y, Width, Height);
   end Draw_Arrow;



   --------------------
   --  Draw_Diamond  --
   --------------------

   procedure Draw_Diamond (Style       : in Gtk_Style;
                           Window      : in Gdk.Window.Gdk_Window;
                           State_Type  : in Enums.Gtk_State_Type;
                           Shadow_Type : in Enums.Gtk_Shadow_Type;
                           X, Y        : in Gint;
                           Width       : in Gint;
                           Height      : in Gint) is
      procedure Internal (Style, Window : in System.Address;
                          State_Type  : in Enums.Gtk_State_Type;
                          Shadow_Type : in Enums.Gtk_Shadow_Type;
                          X, Y        : in Gint;
                          Width       : in Gint;
                          Height      : in Gint);
      pragma Import (C, Internal, "gtk_draw_diamond");
   begin
      Internal (Gtk.Get_Object (Style), Gdk.Get_Object (Window), State_Type,
                Shadow_Type, X, Y, Width, Height);
   end Draw_Diamond;


   ------------------
   --  Draw_Hline  --
   ------------------

   procedure Draw_Hline (Style      : in Gtk_Style;
                         Window     : in Gdk.Window.Gdk_Window;
                         State_Type : in Enums.Gtk_State_Type;
                         X1, X2     : in Gint;
                         Y          : in Gint) is
      procedure Internal (Style, Window : in System.Address;
                          State_Type    : in Enums.Gtk_State_Type;
                          X1, X2, Y     : in Gint);
      pragma Import (C, Internal, "gtk_draw_hline");
   begin
      Internal (Gtk.Get_Object (Style), Gdk.Get_Object (Window),
                State_Type, X1, X2, Y);
   end Draw_Hline;


   -----------------
   --  Draw_Oval  --
   -----------------

   procedure Draw_Oval (Style       : in Gtk_Style;
                        Window      : in Gdk.Window.Gdk_Window;
                        State_Type  : in Enums.Gtk_State_Type;
                        Shadow_Type : in Enums.Gtk_Shadow_Type;
                        X, Y        : in Gint;
                        Width       : in Gint;
                        Height      : in Gint) is
      procedure Internal (Style, Window : in System.Address;
                          State_Type  : in Enums.Gtk_State_Type;
                          Shadow_Type : in Enums.Gtk_Shadow_Type;
                          X, Y        : in Gint;
                          Width       : in Gint;
                          Height      : in Gint);
      pragma Import (C, Internal, "gtk_draw_oval");
   begin
      Internal (Gtk.Get_Object (Style), Gdk.Get_Object (Window), State_Type,
                Shadow_Type, X, Y, Width, Height);
   end Draw_Oval;


   --------------------
   --  Draw_Polygon  --
   --------------------

   procedure Draw_Polygon (Style       : in Gtk_Style;
                           Window      : in Gdk.Window.Gdk_Window;
                           State_Type  : in Enums.Gtk_State_Type;
                           Shadow_Type : in Enums.Gtk_Shadow_Type;
                           Points      : in Points_Array;
                           Fill        : in Gint) is
      procedure Internal (Style, Window : in System.Address;
                          State_Type    : in Enums.Gtk_State_Type;
                          Shadow_Type   : in Enums.Gtk_Shadow_Type;
                          Points        : in Points_Array;
                          Npoints       : in Gint;
                          Fill          : in Gint);
      pragma Import (C, Internal, "gtk_draw_polygon");
   begin
      Internal (Gtk.Get_Object (Style), Gdk.Get_Object (Window), State_Type,
                Shadow_Type, Points, Points'Length, Fill);
   end Draw_Polygon;


   -------------------
   --  Draw_Shadow  --
   -------------------

   procedure Draw_Shadow (Style       : in Gtk_Style;
                          Window      : in Gdk.Window.Gdk_Window;
                          State_Type  : in Enums.Gtk_State_Type;
                          Shadow_Type : in Enums.Gtk_Shadow_Type;
                          X, Y        : in Gint;
                          Width       : in Gint;
                          Height      : in Gint) is
      procedure Internal (Style, Window       : in System.Address;
                          State_Type          : in Enums.Gtk_State_Type;
                          Shadow_Type         : in Enums.Gtk_Shadow_Type;
                          X, Y, Width, Height : Gint);
      pragma Import (C, Internal, "gtk_draw_shadow");
   begin
      Internal (Gtk.Get_Object (Style), Gdk.Get_Object (Window),
                State_Type, Shadow_Type, X, Y, Width, Height);
   end Draw_Shadow;


   -------------------
   --  Draw_String  --
   -------------------

   procedure Draw_String (Style       : in Gtk_Style;
                          Window      : in Gdk.Window.Gdk_Window;
                          State_Type  : in Enums.Gtk_State_Type;
                          X, Y        : in Gint;
                          Str         : in String) is
      procedure Internal (Style, Window : in System.Address;
                          State_Type    : in Enums.Gtk_State_Type;
                          X, Y          : in Gint;
                          Str           : in String);
      pragma Import (C, Internal, "gtk_draw_string");
   begin
      Internal (Gtk.Get_Object (Style), Gdk.Get_Object (Window),
                State_Type, X,  Y, Str & ASCII.NUL);
   end Draw_String;


   ------------------
   --  Draw_Vline  --
   ------------------

   procedure Draw_Vline (Style      : in Gtk_Style;
                         Window     : in Gdk.Window.Gdk_Window;
                         State_Type : in Enums.Gtk_State_Type;
                         Y1, Y2     : in Gint;
                         X          : in Gint) is
      procedure Internal (Style, Window : in System.Address;
                          State_Type    : in Enums.Gtk_State_Type;
                          Y1, Y2, X     : in Gint);
      pragma Import (C, Internal, "gtk_draw_vline");
   begin
      Internal (Gtk.Get_Object (Style), Gdk.Get_Object (Window),
                State_Type, Y1, Y2, X);
   end Draw_Vline;

   ------------
   -- Get_Bg --
   ------------

   function Get_Bg (Style      : in Gtk_Style;
                    State_Type : in Enums.Gtk_State_Type)
                    return          Gdk.Color.Gdk_Color
   is
      function Internal (Style      : in System.Address;
                         State_Type : in Gint)
                        return System.Address;
      pragma Import (C, Internal, "ada_style_get_bg");
      Color : Gdk.Color.Gdk_Color;
   begin
      Set_Object (Color, Internal (Gtk.Get_Object (Style),
                                   Gtk_State_Type'Pos (State_Type)));
      return Color;
   end Get_Bg;

   ---------------
   -- Get_Black --
   ---------------

   function Get_Black (Style : in Gtk_Style) return Gdk.Color.Gdk_Color is
      function Internal (Style      : in System.Address)
                        return System.Address;
      pragma Import (C, Internal, "ada_style_get_black");
      Color : Gdk.Color.Gdk_Color;
   begin
      Set_Object (Color, Internal (Gtk.Get_Object (Style)));
      return Color;
   end Get_Black;

   ---------------
   -- Get_White --
   ---------------

   function Get_White (Style : in Gtk_Style) return Gdk.Color.Gdk_Color is
      function Internal (Style      : in System.Address)
                        return System.Address;
      pragma Import (C, Internal, "ada_style_get_white");
      Color : Gdk.Color.Gdk_Color;
   begin
      Set_Object (Color, Internal (Gtk.Get_Object (Style)));
      return Color;
   end Get_White;

   ---------------
   --  Gtk_New  --
   ---------------

   procedure Gtk_New (Style : out Gtk_Style) is
      function Internal return System.Address;
      pragma Import (C, Internal, "gtk_style_new");
   begin
      Gtk.Set_Object (Style, Internal);
   end Gtk_New;

   ---------------
   -- Get_Style --
   ---------------

   function Get_Style (Widget : in Gtk.Widget.Gtk_Widget'Class)
                      return       Gtk.Style.Gtk_Style
   is
      function Internal (Widget : System.Address)
                        return    System.Address;
      pragma Import (C, Internal, "ada_widget_get_style");
      Style : Gtk.Style.Gtk_Style;
   begin
      Gtk.Set_Object (Style, Internal (Gtk.Get_Object (Widget)));
      return Style;
   end Get_Style;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (Object : in out Gtk_Style) is
   begin
      null;
      --  IFREF Unref (Object);
   end Finalize;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Object : in out Gtk_Style) is
   begin
      null;
      --  IFREF Ref (Object);
   end Initialize;

   ---------
   -- Ref --
   ---------

   procedure Ref (Object : in out Gtk_Style) is
      procedure Internal (Object : in System.Address);
      pragma Import (C, Internal, "gtk_style_ref");
      use type System.Address;
   begin
      if Gtk.Get_Object (Object) /= System.Null_Address then
         Internal (Gtk.Get_Object (Object));
      end if;
   end Ref;

   ----------------------
   --  Set_Background  --
   ----------------------

   procedure Set_Background (Style      : in out Gtk_Style;
                             Window     : in     Gdk.Window.Gdk_Window;
                             State_Type : in     Enums.Gtk_State_Type) is
      procedure Internal (Style      : in System.Address;
                          Window     : in System.Address;
                          State_Type : in Enums.Gtk_State_Type);
      pragma Import (C, Internal, "gtk_style_set_background");
   begin
      Internal (Gtk.Get_Object (Style), Gdk.Get_Object (Window), State_Type);
   end Set_Background;

   -----------
   -- Unref --
   -----------

   procedure Unref (Object : in out Gtk_Style) is
      procedure Internal (Object : in System.Address);
      pragma Import (C, Internal, "gtk_style_unref");
      use type System.Address;
   begin
      if Gtk.Get_Object (Object) /= System.Null_Address then
         Internal (Gtk.Get_Object (Object));
      end if;
   end Unref;


end Gtk.Style;
