// Copyright 2026 Ling71671
// MoonLens Native Desktop Window Runner (Win32 + GDI Double Buffer)

#define UNICODE
#define _UNICODE
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <windowsx.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <dwmapi.h>
#include "moonbit.h"

#ifdef _MSC_VER
#pragma comment(lib, "gdi32.lib")
#pragma comment(lib, "user32.lib")
#pragma comment(lib, "msimg32.lib")
#pragma comment(lib, "dwmapi.lib")
#endif

// Window and Context Globals
static HWND g_hwnd = NULL;
static HDC g_hdc_window = NULL;
static HDC g_hdc_mem = NULL;
static HBITMAP g_hbm_mem = NULL;
static HBITMAP g_hbm_old = NULL;
static int g_buf_width = 0;
static int g_buf_height = 0;
static bool g_running = false;
static int g_dpi = 96;

// Input State
static double g_mouse_x = 0.0;
static double g_mouse_y = 0.0;
static bool g_mouse_down = false;
static bool g_mouse_clicked = false;
static bool g_mouse_right_down = false;
static double g_wheel_delta = 0.0;
static int g_window_w = 1280;
static int g_window_h = 800;
static int g_typed_char = 0;
static bool g_key_states[256] = {0};
static bool g_key_pressed[256] = {0};

// Font cache with DPI scaling
#define MAX_FONT_CACHE 32
typedef struct {
    int size;
    HFONT font;
} FontEntry;
static FontEntry g_font_cache[MAX_FONT_CACHE];
static int g_font_cache_count = 0;

static HFONT get_cached_font(int size) {
    if (size <= 0) size = 13;
    // Scale font size according to system DPI for crisp high-DPI legibility
    int scaled_size = MulDiv(size, g_dpi, 72);
    if (scaled_size <= 0) scaled_size = size;

    for (int i = 0; i < g_font_cache_count; i++) {
        if (g_font_cache[i].size == scaled_size) {
            return g_font_cache[i].font;
        }
    }
    if (g_font_cache_count < MAX_FONT_CACHE) {
        HFONT hFont = CreateFontW(
            -scaled_size, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE,
            DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
            CLEARTYPE_QUALITY, VARIABLE_PITCH | FF_SWISS, L"Segoe UI"
        );
        g_font_cache[g_font_cache_count].size = scaled_size;
        g_font_cache[g_font_cache_count].font = hFont;
        g_font_cache_count++;
        return hFont;
    }
    return (HFONT)GetStockObject(DEFAULT_GUI_FONT);
}

// Dynamic Procedural Icon for MoonLens Window & Taskbar
static HICON create_moonlens_icon(int size) {
    HDC hdc = GetDC(NULL);
    HDC memDC = CreateCompatibleDC(hdc);
    HDC maskDC = CreateCompatibleDC(hdc);

    BITMAPINFO bmi = {0};
    bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bmi.bmiHeader.biWidth = size;
    bmi.bmiHeader.biHeight = -size; // top-down
    bmi.bmiHeader.biPlanes = 1;
    bmi.bmiHeader.biBitCount = 32;
    bmi.bmiHeader.biCompression = BI_RGB;

    void *bits = NULL;
    HBITMAP hbmColor = CreateDIBSection(memDC, &bmi, DIB_RGB_COLORS, &bits, NULL, 0);
    HBITMAP hbmMask = CreateBitmap(size, size, 1, 1, NULL);

    HBITMAP oldColor = (HBITMAP)SelectObject(memDC, hbmColor);
    HBITMAP oldMask = (HBITMAP)SelectObject(maskDC, hbmMask);

    RECT rc = {0, 0, size, size};
    FillRect(maskDC, &rc, (HBRUSH)GetStockObject(WHITE_BRUSH));

    HBRUSH bgBrush = CreateSolidBrush(RGB(13, 17, 23));
    HBRUSH cyanBrush = CreateSolidBrush(RGB(56, 189, 248));
    HBRUSH maskBlack = (HBRUSH)GetStockObject(BLACK_BRUSH);
    HPEN nullPen = (HPEN)GetStockObject(NULL_PEN);

    // Draw dark rounded circle in color DC
    SelectObject(memDC, nullPen);
    SelectObject(memDC, bgBrush);
    Ellipse(memDC, 1, 1, size - 1, size - 1);

    // Draw opaque circle in mask DC
    SelectObject(maskDC, nullPen);
    SelectObject(maskDC, maskBlack);
    Ellipse(maskDC, 1, 1, size - 1, size - 1);

    // Draw Ice Cyan Crescent inside
    SelectObject(memDC, cyanBrush);
    Ellipse(memDC, size / 5, size / 6, size * 5 / 6, size * 5 / 6);
    SelectObject(memDC, bgBrush);
    Ellipse(memDC, size / 3, size / 7, size * 7 / 8, size * 4 / 5);

    SelectObject(memDC, oldColor);
    SelectObject(maskDC, oldMask);
    DeleteDC(memDC);
    DeleteDC(maskDC);
    ReleaseDC(NULL, hdc);
    DeleteObject(bgBrush);
    DeleteObject(cyanBrush);

    ICONINFO ii = {0};
    ii.fIcon = TRUE;
    ii.hbmMask = hbmMask;
    ii.hbmColor = hbmColor;
    HICON hIcon = CreateIconIndirect(&ii);

    DeleteObject(hbmColor);
    DeleteObject(hbmMask);
    return hIcon;
}

