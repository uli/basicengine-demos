// SPDX-License-Identifier: MIT
// Copyright (c) 2021 Ulrich Hecht

#include "ESP8266SAM.h"

#include <eb_basic.h>
#include <eb_native.h>
#include <eb_sound.h>
#include <eb_sys.h>
#include <error.h>

#include <stdio.h>
#include <stdlib.h>

ESP8266SAM *sam;
sts_mixer_sample_t sample;

int buf_size;
uint8_t *buf;

uint32_t end_tick;

extern "C" int sam_done(void)
{
    if (eb_utick() >= end_tick)
        return 1;
    else
        return 0;
}

extern "C" void sam_speak(const char *s)
{
    sam->Say(s);
    int bp = 0;
    while (!sam->finished()) {
        uint8_t samp = sam->getSample();
        if (bp >= buf_size) {
            buf_size *= 2;
            buf = (uint8_t *)realloc(buf, buf_size);
        }
//        fprintf(stdout, "s %d %02X\n", bp, samp);
        buf[bp++] = samp;
    }

    if (sample.length > 0)
        sts_mixer_stop_sample(eb_get_mixer(), &sample);

    sample.data = buf;
    sample.length = bp;
    sts_mixer_play_sample(eb_get_mixer(), &sample, 1.0f, 1.0f, 0.0f);
    end_tick = eb_utick() + bp * 100000 / 2205;
}

EXPORT(sam_speak)
EXPORT(sam_done)

void say(const eb_param_t *params)
{
    sam_speak(params[0].str);
}

double samdone(const eb_param_t *params)
{
    return sam_done();
}

const token_t syn_say[] = { I_STR, I_EOL };
const token_t syn_samdone[] = { I_OPEN, I_CLOSE, I_EOL };

extern "C" void __initcall(void)
{
    sam = new ESP8266SAM;
    if (!sam) {
        err = ERR_OOM;
        return;
    }

    sample.frequency = 22050;
    sample.audio_format = STS_MIXER_SAMPLE_FORMAT_8;
    sample.length = 0;

    buf_size = 512;
    buf = new uint8_t[buf_size];

    end_tick = 0;

    eb_add_command("SAY", syn_say, say);
    eb_add_numfun("SAMDONE", syn_samdone, samdone);
}
