#define POCKETMOD_IMPLEMENTATION
#include "pocketmod.h"

#include <eb_file.h>
#include <eb_sound.h>
#include <stdio.h>
#include <stdlib.h>

sts_mixer_stream_t mod_stream;
uint8_t samples[2048 * sizeof(float)];
void *mod_data = 0;
pocketmod_context mod_ctx;

static void refill_stream_mod(sts_mixer_sample_t *sample, void *userdata)
{
    int i = 0;
    while (i < sizeof(samples)) {
        i += pocketmod_render(userdata, samples + i, sizeof(samples) - i);
    }
}

int playmod(const char *file)
{
    int size = eb_file_size(file);
    if (size <= 0)
        return -1;

    free(mod_data);
    mod_data = malloc(size);
    if (!mod_data)
        return -1;

    FILE *fp = fopen(file, "rb");
    fread(mod_data, 1, size, fp);
    fclose(fp);

    if (!pocketmod_init(&mod_ctx, mod_data, size, 48000)) {
        printf("error: '%s' is not a valid MOD file\n", file);
        return -1;
    }

    mod_stream.callback = refill_stream_mod;
    mod_stream.sample.frequency = 48000;
    mod_stream.sample.audio_format = STS_MIXER_SAMPLE_FORMAT_FLOAT;
    mod_stream.sample.length = 2048;
    mod_stream.sample.data = samples;
    mod_stream.userdata = &mod_ctx;

    sts_mixer_play_stream(eb_get_mixer(), &mod_stream, 1.0f);
}

int stopmod(void)
{
    sts_mixer_stop_stream(eb_get_mixer(), &mod_stream);
}