// Window Procedure
static LRESULT CALLBACK MoonLensWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
        case WM_MOUSEMOVE: {
            g_mouse_x = (double)GET_X_LPARAM(lParam);
            g_mouse_y = (double)GET_Y_LPARAM(lParam);
            return 0;
        }
        case WM_LBUTTONDOWN: {
            g_mouse_x = (double)GET_X_LPARAM(lParam);
            g_mouse_y = (double)GET_Y_LPARAM(lParam);
            g_mouse_down = true;
            g_mouse_clicked = true;
            SetCapture(hwnd);
            return 0;
        }
        case WM_LBUTTONUP: {
            g_mouse_x = (double)GET_X_LPARAM(lParam);
            g_mouse_y = (double)GET_Y_LPARAM(lParam);
            g_mouse_down = false;
            ReleaseCapture();
            return 0;
        }
        case WM_RBUTTONDOWN: {
            g_mouse_x = (double)GET_X_LPARAM(lParam);
            g_mouse_y = (double)GET_Y_LPARAM(lParam);
            g_mouse_right_down = true;
            return 0;
        }
        case WM_RBUTTONUP: {
            g_mouse_x = (double)GET_X_LPARAM(lParam);
            g_mouse_y = (double)GET_Y_LPARAM(lParam);
            g_mouse_right_down = false;
            return 0;
        }
        case WM_MOUSEWHEEL: {
            short delta = GET_WHEEL_DELTA_WPARAM(wParam);
            g_wheel_delta += (double)delta / (double)WHEEL_DELTA;
            return 0;
        }
        case WM_KEYDOWN: {
            if (wParam < 256) {
                g_key_states[wParam] = true;
                g_key_pressed[wParam] = true;
            }
            return 0;
        }
        case WM_KEYUP: {
            if (wParam < 256) {
                g_key_states[wParam] = false;
            }
            return 0;
        }
        case WM_CHAR: {
            g_typed_char = (int)wParam;
            return 0;
        }
        case WM_SIZE: {
            g_window_w = LOWORD(lParam);
            g_window_h = HIWORD(lParam);
            return 0;
        }
        case WM_ERASEBKGND:
            return 1; // Prevent GDI flicker
        case WM_PAINT: {
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);
            if (g_hdc_mem && g_buf_width > 0 && g_buf_height > 0) {
                BitBlt(hdc, 0, 0, g_buf_width, g_buf_height, g_hdc_mem, 0, 0, SRCCOPY);
            }
            EndPaint(hwnd, &ps);
            return 0;
        }
        case WM_CLOSE: {
            g_running = false;
            DestroyWindow(hwnd);
            return 0;
        }
        case WM_DESTROY: {
            g_running = false;
            PostQuitMessage(0);
            return 0;
        }
        default:
            return DefWindowProcW(hwnd, msg, wParam, lParam);
    }
}

// -------------------------------------------------------------
// Exported C Functions for MoonBit FFI
// -------------------------------------------------------------

