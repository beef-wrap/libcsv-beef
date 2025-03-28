using System;
using System.Collections;
using System.Diagnostics;
using System.IO;
using static libcsv_Beef.libcsv;

namespace example;

static class Program
{
	[CLink] static extern void* __acrt_iob_func(uint32);

	static void* stdin = __acrt_iob_func(0);
	static void* stdout = __acrt_iob_func(1);

	static bool put_comma;

	struct counts
	{
		public int fields = 0;
		public int rows = 0;
	}

	static	void cb1(void* s, size_t len, void* data)
	{
		((counts*)data).fields++;
	}

	static void cb2(int c, void* data)
	{
		((counts*)data).rows++;
	}

	static int Main(params String[] args)
	{
		csv_parser p;
		char8 c;
		counts count = .();

		let str = "1, 2, 4, 5,, 6,";

		csv_init(&p, 0);

		let ss = scope StringStream(str, .Reference);

		while (ss.Read<char8>() case .Ok(let val))
		{
			c = val;

			Debug.Write(c);

			if (csv_parse(&p, &c, 1, => cb1, => cb2, &count) != 1)
			{
				Debug.WriteLine($"Error: {StringView(csv_strerror(csv_error(&p)))}");
				return 1;
			}
		}

		csv_fini(&p, => cb1, => cb2, &count);

		csv_free(&p);

		Debug.WriteLine("");

		Debug.WriteLine($"rows: {count.rows}");

		Debug.WriteLine($"fields: {count.fields}");

		return 0;
	}
}