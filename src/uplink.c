/*
 * Copyright (c) 2005 Atheme Development Group
 * Rights to this code are as documented in doc/LICENSE.
 *
 * Uplink management stuff.
 *
 * $Id: uplink.c 6373 2006-09-13 15:56:58Z jilles $
 */

#include "atheme.h"
#include "uplink.h"

uplink_t *curr_uplink;

static void uplink_close(connection_t *cptr);

void uplink_connect(void)
{
	uplink_t *u;

	if (curr_uplink == NULL)
	{
		if (uplinks.head == NULL)
		{
			slog(LG_ERROR, "uplink_connect(): no uplinks configured, exiting. Make sure to have at least one uplink{} block in your configuration file.");
			exit(EXIT_FAILURE);
		}
		curr_uplink = uplinks.head->data;
		slog(LG_INFO, "uplink_connect(): connecting to first entry %s[%s].", curr_uplink->name, curr_uplink->host);
	}
	else if (curr_uplink->node->next)
	{
		u = curr_uplink->node->next->data;

		curr_uplink = u;
		slog(LG_INFO, "uplink_connect(): trying alternate uplink %s[%s]", curr_uplink->name, curr_uplink->host);
	}
	else
	{
		curr_uplink = uplinks.head->data;
		slog(LG_INFO, "uplink_connect(): trying again first entry %s[%s]", curr_uplink->name, curr_uplink->host);
	}

	u = curr_uplink;
	
	curr_uplink->conn = connection_open_tcp(u->host, u->vhost, u->port, recvq_put, sendq_flush);
	curr_uplink->conn->close_handler = uplink_close;
}

/*
 * uplink_close()
 * 
 * inputs:
 *       connection pointer of current uplink
 *       triggered by callback close_handler
 *
 * outputs:
 *       none
 *
 * side effects:
 *       reconnection is scheduled
 *       uplink marked dead
 *       uplink deleted if it had been removed from configuration
 */
static void uplink_close(connection_t *cptr)
{
	event_add_once("reconn", reconn, NULL, me.recontime);

	me.connected = FALSE;

	if (curr_uplink->flags & UPF_ILLEGAL)
	{
		slog(LG_INFO, "uplink_close(): %s was removed from configuration, deleting", curr_uplink->name);
		uplink_delete(curr_uplink);
		if (uplinks.head == NULL)
		{
			slog(LG_ERROR, "uplink_close(): last uplink deleted, exiting.");
			exit(EXIT_FAILURE);
		}
		curr_uplink = uplinks.head->data;
	}
	curr_uplink->conn = NULL;
}
