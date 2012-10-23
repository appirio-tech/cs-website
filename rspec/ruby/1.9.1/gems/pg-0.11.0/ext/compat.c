/************************************************

  compat.c -

  Author: matz 
  created at: Tue May 13 20:07:35 JST 1997

  Author: ematsu
  modified at: Wed Jan 20 16:41:51 1999

  $Author: ged $
  $Date: 2010/10/31 23:29:59 $
************************************************/

#include <ctype.h>
#include "compat.h"

#ifdef PG_BEFORE_080300
int
PQconnectionNeedsPassword(PGconn *conn)
{
	rb_raise(rb_eStandardError, 
		"PQconnectionNeedsPassword not supported by this client version.");
}

int
PQconnectionUsedPassword(PGconn *conn)
{
	rb_raise(rb_eStandardError, 
		"PQconnectionUsedPassword not supported by this client version.");
}

int
lo_truncate(PGconn *conn, int fd, size_t len)
{
	rb_raise(rb_eStandardError, "lo_truncate not supported by this client version.");
}
#endif /* PG_BEFORE_080300 */

#ifdef PG_BEFORE_080200
int
PQisthreadsafe()
{
	return Qfalse;
}

int
PQnparams(const PGresult *res)
{
	rb_raise(rb_eStandardError, "PQnparams not supported by this client version.");
}

Oid
PQparamtype(const PGresult *res, int param_number)
{
	rb_raise(rb_eStandardError, "PQparamtype not supported by this client version.");
}

PGresult *
PQdescribePrepared(PGconn *conn, const char *stmtName)
{
	rb_raise(rb_eStandardError, "PQdescribePrepared not supported by this client version.");
}

PGresult *
PQdescribePortal(PGconn *conn, const char *portalName)
{
	rb_raise(rb_eStandardError, "PQdescribePortal not supported by this client version.");
}

int
PQsendDescribePrepared(PGconn *conn, const char *stmtName)
{
	rb_raise(rb_eStandardError, "PQsendDescribePrepared not supported by this client version.");
}

int
PQsendDescribePortal(PGconn *conn, const char *portalName)
{
	rb_raise(rb_eStandardError, "PQsendDescribePortal not supported by this client version.");
}

char *
PQencryptPassword(const char *passwd, const char *user)
{
	rb_raise(rb_eStandardError, "PQencryptPassword not supported by this client version.");
}
#endif /* PG_BEFORE_080200 */

#ifdef PG_BEFORE_080100
Oid
lo_create(PGconn *conn, Oid lobjId)
{
	rb_raise(rb_eStandardError, "lo_create not supported by this client version.");
}
#endif /* PG_BEFORE_080100 */

#ifdef PG_BEFORE_080000
PGresult *
PQprepare(PGconn *conn, const char *stmtName, const char *query,
	int nParams, const Oid *paramTypes)
{
	rb_raise(rb_eStandardError, "PQprepare not supported by this client version.");
}

int
PQsendPrepare(PGconn *conn, const char *stmtName, const char *query,
	int nParams, const Oid *paramTypes)
{
	rb_raise(rb_eStandardError, "PQsendPrepare not supported by this client version.");
}

int
PQserverVersion(const PGconn* conn)
{
	rb_raise(rb_eStandardError, "PQserverVersion not supported by this client version.");
}
#endif /* PG_BEFORE_080000 */

#ifdef PG_BEFORE_070400
PGresult *
PQexecParams(PGconn *conn, const char *command, int nParams, 
	const Oid *paramTypes, const char * const * paramValues, const int *paramLengths, 
	const int *paramFormats, int resultFormat)
{
	rb_raise(rb_eStandardError, "PQexecParams not supported by this client version.");
}

PGTransactionStatusType 
PQtransactionStatus(const PGconn *conn)
{
	rb_raise(rb_eStandardError, "PQtransactionStatus not supported by this client version.");
}

char *
PQparameterStatus(const PGconn *conn, const char *paramName)
{
	rb_raise(rb_eStandardError, "PQparameterStatus not supported by this client version.");
}

int
PQprotocolVersion(const PGconn *conn)
{
	rb_raise(rb_eStandardError, "PQprotocolVersion not supported by this client version.");
}

PGresult
*PQexecPrepared(PGconn *conn, const char *stmtName, int nParams, 
	const char * const *ParamValues, const int *paramLengths, const int *paramFormats,
	int resultFormat)
{
	rb_raise(rb_eStandardError, "PQexecPrepared not supported by this client version.");
}

int
PQsendQueryParams(PGconn *conn, const char *command, int nParams,
	const Oid *paramTypes, const char * const * paramValues, const int *paramLengths, 
	const int *paramFormats, int resultFormat)
{
	rb_raise(rb_eStandardError, "PQsendQueryParams not supported by this client version.");
}

int
PQsendQueryPrepared(PGconn *conn, const char *stmtName, int nParams, 
	const char * const *ParamValues, const int *paramLengths, const int *paramFormats,
	int resultFormat)
{
	rb_raise(rb_eStandardError, "PQsendQueryPrepared not supported by this client version.");
}

