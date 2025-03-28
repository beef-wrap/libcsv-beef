/*
libcsv - parse and write csv data
Copyright (C) 2008-2021  Robert Gamble

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

using System;
using System.Interop;

namespace libcsv_Beef;

public static class libcsv
{
	public typealias FILE = void*;
	public typealias size_t = uint;
	public typealias char = char8;

	public const int CSV_MAJOR = 3;
	public const int CSV_MINOR = 0;
	public const int CSV_RELEASE = 3;

	/* Error Codes */
	public const int CSV_SUCCESS = 0;
	public const int CSV_EPARSE = 1; /* Parse error in strict mode */
	public const int CSV_ENOMEM = 2; /* Out of memory while increasing buffer size */
	public const int CSV_ETOOBIG = 3; /* Buffer larger than SIZE_MAX needed */
	public const int CSV_EINVALID = 4; /* Invalid code,should never be received from csv_error*/


	/* parser options */
	public const int CSV_STRICT = 1; /* enable strict mode */
	public const int CSV_REPALL_NL = 2; /* report all unquoted carriage returns and linefeeds */
	public const int CSV_STRICT_FINI = 4; /* causes csv_fini to return CSV_EPARSE if last field is quoted and doesn't containg ending  quote */
	public const int CSV_APPEND_NULL = 8; /* Ensure that all fields are null-terminated */
	public const int CSV_EMPTY_IS_NULL = 16; /* Pass null pointer to cb1 function when empty, unquoted fields are encountered */

	/* Character values */
	public const int CSV_TAB    = 0x09;
	public const int CSV_SPACE  = 0x20;
	public const int CSV_CR     = 0x0d;
	public const int CSV_LF     = 0x0a;
	public const int CSV_COMMA  = 0x2c;
	public const int CSV_QUOTE  = 0x22;

	public struct csv_parser
	{
		int pstate; /* Parser state */
		int quoted; /* Is the current field a quoted field? */
		size_t spaces; /* Number of continious spaces after quote or in a non-quoted field */
		c_uchar* entry_buf; /* Entry buffer */
		size_t entry_pos; /* Current position in entry_buf (and current size of entry) */
		size_t entry_size; /* Size of entry buffer */
		int status; /* Operation status */
		c_uchar options;
		c_uchar quote_char;
		c_uchar delim_char;
		function int is_space(c_uchar);
		function int is_term(c_uchar);
		size_t blk_size;
		function void* malloc_func(size_t); /* not used */
		function void* realloc_func(void*, size_t); /* function used to allocate buffer memory */
		function void free_func(void*); /* function used to free buffer memory */
	}

	public function void field_callback(void*, size_t, void*);

	public function void row_callback(int, void*);

	/* Function Prototypes */
	[CLink] public static extern int csv_init(csv_parser* p, c_uchar options);

	[CLink] public static extern int csv_fini(csv_parser* p, field_callback, row_callback, void* data);

	[CLink] public static extern void csv_free(csv_parser* p);

	[CLink] public static extern int csv_error(csv_parser* p);

	[CLink] public static extern char* csv_strerror(int error);

	[CLink] public static extern size_t csv_parse(csv_parser* p, void* s, size_t len, field_callback, row_callback, void* data);

	[CLink] public static extern size_t csv_write(void* dest, size_t dest_size, void* src, size_t src_size);

	[CLink] public static extern int csv_fwrite(FILE* fp, void* src, size_t src_size);

	[CLink] public static extern size_t csv_write2(void* dest, size_t dest_size, void* src, size_t src_size, c_uchar quote);

	[CLink] public static extern int csv_fwrite2(FILE* fp, void* src, size_t src_size, c_uchar quote);

	[CLink] public static extern int csv_get_opts(csv_parser* p);

	[CLink] public static extern int csv_set_opts(csv_parser* p, c_uchar options);

	[CLink] public static extern void csv_set_delim(csv_parser* p, c_uchar c);

	[CLink] public static extern void csv_set_quote(csv_parser* p, c_uchar c);

	[CLink] public static extern c_uchar csv_get_delim(csv_parser* p);

	[CLink] public static extern c_uchar csv_get_quote(csv_parser* p);

	[CLink] public static extern void csv_set_space_func(csv_parser* p, function int(c_uchar) fn);

	[CLink] public static extern void csv_set_term_func(csv_parser* p, function int(c_uchar) fn);

	[CLink] public static extern void csv_set_realloc_func(csv_parser* p, function void*(void*, size_t) fn);

	[CLink] public static extern void csv_set_free_func(csv_parser* p, function void(void*) fn);

	[CLink] public static extern void csv_set_blk_size(csv_parser* p, size_t);

	[CLink] public static extern size_t csv_get_buffer_size(csv_parser* p);
}