-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--      Copyright (C) 2000 E. Briot, J. Brobecker and A. Charlet     --
--                Copyright (C) 2000-2003 ACT-Europe                 --
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
--  This package defines the root of the plot hierarchy. It defines several
--  display strategies that can be used to show scientific data on the
--  screen (see the children for 3D, polar, bars,...)
--
--  All coordinates are in percent of the total size allocates for the data
--  set (ie the actual position is (x * width, y * height), where (x, y) is
--  the value stored in the data set and (width, height) its allocated screen
--  size.
--  </description>
--  <c_version>gtk+extra 0.99.14<c_version>

with Glib; use Glib;
with Gtk.Widget;
with Gtkada.Types;
with Gdk.Color;
with Gdk.GC;
with Unchecked_Conversion;

package Gtk.Extra.Plot_Data is

   type Plot_Label_Style is (Label_Float, Label_Exp, Label_Pow);
   --  The style of labels (floating point, or scientific notation)
   pragma Convention (C, Plot_Label_Style);

   type Plot_Scale is (Scale_Linear, Scale_Log10);
   --  Type of scale used for each axis of a graph.
   pragma Convention (C, Plot_Scale);

   type Gtk_Plot_Data_Record is new Gtk.Widget.Gtk_Widget_Record with private;
   type Gtk_Plot_Data is access all Gtk_Plot_Data_Record'Class;
   --  A set of values that can be represented on the screen. There are
   --  several strategies to set the values, either explicitely in your
   --  application, or by having them automatically generated by a function.

   -----------
   -- Types --
   -----------

   type No_Range_Gdouble_Array is array (Natural) of Gdouble;
   --  An array of values.
   --  This is used to represent the data values displayed in the plot.
   --  This array does not have any range information (so that it can be
   --  easily returned from a C function, without requiring an extra
   --  copy of the table). You can not use 'Range on this array.

   type No_Range_Gdouble_Array_Access is access all No_Range_Gdouble_Array;
   --  An access to a flat array.

   type Gdouble_Array_Access is access all Glib.Gdouble_Array;
   --  The reason we use this type in the functions below is because
   --  gtk+-extra does not keep a copy of the arrays, but points to the one
   --  given in argument. Thus, the Ada arrays should not be allocated on the
   --  stack, or at least they should be at library level. Using this 'Access
   --  will force the compiler to do the check for us.

   type Points_Array is record
      Points     : No_Range_Gdouble_Array_Access;
      Num_Points : Gint := 0;
   end record;
   --  The points are indexed from 0 to Num_Points-1.
   --  Note that you can't use 'Range, 'First or 'Last on Points.

   type Plot_Connector is
     (Connect_None,
      --  No connection

      Connect_Straight,
      --  straight line

      Connect_Spline,
      --  spline or Bezier curve

      Connect_Hv_Step,
      --  Horizontal then vertical

      Connect_Vh_Step,
      --  Vertical then horizontal

      Connect_Middle_Step
      --  Split in the middle
     );
   --  The type of connection between two adjacent points in a graph.
   pragma Convention (C, Plot_Connector);

   type Plot_Gradient is new Integer;
   --  Indicate which color components vary along the gradient

   Gradient_H : constant Plot_Gradient; --  Hue
   Gradient_V : constant Plot_Gradient; --  Value
   Gradient_S : constant Plot_Gradient; --  Saturation

   type Plot_Symbol_Type is
     (Symbol_None,
      Symbol_Square,
      Symbol_Circle,
      Symbol_Up_Triangle,
      Symbol_Down_Triangle,
      Symbol_Right_Triangle,
      Symbol_Left_Triangle,
      Symbol_Diamond,
      Symbol_Plus,
      Symbol_Cross,
      Symbol_Star,
      Symbol_Dot,
      Symbol_Impulse);
   --  Type of symbol used to represent the points in a graph.
   pragma Convention (C, Plot_Symbol_Type);

   type Plot_Symbol_Style is
     (Symbol_Empty,
      Symbol_Filled,
      Symbol_Opaque);
   --  Style used to draw the points in a graph.
   pragma Convention (C, Plot_Symbol_Style);

   type Plot_Line_Style is
     (Line_None,
      Line_Solid,
      Line_Dotted,
      Line_Dashed,
      Line_Dot_Dash,
      Line_Dot_Dot_Dash,
      Line_Dot_Dash_Dash);
   --  Lines used to connect two adjacent points in a graph.
   pragma Convention (C, Plot_Line_Style);

   --------------------
   -- Plot functions --
   --------------------
   --  Plot functions should generate a unique Y value given a parameter.
   --  These can be used for instance to represent exactly mathematical
   --  functions.
   --  Note that due to the C interface, the subprograms in Gtk.Extra.Plot and
   --  in this package expect functions that take a System.Address as a
   --  parameter. However, since it is much more convenient in your application
   --  to get a Gtk_Plot_Record directly, GtkAda includes a generic function
   --  that automatically does the conversion for you (see
   --  Gtk.Plot.Generic_Plot_Function).

   type Plot_Function is access function
     (Plot  : System.Address;
      Set   : Gtk_Plot_Data;
      X     : Gdouble;
      Error : access Gboolean) return Gdouble;
   --  Function used for plotting.
   --  It should return the value associated with X in its graph, and set
   --  Error to True if there was an error while calculating the value.

   pragma Convention (C, Plot_Function);

   -------------------------
   -- Creating a Data set --
   -------------------------

   procedure Gtk_New (Data : out Gtk_Plot_Data; Func : Plot_Function := null);
   --  Creates a new data set. Its values can either be generated automatically
   --  from Func, or will have to be set explicitely using the other
   --  subprograms in this package.

   procedure Initialize
     (Data : access Gtk_Plot_Data_Record'Class; Func : Plot_Function := null);
   --  Internal initialization function.
   --  See the section "Creating your own widgets" in the documentation.

   function Get_Type return Gtk.Gtk_Type;
   --  Return the internal value associated with a Gtk_Plot_Data.

   procedure Set_Name (Data : access Gtk_Plot_Data_Record; Name : String);
   --  Set the name used internally for that dataset.
   --  This name does not appear anywhere on the screen, but it is easier to
   --  find the dataset afterward by using this name.

   -------------------
   -- Drawing a set --
   -------------------
   --  Although a set is basically a list of values, it is closely associated
   --  with its representation on the screen (see the children of Gtk_Plot_Data
   --  for various possible representations).
   --  The Gtk.Extra packages are designed so that the drawing can be done
   --  either to the screen (through a Gdk adapter), to a postscript file for
   --  easy printing, or to any other media.

   procedure Paint (Data : access Gtk_Plot_Data_Record);
   --  Emits the "draw_data" signal to request a redrawing of the data set.

   procedure Update (Data : access Gtk_Plot_Data_Record);
   --  Indicates that the data has changed, and the graphical view should
   --  reflect this.

   procedure Draw_Points (Data : access Gtk_Plot_Data_Record; N : Gint);
   --  Draw the N last (most recent) values of the Data set on the screen.
   --  If N is greater than the actual number of values in Data, then they are
   --  all displayed. This subprogram should be used when you want to
   --  periodically update the contents of a dataset (you would then modify
   --  the number of points in the dataset with a call to Set_Numpoints, then
   --  register the new points with Set_X and Set_Y, and finally refresh the
   --  dataset with a call to Draw_Points and Gtk.Plot.Refresh).

   procedure Draw_Symbol (Data : access Gtk_Plot_Data_Record; X, Y : Gdouble);
   --  Draw the current symbol (see Set_Symbol) at specific coordinates on
   --  the screen.

   -------------------------
   -- Manipulating values --
   -------------------------

   procedure Set_Points
     (Data : access Gtk_Plot_Data_Record;
      X    : Gdouble_Array_Access;
      Y    : Gdouble_Array_Access;
      Dx   : Gdouble_Array_Access;
      Dy   : Gdouble_Array_Access);
   --  Set some explicit points in the set.
   --  Note that the set must not be associated with a function, or the points
   --  will simply be ignored.
   --  All of the arrays must have the same length, the behavior is undefined
   --  otherwise.
   --  X and Y are the list of coordinates of the points.
   --  Dx and Dy are the list of size (precision) of these points. A bigger
   --  symbol will be displayed for the point whose (Dx, Dy) value is bigger.

   procedure Get_Points
     (Data : access Gtk_Plot_Data_Record;
      X    : out Points_Array;
      Y    : out Points_Array;
      Dx   : out Points_Array;
      Dy   : out Points_Array);
   --  Return the value of the points in the set.
   --  Null-length arrays are returned if the set is associated with a
   --  function, since no explicit point has been set.
   --  See Set_Points for a definition of X, Y, Dx and Dy.

   procedure Set_X
     (Data : access Gtk_Plot_Data_Record; X : Gdouble_Array_Access);
   procedure Set_Y
     (Data : access Gtk_Plot_Data_Record; Y : Gdouble_Array_Access);
   procedure Set_Z
     (Data : access Gtk_Plot_Data_Record; Z : Gdouble_Array_Access);
   procedure Set_A
     (Data : access Gtk_Plot_Data_Record; A : Gdouble_Array_Access);
   --  Set the values for one specific coordinate in the set.
   --  The array must have a length of Get_Numpoints (if GtkAda was
   --  compiled with assertions enabled, an exception will be raised if the
   --  length are different).
   --  No copy of the array is made for efficiency reasons, thus modifying
   --  the array content later on will also modify the plot.
   --
   --  "A" is used to specify the size of the symbols. When plotting boxes in
   --  two dimensions, "Z" is used to specify the size of the box.

   procedure Set_A_Scale
     (Data : access Gtk_Plot_Data_Record; A_Scale : Gdouble);
   function Get_A_Scale
     (Data : access Gtk_Plot_Data_Record) return Gdouble;
   --  Changes the scale used for the "A" coordinate

   procedure Set_Dx
     (Data : access Gtk_Plot_Data_Record; Dx : Gdouble_Array_Access);
   procedure Set_Dy
     (Data : access Gtk_Plot_Data_Record; Dy : Gdouble_Array_Access);
   procedure Set_Dz
     (Data : access Gtk_Plot_Data_Record; Dz : Gdouble_Array_Access);
   --  Set the precision of the points in the set. A bigger symbol is displayed
   --  for the points whose (Dx, Dy, Dz) is bigger.
   --  The array must have a length of Get_Numpoints (if GtkAda was
   --  compiled with assertions enabled, an exception will be raised if the
   --  length are different).
   --  No copy of the array is made for efficiency reasons, thus modifying
   --  the array content later on will also modify the plot.

   procedure Set_Da
     (Data : access Gtk_Plot_Data_Record; Da : Gdouble_Array_Access);
   --  Specifies the colors to use for the points.
   --  The color of the symbols is detemined using the gradient. the gradient
   --  has (min, max) values, and corresponding colors. The symbol's color is
   --  interpolated between these values using hue/saturation/value depending
   --  on the gradient_mask.

   function Get_X  (Data : access Gtk_Plot_Data_Record) return Points_Array;
   function Get_Y  (Data : access Gtk_Plot_Data_Record) return Points_Array;
   function Get_Z  (Data : access Gtk_Plot_Data_Record) return Points_Array;
   function Get_A  (Data : access Gtk_Plot_Data_Record) return Points_Array;
   function Get_Dx (Data : access Gtk_Plot_Data_Record) return Points_Array;
   function Get_Dy (Data : access Gtk_Plot_Data_Record) return Points_Array;
   function Get_Dz (Data : access Gtk_Plot_Data_Record) return Points_Array;
   function Get_Da (Data : access Gtk_Plot_Data_Record) return Points_Array;
   --  Return the coordinates for the points in the set.
   --  This is a direct access to the underlying C array, thus modifying this
   --  array's contents also modifies the graph.
   --  See the corresponding Set_* functions for a definition of the
   --  coordinates

   procedure Set_Numpoints (Data : access Gtk_Plot_Data_Record; Num : Gint);
   --  Set the number of points that should be expected in the graph.
   --  Note that this does not automatically resize all the internal structure,
   --  it just indicates what size the parameters to Set_X, Set_Y,... should
   --  have.

   function Get_Numpoints (Data : access Gtk_Plot_Data_Record) return Gint;
   --  Return the number of points expected in the graph.

   ------------
   -- Labels --
   ------------
   --  Each point in the data set can be associated with a label that describes
   --  it. This is only relevant for data sets where you explicitely give
   --  values, not when the values are generated by a function.

   procedure Set_Labels
     (Data : access Gtk_Plot_Data_Record;
      Labels : Gtkada.Types.Chars_Ptr_Array);
   --  Set the labels associated which each point in the canvas.
   --  There must be at least Get_Numpoints elements in Labels, or the
   --  behavior is undefined

   function Get_Labels (Data : access Gtk_Plot_Data_Record)
      return Gtkada.Types.Chars_Ptr_Array;
   --  Return the labels associated with the points in the data set.
   --  Note that this returns a *copy* of the actual array, and thus might
   --  be expensive to call.

   procedure Show_Labels (Data : access Gtk_Plot_Data_Record; Show : Boolean);
   --  Indicate whether the labels should be displayed next to each point in
   --  the data set. This has no effect if no labels were specified.

   procedure Labels_Set_Attributes
     (Data : access Gtk_Plot_Data_Record;
      Font : String;
      Height : Gint;
      Angle  : Gint;
      Foreground : Gdk.Color.Gdk_Color;
      Background : Gdk.Color.Gdk_Color);
   --  Set the properties of the labels

   ----------------------------
   -- Symbols and Connectors --
   ----------------------------
   --  Each point that is explicitely set in the data set through the
   --  Set_X, Set_Y,... subprograms is visually associated with a symbol. There
   --  are several representations for the symbols.
   --
   --  All these symbols are then connected by a line, a curve or any other
   --  link. These are called connectors.
   --
   --  Each symbol, in addition to being connected to the next one with a
   --  connector, can also be linked to the axis X=0, Y=0 or Z=0 so that it is
   --  easier to read its coordinates. These are called errbars, and they must
   --  be explicitely shown.

   procedure Set_Symbol
     (Data         : access Gtk_Plot_Data_Record;
      The_Type     : Plot_Symbol_Type;
      Style        : Plot_Symbol_Style;
      Size         : Gint;
      Line_Width   : Gfloat;
      Color        : Gdk.Color.Gdk_Color;
      Border_Color : Gdk.Color.Gdk_Color);
   --  Set the visual aspect of the symbols.

   procedure Get_Symbol
     (Data         : access Gtk_Plot_Data_Record;
      The_Type     : out Plot_Symbol_Type;
      Style        : out Plot_Symbol_Style;
      Size         : out Gint;
      Line_Width   : out Gint;
      Color        : out Gdk.Color.Gdk_Color;
      Border_Color : out Gdk.Color.Gdk_Color);
   --  Return the visual characteristics of the symbols.

   procedure Set_Connector
     (Data : access Gtk_Plot_Data_Record; Connector : Plot_Connector);
   --  Set the style of the connectors.

   function Get_Connector (Data : access Gtk_Plot_Data_Record)
      return Plot_Connector;
   --  Return the connector style used for the data set.

   procedure Set_Line_Attributes
     (Data       : access Gtk_Plot_Data_Record;
      Style      : Plot_Line_Style;
      Cap_Style  : Gdk.GC.Gdk_Cap_Style;
      Join_Style : Gdk.GC.Gdk_Join_Style;
      Width      : Gfloat;
      Color      : Gdk.Color.Gdk_Color);
   --  Set the line style used for the connectors.

   procedure Get_Line_Attributes
     (Data       : access Gtk_Plot_Data_Record;
      Style      : out Plot_Line_Style;
      Cap_Style  : out Gdk.GC.Gdk_Cap_Style;
      Join_Style : out Gdk.GC.Gdk_Join_Style;
      Width      : out Gfloat;
      Color      : out Gdk.Color.Gdk_Color);
   --  Return the line attributes used for the connectors.

   procedure Set_X_Attributes
     (Data       : access Gtk_Plot_Data_Record;
      Style      : Plot_Line_Style;
      Cap_Style  : Gdk.GC.Gdk_Cap_Style;
      Join_Style : Gdk.GC.Gdk_Join_Style;
      Width      : Gfloat;
      Color      : Gdk.Color.Gdk_Color);
   --  Set the style of the lines used to connect the symbols to the X axis.

   procedure Set_Y_Attributes
     (Data       : access Gtk_Plot_Data_Record;
      Style      : Plot_Line_Style;
      Cap_Style  : Gdk.GC.Gdk_Cap_Style;
      Join_Style : Gdk.GC.Gdk_Join_Style;
      Width      : Gfloat;
      Color      : Gdk.Color.Gdk_Color);
   --  Set the style of the lines used to connect the symbols to the Y axis.

   procedure Set_Z_Attributes
     (Data       : access Gtk_Plot_Data_Record;
      Style      : Plot_Line_Style;
      Cap_Style  : Gdk.GC.Gdk_Cap_Style;
      Join_Style : Gdk.GC.Gdk_Join_Style;
      Width      : Gfloat;
      Color      : Gdk.Color.Gdk_Color);
   --  Set the style of the lines used to connect the symbols to the Z axis.

   procedure Show_Xerrbars (Data : access Gtk_Plot_Data_Record);
   procedure Show_Yerrbars (Data : access Gtk_Plot_Data_Record);
   procedure Show_Zerrbars (Data : access Gtk_Plot_Data_Record);
   --  Indicate that each symbol should be connected to the various axis

   procedure Hide_Xerrbars (Data : access Gtk_Plot_Data_Record);
   procedure Hide_Yerrbars (Data : access Gtk_Plot_Data_Record);
   procedure Hide_Zerrbars (Data : access Gtk_Plot_Data_Record);
   --  Indicate the the symbol should not be connected to the axis.

   procedure Fill_Area (Data : access Gtk_Plot_Data_Record; Fill : Boolean);
   --  Indicate whether the area between two points should be filled or not.

   function Area_Is_Filled (Data : access Gtk_Plot_Data_Record)
      return Boolean;
   --  Indicate whether the area between two points is filled.

   -------------
   -- Legends --
   -------------
   --  In addition to the drawing corresponding to the data set, it is possible
   --  to display a box that contains a legend. This is particulary useful when
   --  multiple data sets are displayed on the same plot.

   procedure Set_Legend (Data : access Gtk_Plot_Data_Record; Legend : String);
   --  Set the string printed in the legend for that data set.
   --  Note that an entry can exist in the legend even if there is no name
   --  associated with the graph.

   procedure Show_Legend (Data : access Gtk_Plot_Data_Record);
   --  An entry will be made in the plot's legend for that dataset.

   procedure Hide_Legend (Data : access Gtk_Plot_Data_Record);
   --  No entry will appear in the plot's legend for that dataset.

   procedure Set_Legend_Precision
     (Data : access Gtk_Plot_Data_Record; Precision : Gint);
   --  Number of digits to display when the legends is associated with values,
   --  as is the case for gradients.

   function Get_Legend_Precision (Data : access Gtk_Plot_Data_Record)
      return Gint;
   --  Return the number of digits used for values in the legend

   ---------------
   -- Gradients --
   ---------------
   --  The symbols displayed in the plot can be assigned specific colors. But
   --  they can also compute their own color by picking it in a gradient,
   --  depending on the value.

   procedure Reset_Gradient (Data : access Gtk_Plot_Data_Record);
   --  Reset the gradient to its default value

   procedure Reset_Gradient_Colors (Data : access Gtk_Plot_Data_Record);
   --  Reset the colors of the gradient to their default values

   procedure Set_Gradient_Mask
     (Data : access Gtk_Plot_Data_Record; Mask : Plot_Gradient);
   --  Indicates which component of the colors vary along the gradient.

   function Get_Gradient_Mask (Data : access Gtk_Plot_Data_Record)
      return Plot_Gradient;
   --  Return the mask used for the gradient.

   procedure Gradient_Set_Visible
     (Data : access Gtk_Plot_Data_Record; Visible : Boolean);
   --  Indicates whether the gradient should be visible

   function Gradient_Visible (Data : access Gtk_Plot_Data_Record)
      return Boolean;
   --  Return True if the gradient is currently visible

   procedure Set_Gradient_Colors
     (Data : access Gtk_Plot_Data_Record;
      Min, Max : Gdk.Color.Gdk_Color);
   --  Set the colors that define the gradient. The colors will vary from
   --  Min to Max along the components specified in Set_Gradient_Mask.

   procedure Get_Gradient_Colors
     (Data : access Gtk_Plot_Data_Record;
      Min, Max : out Gdk.Color.Gdk_Color);
   --  Return the colors that define the range

   procedure Set_Gradient_Nth_Color
     (Data  : access Gtk_Plot_Data_Record;
      Level : Guint;
      Color : Gdk.Color.Gdk_Color);
   --  Set the nth color in the gradient

   function Get_Gradient_Nth_Color
     (Data  : access Gtk_Plot_Data_Record; Level : Guint)
      return Gdk.Color.Gdk_Color;
   --  Get the nth color of the gradient

   procedure Set_Gradient_Outer_Colors
     (Data : access Gtk_Plot_Data_Record;
      Min, Max : Gdk.Color.Gdk_Color);
   --  Set the outer colors for the gradient

   procedure Set_Gradient
     (Data     : access Gtk_Plot_Data_Record;
      Min, Max : Gdouble;
      Nlevels  : Gint);
   --  Define the values associated with the minimal color and the maximal
   --  color. Any value in between will have a color computed in between.
   --  Nlevels is the number of ticks to display in the gradient.

   procedure Get_Gradient
     (Data     : access Gtk_Plot_Data_Record;
      Min, Max : out Gdouble;
      Nlevels  : out Gint);
   --  Return the values associated with the minimal and maximal colors.

   procedure Get_Gradient_Level
     (Data  : access Gtk_Plot_Data_Record;
      Level : Gdouble;
      Color : out Gdk.Color.Gdk_Color);
   --  Return the color associated with a specific level.
   --  The color depends on the parameters to Set_Gradient and
   --  Set_Gradient_Colors.

   procedure Draw_Gradient
     (Data : access Gtk_Plot_Data_Record; X, Y : Gint);
   --  Draw the gradient ast specific coordinates

   procedure Gradient_Autoscale_A (Data : access Gtk_Plot_Data_Record);
   --  ???

   procedure Gradient_Autoscale_Da (Data : access Gtk_Plot_Data_Record);
   --  ???

   procedure Gradient_Autoscale_Z (Data : access Gtk_Plot_Data_Record);
   --  ???

   procedure Gradient_Set_Style
     (Data      : access Gtk_Plot_Data_Record;
      Style     : Plot_Label_Style;
      Precision : Gint);
   --  ???

   procedure Gradient_Set_Scale
     (Data      : access Gtk_Plot_Data_Record;
      Scale     : Plot_Scale);
   --  Set the scale of the gradient

   -------------
   -- Markers --
   -------------

   type Gtk_Plot_Marker is new Glib.C_Proxy;

   function Add_Marker
     (Data : access Gtk_Plot_Data_Record; Point : Guint)
      return Gtk_Plot_Marker;
   --  Add a new marker

   procedure Remove_Marker
     (Data : access Gtk_Plot_Data_Record; Marker : Gtk_Plot_Marker);
   --  Remove a marker from the plot

   procedure Remove_Markers (Data : access Gtk_Plot_Data_Record);
   --  Remove all markers

   procedure Show_Markers (Data : access Gtk_Plot_Data_Record; Show : Boolean);
   --  Whether markers should be shown

   function Markers_Visible (Data : access Gtk_Plot_Data_Record)
      return Boolean;
   --  Whether markers are currently visible

   ---------------
   -- User Data --
   ---------------
   --  It is possible to associated your own user data with a plot. This is
   --  the mechanism provided by the C version of gtkextra. However, the best
   --  way to do this in Ada is to inherit from Gtk_Plot_Data_Record (or one
   --  of its children), and add your own fields.

   procedure Set_Link
     (Data : access Gtk_Plot_Data_Record;
      Link : System.Address);
   --  Associate some user data with Data.
   --  It is the responsability of the user to do some convert conversion to
   --  System.Address.

   function Get_Link (Data : access Gtk_Plot_Data_Record)
      return System.Address;
   --  Return the user data associated with Data, or Null_Address if there is
   --  none.

   procedure Remove_Link (Data : access Gtk_Plot_Data_Record);
   --  Remove the user data associated with Data.


   --  <doc_ignore>
   function To_Double_Array is new Unchecked_Conversion
     (System.Address, No_Range_Gdouble_Array_Access);
   --  </doc_ignore>

private
   type Gtk_Plot_Data_Record is new Gtk.Widget.Gtk_Widget_Record with
     null record;

   Gradient_H : constant Plot_Gradient := 1;
   Gradient_V : constant Plot_Gradient := 2;
   Gradient_S : constant Plot_Gradient := 4;

   pragma Import (C, Get_Type, "gtk_plot_data_get_type");
end Gtk.Extra.Plot_Data;

--  Unbound:
--    gtk_plot_data_new_iterator
--    gtk_plot_data_clone
--    gtk_plot_data_get_gradient_outer_colors
