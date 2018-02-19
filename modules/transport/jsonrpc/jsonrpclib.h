/*
 * Copyright (c) 2014 Atheme Development Group
 *
 * JSONRPC library header
 */

#ifndef JSONRPC_H
#define JSONRPC_H

#include "atheme.h"

typedef bool (*jsonrpc_method_fn)(void *conn, mowgli_list_t *params, char *id);

struct jsonrpc_sourceinfo
{
    struct sourceinfo *base;
    char *id;
};

extern char *jsonrpc_normalizeBuffer(const char *buf);

extern jsonrpc_method_fn get_json_method(const char *method_name);

extern void jsonrpc_process(char *buffer, void *userdata);
extern void jsonrpc_register_method(const char *method_name, bool (*method)(void *conn, mowgli_list_t *params, char *id));
extern void jsonrpc_unregister_method(const char *method_name);
extern void jsonrpc_send_data(void *conn, char *str);
extern void jsonrpc_success_string(void *conn, const char *str, const char *id);
extern void jsonrpc_failure_string(void *conn, int code, const char *str, const char *id);

#endif
