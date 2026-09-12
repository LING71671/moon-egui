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

// ----------------------------------------------------------------------
// Audio Hardware Controls (Knob, Fader)
// ----------------------------------------------------------------------

///|
fn draw_knob_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "270° 弧形物理电位器机架 (Audio / CAD Rack)",
    @color.Color::accent_primary(),
  )
  ui.spacer(8.0)
  ui.horizontal(fn(row) {
    let (c, _) = @composite.knob(
      row,
      "cutoff",
      "CUTOFF",
      gallery_state.knob_cutoff,
      min_val=20.0,
      max_val=20000.0,
      step=10.0,
      default_val=1200.0,
      unit="Hz",
      radius=24.0,
    )
    if c != gallery_state.knob_cutoff {
      gallery_state.knob_cutoff = c
      gallery_state.status_text = "CUTOFF: " + c.to_string() + " Hz"
    }

    row.spacer(16.0)

    let (r, _) = @composite.knob(
      row,
      "res",
      "RESONANCE",
      gallery_state.knob_res,
      min_val=0.0,
      max_val=100.0,
      step=1.0,
      default_val=25.0,
      unit="%",
      radius=24.0,
    )
    if r != gallery_state.knob_res {
      gallery_state.knob_res = r
      gallery_state.status_text = "RESONANCE: " + r.to_string() + "%"
    }

    row.spacer(16.0)

    let (p, _) = @composite.knob(
      row,
      "pan",
      "PAN",
      gallery_state.knob_pan,
      min_val=-100.0,
      max_val=100.0,
      step=1.0,
      default_val=0.0,
      unit="%",
      radius=24.0,
      bipolar=true,
    )
    if p != gallery_state.knob_pan {
      gallery_state.knob_pan = p
      gallery_state.status_text = "PAN (Bipolar): " + p.to_string() + "%"
    }

    row.spacer(16.0)

    let (d, _) = @composite.knob(
      row,
      "drive",
      "DRIVE",
      gallery_state.knob_drive,
      min_val=0.0,
      max_val=24.0,
      step=0.5,
      default_val=6.0,
      unit="dB",
      radius=24.0,
    )
    if d != gallery_state.knob_drive {
      gallery_state.knob_drive = d
      gallery_state.status_text = "DRIVE: " + d.to_string() + " dB"
    }
  })
  ui.spacer(14.0)
  ui.separator()
  ui.spacer(8.0)
  ui.horizontal(fn(row) {
    if @widgets.button_sized(row, "默认预设", @math.Vec2::new(84.0, 26.0)).clicked {
      gallery_state.knob_cutoff = 1200.0
      gallery_state.knob_res = 25.0
      gallery_state.knob_pan = 0.0
      gallery_state.knob_drive = 6.0
      gallery_state.status_text = "Preset applied: Default"
    }
    row.spacer(10.0)
    if @widgets.button_sized(row, "暖调低音", @math.Vec2::new(84.0, 26.0)).clicked {
      gallery_state.knob_cutoff = 380.0
      gallery_state.knob_res = 45.0
      gallery_state.knob_pan = 0.0
      gallery_state.knob_drive = 14.0
      gallery_state.status_text = "Preset applied: Warm Bass"
    }
    row.spacer(10.0)
    if @widgets.button_sized(row, "亮音主导", @math.Vec2::new(84.0, 26.0)).clicked {
      gallery_state.knob_cutoff = 8500.0
      gallery_state.knob_res = 65.0
      gallery_state.knob_pan = 20.0
      gallery_state.knob_drive = 8.0
      gallery_state.status_text = "Preset applied: Bright Lead"
    }
  })
}

///|
fn draw_fader_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "垂直通道推子调节器 (Audio Channel Fader Rack)",
    @color.Color::accent_primary(),
  )
  ui.spacer(8.0)
  ui.horizontal(fn(row) {
    let (v, _) = @composite.fader(
      row,
      "master_vol",
      "MASTER",
      gallery_state.fader_vol,
      min_val=0.0,
      max_val=1.0,
      step=0.01,
      default_val=0.75,
      unit="%",
      show_ticks=true,
    )
    if v != gallery_state.fader_vol {
      gallery_state.fader_vol = v
      gallery_state.status_text = "Master Volume: " +
        (v * 100.0).to_int().to_string() +
        "%"
    }

    row.spacer(14.0)

    let (g, _) = @composite.fader(
      row,
      "channel_gain",
      "GAIN",
      gallery_state.fader_gain,
      min_val=-60.0,
      max_val=12.0,
      step=0.5,
      default_val=0.0,
      unit="dB",
      show_ticks=true,
    )
    if g != gallery_state.fader_gain {
      gallery_state.fader_gain = g
      gallery_state.status_text = "Gain: " + g.to_string() + " dB"
    }

    row.spacer(14.0)

    let (fl, _) = @composite.fader(
      row,
      "ch_left",
      "LEFT",
      gallery_state.fader_l,
      min_val=0.0,
      max_val=1.0,
      step=0.01,
      default_val=0.65,
      unit="%",
      show_ticks=true,
    )
    if fl != gallery_state.fader_l {
      gallery_state.fader_l = fl
      gallery_state.status_text = "Stereo Left: " +
        (fl * 100.0).to_int().to_string() +
        "%"
    }

    row.spacer(8.0)

    let (fr, _) = @composite.fader(
      row,
      "ch_right",
      "RIGHT",
      gallery_state.fader_r,
      min_val=0.0,
      max_val=1.0,
      step=0.01,
      default_val=0.65,
      unit="%",
      show_ticks=true,
    )
    if fr != gallery_state.fader_r {
      gallery_state.fader_r = fr
      gallery_state.status_text = "Stereo Right: " +
        (fr * 100.0).to_int().to_string() +
        "%"
    }
  })

  ui.spacer(14.0)
  ui.separator()
  ui.spacer(8.0)
  ui.horizontal(fn(row) {
    if @widgets.button_sized(
        row,
        "复位默认值",
        @math.Vec2::new(88.0, 26.0),
      ).clicked {
      gallery_state.fader_vol = 0.75
      gallery_state.fader_gain = 0.0
      gallery_state.fader_l = 0.65
      gallery_state.fader_r = 0.65
      gallery_state.status_text = "已复位推子通道参数"
    }
    row.spacer(12.0)
    let _ = row.label_colored(
      "提示: 垂直拖拽微调, 滚轮步进, Shift 精确调节, Alt+点击复位",
      @color.Color::text_muted(),
    )
  })
}
