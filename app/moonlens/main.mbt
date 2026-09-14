// Copyright 2026 Ling71671
// MoonLens Standalone Native Desktop Entry Point

///|
fn main {
  let ok = c_win32_init_window(1280, 800)
  if ok == 0 {
    println("Error: Failed to initialize Win32 window.")
    return
  }

  let ctx = @core.UIContext::new()
  let state = AppState::new()

  while c_win32_poll_events() != 0 {
    let raw_input = fetch_raw_input()
    let vp_w = c_win32_get_window_width()
    let vp_h = c_win32_get_window_height()

    ctx.begin_frame(raw_input)
    render_moonlens_ui(ctx, state, vp_w, vp_h)
    let dl = ctx.end_frame()

    sync_cursor(ctx.cursor_icon())
    render_native_draw_list(dl, @color.Color::rgb(18, 20, 26))
  }
}
