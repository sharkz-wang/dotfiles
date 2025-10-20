#include <inttypes.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

volatile char type_size_summary[] = {
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', '*', ' ', 'P', 'R', 'I', 'M', 'I', 'T', 'I', 'V', 'E', ' ', 'S', 'I', 'Z', 'E', 'S', ' ', '*', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 'c', 'h', 'a', 'r', ':', ' ', '0' + (int) sizeof (char), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 's', 'h', 'o', 'r', 't', ':', ' ', '0' + (int) sizeof (short), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 'i', 'n', 't', ':', ' ', '0' + (int) sizeof (int), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 'l', 'o', 'n', 'g', ':', ' ', '0' + (int) sizeof (long), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 'l', 'o', 'n', 'g', ' ', 'i', 'n', 't', ':', ' ', '0' + (int) sizeof (long int), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 'l', 'o', 'n', 'g', ' ', 'l', 'o', 'n', 'g', ' ', 'i', 'n', 't', ':', ' ', '0' + (int) sizeof (long long int), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 'i', 'n', 't', 'm', 'a', 'x', '_', 't', ':', ' ', '0' + (int) sizeof (long long int), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', '\n', 

	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', '*', ' ', 'P', 'O', 'I', 'N', 'T', 'E', 'R', ' ', 'S', 'I', 'Z', 'E', 'S', ' ', '*', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 'i', 'n', 't', ' ', '*', ':', ' ', '0' + (int) sizeof (int *), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 'v', 'o', 'i', 'd', ' ', '*', ':', ' ', '0' + (int) sizeof (void *), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 'f', 'u', 'n', 'c', '*', ':', ' ', '0' + (int) sizeof (void (*)()), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', '\n', 

	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', '*', ' ',  'P', 'L', 'A', 'T', 'F', 'O', 'R', 'M', ' ', 'S', 'I', 'Z', 'E', 'S', ' ', '*', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 's', 'i', 'z', 'e', '_', 't', ':', ' ', '0' + (int) sizeof (size_t), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 'u', 'i', 'n', 't', 'p', 't', 'r', '_', 't', ':', ' ', '0' + (int) sizeof (uintptr_t), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 'i', 'n', 't', 'p', 't', 'r', '_', 't', ':', ' ', '0' + (int) sizeof (intptr_t), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', 'p', 't', 'r', 'd', 'i', 'f', 'f', '_', 't',  ':', ' ', '0' + (int) sizeof (ptrdiff_t), ' ', '\n',
	'T', 'Y', 'P', 'E', '_', 'D', 'U', 'M', 'P', ':', ' ', '\n',
};

volatile char *printf_placeholder_summary[] = {
	"TYPE_DUMP: * SIGNED TYPES *\n"
	"TYPE_DUMP: PRIo8 : %" PRIo8 "\n"
	"TYPE_DUMP: PRIo16: %" PRIo16 "\n"
	"TYPE_DUMP: PRIo32: %" PRIo32 "\n"
	"TYPE_DUMP: PRIo64: %" PRIo64 "\n"
	"TYPE_DUMP: \n"

	"TYPE_DUMP: * UNSIGNED TYPES *\n"
	"TYPE_DUMP: PRIu8 : %" PRIu8 "\n"
	"TYPE_DUMP: PRIu16: %" PRIu16 "\n"
	"TYPE_DUMP: PRIu32: %" PRIu32 "\n"
	"TYPE_DUMP: PRIu64: %" PRIu64 "\n"
	"TYPE_DUMP: \n"

	"TYPE_DUMP: * HEX TYPES *\n"
	"TYPE_DUMP: PRIx8 : %" PRIx8 "\n"
	"TYPE_DUMP: PRIx16: %" PRIx16 "\n"
	"TYPE_DUMP: PRIx32: %" PRIx32 "\n"
	"TYPE_DUMP: PRIx64: %" PRIx64 "\n"
	"TYPE_DUMP: \n"
	
	"TYPE_DUMP: * TYPE MAX *\n"
	"TYPE_DUMP: PRIoMAX: %" PRIoMAX "\n"
	"TYPE_DUMP: PRIuMAX: %" PRIuMAX "\n"
	"TYPE_DUMP: PRIxMAX: %" PRIxMAX "\n"
	"TYPE_DUMP: PRIXMAX: %" PRIXMAX "\n"
	"TYPE_DUMP: \n"

	"TYPE_DUMP: * POINTER TYPES *\n"
	"TYPE_DUMP: PRIoPTR: %" PRIoPTR "\n"
	"TYPE_DUMP: PRIuPTR: %" PRIuPTR "\n"
	"TYPE_DUMP: PRIxPTR: %" PRIxPTR "\n"
	"TYPE_DUMP: PRIXPTR: %" PRIXPTR "\n"
	"TYPE_DUMP: \n"
};

int main(void) {
	return 0;
}
