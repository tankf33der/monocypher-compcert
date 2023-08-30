int
memcmp(s1, s2, n)
	const void *s1, *s2;
	size_t n;
{
	if (n != 0) {
		register const unsigned char *p1 = s1, *p2 = s2;

		do {
			if (*p1++ != *p2++)
				return (*--p1 - *--p2);
		} while (--n != 0);
	}
	return (0);
}

