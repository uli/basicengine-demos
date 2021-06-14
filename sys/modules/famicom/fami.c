#define AGNES_IMPLEMENTATION
#define AGNES_SINGLE_HEADER
#include "agnes.h"

#include <eb_basic.h>
#include <eb_bg.h>
#include <eb_file.h>
#include <eb_input.h>
#include <eb_video.h>
#include <error.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

agnes_t *agnes = NULL;
uint8_t *rom = NULL;
agnes_input_t input;
int layer = -1;

int pos_x = 0, pos_y = 0;

void not_initialized() {
    eb_set_error(ERR_FILE_NOT_OPEN, "emulator not running");
}

// The painter function is run by the graphics core when it's time to draw
// the BG layer (in this case, the emulator screen).

void painter(pixel_t *p, int w, int h, int pitch, void *userdata) {
    int draw_w = w - pos_x;
    int draw_h = h - pos_y;

    if (draw_w > AGNES_SCREEN_WIDTH)
        draw_w = AGNES_SCREEN_WIDTH;
    if (draw_h > AGNES_SCREEN_HEIGHT)
        draw_h = AGNES_SCREEN_HEIGHT;

    int start_x = 0;
    int start_y = 0;
    if (pos_x < 0)
        start_x -= pos_x;
    if (pos_y < 0)
        start_y -= pos_y;

    for (int y = start_y; y < draw_h; y++) {
        for (int x = start_x; x < draw_w; x++) {
            agnes_color_t c = agnes_get_screen_pixel(agnes, x, y);
            p[pos_x + x + (pos_y + y) * pitch] = eb_rgb(c.r, c.g, c.b);
        }
    }
}

// Implementations of new BASIC commands that control the emulator.

// Engine BASIC passes parameters as an array of eb_param_t. The number and
// meaning of its elements depends on the syntax defined below.

// NB: Only string (I_STR) and numeric (I_NUM) parameters are included in
// the parameter array; static syntax elements (such as parentheses) are
// not.

void famiload(const eb_param_t *params)
{
    const char *file = params[0].str;

    int size = eb_file_size(file);
    if (size <= 0) {
        eb_set_error(ERR_FILE_OPEN, NULL);
        return;
    }

    rom = realloc(rom, size);
    FILE *fp = fopen(file, "rb");
    fread(rom, 1, size, fp);
    fclose(fp);

    if (layer >= 0)
        eb_remove_bg_layer(layer);

    if (agnes)
        agnes_destroy(agnes);
    agnes = agnes_make();
    agnes_load_ines_data(agnes, rom, size);

    layer = eb_add_bg_layer(painter, 0, NULL);
}

void faminput(const eb_param_t *params) {
    uint32_t bits = (uint64_t)params[0].num;

    if (!agnes) {
        not_initialized();
        return;
    }

    memset(&input, 0, sizeof(input));

    input.up = !!(bits & EB_JOY_UP);
    input.down = !!(bits & EB_JOY_DOWN);
    input.left = !!(bits & EB_JOY_LEFT);
    input.right = !!(bits & EB_JOY_RIGHT);
    input.a = !!(bits & EB_JOY_X);
    input.b = !!(bits & EB_JOY_SQUARE);
    input.select = !!(bits & EB_JOY_SELECT);
    input.start = !!(bits & EB_JOY_START);

    agnes_set_input(agnes, &input, 0);
}

void famulate(const eb_param_t *params) {
    if (!agnes) {
        not_initialized();
        return;
    }

    agnes_next_frame(agnes);
}

void famiend(const eb_param_t *params) {
    if (!agnes) {
        not_initialized();
        return;
    }

    eb_remove_bg_layer(layer);
    free(rom);
    rom = NULL;
    agnes_destroy(agnes);
    agnes = NULL;
}

double famiread(const eb_param_t *params) {
    uint32_t addr = (uint64_t)params[0].num;

    if (!agnes) {
        not_initialized();
        return 0;
    }

    return cpu_read8(&agnes->cpu, addr);
}

void famimove(const eb_param_t *params) {
    pos_x = params[0].num;
    pos_y = params[1].num;
}

// Register the new BASIC commands and functions with Engine BASIC.

const enum token_t syn_famiload[] = { I_STR, I_EOL };
const enum token_t syn_faminput[] = { I_NUM, I_EOL };
const enum token_t syn_void[] = { I_EOL };
const enum token_t syn_famiread[] = { I_OPEN, I_NUM, I_CLOSE, I_EOL };
const enum token_t syn_famimove[] = { I_NUM, I_COMMA, I_NUM, I_EOL };

// This function is called at link time, i.e. when the TCCLINK command is
// executed, or the module is loaded via LOADMOD or #REQUIRE.
void __initcall(void) {
    eb_add_command("FAMILOAD", syn_famiload, famiload);
    eb_add_command("FAMINPUT", syn_faminput, faminput);
    eb_add_command("FAMULATE", syn_void, famulate);
    eb_add_command("FAMIEND", syn_void, famiend);
    eb_add_numfun("FAMIREAD", syn_famiread, famiread);
    eb_add_command("FAMIMOVE", syn_famimove, famimove);
}
