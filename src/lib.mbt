// Copyright 2026 Ling71671
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
/// Umbrella facade re-exporting the layered packages:
/// `math` -> `color` -> `draw` -> `core` -> `widgets` -> `composite`.
/// Import this only when the whole toolkit is wanted; application code that
/// needs the bare immediate-mode runtime should import `src/core` directly.
// Foundation: geometry, color, draw commands
pub type Vec2 = @math.Vec2

///|
pub type Rect = @math.Rect

///|
pub type Color = @color.Color

///|
pub type DrawCmd = @draw.DrawCmd

///|
pub type DrawList = @draw.DrawList

// Engine runtime

///|
pub type Id = @core.Id

///|
pub type IdStack = @core.IdStack

///|
pub type RawInput = @core.RawInput

///|
pub type InputState = @core.InputState

///|
pub type Event = @core.Event

///|
pub type Key = @core.Key

///|
pub type Modifiers = @core.Modifiers

///|
pub type Response = @core.Response

///|
pub type Painter = @core.Painter

///|
pub type WidgetStyle = @core.WidgetStyle

///|
pub type Theme = @core.Theme

///|
pub type Memory = @core.Memory

///|
pub type UIContext = @core.UIContext

///|
/// Re-exported engine trait so downstream packages can implement custom
/// widgets against the facade without naming `src/core` explicitly.
pub using @core {trait Widget}

// Standard widgets (src/widgets)

///|
pub type Button = @widgets.Button

///|
pub type Slider = @widgets.Slider

///|
pub type SliderRef = @widgets.SliderRef

///|
pub type Toggle = @widgets.Toggle

///|
pub type ToggleRef = @widgets.ToggleRef

///|
pub type Checkbox = @widgets.Checkbox

///|
pub type CheckboxRef = @widgets.CheckboxRef

///|
pub type Radio = @widgets.Radio

///|
pub type Label = @widgets.Label

///|
pub type Separator = @widgets.Separator

///|
pub type Badge = @widgets.Badge

///|
pub type BadgeKind = @widgets.BadgeKind

///|
pub type ProgressBar = @widgets.ProgressBar

///|
pub type TextEdit = @widgets.TextEdit

///|
pub type TextEditRef = @widgets.TextEditRef

///|
pub type ScrollArea = @widgets.ScrollArea

///|
pub type Splitter = @widgets.Splitter

///|
pub type Window = @widgets.Window

///|
pub type Dialog = @widgets.Dialog

///|
pub type DialogKind = @widgets.DialogKind

///|
pub type DialogResult = @widgets.DialogResult

///|
pub type Toast = @widgets.Toast

///|
pub type ToastKind = @widgets.ToastKind

///|
pub type ToastAnchor = @widgets.ToastAnchor

///|
pub type ToastResponse = @widgets.ToastResponse

///|
pub type Tooltip = @widgets.Tooltip

///|
pub type Breadcrumb = @widgets.Breadcrumb

///|
pub type SegmentedControl = @widgets.SegmentedControl

///|
pub type CollapsingHeader = @widgets.CollapsingHeader

///|
pub type ComboBox = @widgets.ComboBox

///|
pub type TabBar = @widgets.TabBar

// Composite components (src/composite)

///|
pub type CodeEditor = @composite.CodeEditor

///|
pub type CodeEditorRef = @composite.CodeEditorRef

///|
pub type CodeEditorStyle = @composite.CodeEditorStyle

///|
pub type RichTextResponse = @composite.RichTextResponse

///|
pub type TextSpan = @composite.TextSpan

///|
pub type TextSpanKind = @composite.TextSpanKind

///|
pub type Knob = @composite.Knob

///|
pub type KnobRef = @composite.KnobRef

///|
pub type KnobStyle = @composite.KnobStyle

///|
pub type Fader = @composite.Fader

///|
pub type FaderRef = @composite.FaderRef

///|
pub type FaderStyle = @composite.FaderStyle

///|
pub type Sparkline = @composite.Sparkline

///|
pub type Plot = @composite.Plot

///|
pub type PlotPoint = @composite.PlotPoint

///|
pub type PlotSeries = @composite.PlotSeries

///|
pub type PlotSeriesKind = @composite.PlotSeriesKind

///|
pub type PlotStyle = @composite.PlotStyle

///|
pub type BarChart = @composite.BarChart

///|
pub type Table = @composite.Table

///|
pub type TableColumn = @composite.TableColumn

///|
pub type TableResponse = @composite.TableResponse

///|
pub type TableStyle = @composite.TableStyle

///|
pub type TableSortDirection = @composite.TableSortDirection

///|
pub type TreeNode = @composite.TreeNode

///|
pub type TreeViewResponse = @composite.TreeViewResponse

///|
pub type CommandItem = @composite.CommandItem

///|
pub type CommandPaletteResponse = @composite.CommandPaletteResponse

///|
pub type DockArea = @composite.DockArea

///|
pub type DockTree = @composite.DockTree

///|
pub type DockNode = @composite.DockNode

///|
pub type DockTab = @composite.DockTab

///|
pub type DockResponse = @composite.DockResponse

///|
pub type DockSplitDirection = @composite.DockSplitDirection

///|
pub type ContextMenuItem = @composite.ContextMenuItem

///|
pub type ContextMenuResponse = @composite.ContextMenuResponse