int c_win32_init_window(int width, int height) {
    // Enable DPI awareness
    SetProcessDPIAware();

    HINSTANCE hInstance = GetModuleHandle(NULL);
    const wchar_t CLASS_NAME[] = L"MoonLensMainWindowClass";

    WNDCLASSEXW wc = {0};
    wc.cbSize = sizeof(WNDCLASSEXW);
    wc.lpfnWndProc = MoonLensWndProc;
    wc.hInstance = hInstance;
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = NULL;
    wc.lpszClassName = CLASS_NAME;

    RegisterClassExW(&wc);

    RECT rc = {0, 0, width, height};
    AdjustWindowRect(&rc, WS_OVERLAPPEDWINDOW, FALSE);

    g_hwnd = CreateWindowExW(
        0,
        CLASS_NAME,
        L"MoonLens \u2014 Native High-Performance Data Explorer",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT,
        rc.right - rc.left, rc.bottom - rc.top,
        NULL,
        NULL,
        hInstance,
        NULL
    );

    if (!g_hwnd) return 0;

    // Enable Windows 10/11 Dark Mode Title Bar (kills the bright white titlebar border)
    BOOL dark_mode = TRUE;
    DwmSetWindowAttribute(g_hwnd, 20, &dark_mode, sizeof(dark_mode));
    DwmSetWindowAttribute(g_hwnd, 19, &dark_mode, sizeof(dark_mode));

    // Attach custom procedural MoonLens App Icon to Titlebar and Taskbar
    HICON hIconBig = create_moonlens_icon(32);
    HICON hIconSmall = create_moonlens_icon(16);
    SendMessageW(g_hwnd, WM_SETICON, ICON_BIG, (LPARAM)hIconBig);
    SendMessageW(g_hwnd, WM_SETICON, ICON_SMALL, (LPARAM)hIconSmall);

    ShowWindow(g_hwnd, SW_SHOW);
    UpdateWindow(g_hwnd);

    g_hdc_window = GetDC(g_hwnd);
    g_dpi = GetDeviceCaps(g_hdc_window, LOGPIXELSY);
    if (g_dpi <= 0) g_dpi = 96;
    g_hdc_mem = CreateCompatibleDC(g_hdc_window);

    g_window_w = width;
    g_window_h = height;
    g_running = true;
    return 1;
}

int c_win32_poll_events(void) {
    g_mouse_clicked = false;
    g_wheel_delta = 0.0;
    g_typed_char = 0;
    memset(g_key_pressed, 0, sizeof(g_key_pressed));

    MSG msg;
    while (PeekMessageW(&msg, NULL, 0, 0, PM_REMOVE)) {
        if (msg.message == WM_QUIT) {
            g_running = false;
            return 0;
        }
        TranslateMessage(&msg);
        DispatchMessageW(&msg);
    }

    return g_running ? 1 : 0;
}

double c_win32_get_mouse_x(void) { return g_mouse_x; }
double c_win32_get_mouse_y(void) { return g_mouse_y; }
int c_win32_get_mouse_down(void) { return g_mouse_down ? 1 : 0; }
int c_win32_get_mouse_clicked(void) { return g_mouse_clicked ? 1 : 0; }
int c_win32_get_mouse_right_down(void) { return g_mouse_right_down ? 1 : 0; }
double c_win32_get_wheel_delta(void) { return g_wheel_delta; }
double c_win32_get_window_width(void) { return (double)g_window_w; }
double c_win32_get_window_height(void) { return (double)g_window_h; }
int c_win32_get_typed_char(void) { return g_typed_char; }
int c_win32_is_key_pressed(int vk) {
    if (vk >= 0 && vk < 256) return g_key_pressed[vk] ? 1 : 0;
    return 0;
}
int c_win32_is_key_down(int vk) {
    if (vk >= 0 && vk < 256) return g_key_states[vk] ? 1 : 0;
    return 0;
}

void c_win32_set_cursor(int cursor_type) {
    LPCWSTR idc = IDC_ARROW;
    switch (cursor_type) {
        case 1: idc = IDC_HAND; break;      // pointer
        case 2: idc = IDC_IBEAM; break;     // text
        case 3: idc = IDC_SIZEWE; break;    // col-resize / ew-resize
        case 4: idc = IDC_SIZENS; break;    // row-resize / ns-resize
        case 5: idc = IDC_CROSS; break;     // crosshair
        case 6: idc = IDC_SIZEALL; break;   // move
        default: idc = IDC_ARROW; break;
    }
    SetCursor(LoadCursor(NULL, idc));
}

// -------------------------------------------------------------
// Double-buffered GDI Drawing Pipeline
// -------------------------------------------------------------

