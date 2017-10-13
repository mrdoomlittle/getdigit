# include "getdigit.hpp"
# include <cstdlib>
# include <cmath>
# include <mdl/intlen.hpp>
mdl::u8_t mdl::getdigit(uint_t __no, std::size_t __off) {
	if (__no < 10) return __no;

	std::size_t len = intlen(__no);
	if (__off > len) return __off;

	uint_t no_unit = 1;
	for (std::size_t i = 0; i != len-1; i ++) no_unit *= 10;

	mdl::u8_t *digit = (mdl::u8_t*)std::malloc(len);
	uint_t sv = __no, l = no_unit;
	for (std::size_t i = 0; i != len; i ++) {
		if (i != 0) sv -= (floor(sv/no_unit)*no_unit);
		digit[i] = (sv/l);
		if (i != 0) no_unit /= 10;
		l /= 10;
	}

	mdl_u8_t ret = digit[__off];
	std::free(digit);
    return ret;
}

extern "C" {
    mdl::u8_t mdl_getdigit(mdl::uint_t __no, std::size_t __off) {
        return mdl::getdigit(__no, __off);
    }
}
