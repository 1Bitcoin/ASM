#include <iostream>

extern "C"
{
	int StrLength(char *s);
	char *CopyStr(char *s1, char *s2, int L);
}

int main()
{
	char str1[80] = "hello world";
	char str2[80] = "";

	char *tempStr;
	int len1, len2;

	len1 = StrLength(str1);
	len2 = StrLength(str2);

	printf("Len('%s') =  %d\n", str1, len1);
	printf("Len('%s') =  %d\n\n", str2, len2);

	tempStr = CopyStr(str1, str2, len1);

	printf("Given address: %p\n", tempStr);
	printf("Address str: %p\n", str2);

	printf("\nSource : '%s'\n", str1);
	printf("Copy : '%s'\n\n", str2);

	return 0;
}