void c_win32_render_begin(int clear_r, int clear_g, int clear_b) {
    if (g_buf_width != g_window_w || g_buf_height != g_window_h || g_hbm_mem == NULL) {
        g_buf_width = g_window_w;
        g_buf_height = g_window_h;
        if (g_hbm_mem) {
            SelectObject(g_hdc_mem, g_hbm_old);
            DeleteObject(g_hbm_mem);
        }
        g_hbm_mem = CreateCompatibleBitmap(g_hdc_window, g_buf_width, g_buf_height);
        g_hbm_old = (HBITMAP)SelectObject(g_hdc_mem, g_hbm_mem);
    }

    RECT rc = {0, 0, g_buf_width, g_buf_height};
    HBRUSH bg_brush = CreateSolidBrush(RGB(clear_r, clear_g, clear_b));
    FillRect(g_hdc_mem, &rc, bg_brush);
    DeleteObject(bg_brush);
}

void c_win32_draw_rect(double x, double y, double w, double h, int r, int g, int b, int a, double radius) {
    if (w <= 0 || h <= 0) return;
    int left = (int)x;
    int top = (int)y;
    int right = (int)(x + w);
    int bottom = (int)(y + h);

    if (a < 250) {
        // Alpha blend rectangle
        HDC hdc_alpha = CreateCompatibleDC(g_hdc_mem);
        BITMAPINFO bmi = {0};
        bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
        bmi.bmiHeader.biWidth = (int)w;
        bmi.bmiHeader.biHeight = -(int)h;
        bmi.bmiHeader.biPlanes = 1;
        bmi.bmiHeader.biBitCount = 32;
        bmi.bmiHeader.biCompression = BI_RGB;

        void *bits = NULL;
        HBITMAP hbm = CreateDIBSection(hdc_alpha, &bmi, DIB_RGB_COLORS, &bits, NULL, 0);
        if (hbm) {
            HBITMAP old_bm = (HBITMAP)SelectObject(hdc_alpha, hbm);
            uint32_t *p = (uint32_t*)bits;
            uint32_t pixel = ((uint32_t)a << 24) |
                             ((uint32_t)((r * a) / 255) << 16) |
                             ((uint32_t)((g * a) / 255) << 8) |
                             ((uint32_t)((b * a) / 255));
            int total = (int)w * (int)h;
            for (int i = 0; i < total; i++) p[i] = pixel;

            BLENDFUNCTION bf;
            bf.BlendOp = AC_SRC_OVER;
            bf.BlendFlags = 0;
            bf.SourceConstantAlpha = 255;
            bf.AlphaFormat = AC_SRC_ALPHA;

            AlphaBlend(g_hdc_mem, left, top, (int)w, (int)h, hdc_alpha, 0, 0, (int)w, (int)h, bf);
            SelectObject(hdc_alpha, old_bm);
            DeleteObject(hbm);
        }
        DeleteDC(hdc_alpha);
        return;
    }

    HBRUSH brush = CreateSolidBrush(RGB(r, g, b));
    if (radius <= 1.0) {
        RECT rc = {left, top, right, bottom};
        FillRect(g_hdc_mem, &rc, brush);
    } else {
        HPEN null_pen = (HPEN)GetStockObject(NULL_PEN);
        HPEN old_pen = (HPEN)SelectObject(g_hdc_mem, null_pen);
        HBRUSH old_brush = (HBRUSH)SelectObject(g_hdc_mem, brush);
        int d = (int)(radius * 2.0);
        RoundRect(g_hdc_mem, left, top, right + 1, bottom + 1, d, d);
        SelectObject(g_hdc_mem, old_brush);
        SelectObject(g_hdc_mem, old_pen);
    }
    DeleteObject(brush);
}

void c_win32_draw_rect_stroke(double x, double y, double w, double h, int r, int g, int b, int a, double stroke_width, double radius) {
    (void)a;
    if (w <= 0 || h <= 0) return;
    int left = (int)x;
    int top = (int)y;
    int right = (int)(x + w);
    int bottom = (int)(y + h);
    int sw = (int)(stroke_width < 1.0 ? 1.0 : stroke_width);

    HPEN pen = CreatePen(PS_SOLID, sw, RGB(r, g, b));
    HBRUSH null_brush = (HBRUSH)GetStockObject(NULL_BRUSH);
    HPEN old_pen = (HPEN)SelectObject(g_hdc_mem, pen);
    HBRUSH old_brush = (HBRUSH)SelectObject(g_hdc_mem, null_brush);

    if (radius <= 1.0) {
        Rectangle(g_hdc_mem, left, top, right, bottom);
    } else {
        int d = (int)(radius * 2.0);
        RoundRect(g_hdc_mem, left, top, right, bottom, d, d);
    }

    SelectObject(g_hdc_mem, old_brush);
    SelectObject(g_hdc_mem, old_pen);
    DeleteObject(pen);
}