int
PQputCopyData(PGconn *conn, const char *buffer, int nbytes)
{
	rb_raise(rb_eStandardError, "PQputCopyData not supported by this client version.");
}

int
PQputCopyEnd(PGconn *conn, const char *errormsg)
{
	rb_raise(rb_eStandardError, "PQputCopyEnd not supported by this client version.");
}

int
PQgetCopyData(PGconn *conn, char **buffer, int async)
{
	rb_raise(rb_eStandardError, "PQgetCopyData not supported by this client version.");
}

PGVerbosity
PQsetErrorVerbosity(PGconn *conn, PGVerbosity verbosity)
{
	rb_raise(rb_eStandardError, "PQsetErrorVerbosity not supported by this client version.");
}

Oid
PQftable(const PGresult *res, int column_number)
{
	rb_raise(rb_eStandardError, "PQftable not supported by this client version.");
}

int
PQftablecol(const PGresult *res, int column_number)
{
	rb_raise(rb_eStandardError, "PQftablecol not supported by this client version.");
}

int
PQfformat(const PGresult *res, int column_number)
{
	rb_raise(rb_eStandardError, "PQfformat not supported by this client version.");
}

PQnoticeReceiver 
PQsetNoticeReceiver(PGconn *conn, PQnoticeReceiver proc, void *arg)
{
	rb_raise(rb_eStandardError, "PQsetNoticeReceiver not supported by this client version.");
}

char *
PQresultErrorField(const PGresult *res, int fieldcode)
{
	rb_raise(rb_eStandardError, "PQresultErrorField not supported by this client version.");
}
#endif /* PG_BEFORE_070400 */

#ifdef PG_BEFORE_070300
size_t
PQescapeStringConn(PGconn *conn, char *to, const char *from, 
	size_t length, int *error)
{
	return PQescapeString(to,from,length);
}

unsigned char *
PQescapeByteaConn(PGconn *conn, const unsigned char *from, 
	size_t from_length, size_t *to_length)
{
	return PQescapeBytea(from, from_length, to_length);
}
#endif /* PG_BEFORE_070300 */


/**************************************************************************

IF ANY CODE IS COPIED FROM POSTGRESQL, PLACE IT AFTER THIS COMMENT.

***************************************************************************

Portions of code after this point were copied from the PostgreSQL source
distribution, available at http://www.postgresql.org

***************************************************************************

Portions Copyright (c) 1996-2007, PostgreSQL Global Development Group

Portions Copyright (c) 1994, The Regents of the University of California

Permission to use, copy, modify, and distribute this software and its
documentation for any purpose, without fee, and without a written agreement
is hereby granted, provided that the above copyright notice and this
paragraph and the following two paragraphs appear in all copies.

IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING
LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
DOCUMENTATION, EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATIONS TO
PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

**************************************************************************/

#ifndef HAVE_PQSETCLIENTENCODING
int
PQsetClientEncoding(PGconn *conn, const char *encoding)
{
	char        qbuf[128];
	static const char query[] = "set client_encoding to '%s'";
	PGresult   *res;
	int         status;

	if (!conn || PQstatus(conn) != CONNECTION_OK)
		return -1;

	if (!encoding)
		return -1;

	/* check query buffer overflow */
	if (sizeof(qbuf) < (sizeof(query) + strlen(encoding)))
		return -1;

	/* ok, now send a query */
	sprintf(qbuf, query, encoding);
	res = PQexec(conn, qbuf);

	if (res == NULL)
	return -1;
	if (PQresultStatus(res) != PGRES_COMMAND_OK)
	status = -1;
	else
	{
		/*
		 * In protocol 2 we have to assume the setting will stick, and adjust
		 * our state immediately.  In protocol 3 and up we can rely on the
		 * backend to report the parameter value, and we'll change state at
		 * that time.
		 */
		if (PQprotocolVersion(conn) < 3)
			pqSaveParameterStatus(conn, "client_encoding", encoding);
		status = 0;             /* everything is ok */
	}
	PQclear(res);
	return status;
}
#endif /* HAVE_PQSETCLIENTENCODING */

#ifndef HAVE_PQESCAPESTRING
/*
 * Escaping arbitrary strings to get valid SQL literal strings.
 *
 * Replaces "\\" with "\\\\" and "'" with "''".
 *
 * length is the length of the source string.  (Note: if a terminating NUL
 * is encountered sooner, PQescapeString stops short of "length"; the behavior
 * is thus rather like strncpy.)
 *
 * For safety the buffer at "to" must be at least 2*length + 1 bytes long.
 * A terminating NUL character is added to the output string, whether the
 * input is NUL-terminated or not.
 *
 * Returns the actual length of the output (not counting the terminating NUL).
 */
size_t
PQescapeString(char *to, const char *from, size_t length)
{
	const char *source = from;
	char	   *target = to;
	size_t		remaining = length;

	while (remaining > 0 && *source != '\0')
	{
		switch (*source)
		{
			case '\\':
				*target++ = '\\';
				*target++ = '\\';
				break;

			case '\'':
				*target++ = '\'';
				*target++ = '\'';
				break;

			default:
				*target++ = *source;
				break;
		}
		source++;
		remaining--;
	}

	/* Write the terminating NUL character. */
	*target = '\0';

	return target - to;
}

