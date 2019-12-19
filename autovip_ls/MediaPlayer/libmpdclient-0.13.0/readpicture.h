#ifndef READPICTURE_H
#define READPICTURE_H

#define MPD_BINARY_CHUNK_SIZE 8192
#include "compiler.h"

#include <stdbool.h>
#include <stddef.h>

struct mpd_connection;

struct mpd_readpicture {
        /** fixed size binary data buffer*/
        unsigned char data[MPD_BINARY_CHUNK_SIZE];

        /** the size of the picture */
        size_t size;
        
        /** bytes in the binary data buffer*/
        size_t data_length;
        
        /** optional mime_type*/
        char *mime_type;
};


#ifdef __cplusplus
extern "C" {
#endif

/**
 * Frees the "readpicture" struct
 *
 * @param buffer a allocated struct mpd_readpicture
 */
void
mpd_free_readpicture(struct mpd_readpicture *buffer);

/**
 * Sends the "readpicture" command to MPD.  Call mpd_recv_readpicture() to
 * read response lines. 
 *
 * @param connection a valid and connected #mpd_connection
 * @param uri the URI of the song
 * @param offset to read from
 * @return true on success
 */
bool
mpd_send_readpicture(struct mpd_connection *connection, 
                                   const char *uri, 
                                   unsigned offset);

/**
 * Receives the "readpicture" response
 *
 * @param connection a valid and connected #mpd_connection
 * @param buffer a allocated struct mpd_readpicture
 * @return true on success
 */
bool
mpd_recv_readpicture(struct mpd_connection *connection, struct mpd_readpicture *buffer);

/**
 * Shortcut for mpd_send_readpicture(), mpd_recv_readpicture() and
 * mpd_response_finish().
 *
 * @param connection a valid and connected #mpd_connection
 * @param uri the URI of the song
 * @param offset to read from
 * @param buffer a allocated struct mpd_readpicture
 * @return true on success
 */
bool
mpd_run_readpicture(struct mpd_connection *connection,
				   const char *uri,
				   unsigned offset,
				   struct mpd_readpicture *buffer);

#ifdef __cplusplus
}
#endif

#endif