void c_win32_draw_line(double x1, double y1, double x2, double y2, int r, int g, int b, int a, double width) {
    (void)a;
    int w = (int)(width < 1.0 ? 1.0 : width);
    HPEN pen = CreatePen(PS_SOLID, w, RGB(r, g, b));
    HPEN old_pen = (HPEN)SelectObject(g_hdc_mem, pen);

    MoveToEx(g_hdc_mem, (int)x1, (int)y1, NULL);
    LineTo(g_hdc_mem, (int)x2, (int)y2);

    SelectObject(g_hdc_mem, old_pen);
    DeleteObject(pen);
}

void c_win32_draw_circle(double cx, double cy, double radius, int r, int g, int b, int a) {
    (void)a;
    int left = (int)(cx - radius);
    int top = (int)(cy - radius);
    int right = (int)(cx + radius);
    int bottom = (int)(cy + radius);

    HBRUSH brush = CreateSolidBrush(RGB(r, g, b));
    HPEN null_pen = (HPEN)GetStockObject(NULL_PEN);
    HPEN old_pen = (HPEN)SelectObject(g_hdc_mem, null_pen);
    HBRUSH old_brush = (HBRUSH)SelectObject(g_hdc_mem, brush);

    Ellipse(g_hdc_mem, left, top, right, bottom);

    SelectObject(g_hdc_mem, old_brush);
    SelectObject(g_hdc_mem, old_pen);
    DeleteObject(brush);
}

void c_win32_draw_circle_stroke(double cx, double cy, double radius, int r, int g, int b, int a, double stroke_width) {
    (void)a;
    int left = (int)(cx - radius);
    int top = (int)(cy - radius);
    int right = (int)(cx + radius);
    int bottom = (int)(cy + radius);
    int sw = (int)(stroke_width < 1.0 ? 1.0 : stroke_width);

    HPEN pen = CreatePen(PS_SOLID, sw, RGB(r, g, b));
    HBRUSH null_brush = (HBRUSH)GetStockObject(NULL_BRUSH);
    HPEN old_pen = (HPEN)SelectObject(g_hdc_mem, pen);
    HBRUSH old_brush = (HBRUSH)SelectObject(g_hdc_mem, null_brush);

    Ellipse(g_hdc_mem, left, top, right, bottom);

    SelectObject(g_hdc_mem, old_brush);
    SelectObject(g_hdc_mem, old_pen);
    DeleteObject(pen);
}

void c_win32_draw_text(double x, double y, moonbit_string_t str, double font_size, int r, int g, int b, int a, int align) {
    (void)a;
    if (!str) return;
    int len = Moonbit_array_length(str);
    if (len <= 0) return;

    HFONT font = get_cached_font((int)font_size);
    HFONT old_font = (HFONT)SelectObject(g_hdc_mem, font);

    SetBkMode(g_hdc_mem, TRANSPARENT);
    SetTextColor(g_hdc_mem, RGB(r, g, b));

    int tx = (int)x;
    int ty = (int)y;

    if (align == 1 || align == 2) {
        SIZE sz;
        GetTextExtentPoint32W(g_hdc_mem, (const wchar_t*)str, len, &sz);
        if (align == 1) tx -= sz.cx / 2;     // Center
        else if (align == 2) tx -= sz.cx;    // Right
    }

    TextOutW(g_hdc_mem, tx, ty, (const wchar_t*)str, len);

    SelectObject(g_hdc_mem, old_font);
}

void c_win32_push_clip(double x, double y, double w, double h) {
    SaveDC(g_hdc_mem);
    IntersectClipRect(g_hdc_mem, (int)x, (int)y, (int)(x + w), (int)(y + h));
}

void c_win32_pop_clip(void) {
    RestoreDC(g_hdc_mem, -1);
}

void c_win32_render_end(void) {
    // Present memory buffer to window
    BitBlt(g_hdc_window, 0, 0, g_buf_width, g_buf_height, g_hdc_mem, 0, 0, SRCCOPY);
    // Yield time slice to keep 60-120 fps without melting CPU
    Sleep(8);
}