/*
 *		PQescapeBytea	- converts from binary string to the
 *		minimal encoding necessary to include the string in an SQL
 *		INSERT statement with a bytea type column as the target.
 *
 *		The following transformations are applied
 *		'\0' == ASCII  0 == \\000
 *		'\'' == ASCII 39 == \'
 *		'\\' == ASCII 92 == \\\\
 *		anything < 0x20, or > 0x7e ---> \\ooo
 *										(where ooo is an octal expression)
 */
unsigned char *
PQescapeBytea(const unsigned char *bintext, size_t binlen, size_t *bytealen)
{
	const unsigned char *vp;
	unsigned char *rp;
	unsigned char *result;
	size_t		i;
	size_t		len;

	/*
	 * empty string has 1 char ('\0')
	 */
	len = 1;

	vp = bintext;
	for (i = binlen; i > 0; i--, vp++)
	{
		if (*vp < 0x20 || *vp > 0x7e)
			len += 5;			/* '5' is for '\\ooo' */
		else if (*vp == '\'')
			len += 2;
		else if (*vp == '\\')
			len += 4;
		else
			len++;
	}

	rp = result = (unsigned char *) malloc(len);
	if (rp == NULL)
		return NULL;

	vp = bintext;
	*bytealen = len;

	for (i = binlen; i > 0; i--, vp++)
	{
		if (*vp < 0x20 || *vp > 0x7e)
		{
			(void) sprintf(rp, "\\\\%03o", *vp);
			rp += 5;
		}
		else if (*vp == '\'')
		{
			rp[0] = '\\';
			rp[1] = '\'';
			rp += 2;
		}
		else if (*vp == '\\')
		{
			rp[0] = '\\';
			rp[1] = '\\';
			rp[2] = '\\';
			rp[3] = '\\';
			rp += 4;
		}
		else
			*rp++ = *vp;
	}
	*rp = '\0';

	return result;
}

#define ISFIRSTOCTDIGIT(CH) ((CH) >= '0' && (CH) <= '3')
#define ISOCTDIGIT(CH) ((CH) >= '0' && (CH) <= '7')
#define OCTVAL(CH) ((CH) - '0')

/*
 *		PQunescapeBytea - converts the null terminated string representation
 *		of a bytea, strtext, into binary, filling a buffer. It returns a
 *		pointer to the buffer (or NULL on error), and the size of the
 *		buffer in retbuflen. The pointer may subsequently be used as an
 *		argument to the function free(3). It is the reverse of PQescapeBytea.
 *
 *		The following transformations are made:
 *		\\	 == ASCII 92 == \
 *		\ooo == a byte whose value = ooo (ooo is an octal number)
 *		\x	 == x (x is any character not matched by the above transformations)
 */
unsigned char *
PQunescapeBytea(const unsigned char *strtext, size_t *retbuflen)
{
	size_t		strtextlen,
				buflen;
	unsigned char *buffer,
			   *tmpbuf;
	size_t		i,
				j;

	if (strtext == NULL)
		return NULL;

	strtextlen = strlen(strtext);

	/*
	 * Length of input is max length of output, but add one to avoid
	 * unportable malloc(0) if input is zero-length.
	 */
	buffer = (unsigned char *) malloc(strtextlen + 1);
	if (buffer == NULL)
		return NULL;

	for (i = j = 0; i < strtextlen;)
	{
		switch (strtext[i])
		{
			case '\\':
				i++;
				if (strtext[i] == '\\')
					buffer[j++] = strtext[i++];
				else
				{
					if ((ISFIRSTOCTDIGIT(strtext[i])) &&
						(ISOCTDIGIT(strtext[i + 1])) &&
						(ISOCTDIGIT(strtext[i + 2])))
					{
						int			byte;

						byte = OCTVAL(strtext[i++]);
						byte = (byte << 3) + OCTVAL(strtext[i++]);
						byte = (byte << 3) + OCTVAL(strtext[i++]);
						buffer[j++] = byte;
					}
				}

				/*
				 * Note: if we see '\' followed by something that isn't a
				 * recognized escape sequence, we loop around having done
				 * nothing except advance i.  Therefore the something will
				 * be emitted as ordinary data on the next cycle. Corner
				 * case: '\' at end of string will just be discarded.
				 */
				break;

			default:
				buffer[j++] = strtext[i++];
				break;
		}
	}
	buflen = j;					/* buflen is the length of the dequoted
								 * data */

	/* Shrink the buffer to be no larger than necessary */
	/* +1 avoids unportable behavior when buflen==0 */
	tmpbuf = realloc(buffer, buflen + 1);

	/* It would only be a very brain-dead realloc that could fail, but... */
	if (!tmpbuf)
	{
		free(buffer);
		return NULL;
	}

	*retbuflen = buflen;
	return tmpbuf;
}
#endif

